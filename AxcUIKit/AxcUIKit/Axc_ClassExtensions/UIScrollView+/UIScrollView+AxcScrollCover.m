//
//  UIScrollView+AxcScrollCover.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/3.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "UIScrollView+AxcScrollCover.h"
#import "UIView+AxcCoverEX.h"

#import <objc/runtime.h>
#import "AxcUIKit.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored  "-Wincompatible-pointer-types"

static NSString * const kCoverView = @"axcUI_CoverView";
static NSString * const kAutomaticCoverHeight = @"axcUI_AutomaticCoverHeight";
static NSString * const ktableHeaderView = @"tableHeaderView";

@implementation UIScrollView (AxcScrollCover)


- (void)setAxcUI_CoverView:(UIView *)axcUI_CoverView{
    [self willChangeValueForKey:kCoverView];
    objc_setAssociatedObject(self, &kCoverView,
                             axcUI_CoverView,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kCoverView];
    [self setCoverView:axcUI_CoverView];
}

- (UIView *)axcUI_CoverView{
    return objc_getAssociatedObject(self, &kCoverView);
}

- (void)setAxcUI_AutomaticCoverHeight:(BOOL)axcUI_AutomaticCoverHeight{
    [self willChangeValueForKey:kAutomaticCoverHeight];
    objc_setAssociatedObject(self, &kAutomaticCoverHeight,
                             @(axcUI_AutomaticCoverHeight),
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:kCoverView];
    UITableView *tableView;
    if (axcUI_AutomaticCoverHeight) {
        if ([self isKindOfClass:[UITableView class]]) { // 如果类型匹配则调整tableHeaderView高度参数
            UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.axcUI_CoverView.axcUI_Height)];
            tableView = (UITableView *)self;
            tableView.tableHeaderView = view;
        }
    }else{
        if ([self isKindOfClass:[UITableView class]]) { // 如果类型匹配则取消tableHeaderView高度参数
            tableView = (UITableView *)self;
            tableView.tableHeaderView = nil;
        }
    }
    [tableView reloadData];
}
    
- (BOOL)axcUI_AutomaticCoverHeight{
    return [objc_getAssociatedObject(self, &kAutomaticCoverHeight) boolValue];
}


- (void)setCoverView:(UIView *)view{
    [view setAxcUI_CoverScrollView:self];
    [self addSubview:view];
}

- (void)AxcUIKit_removeCoverView{
    [self.axcUI_CoverView removeFromSuperview];
    self.axcUI_CoverView = nil;
}


@end
