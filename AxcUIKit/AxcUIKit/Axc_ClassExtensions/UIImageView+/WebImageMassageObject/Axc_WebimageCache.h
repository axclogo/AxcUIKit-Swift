//
//  Axc_WebImageManager.h
//  AxcUIKit
//
//  Created by Axc_5324 on 17/5/4.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UIImage+AxcImageName.h"


@interface Axc_WebimageCache : NSObject

/**
 *  共享单例
 */
+ (id)AxcUI_sharedManager;

/**
 *  将数据存入缓存器
 */
+ (void)AxcUI_webimageCacheSaveWithData:(NSData *)data webKey:(NSString *)webKey;
/**
 *  将数据取出缓存器
 */
+ (NSData *)AxcUI_webimageCacheGetDataWithwebKey:(NSString *)webKey;
/**
 *  清除数据缓存
 */
+ (BOOL)AxcUI_webimageCacheClearCache;
/**
 *  获取缓存目录
 */
+ (NSString *)AxcUI_getAxcImageCachePath;
/**
 *  将图片取出缓存器
 */
+ (UIImage *)AxcUI_getAxcImageWithCacheKey:(NSString *)key;

/**
 *  清理分线程方法中所有加载图片遗留的缓存
 */
+ (void)AxcUI_imageCachePurge;

@end
