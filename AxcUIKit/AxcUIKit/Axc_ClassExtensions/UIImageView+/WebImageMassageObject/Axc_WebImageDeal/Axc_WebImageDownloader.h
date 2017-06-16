//
//  Axc_WebImageDownloader.h
//  AxcUIKit
//
//  Created by Axc on 2017/6/6.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Axc_WebImageCompat.h"
#import "Axc_WebImageOperation.h"

typedef NS_OPTIONS(NSUInteger, Axc_WebimageDownloaderOptions) {
    Axc_WebimageDownloaderLowPriority = 1 << 0,
    Axc_WebimageDownloaderProgressiveDownload = 1 << 1,
    Axc_WebimageDownloaderUseNSURLCache = 1 << 2,
    Axc_WebimageDownloaderIgnoreCachedResponse = 1 << 3,
    Axc_WebimageDownloaderContinueInBackground = 1 << 4,
    Axc_WebimageDownloaderHandleCookies = 1 << 5,
    Axc_WebimageDownloaderAllowInvalidSSLCertificates = 1 << 6,
    Axc_WebimageDownloaderHighPriority = 1 << 7,
};

typedef NS_ENUM(NSInteger, Axc_WebimageDownloaderExecutionOrder) {
    Axc_WebimageDownloaderFIFOExecutionOrder,
    Axc_WebimageDownloaderLIFOExecutionOrder
};

extern NSString *const Axc_WebimageDownloadStartNotification;
extern NSString *const Axc_WebimageDownloadStopNotification;

typedef void(^Axc_DownloadWebimageDownloaderProgressBlock)(NSInteger receivedSize, NSInteger expectedSize);

typedef void(^Axc_DownloadWebimageDownloaderCompletedBlock)(UIImage *image, NSData *data, NSError *error, BOOL finished);

typedef NSDictionary *(^Axc_WebimageDownloaderHeadersFilterBlock)(NSURL *url, NSDictionary *headers);

@interface Axc_WebimageDownloader : NSObject
@property (assign, nonatomic) BOOL shouldDecompressImages;

@property (assign, nonatomic) NSInteger maxConcurrentDownloads;
@property (readonly, nonatomic) NSUInteger currentDownloadCount;

@property (assign, nonatomic) NSTimeInterval downloadTimeout;

@property (assign, nonatomic) Axc_WebimageDownloaderExecutionOrder executionOrder;

+ (Axc_WebimageDownloader *)sharedDownloader;

@property (strong, nonatomic) NSString *username;

@property (strong, nonatomic) NSString *password;

@property (nonatomic, copy) Axc_WebimageDownloaderHeadersFilterBlock headersFilter;

- (void)setValue:(NSString *)value forHTTPHeaderField:(NSString *)field;

- (NSString *)valueForHTTPHeaderField:(NSString *)field;

- (void)setOperationClass:(Class)operationClass;

- (id <Axc_WebimageOperation>)downloadImageWithURL:(NSURL *)url
                                         options:(Axc_WebimageDownloaderOptions)options
                                        progress:(Axc_DownloadWebimageDownloaderProgressBlock)progressBlock
                                       completed:(Axc_DownloadWebimageDownloaderCompletedBlock)completedBlock;

- (void)setSuspended:(BOOL)suspended;

@end
