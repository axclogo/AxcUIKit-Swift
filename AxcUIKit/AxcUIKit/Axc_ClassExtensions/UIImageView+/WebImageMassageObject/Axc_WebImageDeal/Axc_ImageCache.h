//
//  Axc_ImageCache.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/6.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Axc_WebImageCompat.h"

typedef NS_ENUM(NSInteger, coreAxc_ImageCache_remakesType) {
    coreAxc_ImageCache_remakesTypeNone,
    coreAxc_ImageCache_remakesTypeDisk,
    coreAxc_ImageCache_remakesTypeMemory
};

typedef void(^Axc_WebimageQueryCompletedBlock)(UIImage *image, coreAxc_ImageCache_remakesType cacheType);

typedef void(^Axc_WebimageCheckCacheCompletionBlock)(BOOL isInCache);

typedef void(^Axc_WebimageCalculateSizeBlock)(NSUInteger fileCount, NSUInteger totalSize);

@interface coreAxc_ImageCache_remakes : NSObject

// 清洁套装
- (void)clearMemory;
- (void)clearDisk;
- (void)cleanDisk;


@property (assign, nonatomic) BOOL shouldDecompressImages;
@property (assign, nonatomic) BOOL shouldDisableiCloud;
@property (assign, nonatomic) BOOL shouldCacheImagesInMemory;
@property (assign, nonatomic) NSUInteger maxMemoryCost;
@property (assign, nonatomic) NSUInteger maxMemoryCountLimit;
@property (assign, nonatomic) NSInteger maxCacheAge;
@property (assign, nonatomic) NSUInteger maxCacheSize;
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
+ (coreAxc_ImageCache_remakes *)sharedImageCache;
- (id)initWithNamespace:(NSString *)ns;
- (id)initWithNamespace:(NSString *)ns diskCacheDirectory:(NSString *)directory;
-(NSString *)makeDiskCachePath:(NSString*)fullNamespace;
- (void)addReadOnlyCachePath:(NSString *)path;
- (void)storeImage:(UIImage *)image forKey:(NSString *)key;
- (void)storeImage:(UIImage *)image forKey:(NSString *)key toDisk:(BOOL)toDisk;
- (void)storeImage:(UIImage *)image recalculateFromImage:(BOOL)recalculate imageData:(NSData *)imageData forKey:(NSString *)key toDisk:(BOOL)toDisk;
- (NSOperation *)queryDiskCacheForKey:(NSString *)key done:(Axc_WebimageQueryCompletedBlock)doneBlock;
- (UIImage *)imageFromMemoryCacheForKey:(NSString *)key;
- (UIImage *)imageFromDiskCacheForKey:(NSString *)key;
- (void)removeImageForKey:(NSString *)key;
- (void)removeImageForKey:(NSString *)key withCompletion:(Axc_WebimageNoParamsBlock)completion;
- (void)removeImageForKey:(NSString *)key fromDisk:(BOOL)fromDisk;
- (void)removeImageForKey:(NSString *)key fromDisk:(BOOL)fromDisk withCompletion:(Axc_WebimageNoParamsBlock)completion;

- (NSUInteger)getSize;
- (NSUInteger)getDiskCount;
- (void)calculateSizeWithCompletionBlock:(Axc_WebimageCalculateSizeBlock)completionBlock;
- (void)diskImageExistsWithKey:(NSString *)key completion:(Axc_WebimageCheckCacheCompletionBlock)completionBlock;
- (BOOL)diskImageExistsWithKey:(NSString *)key;
- (NSString *)cachePathForKey:(NSString *)key inPath:(NSString *)path;
- (NSString *)defaultCachePathForKey:(NSString *)key;

@end
