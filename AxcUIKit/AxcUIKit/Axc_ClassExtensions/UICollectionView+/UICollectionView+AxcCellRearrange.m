//
//  UICollectionView+AxcCellRearrange.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/3.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//


#import "UICollectionView+AxcCellRearrange.h"
#import <objc/runtime.h>

typedef NS_ENUM(NSUInteger, AutoScrollDirection) {
    AxcCellRearrangeAutoScrollDirectionNone = 0,
    AxcCellRearrangeAutoScrollDirectionUp,
    AxcCellRearrangeAutoScrollDirectionDown,
    AxcCellRearrangeAutoScrollDirectionLeft,
    AxcCellRearrangeAutoScrollDirectionRight
};

@interface UICollectionView ()

@property (nonatomic, strong) UILongPressGestureRecognizer *rearrangeLongPress;     // 长摁手势
@property (nonatomic, assign) AutoScrollDirection autoScrollDirection;              // 枚举方向
@property (nonatomic, strong) CADisplayLink *displayLink;                           // 展示动画
@property (nonatomic, strong) UIView *moveView;                                     // 替身View
@property (nonatomic, strong) NSIndexPath *sourceIndexPath;                         // 记录参数
@property (nonatomic, strong) UICollectionViewCell *moveCell;                       // 使用Runtime获取

@end

@implementation UICollectionView (AxcCellRearrange)

#pragma mark - Runtime重写SET&GET

- (UIView *)moveView {
    return objc_getAssociatedObject(self, @selector(moveView));
}

- (UICollectionViewCell *)moveCell {
    return objc_getAssociatedObject(self, @selector(moveCell));
}

- (NSIndexPath *)sourceIndexPath {
    return objc_getAssociatedObject(self, @selector(sourceIndexPath));
}

- (BOOL)axcUI_enableRearrangement {
    return [objc_getAssociatedObject(self, @selector(axcUI_enableRearrangement)) boolValue];
}

- (CGFloat)axcUI_autoScrollSpeed {
    return [objc_getAssociatedObject(self, @selector(axcUI_autoScrollSpeed)) doubleValue];
}

- (CGFloat)axcUI_longPressMagnificationFactor {
    return [objc_getAssociatedObject(self, @selector(axcUI_longPressMagnificationFactor)) doubleValue];
}

- (id<AxcCollectionViewRearrangeDelegate>)axcUI_rearrangeDelegate {
    return objc_getAssociatedObject(self, @selector(axcUI_rearrangeDelegate));
}

- (UILongPressGestureRecognizer *)rearrangeLongPress {
    return objc_getAssociatedObject(self, @selector(rearrangeLongPress));
}

- (AutoScrollDirection)autoScrollDirection {
    return [objc_getAssociatedObject(self, @selector(autoScrollDirection)) unsignedIntegerValue];
}

- (CADisplayLink *)displayLink {
    return objc_getAssociatedObject(self, @selector(displayLink));
}

