//
//  NSData+ImageContentType.h
//  AxcUIKit
//
//  Created by Axc on 2017/6/6.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (ImageContentType)

/**
 * 计算图像数据的内容类型
 */
+ (NSString *)coreAxc_contentTypeForImageData:(NSData *)data;

@end


