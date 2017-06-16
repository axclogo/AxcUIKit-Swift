//
//  Axc_WebImageDownloaderOperation.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/6.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "Axc_WebImageDownloaderOperation.h"
#import "Axc_WebImageDecoder.h"
#import "UIImage+MultiFormat.h"
#import <ImageIO/ImageIO.h>
#import "Axc_WebImageManager.h"

// 通知中心Key
NSString *const Axc_WebimageDownloadStartNotification           = @"Axc_WebimageDownloadStartNotification";
NSString *const Axc_WebimageDownloadReceiveResponseNotification = @"Axc_WebimageDownloadReceiveResponseNotification";
NSString *const Axc_WebimageDownloadStopNotification            = @"Axc_WebimageDownloadStopNotification";
NSString *const Axc_WebimageDownloadFinishNotification          = @"Axc_WebimageDownloadFinishNotification";

@interface Axc_WebimageDownloaderOperation () <NSURLConnectionDataDelegate>

@property (copy, nonatomic) Axc_DownloadWebimageDownloaderProgressBlock progressBlock;
@property (copy, nonatomic) Axc_DownloadWebimageDownloaderCompletedBlock completedBlock;
@property (copy, nonatomic) Axc_WebimageNoParamsBlock cancelBlock;

@property (assign, nonatomic, getter = isExecuting) BOOL executing; // 设置默认
@property (assign, nonatomic, getter = isFinished)  BOOL finished;
@property (strong, nonatomic) NSMutableData *imageData;
@property (strong, nonatomic) NSURLConnection *connection;
@property (strong, atomic)    NSThread *thread;

@property (assign, nonatomic) UIBackgroundTaskIdentifier backgroundTaskId;

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@end

@implementation Axc_WebimageDownloaderOperation {
    size_t              width, height;
    UIImageOrientation  orientation;
    BOOL                responseFromCached;
}// 瓜皮写法，但耐不住方便啊

@synthesize executing = _executing;
@synthesize finished = _finished;

- (id)initWithRequest:(NSURLRequest *)request
              options:(Axc_WebimageDownloaderOptions)options
             progress:(Axc_DownloadWebimageDownloaderProgressBlock)progressBlock
            completed:(Axc_DownloadWebimageDownloaderCompletedBlock)completedBlock
            cancelled:(Axc_WebimageNoParamsBlock)cancelBlock {
    if ((self = [super init])) {
        _request = request;
        _shouldDecompressImages = YES;
        _shouldUseCredentialStorage = YES;
        _options = options;
        _progressBlock = [progressBlock copy];   // 不copy会jb崩溃，不他妈知道为啥。
        _completedBlock = [completedBlock copy]; // 指针地址本来就不一样啊我操
        _cancelBlock = [cancelBlock copy];       // 神经病啊
        _executing = NO;
        _finished = NO;
        _expectedSize = 0;
        responseFromCached = YES; // 默认开启。直到连接:willCacheResponse
    }
    return self;
}