#pragma mark - set
- (void)setMoveView:(UIView *)moveView {
    objc_setAssociatedObject(self, @selector(moveView), moveView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setMoveCell:(UICollectionViewCell *)moveCell {
    objc_setAssociatedObject(self, @selector(moveCell), moveCell, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setSourceIndexPath:(NSIndexPath *)sourceIndexPath {
    objc_setAssociatedObject(self, @selector(sourceIndexPath), sourceIndexPath, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setAxcUI_enableRearrangement:(BOOL)axcUI_enableRearrangement {
    objc_setAssociatedObject(self, @selector(axcUI_enableRearrangement), @(axcUI_enableRearrangement), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    if (axcUI_enableRearrangement) {
        [self setupRearrangement];
    } else {
        [self removeGestureRecognizer:self.rearrangeLongPress];
    }
}

- (void)setAxcUI_autoScrollSpeed:(CGFloat)axcUI_autoScrollSpeed {
    objc_setAssociatedObject(self, @selector(axcUI_autoScrollSpeed), @(axcUI_autoScrollSpeed), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setAxcUI_longPressMagnificationFactor:(CGFloat)axcUI_longPressMagnificationFactor {
    objc_setAssociatedObject(self, @selector(axcUI_longPressMagnificationFactor), @(axcUI_longPressMagnificationFactor), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setAxcUI_rearrangeDelegate:(id<AxcCollectionViewRearrangeDelegate>)axcUI_rearrangeDelegate {
    objc_setAssociatedObject(self, @selector(axcUI_rearrangeDelegate), axcUI_rearrangeDelegate, OBJC_ASSOCIATION_ASSIGN);
}

- (void)setRearrangeLongPress:(UILongPressGestureRecognizer *)rearrangeLongPress {
    objc_setAssociatedObject(self, @selector(rearrangeLongPress), rearrangeLongPress, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setAutoScrollDirection:(AutoScrollDirection)autoScrollDirection {
    objc_setAssociatedObject(self, @selector(autoScrollDirection), @(autoScrollDirection), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (void)setDisplayLink:(CADisplayLink *)displayLink {
    objc_setAssociatedObject(self, @selector(displayLink), displayLink, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - Axc执行方案

- (void)setupRearrangement {
    if (!self.axcUI_autoScrollSpeed) {
        self.axcUI_autoScrollSpeed = 5;
    }
    
    if (!self.axcUI_longPressMagnificationFactor) {
        self.axcUI_longPressMagnificationFactor = 1.2;
    }
    
    self.rearrangeLongPress = [[UILongPressGestureRecognizer alloc]
                               initWithTarget:self action:@selector(longPressAction:)];
    [self addGestureRecognizer:self.rearrangeLongPress];
}

- (UIView *)snapshotOfView:(UIView *)view {
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0.0f);
    
    [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return [[UIImageView alloc] initWithImage:image];
}

#pragma mark - 复用函数
- (void)startDisplayLink {
    CADisplayLink *displaylink = [CADisplayLink displayLinkWithTarget:self selector:@selector(displayLinkUpdate)];
    [displaylink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    self.displayLink = displaylink;
}

- (void)stopDisplayLink {
    if (!self.displayLink) {
        return;
    }
    
    [self.displayLink invalidate];
    self.displayLink = nil;
}

#pragma mark - 核心处理方案
- (void)autoScrollWithTouchMoveView:(UIView *)moveView {
    CGRect moveViewRectInSuperView = [moveView convertRect:moveView.bounds toView:self.superview];
    
    if (self.contentSize.height > self.frame.size.height) {
        if (moveViewRectInSuperView.size.height > self.frame.size.height) {
            return;
        }
        
        if (moveViewRectInSuperView.origin.y + moveView.frame.size.height > self.frame.size.height) {
            if (self.autoScrollDirection == AxcCellRearrangeAutoScrollDirectionUp) {
                return;
            }
            self.autoScrollDirection = AxcCellRearrangeAutoScrollDirectionUp;
            [self startDisplayLink];
            
            return;
            
        } else if (moveViewRectInSuperView.origin.y < 0) { // top
            
            if (self.autoScrollDirection == AxcCellRearrangeAutoScrollDirectionDown) {
                return;
            }
            self.autoScrollDirection = AxcCellRearrangeAutoScrollDirectionDown;
            [self startDisplayLink];
            
            return;
        }
        
    } else if(self.contentSize.width > self.frame.size.width) { // horizontal scroll
        
        if (moveViewRectInSuperView.size.width > self.frame.size.width) {
            return;
        }
        
        if (moveViewRectInSuperView.origin.x + moveView.frame.size.width > self.frame.size.width) { // right
            
            if (self.autoScrollDirection == AxcCellRearrangeAutoScrollDirectionLeft) {
                return;
            }
            self.autoScrollDirection = AxcCellRearrangeAutoScrollDirectionLeft;
            [self startDisplayLink];
            
            return;
            
        } else if (moveViewRectInSuperView.origin.x < 0) { // left
            
            if (self.autoScrollDirection == AxcCellRearrangeAutoScrollDirectionRight) {
                return;
            }
            self.autoScrollDirection = AxcCellRearrangeAutoScrollDirectionRight;
            [self startDisplayLink];
            
            return;
        }
    }
    
    self.autoScrollDirection = AxcCellRearrangeAutoScrollDirectionNone;
    [self stopDisplayLink];
}

- (void)autoScrollUpdateWithDirection:(AutoScrollDirection)autoScrollDirection {
    CGPoint offset = self.contentOffset;
    CGRect moveViewRect = self.moveView.frame;
    
    switch (autoScrollDirection) {
        case AxcCellRearrangeAutoScrollDirectionNone: {
            [self stopDisplayLink];
            break;
        }
        case AxcCellRearrangeAutoScrollDirectionLeft: {
            CGFloat diff = self.contentOffset.x - (self.contentSize.width - self.frame.size.width);
            
            if(diff + self.axcUI_autoScrollSpeed >= 0) {
                offset.x = self.contentSize.width - self.frame.size.width;
                self.contentOffset = offset;
                
                moveViewRect.origin.x += - diff;
                self.moveView.frame = moveViewRect;
                
                [self stopDisplayLink];
                return;
            }
            
            offset.x += self.axcUI_autoScrollSpeed;
            self.contentOffset = offset;
            
            moveViewRect.origin.x += self.axcUI_autoScrollSpeed;
            self.moveView.frame = moveViewRect;
            
            break;
        }
        case AxcCellRearrangeAutoScrollDirectionRight: {
            if (self.contentOffset.x - self.axcUI_autoScrollSpeed <= 0) {
                offset.x = 0;
                self.contentOffset = offset;
                
                moveViewRect.origin.x -= self.contentOffset.x;
                self.moveView.frame = moveViewRect;
                
                [self stopDisplayLink];
                return;
            }
            
            offset.x -= self.axcUI_autoScrollSpeed;
            self.contentOffset = offset;
            
            moveViewRect.origin.x -= self.axcUI_autoScrollSpeed;
            self.moveView.frame = moveViewRect;
            
            break;
        }
        case AxcCellRearrangeAutoScrollDirectionUp: {
            CGFloat diff = self.contentOffset.y - (self.contentSize.height - self.frame.size.height);
            
            if (diff + self.axcUI_autoScrollSpeed >= 0) {
                offset.y = self.contentSize.height - self.frame.size.height;
                self.contentOffset = offset;
                
                moveViewRect.origin.y += -diff;
                self.moveView.frame = moveViewRect;
                
                [self stopDisplayLink];
                return;
            }
            
            offset.y += self.axcUI_autoScrollSpeed;
            self.contentOffset = offset;
            
            moveViewRect.origin.y += self.axcUI_autoScrollSpeed;
            self.moveView.frame = moveViewRect;
            
            break;
        }
        case AxcCellRearrangeAutoScrollDirectionDown: {
            if (self.contentOffset.y - self.axcUI_autoScrollSpeed <= 0) {
                offset.y = 0;
                self.contentOffset = offset;
                
                moveViewRect.origin.y -= self.contentOffset.y;
                self.moveView.frame = moveViewRect;
                
                [self stopDisplayLink];
                return;
            }
            
            offset.y -= self.axcUI_autoScrollSpeed;
            self.contentOffset = offset;
            
            moveViewRect.origin.y -= self.axcUI_autoScrollSpeed;
            self.moveView.frame = moveViewRect;
            
            break;
        }
    }
    
    if (autoScrollDirection != AxcCellRearrangeAutoScrollDirectionNone) {
        NSIndexPath *targetIndexPath = [self indexPathForItemAtPoint:self.moveView.center];
        
        if (!targetIndexPath) {
            targetIndexPath = [self findIndexPathFailureHandleWithMoveView:self.moveView
                                                           scrollDirection:autoScrollDirection];
        }
        
        if (targetIndexPath) {
            [self longPressChangeWithTargetIndexPath:targetIndexPath pressPoint:self.moveView.center];
        }
    }
}

- (NSIndexPath *)findIndexPathFailureHandleWithMoveView:(UIView *)moveView
                                        scrollDirection:(AutoScrollDirection)autoScrollDirection {
    NSIndexPath *indexPath = nil;
    
    switch (autoScrollDirection) {
        case AxcCellRearrangeAutoScrollDirectionRight: {
            CGPoint firstPoint = CGPointMake(CGRectGetMaxX(moveView.frame), CGRectGetMaxY(moveView.frame));
            indexPath = [self indexPathForItemAtPoint:firstPoint];
            
            if (!indexPath) {
                CGPoint secondPoint = CGPointMake(CGRectGetMaxX(moveView.frame), CGRectGetMinY(moveView.frame));
                indexPath = [self indexPathForItemAtPoint:secondPoint];
            }
            
            break;
        }
        case AxcCellRearrangeAutoScrollDirectionLeft: {
            CGPoint firstPoint = CGPointMake(CGRectGetMinX(moveView.frame), CGRectGetMaxY(moveView.frame));
            indexPath = [self indexPathForItemAtPoint:firstPoint];
            
            if (!indexPath) {
                CGPoint secondPoint = CGPointMake(CGRectGetMinX(moveView.frame), CGRectGetMinY(moveView.frame));
                indexPath = [self indexPathForItemAtPoint:secondPoint];
            }
            
            break;
        }
        case AxcCellRearrangeAutoScrollDirectionDown: {
            CGPoint firstPoint = CGPointMake(CGRectGetMinX(moveView.frame), CGRectGetMaxY(moveView.frame));
            indexPath = [self indexPathForItemAtPoint:firstPoint];
            
            if (!indexPath) {
                CGPoint secondPoint = CGPointMake(CGRectGetMaxX(moveView.frame), CGRectGetMaxY(moveView.frame));
                indexPath = [self indexPathForItemAtPoint:secondPoint];
            }
            
            break;
        }
        case AxcCellRearrangeAutoScrollDirectionUp: {
            CGPoint firstPoint = CGPointMake(CGRectGetMinX(moveView.frame), CGRectGetMinY(moveView.frame));
            indexPath = [self indexPathForItemAtPoint:firstPoint];
            
            if (!indexPath) {
                CGPoint secondPoint = CGPointMake(CGRectGetMaxX(moveView.frame), CGRectGetMinY(moveView.frame));
                indexPath = [self indexPathForItemAtPoint:secondPoint];
            }
            
            break;
        }
        case AxcCellRearrangeAutoScrollDirectionNone: {
            break;
        }
            
    }
    
    return indexPath;
}

#pragma mark - 其他

- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
    CGPoint pressPoint = [longPress locationInView:longPress.view];
    NSIndexPath *targetIndexPath = [self indexPathForItemAtPoint:pressPoint];
    
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            [self longPressBeginWithTargetIndexPath:targetIndexPath pressPoint:pressPoint];
            
            break;
        }
        case UIGestureRecognizerStateChanged: {
            [self longPressChangeWithTargetIndexPath:targetIndexPath pressPoint:pressPoint];
            
            break;
        }
        default: {
            [self longPressEndWithTargetIndexPath:targetIndexPath];
            
            break;
        }
    }
}


#pragma mark - 代理回调区
- (void)longPressBeginWithTargetIndexPath:(NSIndexPath *)targetIndexPath pressPoint:(CGPoint)pressPoint {
    if (!targetIndexPath) {
        return;
    }
    
    self.sourceIndexPath = targetIndexPath;
    self.moveCell = [self cellForItemAtIndexPath:self.sourceIndexPath];
    
    if ([self.axcUI_rearrangeDelegate respondsToSelector:@selector(AxcUI_collectionView:shouldMoveCell:atIndexPath:)]) {
        if (![self.axcUI_rearrangeDelegate AxcUI_collectionView:self shouldMoveCell:self.moveCell atIndexPath:self.sourceIndexPath]) {
            return;
        }
    }
    
    self.moveView = [self snapshotOfView:self.moveCell];
    self.moveView.frame = self.moveCell.frame;
    [self addSubview:self.moveView];
    self.moveCell.hidden = YES;
    
    [UIView animateWithDuration:0.2 animations:^{
        self.moveView.transform = CGAffineTransformMakeScale(self.axcUI_longPressMagnificationFactor, self.axcUI_longPressMagnificationFactor);
        self.moveView.center = pressPoint;
    }];
}

- (void)longPressChangeWithTargetIndexPath:(NSIndexPath *)targetIndexPath pressPoint:(CGPoint)pressPoint{
    if (self.moveView) {
        self.moveView.center = pressPoint;
        [self autoScrollWithTouchMoveView:self.moveView];
    }
    
    if (!self.sourceIndexPath || !targetIndexPath || [targetIndexPath isEqual:self.sourceIndexPath]) {
        return;
    }
    
    if ([self.axcUI_rearrangeDelegate respondsToSelector:@selector(AxcUI_collectionView:shouldMoveCell:atIndexPath:)]) {
        if (![self.axcUI_rearrangeDelegate AxcUI_collectionView:self shouldMoveCell:self.moveCell atIndexPath:self.sourceIndexPath]) {
            return;
        }
        if (![self.axcUI_rearrangeDelegate AxcUI_collectionView:self shouldMoveCell:self.moveCell atIndexPath:targetIndexPath]) {
            return;
        }
    }
    
    if ([self.axcUI_rearrangeDelegate respondsToSelector:@selector(AxcUI_collectionView:shouldMoveCell:fromIndexPath:toIndexPath:)]) {
        if (![self.axcUI_rearrangeDelegate AxcUI_collectionView:self shouldMoveCell:self.moveCell fromIndexPath:self.sourceIndexPath toIndexPath:targetIndexPath]) {
            return;
        }
    }
    
    [self moveItemAtIndexPath:self.sourceIndexPath toIndexPath:targetIndexPath];
    
    
    if ([self.axcUI_rearrangeDelegate respondsToSelector:@selector(AxcUI_collectionView:didMoveCell:fromIndexPath:toIndexPath:)]) {
        [self.axcUI_rearrangeDelegate AxcUI_collectionView:self didMoveCell:self.moveCell fromIndexPath:self.sourceIndexPath toIndexPath:targetIndexPath];
    }
    
    self.sourceIndexPath = targetIndexPath;
}

- (void)longPressEndWithTargetIndexPath:(NSIndexPath *)targetIndexPath {
    if (!self.sourceIndexPath) {
        return;
    }
    
    if ([self.axcUI_rearrangeDelegate respondsToSelector:@selector(AxcUI_collectionView:shouldMoveCell:atIndexPath:)]) {
        if (![self.axcUI_rearrangeDelegate AxcUI_collectionView:self shouldMoveCell:self.moveCell atIndexPath:self.sourceIndexPath]) {
            return;
        }
    }
    
    [UIView animateWithDuration:0.2 animations:^{
        self.moveView.center = self.moveCell.center;
        self.moveView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        self.moveCell.hidden = NO;
        [self.moveView removeFromSuperview];
        self.moveView = nil;
        self.moveCell = nil;
        self.sourceIndexPath = nil;
        [self autoScrollWithTouchMoveView:self.moveView];
    }];
    
    if ([self.axcUI_rearrangeDelegate respondsToSelector:@selector(AxcUI_collectionView:putDownCell:atIndexPath:)]) {
        [self.axcUI_rearrangeDelegate AxcUI_collectionView:self putDownCell:self.moveCell atIndexPath:self.sourceIndexPath];
    }
}

// 展示、
- (void)displayLinkUpdate {
    [self autoScrollUpdateWithDirection:self.autoScrollDirection];
}

@end
