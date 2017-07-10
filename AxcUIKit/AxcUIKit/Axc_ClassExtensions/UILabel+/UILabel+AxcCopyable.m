//
//  UILabel+AxcCopyable.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/10.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "UILabel+AxcCopyable.h"
#import <objc/runtime.h>

@interface UILabel ()

@property (nonatomic) UILongPressGestureRecognizer *longPressGestureRecognizer;

@end

@implementation UILabel (AxcCopyable)

#pragma mark - UIResponder类
// 需要拥有第一响应者

- (BOOL)canBecomeFirstResponder{
    return self.axcUI_copyingEnabled;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender{
    // 只返回YES axcUI_copyingEnabled属性是YES
    return (action == @selector(copy:) && self.axcUI_copyingEnabled);
}

- (void)copy:(id)sender{
    if(self.axcUI_copyingEnabled){
        // 复制标签文本
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        [pasteboard setString:self.text];
    }
}

#pragma mark - 界面操作

- (void) longPressGestureRecognized:(UIGestureRecognizer *) gestureRecognizer{
    if (gestureRecognizer == self.longPressGestureRecognizer){
        if (gestureRecognizer.state == UIGestureRecognizerStateBegan){
            [self becomeFirstResponder];
            UIMenuController *copyMenu = [UIMenuController sharedMenuController];
            [copyMenu setTargetRect:self.bounds inView:self];
            copyMenu.arrowDirection = UIMenuControllerArrowDefault;
            [copyMenu setMenuVisible:YES animated:YES];
        }
    }
}

#pragma mark - SET

- (BOOL)axcUI_copyingEnabled{
    return [objc_getAssociatedObject(self, @selector(axcUI_copyingEnabled)) boolValue];
}

- (void)setAxcUI_copyingEnabled:(BOOL)axcUI_copyingEnabled{
    if(self.axcUI_copyingEnabled != axcUI_copyingEnabled){
        objc_setAssociatedObject(self, @selector(axcUI_copyingEnabled), @(axcUI_copyingEnabled), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [self setupGestureRecognizers];
    }
}

- (UILongPressGestureRecognizer *)longPressGestureRecognizer{
    return objc_getAssociatedObject(self, @selector(longPressGestureRecognizer));
}

- (void)setLongPressGestureRecognizer:(UILongPressGestureRecognizer *)longPressGestureRecognizer{
    objc_setAssociatedObject(self, @selector(longPressGestureRecognizer), longPressGestureRecognizer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)axcUI_shouldUseLongPressGestureRecognizer{
    NSNumber *value = objc_getAssociatedObject(self, @selector(axcUI_shouldUseLongPressGestureRecognizer));
    if(value == nil) {
        // 设置初始化参数
        value = @YES;
        objc_setAssociatedObject(self, @selector(axcUI_shouldUseLongPressGestureRecognizer), value, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return [value boolValue];
}

- (void)setAxcUI_shouldUseLongPressGestureRecognizer:(BOOL)useGestureRecognizer{
    if(self.axcUI_shouldUseLongPressGestureRecognizer != useGestureRecognizer){
        objc_setAssociatedObject(self, @selector(axcUI_shouldUseLongPressGestureRecognizer), @(useGestureRecognizer), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [self setupGestureRecognizers];
    }
}

#pragma mark - 复用函数

- (void) setupGestureRecognizers{
    // 移除 gesture recognizer
    if(self.longPressGestureRecognizer) {
        [self removeGestureRecognizer:self.longPressGestureRecognizer];
        self.longPressGestureRecognizer = nil;
    }
    if(self.axcUI_shouldUseLongPressGestureRecognizer && self.axcUI_copyingEnabled) {
        self.userInteractionEnabled = YES;
        // 编辑 gesture recognizer
        self.longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressGestureRecognized:)];
        [self addGestureRecognizer:self.longPressGestureRecognizer];
    }
}


@end
