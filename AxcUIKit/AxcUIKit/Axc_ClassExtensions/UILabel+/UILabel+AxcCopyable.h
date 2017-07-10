//
//  UILabel+AxcCopyable.h
//  AxcUIKit
//
//  Created by Axc on 2017/7/10.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>


// 支持XIB使用
/**
    一个类别,使长按UILabel复制功能。
 */
@interface UILabel (AxcCopyable)

/**
    将此属性设置为是的为了启用复制特性。默认为 NO
 */
@property (nonatomic) IBInspectable BOOL axcUI_copyingEnabled;

/**
    用于启用/禁用内部长按手势识别器。默认值为YES。
 */
@property (nonatomic) IBInspectable BOOL axcUI_shouldUseLongPressGestureRecognizer;

@end
