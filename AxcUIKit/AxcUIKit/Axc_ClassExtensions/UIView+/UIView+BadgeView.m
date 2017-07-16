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


static NSString * const kbadgeView = @"AxcUI_BadgeInteractionView";
static NSString * const kbadgePoint = @"axcUI_badgeInteractionPoint";
static NSString * const kbadgeText = @"axcUI_badgeText";


@implementation UIView (BadgeView)



- (void)setAxcUI_badgeText:(NSString *)axcUI_badgeText{
    [self willChangeValueForKey:kbadgeText];
    objc_setAssociatedObject(self, &kbadgeText,
                             axcUI_badgeText,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kbadgeText];
    self.axcUI_badgeView.axcUI_text = axcUI_badgeText;
}

- (NSString *)axcUI_badgeInteractionText{
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

- (CGPoint)axcUI_badgeInteractionPoint{
    return self.axcUI_badgeView.center;
}
@end
