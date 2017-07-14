//
//  UIView+AxcBadgeView.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/14.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "UIView+AxcBadgeView.h"

#import <objc/runtime.h>

#import "UIView+AxcExtension.h"


static NSString * const kbadgeView = @"AxcUI_BadgeInteractionView";
static NSString * const kbadgePoint = @"axcUI_badgePoint";
static NSString * const kbadgeText = @"axcUI_badgeText";

@implementation UIView (AxcBadgeView)


- (void)setAxcUI_badgeText:(NSString *)axcUI_badgeText{
    [self willChangeValueForKey:kbadgeText];
    objc_setAssociatedObject(self, &kbadgeText,
                             axcUI_badgeText,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kbadgeText];
    self.AxcUI_BadgeInteractionView.axcUI_text = axcUI_badgeText;
}

- (NSString *)axcUI_badgeText{
    return self.AxcUI_BadgeInteractionView.axcUI_text;
}


- (void)setAxcUI_badgePoint:(CGPoint)axcUI_badgePoint{
    [self willChangeValueForKey:kbadgeView];
    objc_setAssociatedObject(self, &kbadgeView,
                             [NSValue valueWithCGPoint:axcUI_badgePoint],
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kbadgeView];
    self.AxcUI_BadgeInteractionView.center = axcUI_badgePoint;
}

- (CGPoint)axcUI_badgePoint{
    return self.AxcUI_BadgeInteractionView.center;
}



- (void)setAxcUI_BadgeInteractionView:(AxcUI_BadgeInteractionView *)AxcUI_BadgeInteractionView{
    [self willChangeValueForKey:kbadgeView];
    objc_setAssociatedObject(self, &kbadgeView,
                             AxcUI_BadgeInteractionView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kbadgeView];
}

- (AxcUI_BadgeInteractionView *)AxcUI_BadgeInteractionView{
    AxcUI_BadgeInteractionView *badgeView = objc_getAssociatedObject(self, &kbadgeView);
    if (!badgeView) {
        badgeView = [[AxcUI_BadgeInteractionView alloc] init];
        badgeView.axcUI_Size = CGSizeMake(40, 40);
        badgeView.axcUI_X = self.axcUI_Width - badgeView.axcUI_Size.width;
        badgeView.axcUI_Y = 0;
        badgeView.axcUI_font = [UIFont systemFontOfSize:13];
        badgeView.axcUI_text = @"0";
        badgeView.axcUI_hiddenWhenZero = NO;
        [self addSubview:badgeView];
        [self setAxcUI_BadgeInteractionView:badgeView];
    }
    return badgeView;
}





@end
