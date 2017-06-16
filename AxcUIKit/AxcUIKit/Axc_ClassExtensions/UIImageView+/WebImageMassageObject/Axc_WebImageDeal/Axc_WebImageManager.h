//
//  Axc_WebImageManager.h
//  AxcUIKit
//
//  Created by Axc on 2017/6/6.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "Axc_WebImageCompat.h"
#import "Axc_WebImageOperation.h"
#import "Axc_WebImageDownloader.h"
#import "Axc_ImageCache.h"

typedef NS_OPTIONS(NSUInteger, Axc_WebimageOptions) {
    Axc_WebimageRetryFailed = 1 << 0,
    Axc_WebimageLowPriority = 1 << 1,
    Axc_WebimageCacheMemoryOnly = 1 << 2,
    Axc_WebimageProgressiveDownload = 1 << 3,
    Axc_WebimageRefreshCached = 1 << 4,
    Axc_WebimageContinueInBackground = 1 << 5,
    Axc_WebimageHandleCookies = 1 << 6,
    Axc_WebimageAllowInvalidSSLCertificates = 1 << 7,
    Axc_WebimageHighPriority = 1 << 8,
    Axc_WebimageDelayPlaceholder = 1 << 9,
    Axc_WebimageTransformAnimatedImage = 1 << 10,
    Axc_WebimageAvoidAutoSetImage = 1 << 11
};

// 遵循主流接口传参方式，方便对接，以免兼容性问题，选择低头
typedef void(^Axc_WebimageCompletionBlock)(UIImage *image, NSError *error, coreAxc_ImageCache_remakesType cacheType, NSURL *imageURL);

typedef void(^Axc_WebimageCompletionWithFinishedBlock)(UIImage *image, NSError *error, coreAxc_ImageCache_remakesType cacheType, BOOL finished, NSURL *imageURL);

typedef NSString *(^Axc_WebimageCacheKeyFilterBlock)(NSURL *url);


@class Axc_WebimageManager;

@protocol Axc_WebimageManagerDelegate <NSObject>

@optional
- (BOOL)imageManager:(Axc_WebimageManager *)imageManager imageURL:(NSURL *)imageURL;
- (UIImage *)imageManager:(Axc_WebimageManager *)imageManager Image:(UIImage *)image withURL:(NSURL *)imageURL;

@end

@interface Axc_WebimageManager : NSObject

@property (weak, nonatomic) id <Axc_WebimageManagerDelegate> delegate;
@property (strong, nonatomic, readonly) coreAxc_ImageCache_remakes *imageCache;
@property (strong, nonatomic, readonly) Axc_WebimageDownloader *imageDownloader;
@property (nonatomic, copy) Axc_WebimageCacheKeyFilterBlock cacheKeyFilter;
+ (Axc_WebimageManager *)sharedManager;
- (id <Axc_WebimageOperation>)downloadImageWithURL:(NSURL *)url
                                         options:(Axc_WebimageOptions)options
                                        progress:(Axc_DownloadWebimageDownloaderProgressBlock)progressBlock
                                       completed:(Axc_WebimageCompletionWithFinishedBlock)completedBlock;
- (void)saveImageToCache:(UIImage *)image forURL:(NSURL *)url;
- (void)cancelAll;
- (BOOL)isRunning;
- (BOOL)cachedImageExistsForURL:(NSURL *)url;
- (BOOL)diskImageExistsForURL:(NSURL *)url;
- (void)cachedImageExistsForURL:(NSURL *)url
                     completion:(Axc_WebimageCheckCacheCompletionBlock)completionBlock;
- (void)diskImageExistsForURL:(NSURL *)url
                   completion:(Axc_WebimageCheckCacheCompletionBlock)completionBlock;
- (NSString *)cacheKeyForURL:(NSURL *)url;

@end


