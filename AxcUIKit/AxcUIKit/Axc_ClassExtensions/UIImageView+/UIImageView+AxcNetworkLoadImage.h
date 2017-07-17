//
//  UIImage+AxcNetworkLoadImage.h
//  AxcUIKit
//
//  Created by Axc_5324 on 17/5/4.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//


//                //
// 轻量级图片加载模块 //
//                //





#import <UIKit/UIKit.h>

#import "Axc_WebImageRequest.h"


#define dispatch_global_async_safe(block)\
if ([NSThread isMainThread]) {\
block();\
} else {\
dispatch_async(dispatch_get_global_queue(0, 0),block);\
}


@interface UIImageView (AxcNetworkLoadImage)

/**
 *  加载网络图片
 */
- (void)AxcUI_setImageWithURL:(NSString *)url;
/**
 *  加载网络图片，带占位图
 */
- (void)AxcUI_setImageWithURL:(NSString *)url placeholderImage:(NSString *)placeholder;
/**
 *  加载网络图片,带进度
 */
- (void)AxcUI_setImageWithURL:(NSString *)url Progress:(Axc_WebimageDownloaderProgressBlock)progress;
/**
 *  加载网络图片，带占位图，带进度
 */
- (void)AxcUI_setImageWithURL:(NSString *)url placeholderImage:(NSString *)placeholder Progress:(Axc_WebimageDownloaderProgressBlock)progress;
/**
 *  加载网络图片，带占位图，带进度，失败回调
 */
- (void)AxcUI_setImageWithURL:(NSString *)url placeholderImage:(NSString *)placeholder Progress:(Axc_WebimageDownloaderProgressBlock)progress Failure:(Axc_WebimageDownloaderFailureBlock )failure;

////////////////////////以下为安全策略使用///////////////////////////////

/**
 *  多组分线程\队列下载图 加载网络图片
 */
- (void)AxcUI_queueSetImageWithURL:(NSString *)url;
/**
 *  多组分线程\队列下载图 加载网络图片，带占位图
 */
- (void)AxcUI_queueSetImageWithURL:(NSString *)url
                  placeholderImage:(NSString *)placeholder;
/**
 *  多组分线程\队列下载图 加载网络图片，带进度
 */
- (void)AxcUI_queueSetImageWithURL:(NSString *)url
                          Progress:(Axc_WebimageDownloaderProgressBlock)progress;
/**
 *  多组分线程\队列下载图 加载网络图片，带占位图，带进度
 */
- (void)AxcUI_queueSetImageWithURL:(NSString *)url
                  placeholderImage:(NSString *)placeholder
                          Progress:(Axc_WebimageDownloaderProgressBlock)progress;
/**
 *  多组分线程\队列下载图 加载网络图片，带占位图，带进度，完成回调
 */
- (void)AxcUI_queueSetImageWithURL:(NSString *)url
                  placeholderImage:(NSString *)placeholder
                          Progress:(Axc_WebimageDownloaderProgressBlock)progress
                          Complete:(Axc_WebimageDownloaderCompletedBlock )complete;


@end
