//
//  UIImage+AxcNetworkLoadImage.m
//  AxcUIKit
//
//  Created by Axc_5324 on 17/5/4.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "UIImageView+AxcNetworkLoadImage.h"

#import "Axc_WebimageCache.h"

#import "UIImageView+AxcWebCache.h"

@implementation UIImageView (AxcNetworkLoadImage)

- (void)AxcUI_setImageWithURL:(NSString *)url{
    [self AxcUI_loadingDiskImageCacheWithURL:url
                             placeholderName:nil];
}

- (void)AxcUI_setImageWithURL:(NSString *)url placeholderImage:(NSString *)placeholder{
    [self AxcUI_loadingDiskImageCacheWithURL:url
                             placeholderName:placeholder];
}

- (void)AxcUI_setImageWithURL:(NSString *)url Progress:(Axc_WebimageDownloaderProgressBlock)progress{
    [self AxcUI_loadingDiskImageCacheWithURL:url
                             placeholderName:nil
                                    Progress:progress
                                     Failure:nil];
}

- (void)AxcUI_setImageWithURL:(NSString *)url placeholderImage:(NSString *)placeholder Progress:(Axc_WebimageDownloaderProgressBlock)progress{
    [self AxcUI_loadingDiskImageCacheWithURL:url
                             placeholderName:placeholder
                                    Progress:progress
                                     Failure:nil];
}
- (void)AxcUI_setImageWithURL:(NSString *)url placeholderImage:(NSString *)placeholder
                     Progress:(Axc_WebimageDownloaderProgressBlock)progress
                      Failure:(Axc_WebimageDownloaderFailureBlock)failure{
    [self AxcUI_loadingDiskImageCacheWithURL:url
                             placeholderName:placeholder
                                    Progress:progress
                                     Failure:failure];
}

#pragma mark - 分水岭 ==================================================
//  多组分线程\队列下载图 加载网络图片
- (void)AxcUI_queueSetImageWithURL:(NSString *)url{
    [self coreAxc_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:url]
                                     andPlaceholderImage:nil
                                                 options:0
                                                progress:nil
                                               completed:nil];
}
// 多组分线程\队列下载图 加载网络图片，带占位图
- (void)AxcUI_queueSetImageWithURL:(NSString *)url
                  placeholderImage:(NSString *)placeholder{
    [self coreAxc_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:url]
                                     andPlaceholderImage:[UIImage imageNamed:placeholder]
                                                 options:0
                                                progress:nil
                                               completed:nil];
}
// 多组分线程\队列下载图 加载网络图片，带进度
- (void)AxcUI_queueSetImageWithURL:(NSString *)url
                          Progress:(Axc_WebimageDownloaderProgressBlock)progress{
    [self coreAxc_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:url]
                                     andPlaceholderImage:nil
                                                 options:0
                                                progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                    progress((CGFloat )receivedSize/expectedSize);
                                                } completed:nil];
}
// 多组分线程\队列下载图 加载网络图片，带占位图，带进度
- (void)AxcUI_queueSetImageWithURL:(NSString *)url
                  placeholderImage:(NSString *)placeholder
                          Progress:(Axc_WebimageDownloaderProgressBlock)progress{
    [self coreAxc_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:url]
                                     andPlaceholderImage:[UIImage imageNamed:placeholder]
                                                 options:0
                                                progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                    progress((CGFloat )receivedSize/expectedSize);
                                                }
                                               completed:nil];
}
// 多组分线程\队列下载图 加载网络图片，带占位图，带进度，完成回调
- (void)AxcUI_queueSetImageWithURL:(NSString *)url
                  placeholderImage:(NSString *)placeholder
                          Progress:(Axc_WebimageDownloaderProgressBlock)progress
                          Complete:(Axc_WebimageDownloaderCompletedBlock )complete{
    [self coreAxc_setImageWithPreviousCachedImageWithURL:[NSURL URLWithString:url]
                                     andPlaceholderImage:[UIImage imageNamed:placeholder]
                                                 options:0
                                                progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                    progress((CGFloat )receivedSize/expectedSize);
                                                }
                                               completed:^(UIImage *image, NSError *error, coreAxc_ImageCache_remakesType cacheType, NSURL *imageURL) {
                                                   NSData *data ;
                                                   if (UIImagePNGRepresentation(image) == nil) {
                                                       data = UIImageJPEGRepresentation(image, 1);
                                                   } else {
                                                       data = UIImagePNGRepresentation(image);
                                                   }
                                                   complete(image,data,imageURL.absoluteString);
                                                }];
}


- (void)AxcUI_loadingDiskImageCacheWithURL:(NSString *)urlStr placeholderName:(NSString *)placeholder{
    [Axc_WebimageCache AxcUI_sharedManager];
    __weak __typeof(self)WeakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *imageData = [Axc_WebimageCache AxcUI_webimageCacheGetDataWithwebKey:urlStr];
        if (!imageData) {
            if (placeholder || (![placeholder isEqualToString:@""])) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    WeakSelf.image = [UIImage AxcUI_setImageNamed:placeholder];
                });
            }
            NSURL *url = [NSURL URLWithString:urlStr];
            imageData = [NSData dataWithContentsOfURL:url];
            if (!imageData) {return ;}
            [WeakSelf AxcUI_setImageWithSelf:imageData];
            [Axc_WebimageCache AxcUI_webimageCacheSaveWithData:imageData
                                                        webKey:urlStr];
        }else{
            [WeakSelf AxcUI_setImageWithSelf:imageData];
        }
    });
}

- (void)AxcUI_setImageWithSelf:(NSData *)data{
    dispatch_async(dispatch_get_main_queue(), ^{
        self.image = [UIImage imageWithData:data];
        [self setNeedsDisplay];
    });
}

- (void)AxcUI_loadingDiskImageCacheWithURL:(NSString *)urlStr
                           placeholderName:(NSString *)placeholder
                                  Progress:(Axc_WebimageDownloaderProgressBlock)downloadProgress
                                   Failure:(Axc_WebimageDownloaderFailureBlock )failure{
    [Axc_WebimageCache AxcUI_sharedManager];
    __weak __typeof(self)WeakSelf = self;
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *imageData = [Axc_WebimageCache AxcUI_webimageCacheGetDataWithwebKey:urlStr];
        if (!imageData) {
            if (placeholder || (![placeholder isEqualToString:@""])) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    WeakSelf.image = [UIImage AxcUI_setImageNamed:placeholder];
                });
            }
            NSURL *url = [NSURL URLWithString:urlStr];
            imageData = [NSData dataWithContentsOfURL:url];
            [[Axc_WebImageRequest AxcUI_sharedRequest] AxcUI_sendRequestWithURL:url
                                                 Progress:^(CGFloat progress) {
                                                     downloadProgress(progress);}
                                           CompletedBlock:^(UIImage *image,
                                                            NSData *data,
                                                            NSString *path) {
                                               if (!imageData) {return ;}
                                               [WeakSelf AxcUI_setImageWithSelf:imageData];}
                                                  Failure:^(NSError *error) {failure(error);}];
        }else{
            [WeakSelf AxcUI_setImageWithSelf:imageData];
        }
    });
}



@end
