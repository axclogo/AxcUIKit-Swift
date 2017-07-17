//
//  UIImage+AxcImageName.h
//  AxcUIKit
//
//  Created by Axc_5324 on 17/5/4.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AxcImageName)

/**
 *  通过图片大小来选择来加载图片
 */
+(UIImage *)AxcUI_setImageNamed:(NSString *)name;
/**
 *  计算图片大小（KB）
 */
+ (int )AxcUI_fileSizeAtPath:(NSString*) filePath;

/**
 *  获取Boundle里的图片
 */
+(UIImage *)AxcUI_axcUIBoundleImageName:(NSString *)name;


@end
