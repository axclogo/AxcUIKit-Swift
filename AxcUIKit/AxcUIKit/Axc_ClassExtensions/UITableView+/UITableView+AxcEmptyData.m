//
//  UITableView+AxcEmptyData.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/11.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "UITableView+AxcEmptyData.h"
#import <objc/runtime.h>

static NSString * const kplaceHolderViewAnimations = @"axcUI_placeHolderViewAnimations";


@implementation UITableView (AxcEmptyData)

-(void)setAxcUI_placeHolderViewAnimations:(BOOL)axcUI_placeHolderViewAnimations{
    [self willChangeValueForKey:kplaceHolderViewAnimations];
    objc_setAssociatedObject(self, &kplaceHolderViewAnimations,
                             @(axcUI_placeHolderViewAnimations),
                             OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:kplaceHolderViewAnimations];
}
- (BOOL)axcUI_placeHolderViewAnimations{
    if (!objc_getAssociatedObject(self, &kplaceHolderViewAnimations)) {
        return YES;
    }else{
        BOOL bol = [objc_getAssociatedObject(self, &kplaceHolderViewAnimations) boolValue];
        return bol;
    }
}

-(void)setAxcUI_placeHolderView:(UIView *)axcUI_placeHolderView{
    objc_setAssociatedObject(self, @selector(axcUI_placeHolderView),axcUI_placeHolderView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    if (objc_getAssociatedObject(self, @selector(axcUI_placeHolderView))) {
        //防止手动调用load出现多次调用的情况：
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            [UITableView swizzleOriginMethod:@selector(reloadData)
                                      Method:@selector(customReloadData)];
        });
    }
}

-(UIView *)axcUI_placeHolderView{
    return objc_getAssociatedObject(self, @selector(axcUI_placeHolderView));
}


#pragma mark 自定义刷新方法：
-(void)customReloadData{
    [self checkIsEmpty];
    [self customReloadData];
}
//替换方法：
+ (void)swizzleOriginMethod:(SEL)oriSel Method:(SEL)newSel{
    Method oriMethod = class_getInstanceMethod(self, oriSel);
    Method newMethod = class_getInstanceMethod(self, newSel);
    BOOL methodIsAdd = class_addMethod(self, oriSel, method_getImplementation(newMethod), method_getTypeEncoding(newMethod));
    if (methodIsAdd) {
        class_replaceMethod(self, newSel, method_getImplementation(oriMethod), method_getTypeEncoding(oriMethod));
    }else{
        method_exchangeImplementations(oriMethod, newMethod);
    }
}

- (void)checkIsEmpty{
    BOOL isEmpty = YES;
    id<UITableViewDataSource> src = self.dataSource;
    if ([src respondsToSelector:@selector(numberOfSectionsInTableView:)]) {//group
        NSInteger sections = [src numberOfSectionsInTableView:self];
        if (sections > 0) {
            isEmpty = NO;
        }
    }else{
        NSInteger rows = [src tableView:self numberOfRowsInSection:0];//plain
        if (rows > 0) {
            isEmpty = NO;
        }
    }
    if (isEmpty) {
        [self.axcUI_placeHolderView removeFromSuperview];
        [self addSubview:self.axcUI_placeHolderView];
        if (self.axcUI_placeHolderViewAnimations) {
            __weak typeof(self) WeakSelf = self;
            self.axcUI_placeHolderView.alpha = 0;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 WeakSelf.axcUI_placeHolderView.alpha = 1;
                             }];
        }
    }else{
        if (self.axcUI_placeHolderViewAnimations) {
            __weak typeof(self) WeakSelf = self;
            [UIView animateWithDuration:0.3
                             animations:^{
                                 WeakSelf.axcUI_placeHolderView.alpha = 0;
                             } completion:^(BOOL finished) {
                                 [WeakSelf.axcUI_placeHolderView removeFromSuperview];
                             }];
        }else{
            [self.axcUI_placeHolderView removeFromSuperview];
        }
    }
}



@end
