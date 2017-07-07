//
//  UIButton+AxcContentLayout.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/7.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "UIButton+AxcContentLayout.h"
#import <objc/runtime.h>

NS_ASSUME_NONNULL_BEGIN


static void *axcUI_buttonContentLayoutTypeKey = @"axcUI_buttonContentLayoutTypeKey";
static void *paddingKey = @"paddingKey";
static void *axcUI_paddingInsetKey = @"axcUI_paddingInsetKey";

@implementation UIButton (AxcContentLayout)

- (void)setupButtonLayout{
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    CGFloat image_w = self.imageView.frame.size.width;
    CGFloat image_h = self.imageView.frame.size.height;
    
    CGFloat title_w = self.titleLabel.frame.size.width;
    CGFloat title_h = self.titleLabel.frame.size.height;
    
    if ([UIDevice currentDevice].systemVersion.floatValue >= 8.0){
        // 由于iOS8中titleLabel的size为0，用下面的这种设置
        title_w = self.titleLabel.intrinsicContentSize.width;
        title_h = self.titleLabel.intrinsicContentSize.height;
    }
    
    UIEdgeInsets imageEdge = UIEdgeInsetsZero;
    UIEdgeInsets titleEdge = UIEdgeInsetsZero;
    
    if (self.axcUI_paddingInset == 0){
        self.axcUI_paddingInset = 5;
    }
    
    switch (self.axcUI_buttonContentLayoutType) {
        case AxcButtonContentLayoutStyleNormal:{
            titleEdge = UIEdgeInsetsMake(0, self.axcUI_padding, 0, 0);
            imageEdge = UIEdgeInsetsMake(0, 0, 0, self.axcUI_padding);
        }
            break;
        case AxcButtonContentLayoutStyleCenterImageRight:{
            titleEdge = UIEdgeInsetsMake(0, -image_w - self.axcUI_padding, 0, image_w);
            imageEdge = UIEdgeInsetsMake(0, title_w + self.axcUI_padding, 0, -title_w);
        }
            break;
        case AxcButtonContentLayoutStyleCenterImageTop:{
            titleEdge = UIEdgeInsetsMake(0, -image_w, -image_h - self.axcUI_padding, 0);
            imageEdge = UIEdgeInsetsMake(-title_h - self.axcUI_padding, 0, 0, -title_w);
        }
            break;
        case AxcButtonContentLayoutStyleCenterImageBottom:{
            titleEdge = UIEdgeInsetsMake(-image_h - self.axcUI_padding, -image_w, 0, 0);
            imageEdge = UIEdgeInsetsMake(0, 0, -title_h - self.axcUI_padding, -title_w);
        }
            break;
        case AxcButtonContentLayoutStyleLeftImageLeft:{
            titleEdge = UIEdgeInsetsMake(0, self.axcUI_padding + self.axcUI_paddingInset, 0, 0);
            imageEdge = UIEdgeInsetsMake(0, self.axcUI_paddingInset, 0, 0);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }
            break;
        case AxcButtonContentLayoutStyleLeftImageRight:{
            titleEdge = UIEdgeInsetsMake(0, -image_w + self.axcUI_paddingInset, 0, 0);
            imageEdge = UIEdgeInsetsMake(0, title_w + self.axcUI_padding + self.axcUI_paddingInset, 0, 0);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
        }
            break;
        case AxcButtonContentLayoutStyleRightImageLeft:{
            imageEdge = UIEdgeInsetsMake(0, 0, 0, self.axcUI_padding + self.axcUI_paddingInset);
            titleEdge = UIEdgeInsetsMake(0, 0, 0, self.axcUI_paddingInset);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        }
            break;
        case AxcButtonContentLayoutStyleRightImageRight:{
            titleEdge = UIEdgeInsetsMake(0, -self.frame.size.width / 2, 0, image_w + self.axcUI_padding + self.axcUI_paddingInset);
            imageEdge = UIEdgeInsetsMake(0, 0, 0, -title_w + self.axcUI_paddingInset);
            self.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
        }
            break;
        default:break;
    }
    self.imageEdgeInsets = imageEdge;
    self.titleEdgeInsets = titleEdge;
    [self setNeedsDisplay];
}


#pragma mark - setter / getter
- (void)setAxcUI_buttonContentLayoutType:(AxcButtonContentLayoutStyle)axcUI_buttonContentLayoutType{
    objc_setAssociatedObject(self, axcUI_buttonContentLayoutTypeKey, @(axcUI_buttonContentLayoutType), OBJC_ASSOCIATION_ASSIGN);
    [self setupButtonLayout];
}

- (AxcButtonContentLayoutStyle)axcUI_buttonContentLayoutType{
    return [objc_getAssociatedObject(self, axcUI_buttonContentLayoutTypeKey) integerValue];
}

- (void)setAxcUI_padding:(CGFloat)axcUI_padding{
    objc_setAssociatedObject(self, paddingKey, @(axcUI_padding), OBJC_ASSOCIATION_ASSIGN);
    [self setupButtonLayout];
}

- (CGFloat)axcUI_padding{
    return [objc_getAssociatedObject(self, paddingKey) floatValue];
}

- (void)setAxcUI_paddingInset:(CGFloat)axcUI_paddingInset{
    objc_setAssociatedObject(self, axcUI_paddingInsetKey, @(axcUI_paddingInset), OBJC_ASSOCIATION_ASSIGN);
    [self setupButtonLayout];
}

- (CGFloat)axcUI_paddingInset{
    return [objc_getAssociatedObject(self, axcUI_paddingInsetKey) floatValue];
}


@end
NS_ASSUME_NONNULL_END