- (void)start { // 开始
    @synchronized (self) {
        if (self.isCancelled) {
            self.finished = YES;
            [self reset];
            return;
        }
        Class UIApplicationClass = NSClassFromString(@"UIApplication");
        BOOL hasApplication = UIApplicationClass && [UIApplicationClass respondsToSelector:@selector(sharedApplication)];
        if (hasApplication && [self shouldContinueWhenAppEntersBackground]) {
            __weak __typeof__ (self) wself = self;
            UIApplication * app = [UIApplicationClass performSelector:@selector(sharedApplication)];
            self.backgroundTaskId = [app beginBackgroundTaskWithExpirationHandler:^{
                __strong __typeof (wself) sself = wself;
                
                if (sself) {
                    [sself cancel];
                    
                    [app endBackgroundTask:sself.backgroundTaskId];
                    sself.backgroundTaskId = UIBackgroundTaskInvalid;
                }
            }];
        }
        self.executing = YES;
        self.connection = [[NSURLConnection alloc] initWithRequest:self.request delegate:self startImmediately:NO];
        self.thread = [NSThread currentThread];
    }
    [self.connection start];
    
    if (self.connection) {
        if (self.progressBlock) {
            self.progressBlock(0, NSURLResponseUnknownLength);
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:Axc_WebimageDownloadStartNotification object:self];
        });
        
        if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_5_1) {
            // 后台线程运行runloop
            // 使用超时来解决NSURLConnection的取消执行
            CFRunLoopRunInMode(kCFRunLoopDefaultMode, 10, false);
        }
        else {CFRunLoopRun();}
        if (!self.isFinished) {
            [self.connection cancel];
            [self connection:self.connection didFailWithError:[NSError errorWithDomain:NSURLErrorDomain code:NSURLErrorTimedOut userInfo:@{NSURLErrorFailingURLErrorKey : self.request.URL}]];}
    }
    else {
        if (self.completedBlock) { // Block嫁接大法好
            self.completedBlock(nil, nil, [NSError errorWithDomain:NSURLErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : @"连接未初始化!"}], YES);}
    }
    Class UIApplicationClass = NSClassFromString(@"UIApplication");
    if(!UIApplicationClass || ![UIApplicationClass respondsToSelector:@selector(sharedApplication)]) {
        return; // 不能共享
    }
    if (self.backgroundTaskId != UIBackgroundTaskInvalid) {
        UIApplication * app = [UIApplication performSelector:@selector(sharedApplication)];
        [app endBackgroundTask:self.backgroundTaskId];
        self.backgroundTaskId = UIBackgroundTaskInvalid;
    }
}

- (void)cancelInternal {
    if (self.isFinished) return;
    [super cancel];
    if (self.cancelBlock) self.cancelBlock();
    if (self.connection) {
        [self.connection cancel];
        dispatch_async(dispatch_get_main_queue(), ^{ // 必须线程回调
            [[NSNotificationCenter defaultCenter] postNotificationName:Axc_WebimageDownloadStopNotification object:self];
        });
        // 回调因此不会结束
        if (self.isExecuting) self.executing = NO;
        if (!self.isFinished) self.finished = YES;
    }
    
    [self reset];
}

- (void)done {
    self.finished = YES;
    self.executing = NO;
    [self reset];
}

- (void)reset {
    self.cancelBlock    = nil;
    self.completedBlock = nil;
    self.progressBlock  = nil;
    self.connection     = nil;
    self.imageData      = nil;
    self.thread         = nil;
}

- (void)setFinished:(BOOL)finished {
    [self willChangeValueForKey:@"isFinished"];
    _finished = finished;
    [self didChangeValueForKey:@"isFinished"];
}

- (void)setExecuting:(BOOL)executing {
    [self willChangeValueForKey:@"isExecuting"];
    _executing = executing;
    [self didChangeValueForKey:@"isExecuting"];
}

- (BOOL)isConcurrent {
    return YES;
}

#pragma mark - 代理区NSURLConnection - delegate

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    // 304特殊处理 不知道会不会出错
    if (![response respondsToSelector:@selector(statusCode)] || ([((NSHTTPURLResponse *)response) statusCode] < 400 && [((NSHTTPURLResponse *)response) statusCode] != 304)) {
        NSInteger expected = response.expectedContentLength > 0 ? (NSInteger)response.expectedContentLength : 0;
        self.expectedSize = expected;
        if (self.progressBlock) {
            self.progressBlock(0, expected);
        }
        self.imageData = [[NSMutableData alloc] initWithCapacity:expected];
        self.response = response;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:Axc_WebimageDownloadReceiveResponseNotification object:self];
        });
    }
    else {
        NSUInteger code = [((NSHTTPURLResponse *)response) statusCode];
        // 304 [self cancelInternal];
        if (code == 304) {
            [self cancelInternal];
        } else {
            [self.connection cancel];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:Axc_WebimageDownloadStopNotification object:self];
        });
        
        if (self.completedBlock) {
            self.completedBlock(nil, nil, [NSError errorWithDomain:NSURLErrorDomain code:[((NSHTTPURLResponse *)response) statusCode] userInfo:nil], YES);
        }
        CFRunLoopStop(CFRunLoopGetCurrent());
        [self done];
    }
}

