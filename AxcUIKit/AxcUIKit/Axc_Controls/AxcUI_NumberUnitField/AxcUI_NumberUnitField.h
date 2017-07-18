//
//  AxcUI_NumberUnitField.h
//  AxcUIKit
//
//  Created by Axc on 2017/7/3.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

// 兼容性
#ifdef NSFoundationVersionNumber_iOS_9_x_Max
    UIKIT_EXTERN NSNotificationName const NumberUnitFieldDidBecomeFirstResponderNotification;
    UIKIT_EXTERN NSNotificationName const NumberUnitFieldDidResignFirstResponderNotification;
#else
    UIKIT_EXTERN NSString *const NumberUnitFieldDidBecomeFirstResponderNotification;
    UIKIT_EXTERN NSString *const NumberUnitFieldDidResignFirstResponderNotification;
#endif

@protocol AxcNumberUnitFieldDelegate;

IB_DESIGNABLE


/** 数字输入框 */
@interface AxcUI_NumberUnitField : UIControl

@property (nullable, nonatomic, weak) id<AxcNumberUnitFieldDelegate> axcUI_numberFieldDelegate;

/**
 保留的用户输入的字符串
 */
@property (nullable, nonatomic, copy) NSString *axcUI_text;

/**
 当需要密文输入时，可以设置该值为 YES，输入文字将被圆点替代
 如：
    ┌┈┈┈┬┈┈┈┬┈┈┈┬┈┈┈┐
    ┆ • ┆ • ┆ • ┆ • ┆       axcUI_secureTextEntry is YES.
    └┈┈┈┴┈┈┈┴┈┈┈┴┈┈┈┘
    ┌┈┈┈┬┈┈┈┬┈┈┈┬┈┈┈┐
    ┆ 1 ┆ 2 ┆ 3 ┆ 4 ┆       axcUI_secureTextEntry is NO.
    └┈┈┈┴┈┈┈┴┈┈┈┴┈┈┈┘
 默认值为 NO.
 */
@property (nonatomic, assign, getter=isaxcUI_secureTextEntry) IBInspectable BOOL axcUI_secureTextEntry;

#if TARGET_INTERFACE_BUILDER
/**
 允许输入的个数。
 目前 AxcUI_NumberUnitField 允许的输入单元个数区间控制在 1 ~ 8 个。任何超过该范围内的赋值行为都将被忽略。
 */
@property (nonatomic, assign) IBInspectable NSUInteger axcUI_inputUnitCount;
#else
@property (nonatomic, assign) NSUInteger axcUI_inputUnitCount;
#endif


/**
 每个 Unit 之间的距离，默认为 0
    ┌┈┈┈┬┈┈┈┬┈┈┈┬┈┈┈┐
    ┆ 1 ┆ 2 ┆ 3 ┆ 4 ┆       axcUI_unitSpace is 0.
    └┈┈┈┴┈┈┈┴┈┈┈┴┈┈┈┘
    ┌┈┈┈┐┌┈┈┈┐┌┈┈┈┐┌┈┈┈┐
    ┆ 1 ┆┆ 2 ┆┆ 3 ┆┆ 4 ┆    axcUI_unitSpace is 6
    └┈┈┈┘└┈┈┈┘└┈┈┈┘└┈┈┈┘
 */
@property (nonatomic, assign) IBInspectable CGFloat axcUI_unitSpace;

/**
 设置边框圆角
    ╭┈┈┈╮╭┈┈┈╮╭┈┈┈╮╭┈┈┈╮
    ┆ 1 ┆┆ 2 ┆┆ 3 ┆┆ 4 ┆    axcUI_unitSpace is 6, axcUI_borderRadius is 4.
    ╰┈┈┈╯╰┈┈┈╯╰┈┈┈╯╰┈┈┈╯
    ╭┈┈┈┬┈┈┈┬┈┈┈┬┈┈┈╮
    ┆ 1 ┆ 2 ┆ 3 ┆ 4 ┆       axcUI_unitSpace is 0, axcUI_borderRadius is 4.
    ╰┈┈┈┴┈┈┈┴┈┈┈┴┈┈┈╯
 */
@property (nonatomic, assign) IBInspectable CGFloat axcUI_borderRadius;

/**
 设置边框宽度，默认为 1。
 */
@property (nonatomic, assign) IBInspectable CGFloat axcUI_borderWidth;

/**
 设置文本字体
 */
@property (nonatomic, strong) IBInspectable UIFont *axcUI_textFont;

/**
 设置文本颜色，默认为黑色。
 */
@property (null_resettable, nonatomic, strong) IBInspectable UIColor *axcUI_textColor;

@property (null_resettable, nonatomic, strong) IBInspectable UIColor *axcUI_tintColor;

/**
 如果需要完成一个 unit 输入后显示地指定已完成的 unit 颜色，可以设置该属性。默认为 nil。
 注意：
    该属性仅在`axcUI_unitSpace`属性值大于 2 时有效。在连续模式下，不适合颜色跟踪。可以考虑使用`axcUI_cursorColor`替代
 */
@property (nullable, nonatomic, strong) IBInspectable UIColor *axcUI_trackTintColor;

/**
 用于提示输入的焦点所在位置，设置该值后会产生一个光标闪烁动画，如果设置为空，则不生成光标动画。
 */
@property (nullable, nonatomic, strong) IBInspectable UIColor *axcUI_cursorColor;

/**
 当输入完成后，是否需要自动取消第一响应者。默认为 NO。
 */
@property (nonatomic, assign) IBInspectable BOOL axcUI_autoResignFirstResponderWhenInputFinished;

- (instancetype)initWithInputUnitCount:(NSUInteger)count;

@end



@protocol AxcNumberUnitFieldDelegate <NSObject>

@optional
- (BOOL)AxcUI_numberUnitField:(AxcUI_NumberUnitField *)uniField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
