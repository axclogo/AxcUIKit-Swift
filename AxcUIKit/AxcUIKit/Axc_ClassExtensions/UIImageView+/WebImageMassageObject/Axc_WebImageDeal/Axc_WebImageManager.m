//
//  Axc_WebImageManager.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/6.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "Axc_WebImageManager.h"
#import <objc/message.h>

@interface Axc_WebimageCombinedOperation : NSObject <Axc_WebimageOperation>

@property (assign, nonatomic, getter = isCancelled) BOOL cancelled;
@property (copy, nonatomic) Axc_WebimageNoParamsBlock cancelBlock;
@property (strong, nonatomic) NSOperation *cacheOperation;

@end

@interface Axc_WebimageManager ()

@property (strong, nonatomic, readwrite) coreAxc_ImageCache_remakes *imageCache;
@property (strong, nonatomic, readwrite) Axc_WebimageDownloader *imageDownloader;
@property (strong, nonatomic) NSMutableSet *failedURLs;
@property (strong, nonatomic) NSMutableArray *runningOperations;

@end

@implementation Axc_WebimageManager

+ (id)sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

- (id)init {
    if ((self = [super init])) {
        _imageCache = [self createCache];
        _imageDownloader = [Axc_WebimageDownloader sharedDownloader];
        _failedURLs = [NSMutableSet new];
        _runningOperations = [NSMutableArray new];
    }
    return self;
}

- (coreAxc_ImageCache_remakes *)createCache {
    return [coreAxc_ImageCache_remakes sharedImageCache];
}

- (NSString *)cacheKeyForURL:(NSURL *)url {
    if (self.cacheKeyFilter) {
        return self.cacheKeyFilter(url);
    }
    else {
        return [url absoluteString];
    }
}

- (BOOL)cachedImageExistsForURL:(NSURL *)url {
    NSString *key = [self cacheKeyForURL:url];
    if ([self.imageCache imageFromMemoryCacheForKey:key] != nil) return YES;
    return [self.imageCache diskImageExistsWithKey:key];
}

- (BOOL)diskImageExistsForURL:(NSURL *)url {
    NSString *key = [self cacheKeyForURL:url];
    return [self.imageCache diskImageExistsWithKey:key];
}

- (void)cachedImageExistsForURL:(NSURL *)url
                     completion:(Axc_WebimageCheckCacheCompletionBlock)completionBlock {
    NSString *key = [self cacheKeyForURL:url];
    
    BOOL isInMemoryCache = ([self.imageCache imageFromMemoryCacheForKey:key] != nil);
    
    if (isInMemoryCache) {
        // 主队列
        dispatch_async(dispatch_get_main_queue(), ^{
            if (completionBlock) {
                completionBlock(YES);
            }
        });
        return;
    }
    
    [self.imageCache diskImageExistsWithKey:key completion:^(BOOL isInDiskCache) {
        // 完成checkDiskCacheForImageWithKey 回调
        if (completionBlock) {
            completionBlock(isInDiskCache);
        }
    }];
}

- (void)diskImageExistsForURL:(NSURL *)url
                   completion:(Axc_WebimageCheckCacheCompletionBlock)completionBlock {
    NSString *key = [self cacheKeyForURL:url];
    
    [self.imageCache diskImageExistsWithKey:key completion:^(BOOL isInDiskCache) {
        // 完成checkDiskCacheForImageWithKey 回调
        if (completionBlock) {
            completionBlock(isInDiskCache);
        }
    }];
}