// MARK: 计算和回调
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [self.imageData appendData:data];
    if ((self.options & Axc_WebimageDownloaderProgressiveDownload) && self.expectedSize > 0 && self.completedBlock) {
        const NSInteger totalSize = self.imageData.length;
        CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)self.imageData, NULL);
        if (width + height == 0) {
            CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
            if (properties) {
                NSInteger orientationValue = -1;
                CFTypeRef val = CFDictionaryGetValue(properties, kCGImagePropertyPixelHeight);
                if (val) CFNumberGetValue(val, kCFNumberLongType, &height);
                val = CFDictionaryGetValue(properties, kCGImagePropertyPixelWidth);
                if (val) CFNumberGetValue(val, kCFNumberLongType, &width);
                val = CFDictionaryGetValue(properties, kCGImagePropertyOrientation);
                if (val) CFNumberGetValue(val, kCFNumberNSIntegerType, &orientationValue);
                CFRelease(properties);
                orientation = [[self class] orientationFromPropertyValue:(orientationValue == -1 ? 1 : orientationValue)];
            }
        }
        if (width + height > 0 && totalSize < self.expectedSize) {
            CGImageRef partialImageRef = CGImageSourceCreateImageAtIndex(imageSource, 0, NULL);
            // iOS失真
            if (partialImageRef) {
                const size_t partialHeight = CGImageGetHeight(partialImageRef);
                CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
                CGContextRef bmContext = CGBitmapContextCreate(NULL, width, height, 8, width * 4, colorSpace, kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedFirst);
                CGColorSpaceRelease(colorSpace);
                if (bmContext) {
                    CGContextDrawImage(bmContext, (CGRect){.origin.x = 0.0f, .origin.y = 0.0f, .size.width = width, .size.height = partialHeight}, partialImageRef);
                    CGImageRelease(partialImageRef);
                    partialImageRef = CGBitmapContextCreateImage(bmContext);
                    CGContextRelease(bmContext);
                }
                else {
                    CGImageRelease(partialImageRef);
                    partialImageRef = nil;
                }
            }
            
            if (partialImageRef) {
                UIImage *image = [UIImage imageWithCGImage:partialImageRef scale:1 orientation:orientation];
                NSString *key = [[Axc_WebimageManager sharedManager] cacheKeyForURL:self.request.URL];
                UIImage *scaledImage = [self scaledImageForKey:key image:image];
                if (self.shouldDecompressImages) {
                    image = [UIImage decodedImageWithImage:scaledImage];
                }
                else {
                    image = scaledImage;
                }
                CGImageRelease(partialImageRef);
                dispatch_main_sync_safe(^{
                    if (self.completedBlock) {
                        self.completedBlock(image, nil, nil, NO);
                    }
                });
            }
        }
        CFRelease(imageSource);
    }
    if (self.progressBlock) {
        self.progressBlock(self.imageData.length, self.expectedSize);
    }
}

+ (UIImageOrientation)orientationFromPropertyValue:(NSInteger)value {
    switch (value) {
        case 1:
            return UIImageOrientationUp;
        case 3:
            return UIImageOrientationDown;
        case 8:
            return UIImageOrientationLeft;
        case 6:
            return UIImageOrientationRight;
        case 2:
            return UIImageOrientationUpMirrored;
        case 4:
            return UIImageOrientationDownMirrored;
        case 5:
            return UIImageOrientationLeftMirrored;
        case 7:
            return UIImageOrientationRightMirrored;
        default:
            return UIImageOrientationUp;
    }
}

- (UIImage *)scaledImageForKey:(NSString *)key image:(UIImage *)image {
    return coreAxc_scaledImageForKey(key, image);
}

