//
//  Axc_WebImageRequest.m
//  AxcUIKit
//
//  Created by Axc_5324 on 17/5/5.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "Axc_WebImageRequest.h"

#import "Axc_WebimageCache.h"

#define DownloadProgressKeyPath @"downloadProgress"

static Axc_WebImageRequest *axc_WebImageRequest;


@interface Axc_WebImageRequest  ()<NSURLSessionDownloadDelegate>
{
    NSMutableData *_data;
    long long totalLength;
}
@end

@implementation Axc_WebImageRequest

+ (id)AxcUI_sharedRequest{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        if (!axc_WebImageRequest) {
            axc_WebImageRequest = [[Axc_WebImageRequest alloc] init];
        }
    });
    return axc_WebImageRequest;
}


- (void)AxcUI_sendRequestWithURL:(NSURL *)url
                        Progress:(Axc_WebimageDownloaderProgressBlock)progress
                  CompletedBlock:(Axc_WebimageDownloaderCompletedBlock)completedBlock
                         Failure:(Axc_WebimageDownloaderFailureBlock)failure{
    __weak __typeof(self)WeakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        WeakSelf.mainUrl = url;
        NSURLSessionConfiguration *config = [NSURLSessionConfiguration defaultSessionConfiguration];
        NSURLSession *session = [NSURLSession sessionWithConfiguration:config
                                                              delegate:WeakSelf
                                                         delegateQueue:[[NSOperationQueue alloc] init]];
        [[session downloadTaskWithURL:url] resume];
        // Block移接代理管理
        WeakSelf.progressBlock = progress;
        WeakSelf.completedBlock = completedBlock;
        WeakSelf.failureBlock = failure;
    });
}


#pragma mark - 连接代理方法
#pragma mark - NSURLSessionDownloadDelegate
- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didFinishDownloadingToURL:(NSURL *)location{
    NSData *data = [NSData dataWithContentsOfFile:location.path];
    [Axc_WebimageCache AxcUI_webimageCacheSaveWithData:data
                                                webKey:[axc_WebImageRequest.mainUrl absoluteString]];
    _completedBlock([UIImage imageWithData:data],data,location.path);
}


- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask didWriteData:(int64_t)bytesWritten totalBytesWritten:(int64_t)totalBytesWritten totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite{
    _progressBlock((CGFloat)totalBytesWritten / totalBytesExpectedToWrite);
}



- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(NSError *)error {
    if (error) {
        _failureBlock(error);
    }
}

@end
