//
//  UIView+AxcCoverEX.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/3.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "UIView+AxcCoverEX.h"
#import "UIView+AxcExtension.h"
#import <objc/runtime.h>

static NSString * const kCoverScrollView = @"axcUI_CoverScrollView";
static NSString * const kContentOffset = @"contentOffset";

@interface UIView ()

@property (nonatomic, strong) UIScrollView *axcUI_CoverScrollView;

@end

@implementation UIView (AxcCoverEX)



- (void)setAxcUI_CoverScrollView:(UIScrollView *)axcUI_CoverScrollView{
    [objc_getAssociatedObject(self, &kCoverScrollView) removeObserver:axcUI_CoverScrollView
                                                           forKeyPath:kContentOffset];

    [self willChangeValueForKey:kCoverScrollView];
    objc_setAssociatedObject(self, &kCoverScrollView,
                             axcUI_CoverScrollView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kCoverScrollView];
    
    [objc_getAssociatedObject(self, &kCoverScrollView) addObserver:self forKeyPath:kContentOffset options:NSKeyValueObservingOptionNew context:nil];
}

- (UIScrollView *)axcUI_CoverScrollView{
    return objc_getAssociatedObject(self, &kCoverScrollView);
}
- (void)AxcUI_removeObserveCoverScrollView{
    [self.axcUI_CoverScrollView removeObserver:self
                                    forKeyPath:kContentOffset];
    [self.axcUI_CoverScrollView removeFromSuperview];
    self.axcUI_CoverScrollView = nil;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context{
    if ([keyPath isEqualToString:kContentOffset]) {
        if (self.axcUI_CoverScrollView.contentOffset.y < 0) {
            CGFloat offset = -self.axcUI_CoverScrollView.contentOffset.y;
            self.frame = CGRectMake(-offset,
                                    -offset,
                                    self.axcUI_CoverScrollView.bounds.size.width + offset * 2,
                                    100 + offset);
        } else {
            self.frame = CGRectMake(0, 0, self.axcUI_CoverScrollView.bounds.size.width, 100);
        }
    }
    
}




@end
