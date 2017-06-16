//
//  Axc_WebImageManager.m
//  AxcUIKit
//
//  Created by Axc_5324 on 17/5/4.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CommonCrypto/CommonDigest.h>

#import "Axc_WebimageCache.h"

#import "Axc_ImageCache.h"
#import "Axc_WebImageManager.h"

#define AxcImageCachePath @"/Documents/AxcImageCache/"

static NSString     *_imageCachePath;

@implementation Axc_WebimageCache

+ (id)AxcUI_sharedManager {
    static dispatch_once_t once;
    static id instance;
    dispatch_once(&once, ^{
        instance = [self new];
    });
    return instance;
}

#pragma mark Axc的数据缓存器 ------------------
#pragma mark 将数据存入缓存器
+ (void)AxcUI_webimageCacheSaveWithData:(NSData *)data webKey:(NSString *)webKey{
    NSString *cachePath = [NSString stringWithFormat:@"%@%@",NSHomeDirectory(),AxcImageCachePath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isSuccess = [fileManager createDirectoryAtPath:cachePath
                            withIntermediateDirectories:YES
                                             attributes:nil
                                                  error:nil];
    if (!isSuccess) {NSLog(@"Axc_WebimageCache创建图片缓存文件失败");return;}
    webKey = [Axc_WebimageCache AxcUI_webimageCacheMD5_Hash:webKey];
    NSString *filePath = [NSString stringWithFormat:@"%@%@",cachePath,webKey];
    BOOL isWrite = [data writeToFile:filePath
                          atomically:YES];
    if (!isWrite) { NSLog(@"Axc_WebimageCache缓存图片数据失败"); }
}

#pragma mark 将数据取出缓存器
+ (NSData *)AxcUI_webimageCacheGetDataWithwebKey:(NSString *)webKey{
    webKey = [Axc_WebimageCache AxcUI_webimageCacheMD5_Hash:webKey];
    NSString *filePath = [NSString stringWithFormat:@"%@%@%@",
                          NSHomeDirectory(),
                          AxcImageCachePath,
                          webKey];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:filePath]) {return nil;}
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    return data;
}

#pragma mark 清除数据缓存
+ (BOOL)AxcUI_webimageCacheClearCache{
    BOOL Clear;
    _imageCachePath = [NSString stringWithFormat:@"%@%@",
                       NSHomeDirectory(),
                       AxcImageCachePath];
    NSFileManager * fileManager = [NSFileManager defaultManager];
    CGFloat foderSize = 0.0;
        NSArray * fileArray = [fileManager subpathsAtPath:_imageCachePath];
        for (NSString * fileName in fileArray) {
            NSString *filePath = [_imageCachePath stringByAppendingPathComponent:fileName];
            CGFloat fileSize  = [fileManager attributesOfItemAtPath:filePath error:nil].fileSize;
            foderSize += fileSize/1024.0/1024.0;
        }
        if (foderSize > 0.01) {
            NSFileManager * fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:_imageCachePath]) {
                NSArray * fileArray = [fileManager subpathsAtPath:_imageCachePath];
                for (NSString * fileName in fileArray) {
                    NSString * filePath = [_imageCachePath stringByAppendingPathComponent:fileName];
                    [fileManager removeItemAtPath:filePath error:nil];
                }
            }
            Clear = YES;
        }else{Clear = NO ; }
    return Clear;
}
#pragma mark 获取缓存目录
+ (NSString *)AxcUI_getAxcImageCachePath{
    return [NSString stringWithFormat:@"%@%@",
            NSHomeDirectory(),
            AxcImageCachePath];
}

#pragma mark MD5加密方法(C语言hash算法)
+ (NSString *)AxcUI_webimageCacheMD5_Hash:(NSString *)oStr{
    const char *cStr = [oStr UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (int)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X%02X",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]];
}

+ (UIImage *)AxcUI_getAxcImageWithCacheKey:(NSString *)key{
    NSString *keyStr = [[Axc_WebimageManager sharedManager] cacheKeyForURL:[NSURL URLWithString:key]];
    return [[coreAxc_ImageCache_remakes sharedImageCache ]imageFromDiskCacheForKey:keyStr];
}
+ (void)AxcUI_imageCachePurge{
    [[coreAxc_ImageCache_remakes sharedImageCache] clearMemory];
    [[coreAxc_ImageCache_remakes sharedImageCache] clearDisk];
    [[coreAxc_ImageCache_remakes sharedImageCache] cleanDisk];
}

@end
