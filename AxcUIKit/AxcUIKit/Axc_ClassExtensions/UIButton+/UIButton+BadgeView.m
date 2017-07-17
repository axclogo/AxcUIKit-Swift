//
//  UIView+BadgeView.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/16.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "UIView+BadgeView.h"
#import <objc/runtime.h>

#import "UIView+AxcExtension.h"


static NSString * const kbadgeView = @"AxcUI_BadgeView";
static NSString * const kbadgePoint = @"axcUI_badgePoint";
static NSString * const kbadgeText = @"axcUI_badgeText";


@implementation UIView (BadgeView)

- (AxcUI_BadgeView *)axcUI_badgeView{
    AxcUI_BadgeView *_axcUI_badgeView = objc_getAssociatedObject(self, &kbadgeView);
    if (!_axcUI_badgeView) {
        _axcUI_badgeView = [[AxcUI_BadgeView alloc] init];
        _axcUI_badgeView.axcUI_Size = CGSizeMake(24, 24);
        _axcUI_badgeView.axcUI_text = @"1";
        [self setAxcUI_badgeView:_axcUI_badgeView];
        [self addSubview:_axcUI_badgeView];
    }
    return _axcUI_badgeView;
}

- (void)setAxcUI_badgeView:(AxcUI_BadgeView *)axcUI_badgeView{
    [self willChangeValueForKey:kbadgeView];
    objc_setAssociatedObject(self, &kbadgeView,
                             axcUI_badgeView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kbadgeView];
}


- (void)setAxcUI_badgeText:(NSString *)axcUI_badgeText{
    [self willChangeValueForKey:kbadgeText];
    objc_setAssociatedObject(self, &kbadgeText,
                             axcUI_badgeText,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kbadgeText];
    self.axcUI_badgeView.axcUI_text = axcUI_badgeText;
}

- (NSString *)axcUI_badgeText{
    return self.axcUI_badgeView.axcUI_text;
}


- (void)setAxcUI_badgePoint:(CGPoint)axcUI_badgePoint{
    [self willChangeValueForKey:kbadgePoint];
    objc_setAssociatedObject(self, &kbadgePoint,
                             [NSValue valueWithCGPoint:axcUI_badgePoint],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kbadgePoint];
    self.axcUI_badgeView.center = axcUI_badgePoint;
}

- (CGPoint)axcUI_badgePoint{
    return self.axcUI_badgeView.center;
}
@end