- (void)connectionDidFinishLoading:(NSURLConnection *)aConnection {
    Axc_DownloadWebimageDownloaderCompletedBlock completionBlock = self.completedBlock;
    @synchronized(self) {
        CFRunLoopStop(CFRunLoopGetCurrent());
        self.thread = nil;
        self.connection = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:Axc_WebimageDownloadStopNotification object:self];
            [[NSNotificationCenter defaultCenter] postNotificationName:Axc_WebimageDownloadFinishNotification object:self];
        });
    }
    if (![[NSURLCache sharedURLCache] cachedResponseForRequest:_request]) {
        responseFromCached = NO;
    }
    if (completionBlock) {
        if (self.options & Axc_WebimageDownloaderIgnoreCachedResponse && responseFromCached) {
            completionBlock(nil, nil, nil, YES);
        } else if (self.imageData) {
            UIImage *image = [UIImage coreAxc_imageWithData:self.imageData];
            NSString *key = [[Axc_WebimageManager sharedManager] cacheKeyForURL:self.request.URL];
            image = [self scaledImageForKey:key image:image];
            // 动画gif
            if (!image.images) {
                if (self.shouldDecompressImages) {
                    image = [UIImage decodedImageWithImage:image];
                }
            }
            if (CGSizeEqualToSize(image.size, CGSizeZero)) {
                completionBlock(nil, nil, [NSError errorWithDomain:Axc_WebimageErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : @"下载图片0像素"}], YES);
            }
            else {
                completionBlock(image, self.imageData, nil, YES);
            }
        } else {
            completionBlock(nil, nil, [NSError errorWithDomain:Axc_WebimageErrorDomain code:0 userInfo:@{NSLocalizedDescriptionKey : @"Image data 为 nil"}], YES);
        }
    }
    self.completionBlock = nil;
    [self done];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    @synchronized(self) {
        CFRunLoopStop(CFRunLoopGetCurrent());
        self.thread = nil;
        self.connection = nil;
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:Axc_WebimageDownloadStopNotification object:self];
        });
    }
    if (self.completedBlock) {
        self.completedBlock(nil, nil, error, YES);
    }
    self.completionBlock = nil;
    [self done];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse *)cachedResponse {
    responseFromCached = NO; // 如果调用此方法,说明图片不是从缓存读取
    if (self.request.cachePolicy == NSURLRequestReloadIgnoringLocalCacheData) {
        // 缓存器请闭嘴
        return nil;
    }else {return cachedResponse;}
}

- (BOOL)shouldContinueWhenAppEntersBackground {
    return self.options & Axc_WebimageDownloaderContinueInBackground;
}

- (BOOL)connectionShouldUseCredentialStorage:(NSURLConnection __unused *)connection {
    return self.shouldUseCredentialStorage;
}

- (void)connection:(NSURLConnection *)connection willSendRequestForAuthenticationChallenge:(NSURLAuthenticationChallenge *)challenge{
    if ([challenge.protectionSpace.authenticationMethod isEqualToString:NSURLAuthenticationMethodServerTrust]) {
        if (!(self.options & Axc_WebimageDownloaderAllowInvalidSSLCertificates) &&
            [challenge.sender respondsToSelector:@selector(performDefaultHandlingForAuthenticationChallenge:)]) {
            [challenge.sender performDefaultHandlingForAuthenticationChallenge:challenge];
        } else {
            NSURLCredential *credential = [NSURLCredential credentialForTrust:challenge.protectionSpace.serverTrust];
            [[challenge sender] useCredential:credential forAuthenticationChallenge:challenge];
        }
    } else {
        if ([challenge previousFailureCount] == 0) {
            if (self.credential) {
                [[challenge sender] useCredential:self.credential forAuthenticationChallenge:challenge];
            } else {
                [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
            }
        } else {
            [[challenge sender] continueWithoutCredentialForAuthenticationChallenge:challenge];
        }
    }
}
- (void)cancel {
    @synchronized (self) {
        if (self.thread) {
            [self performSelector:@selector(cancelInternalAndStop) onThread:self.thread withObject:nil waitUntilDone:NO];
        }
        else {
            [self cancelInternal];
        }
    }
}

- (void)cancelInternalAndStop {
    if (self.isFinished) return;
    [self cancelInternal];
    CFRunLoopStop(CFRunLoopGetCurrent());
}
@end