- (id <Axc_WebimageOperation>)downloadImageWithURL:(NSURL *)url
                                           options:(Axc_WebimageOptions)options
                                          progress:(Axc_DownloadWebimageDownloaderProgressBlock)progressBlock
                                         completed:(Axc_WebimageCompletionWithFinishedBlock)completedBlock {
    // 调用这个方法completedBlock无意义，准备嫁接
    NSAssert(completedBlock != nil, @"使用-[Axc_WebimagePrefetcher prefetchURLs]");
    // 允许url作为NSString传递
    if ([url isKindOfClass:NSString.class]) {
        url = [NSURL URLWithString:(NSString *)url]; // 啦啦啦
    }
    // 防止程序崩溃重置指针
    if (![url isKindOfClass:NSURL.class]) {
        url = nil;
    }
    __block Axc_WebimageCombinedOperation *operation = [Axc_WebimageCombinedOperation new];
    __weak  Axc_WebimageCombinedOperation *weakOperation = operation;
    BOOL isFailedUrl = NO;
    @synchronized (self.failedURLs) {
        isFailedUrl = [self.failedURLs containsObject:url];
    }
    if (!url || (!(options & Axc_WebimageRetryFailed) && isFailedUrl)) {
        dispatch_main_sync_safe(^{
            NSError *error = [NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorFileDoesNotExist userInfo:nil];
            completedBlock(nil, error, coreAxc_ImageCache_remakesTypeNone, YES, url);
        });
        return operation;
    }
    @synchronized (self.runningOperations) { // 线程
        [self.runningOperations addObject:operation];
    }
    NSString *key = [self cacheKeyForURL:url];
    operation.cacheOperation = [self.imageCache queryDiskCacheForKey:key done:^(UIImage *image, coreAxc_ImageCache_remakesType cacheType) {
        if (operation.isCancelled) {
            @synchronized (self.runningOperations) {
                [self.runningOperations removeObject:operation];
            }
            return;
        }
        /*****************************核心== 准备回调数据到扩展类*************************/
        if ((!image || options & Axc_WebimageRefreshCached) &&
            (![self.delegate respondsToSelector:@selector(imageManager:imageURL:)] ||
             [self.delegate imageManager:self imageURL:url])) {
                if (image && options & Axc_WebimageRefreshCached) {
                    dispatch_main_sync_safe(^{
                        // 尝试重新下载,从服务器刷新
                        completedBlock(image, nil, cacheType, YES, url);
                    });
                }
                // 如果没有图像或请求刷新,重新委托
                Axc_WebimageDownloaderOptions downloaderOptions = 0;
                if (options & Axc_WebimageLowPriority) downloaderOptions |= Axc_WebimageDownloaderLowPriority;
                if (options & Axc_WebimageProgressiveDownload) downloaderOptions |= Axc_WebimageDownloaderProgressiveDownload;
                if (options & Axc_WebimageRefreshCached) downloaderOptions |= Axc_WebimageDownloaderUseNSURLCache;
                if (options & Axc_WebimageContinueInBackground) downloaderOptions |= Axc_WebimageDownloaderContinueInBackground;
                if (options & Axc_WebimageHandleCookies) downloaderOptions |= Axc_WebimageDownloaderHandleCookies;
                if (options & Axc_WebimageAllowInvalidSSLCertificates) downloaderOptions |= Axc_WebimageDownloaderAllowInvalidSSLCertificates;
                if (options & Axc_WebimageHighPriority) downloaderOptions |= Axc_WebimageDownloaderHighPriority;
                if (image && options & Axc_WebimageRefreshCached) {
                    // 强制刷新
                    downloaderOptions &= ~Axc_WebimageDownloaderProgressiveDownload;
                    // 忽略图像读取NSURLCache
                    downloaderOptions |= Axc_WebimageDownloaderIgnoreCachedResponse;
                }
                id <Axc_WebimageOperation> subOperation = [self.imageDownloader downloadImageWithURL:url options:downloaderOptions progress:progressBlock completed:^(UIImage *downloadedImage, NSData *data, NSError *error, BOOL finished) {
                    if (weakOperation.isCancelled) {
                        // 操作被取消
                    }else if (error) {
                        dispatch_main_sync_safe(^{
                            if (!weakOperation.isCancelled) {
                                completedBlock(nil, error, coreAxc_ImageCache_remakesTypeNone, finished, url);
                            }
                        });
                        BOOL shouldBeFailedURLAlliOSVersion = (error.code != NSURLErrorNotConnectedToInternet && error.code != NSURLErrorCancelled && error.code != NSURLErrorTimedOut);
                        BOOL shouldBeFailedURLiOS7 = (NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_6_1 && error.code != NSURLErrorInternationalRoamingOff && error.code != NSURLErrorCallIsActive && error.code != NSURLErrorDataNotAllowed);
                        if (shouldBeFailedURLAlliOSVersion || shouldBeFailedURLiOS7) {
                            @synchronized (self.failedURLs) {
                                [self.failedURLs addObject:url];
                            }
                        }
                    }
                    else {
                        if ((options & Axc_WebimageRetryFailed)) {
                            @synchronized (self.failedURLs) {
                                [self.failedURLs removeObject:url];
                            }
                        }
                        
                        BOOL cacheOnDisk = !(options & Axc_WebimageCacheMemoryOnly);
                        
                        if (options & Axc_WebimageRefreshCached && image && !downloadedImage) {
                            // 图像刷新NSURLCache缓存
                        }
                        else if (downloadedImage && (!downloadedImage.images || (options & Axc_WebimageTransformAnimatedImage)) && [self.delegate respondsToSelector:@selector(imageManager:Image:withURL:)]) {
                            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0), ^{
                                UIImage *transformedImage = [self.delegate imageManager:self Image:downloadedImage withURL:url];
                                if (transformedImage && finished) {
                                    BOOL imageWasTransformed = ![transformedImage isEqual:downloadedImage];
                                    [self.imageCache storeImage:transformedImage recalculateFromImage:imageWasTransformed imageData:(imageWasTransformed ? nil : data) forKey:key toDisk:cacheOnDisk];
                                }
                                dispatch_main_sync_safe(^{
                                    if (!weakOperation.isCancelled) {
                                        completedBlock(transformedImage, nil, coreAxc_ImageCache_remakesTypeNone, finished, url);
                                    }
                                });
                            });
                        }
                        else {
                            if (downloadedImage && finished) {
                                [self.imageCache storeImage:downloadedImage recalculateFromImage:NO imageData:data forKey:key toDisk:cacheOnDisk];
                            }
                            dispatch_main_sync_safe(^{
                                if (!weakOperation.isCancelled) {
                                    completedBlock(downloadedImage, nil, coreAxc_ImageCache_remakesTypeNone, finished, url);
                                }
                            });
                        }
                    }
                    if (finished) {
                        @synchronized (self.runningOperations) {
                            [self.runningOperations removeObject:operation];
                        }
                    }
                }];
                operation.cancelBlock = ^{
                    [subOperation cancel];
                    @synchronized (self.runningOperations) {
                        [self.runningOperations removeObject:weakOperation];
                    }
                };
            }
        else if (image) {
            dispatch_main_sync_safe(^{
                if (!weakOperation.isCancelled) {
                    completedBlock(image, nil, cacheType, YES, url);
                }
            });
            @synchronized (self.runningOperations) {
                [self.runningOperations removeObject:operation];
            }
        }
        else {
            // 图像不缓存
            dispatch_main_sync_safe(^{
                if (!weakOperation.isCancelled) {
                    completedBlock(nil, nil, coreAxc_ImageCache_remakesTypeNone, YES, url);
                }
            });
            @synchronized (self.runningOperations) {
                [self.runningOperations removeObject:operation];
            }
        }
    }];
    
    return operation;
}
- (void)saveImageToCache:(UIImage *)image forURL:(NSURL *)url {
    if (image && url) {
        NSString *key = [self cacheKeyForURL:url];
        [self.imageCache storeImage:image forKey:key toDisk:YES];
    }
}

- (void)cancelAll {
    @synchronized (self.runningOperations) {
        NSArray *copiedOperations = [self.runningOperations copy];
        [copiedOperations makeObjectsPerformSelector:@selector(cancel)];
        [self.runningOperations removeObjectsInArray:copiedOperations];
    }
}

- (BOOL)isRunning {
    return self.runningOperations.count > 0;
}

@end


@implementation Axc_WebimageCombinedOperation

- (void)setCancelBlock:(Axc_WebimageNoParamsBlock)cancelBlock {
    // 检查操作是否已经取消
    if (self.isCancelled) {
        if (cancelBlock) {
            cancelBlock();
        }
        _cancelBlock = nil; // nil cancelBlock防崩溃
    } else {
        _cancelBlock = [cancelBlock copy];
    }
}

- (void)cancel {
    self.cancelled = YES;
    if (self.cacheOperation) {
        [self.cacheOperation cancel];
        self.cacheOperation = nil;
    }
    if (self.cancelBlock) {
        self.cancelBlock();
//        self.cancelBlock = nil;
        _cancelBlock = nil;
    }
}

@end



