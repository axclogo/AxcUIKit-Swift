//
//  Axc_WebImageDownloaderOperation.h
//  AxcUIKit
//
//  Created by Axc on 2017/6/6.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Axc_WebImageDownloader.h"
#import "Axc_WebImageOperation.h"

extern NSString *const Axc_WebimageDownloadStartNotification;
extern NSString *const Axc_WebimageDownloadReceiveResponseNotification;
extern NSString *const Axc_WebimageDownloadStopNotification;
extern NSString *const Axc_WebimageDownloadFinishNotification;

@interface Axc_WebimageDownloaderOperation : NSOperation <Axc_WebimageOperation>

@property (strong, nonatomic, readonly) NSURLRequest *request;
@property (assign, nonatomic) BOOL shouldDecompressImages;
@property (nonatomic, assign) BOOL shouldUseCredentialStorage;
@property (nonatomic, strong) NSURLCredential *credential;

@property (assign, nonatomic, readonly) Axc_WebimageDownloaderOptions options;

@property (assign, nonatomic) NSInteger expectedSize; // 下载
@property (strong, nonatomic) NSURLResponse *response;

- (id)initWithRequest:(NSURLRequest *)request
              options:(Axc_WebimageDownloaderOptions)options
             progress:(Axc_DownloadWebimageDownloaderProgressBlock)progressBlock
            completed:(Axc_DownloadWebimageDownloaderCompletedBlock)completedBlock
            cancelled:(Axc_WebimageNoParamsBlock)cancelBlock;

@end
