//
//  UIButton+AxcButtonCountDown.h
//  AxcUIKit
//
//  Created by Axc on 2017/7/13.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (AxcButtonCountDown)

/**
 * 倒计时结束的回调
 */
@property (nonatomic, copy) void(^axcUI_buttonTimeStoppedCallback)();

/**
 设置倒计时的间隔和倒计时文案

 @param duration 倒计时时间
 @param format 可选，传nil默认为 @"%zd秒"
 */
- (void)AxcUI_countDownWithTimeInterval:(NSTimeInterval)duration
                        countDownFormat:(NSString *)format;

/** 
 * invalidate timer
 */
- (void)AxcUI_cancelTimer;

@end
