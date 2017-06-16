//
//  Axc_WebImageRequest.h
//  AxcUIKit
//
//  Created by Axc_5324 on 17/5/5.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void(^Axc_WebimageDownloaderProgressBlock)(CGFloat progress);

typedef void(^Axc_WebimageDownloaderCompletedBlock)(UIImage *image, NSData *data, NSString *path);

typedef void(^Axc_WebimageDownloaderFailureBlock)(NSError *error);



@interface Axc_WebImageRequest : NSObject

@property (nonatomic,strong) Axc_WebimageDownloaderProgressBlock progressBlock;
@property (nonatomic,strong) Axc_WebimageDownloaderCompletedBlock completedBlock;
@property (nonatomic,strong) Axc_WebimageDownloaderFailureBlock failureBlock;

@property (nonatomic,strong) NSURL *mainUrl;


/**
 *  共享单例
 */
+ (id)AxcUI_sharedRequest;

/**
 *  Axc独享方法嫁接式网络下载
 */
- (void)AxcUI_sendRequestWithURL:(NSURL *)url
                        Progress:(Axc_WebimageDownloaderProgressBlock)progress
                  CompletedBlock:(Axc_WebimageDownloaderCompletedBlock)completedBlock
                         Failure:(Axc_WebimageDownloaderFailureBlock)failure;



@end
