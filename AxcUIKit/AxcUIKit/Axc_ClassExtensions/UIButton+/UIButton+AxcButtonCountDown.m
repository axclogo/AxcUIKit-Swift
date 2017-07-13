//
//  UIButton+AxcButtonCountDown.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/13.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "UIButton+AxcButtonCountDown.h"
#import <objc/runtime.h>

@interface UIButton ()

@property (nonatomic, assign) NSTimeInterval leaveTime;
@property (nonatomic, copy) NSString *normalTitle;
@property (nonatomic, copy) NSString *countDownFormat;
@property (nonatomic, strong) dispatch_source_t timer;

@end

static NSString * const ktimer = @"timer";
static NSString * const kleaveTime = @"leaveTime";
static NSString * const kcountDownFormat = @"countDownFormat";
static NSString * const kaxcUI_buttonTimeStoppedCallback = @"axcUI_buttonTimeStoppedCallback";
static NSString * const knormalTitle = @"normalTitle";

@implementation UIButton (AxcButtonCountDown)

- (void)setTimer:(dispatch_source_t)timer {
    [self willChangeValueForKey:ktimer];
    objc_setAssociatedObject(self, &ktimer,
                             timer,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:ktimer];
}

- (dispatch_source_t)timer {
    return objc_getAssociatedObject(self, &ktimer);
}

- (void)setLeaveTime:(NSTimeInterval)leaveTime {
    [self willChangeValueForKey:kleaveTime];
    objc_setAssociatedObject(self, &kleaveTime,
                             @(leaveTime),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kleaveTime];
}

- (NSTimeInterval)leaveTime {
    return [objc_getAssociatedObject(self, &kleaveTime) doubleValue];
}

- (void)setCountDownFormat:(NSString *)countDownFormat {
    [self willChangeValueForKey:kcountDownFormat];
    objc_setAssociatedObject(self, &kcountDownFormat,
                             countDownFormat,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kcountDownFormat];
}

- (NSString *)countDownFormat {
    return objc_getAssociatedObject(self, &kcountDownFormat);
}

- (void)setAxcUI_buttonTimeStoppedCallback:(void (^)())axcUI_buttonTimeStoppedCallback {
    [self willChangeValueForKey:kaxcUI_buttonTimeStoppedCallback];
    objc_setAssociatedObject(self, &kaxcUI_buttonTimeStoppedCallback,
                             axcUI_buttonTimeStoppedCallback,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kaxcUI_buttonTimeStoppedCallback];
}

- (void (^)())axcUI_buttonTimeStoppedCallback {
    return objc_getAssociatedObject(self, &kaxcUI_buttonTimeStoppedCallback);
}

- (void)setNormalTitle:(NSString *)normalTitle {
    [self willChangeValueForKey:knormalTitle];
    objc_setAssociatedObject(self, &knormalTitle,
                             normalTitle,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:knormalTitle];
}

- (NSString *)normalTitle {
    return objc_getAssociatedObject(self, &knormalTitle);
}

#pragma mark - 设置函数

- (void)AxcUI_countDownWithTimeInterval:(NSTimeInterval)duration countDownFormat:(NSString *)format{
    if (!format){
        self.countDownFormat = @"%zd秒";
    } else {
        self.countDownFormat = format;
    }
    self.normalTitle = self.titleLabel.text;
    __block NSInteger timeOut = duration; //倒计时时间
    __weak typeof(self) weakSelf = self;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    self.timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0,queue);
    dispatch_source_set_timer(self.timer,dispatch_walltime(NULL, 0),1.0*NSEC_PER_SEC, 0); //每秒执行
    dispatch_source_set_event_handler(self.timer, ^{
        if (timeOut <= 0) { // 倒计时结束，关闭
            [weakSelf AxcUI_cancelTimer];
        } else {
            NSString *title = [NSString stringWithFormat:weakSelf.countDownFormat,timeOut];
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setTitle:title forState:UIControlStateNormal];
            });
            timeOut--;
        }
    });
    dispatch_resume(self.timer);
}

- (void)AxcUI_cancelTimer {
    dispatch_source_cancel(self.timer);
    self.timer = nil;
    dispatch_async(dispatch_get_main_queue(), ^{
        // 设置界面的按钮显示 根据自己需求设置
        [self setTitle:self.normalTitle forState:UIControlStateNormal];
        self.userInteractionEnabled = YES;
        if (self.axcUI_buttonTimeStoppedCallback) { self.axcUI_buttonTimeStoppedCallback(); }
    });
}

@end
