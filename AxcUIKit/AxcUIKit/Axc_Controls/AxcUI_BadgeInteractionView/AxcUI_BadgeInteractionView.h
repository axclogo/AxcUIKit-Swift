//
//  AxcUI_BadgeInteractionView.h
//  AxcUIKit
//
//  Created by Axc on 2017/7/12.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 * 一个支持拖拽的小气泡
 */
@interface AxcUI_BadgeInteractionView : UIView


/**
 * 快速构造方法
 */
- (instancetype)initWithFrame:(CGRect)frame
           axcUI_dragdropCompletion:(void(^)())axcUI_dragdropCompletion;

/**
 * 拖拽结束的回调
 */
@property (nonatomic, copy) void(^axcUI_dragdropCompletion)();

/**
 * 颜色
 */
@property (nonatomic, strong) UIColor* axcUI_tintColor;

/**
 * 当文本是0的时候默认YES隐藏
 */
@property (nonatomic, assign) BOOL axcUI_hiddenWhenZero;

/**
 * 文本大小 默认16
 */
@property (nonatomic, strong) UIFont* axcUI_font;

/**
 * 文本大小 默认16
 */
@property (nonatomic, assign) CGFloat axcUI_fontSize;

/**
 * 自适应文本大小，默认NO
 */
@property (nonatomic, assign) BOOL axcUI_fontSizeAutoFit;

/**
 * 文本
 */
@property (nonatomic, strong) NSString* axcUI_text;

/**
 * 文本颜色
 */
@property (nonatomic, strong) UIColor* axcUI_textColor;

/**
 * 置空函数
 */
- (void)empty;


@end
