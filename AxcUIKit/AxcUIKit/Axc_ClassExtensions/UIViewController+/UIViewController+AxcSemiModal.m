//
//  UIViewController+AxcSemiModal.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/3.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

// 和拖拽移动异曲同工，截图背景，增加展示效果，然后隐藏释放，不会驻留内存


#import "UIViewController+AxcSemiModal.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

const struct AxcSemiModalOption AxcUISemiModalOptionKeys = {
	.axcUI_traverseParentHierarchy = @"AxcSemiModalOptionTraverseParentHierarchy",
	.axcUI_pushParentBack          = @"AxcSemiModalOptionPushParentBack",
	.axcUI_animationDuration       = @"AxcSemiModalOptionAnimationDuration",
	.axcUI_parentAlpha             = @"AxcSemiModalOptionParentAlpha",
    .axcUI_parentScale             = @"AxcSemiModalOptionParentScale",
	.axcUI_shadowOpacity           = @"AxcSemiModalOptionShadowOpacity",
	.axcUI_transitionStyle         = @"AxcSemiModalOptionTransitionStyle",
    .axcUI_disableCancel           = @"AxcSemiModalOptionDisableCancel",
    .axcUI_backgroundView          = @"AxcSemiModelOptionBackgroundView",
};

#define kSemiModalViewController           @"PaPQC93kjgzUanz"
#define kSemiModalDismissBlock             @"l27h7RU2dzVfPoQ"
#define kSemiModalPresentingViewController @"QKWuTQjUkWaO1Xr"
#define kSemiModalOverlayTag               10001
#define kSemiModalScreenshotTag            10002
#define kSemiModalModalViewTag             10003
#define kSemiModalDismissButtonTag         10004

@interface UIViewController (AxcSemiModalInternal)
-(UIView*)parentTarget;
-(CAAnimationGroup*)animationGroupForward:(BOOL)_forward;
@end

@implementation UIViewController (AxcSemiModalInternal)

-(UIViewController*)Axc_parentTargetViewController {
	UIViewController * target = self;
	if ([[self optionsAndDefaultsAxc_optionOrDefaultForKey:AxcUISemiModalOptionKeys.axcUI_traverseParentHierarchy] boolValue]) {
		// 截图
		while (target.parentViewController != nil) {
			target = target.parentViewController;
		}
	}
	return target;
}
-(UIView*)parentTarget {
    return [self Axc_parentTargetViewController].view;
}

#pragma mark 仿SDLayout结构设置参数

-(void)Axc_registerDefaultsAndOptions:(NSDictionary*)options {
	[self optionsAndDefaultsAxc_registerOptions:options defaults:@{
     AxcUISemiModalOptionKeys.axcUI_traverseParentHierarchy : @(YES),
     AxcUISemiModalOptionKeys.axcUI_pushParentBack : @(YES),
     AxcUISemiModalOptionKeys.axcUI_animationDuration : @(0.5),
     AxcUISemiModalOptionKeys.axcUI_parentAlpha : @(0.5),
     AxcUISemiModalOptionKeys.axcUI_parentScale : @(0.8),
     AxcUISemiModalOptionKeys.axcUI_shadowOpacity : @(0.8),
     AxcUISemiModalOptionKeys.axcUI_transitionStyle : @(AxcSemiModalTransitionStyleSlideUp),
     AxcUISemiModalOptionKeys.axcUI_disableCancel : @(NO),
	 }];
}

#pragma mark Push-back 动画区

-(CAAnimationGroup*)animationGroupForward:(BOOL)_forward {
    // 动画键向前和向后
    CATransform3D t1 = CATransform3DIdentity;
    t1.m34 = 1.0/-900;
    t1 = CATransform3DScale(t1, 0.95, 0.95, 1);
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        // 旋转角度
        t1 = CATransform3DRotate(t1, 7.5f*M_PI/180.0f, 1, 0, 0);
    } else {
        t1 = CATransform3DRotate(t1, 15.0f*M_PI/180.0f, 1, 0, 0);
    }
    
    CATransform3D t2 = CATransform3DIdentity;
    t2.m34 = t1.m34;
    double scale = [[self optionsAndDefaultsAxc_optionOrDefaultForKey:AxcUISemiModalOptionKeys.axcUI_parentScale] doubleValue];
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
        // mantai视角控制
        t2 = CATransform3DTranslate(t2, 0, [self parentTarget].frame.size.height*-0.04, 0);
        t2 = CATransform3DScale(t2, scale, scale, 1);
    } else {
        t2 = CATransform3DTranslate(t2, 0, [self parentTarget].frame.size.height*-0.08, 0);
        t2 = CATransform3DScale(t2, scale, scale, 1);
    }
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation.toValue = [NSValue valueWithCATransform3D:t1];
	CFTimeInterval duration = [[self optionsAndDefaultsAxc_optionOrDefaultForKey:AxcUISemiModalOptionKeys.axcUI_animationDuration] doubleValue];
    animation.duration = duration/2;
    animation.fillMode = kCAFillModeForwards;
    animation.removedOnCompletion = NO;
    [animation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut]];
    
    CABasicAnimation *animation2 = [CABasicAnimation animationWithKeyPath:@"transform"];
    animation2.toValue = [NSValue valueWithCATransform3D:(_forward?t2:CATransform3DIdentity)];
    animation2.beginTime = animation.duration;
    animation2.duration = animation.duration;
    animation2.fillMode = kCAFillModeForwards;
    animation2.removedOnCompletion = NO;
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    [group setDuration:animation.duration*2];
    [group setAnimations:[NSArray arrayWithObjects:animation,animation2, nil]];
    return group;
}

-(void)Axc_interfaceOrientationDidChange:(NSNotification*)notification {
	UIView *overlay = [[self parentTarget] viewWithTag:kSemiModalOverlayTag];
	[self Axc_addOrUpdateParentScreenshotInView:overlay];
}

-(UIImageView*)Axc_addOrUpdateParentScreenshotInView:(UIView*)screenshotContainer {
	UIView *target = [self parentTarget];
	UIView *semiView = [target viewWithTag:kSemiModalModalViewTag];
	
	screenshotContainer.hidden = YES; // 没有蒙版
	semiView.hidden = YES;
	UIGraphicsBeginImageContextWithOptions(target.bounds.size, YES, [[UIScreen mainScreen] scale]);
    if ([target respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [target drawViewHierarchyInRect:target.bounds afterScreenUpdates:YES];
    } else {
        [target.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
	screenshotContainer.hidden = NO;
	semiView.hidden = NO;
	
	UIImageView* screenshot = (id) [screenshotContainer viewWithTag:kSemiModalScreenshotTag];
	if (screenshot) {
		screenshot.image = image;
	}
	else {
		screenshot = [[UIImageView alloc] initWithImage:image];
		screenshot.tag = kSemiModalScreenshotTag;
		screenshot.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[screenshotContainer addSubview:screenshot];
	}
	return screenshot;
}

@end

@implementation UIViewController (AxcSemiModal)

-(void)AxcUI_presentSemiViewController:(UIViewController*)vc {
	[self AxcUI_presentSemiViewController:vc withOptions:nil completion:nil dismissBlock:nil];
}
-(void)AxcUI_presentSemiViewController:(UIViewController*)vc
					 withOptions:(NSDictionary*)options {
    [self AxcUI_presentSemiViewController:vc withOptions:options completion:nil dismissBlock:nil];
}
-(void)AxcUI_presentSemiViewController:(UIViewController*)vc
					 withOptions:(NSDictionary*)options
					  completion:(AxcTransitionCompletionBlock)completion
					dismissBlock:(AxcTransitionCompletionBlock)dismissBlock {
    [self Axc_registerDefaultsAndOptions:options]; //  OK
	UIViewController *targetParentVC = [self Axc_parentTargetViewController];

	// semi-modal视图控制器
	[targetParentVC addChildViewController:vc];
	if ([vc respondsToSelector:@selector(beginAppearanceTransition:animated:)]) {
		[vc beginAppearanceTransition:YES animated:YES]; // iOS 6
	}
	objc_setAssociatedObject(self, kSemiModalViewController, vc, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	objc_setAssociatedObject(self, kSemiModalDismissBlock, dismissBlock, OBJC_ASSOCIATION_COPY_NONATOMIC);
	[self AxcUI_presentSemiView:vc.view withOptions:options completion:^{
		[vc didMoveToParentViewController:targetParentVC];
		if ([vc respondsToSelector:@selector(endAppearanceTransition)]) {
			[vc endAppearanceTransition]; // iOS 6
		}
		if (completion) {
			completion();
		}
	}];
}

-(void)AxcUI_presentSemiView:(UIView*)view {
	[self AxcUI_presentSemiView:view withOptions:nil completion:nil];
}
-(void)AxcUI_presentSemiView:(UIView*)view withOptions:(NSDictionary*)options {
	[self AxcUI_presentSemiView:view withOptions:options completion:nil];
}
-(void)AxcUI_presentSemiView:(UIView*)view
		   withOptions:(NSDictionary*)options
			completion:(AxcTransitionCompletionBlock)completion {
	[self Axc_registerDefaultsAndOptions:options]; //  OK
	UIView * target = [self parentTarget];
	
    if (![target.subviews containsObject:view]) {
        //设置关联对象
        objc_setAssociatedObject(view, kSemiModalPresentingViewController, self, OBJC_ASSOCIATION_RETAIN_NONATOMIC);

        // 更新控制器截图
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(Axc_interfaceOrientationDidChange:)
                                                     name:UIDeviceOrientationDidChangeNotification
                                                   object:nil];
        // 获取翻转风格
        NSUInteger transitionStyle = [[self optionsAndDefaultsAxc_optionOrDefaultForKey:AxcUISemiModalOptionKeys.axcUI_transitionStyle] unsignedIntegerValue];
        
        //Calulate所有帧
        CGFloat semiViewHeight = view.frame.size.height;
        CGRect vf = target.bounds;
        CGRect semiViewFrame;
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
            // 配给中心视图
            semiViewFrame = CGRectMake((vf.size.width - view.frame.size.width) / 2.0, vf.size.height-semiViewHeight, view.frame.size.width, semiViewHeight);
        } else {
            semiViewFrame = CGRectMake(0, vf.size.height-semiViewHeight, vf.size.width, semiViewHeight);
        }
        
        CGRect overlayFrame = CGRectMake(0, 0, vf.size.width, vf.size.height-semiViewHeight);
        
        // 添加覆盖
        UIView *overlay;
        UIView *backgroundView = [self optionsAndDefaultsAxc_optionOrDefaultForKey:AxcUISemiModalOptionKeys.axcUI_backgroundView];
        if (backgroundView) {
            overlay = backgroundView;
        } else {
            overlay = [[UIView alloc] init];
        }
        
        overlay.frame = target.bounds;
        overlay.backgroundColor = [UIColor blackColor];
        overlay.userInteractionEnabled = YES;
        overlay.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        overlay.tag = kSemiModalOverlayTag;
        
        // 截图
        UIImageView *ss = [self Axc_addOrUpdateParentScreenshotInView:overlay];
        [target addSubview:overlay];
        
        // 撤销按钮(如果允许)
        if(![[self optionsAndDefaultsAxc_optionOrDefaultForKey:AxcUISemiModalOptionKeys.axcUI_disableCancel] boolValue]) {
            // 不要使用UITapGestureRecognizer来避免与VCLoadView方法指针复写
            UIButton * dismissButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [dismissButton addTarget:self action:@selector(AxcUI_dismissSemiModalView) forControlEvents:UIControlEventTouchUpInside];
            dismissButton.backgroundColor = [UIColor clearColor];
            dismissButton.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
            dismissButton.frame = overlayFrame;
            dismissButton.tag = kSemiModalDismissButtonTag;
            [overlay addSubview:dismissButton];
        }
        
        // 动画就绪
		if ([[self optionsAndDefaultsAxc_optionOrDefaultForKey:AxcUISemiModalOptionKeys.axcUI_pushParentBack] boolValue]) {
			[ss.layer addAnimation:[self animationGroupForward:YES] forKey:@"pushedBackAnimation"];
		}
		NSTimeInterval duration = [[self optionsAndDefaultsAxc_optionOrDefaultForKey:AxcUISemiModalOptionKeys.axcUI_animationDuration] doubleValue];
        [UIView animateWithDuration:duration animations:^{
            ss.alpha = [[self optionsAndDefaultsAxc_optionOrDefaultForKey:AxcUISemiModalOptionKeys.axcUI_parentAlpha] floatValue];
        }];
        
        // 推出View动画
        view.frame = (transitionStyle == AxcSemiModalTransitionStyleSlideUp
                      ? CGRectOffset(semiViewFrame, 0, +semiViewHeight)
                      : semiViewFrame);
        if (transitionStyle == AxcSemiModalTransitionStyleFadeIn || transitionStyle == AxcSemiModalTransitionStyleFadeInOut) {
            view.alpha = 0.0;
        }
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
            // 不调整旋转视图的宽度
            view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
        } else {
            view.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleWidth;
        }
        
        view.tag = kSemiModalModalViewTag;
        [target addSubview:view];
        view.layer.shadowColor = [[UIColor blackColor] CGColor];
        view.layer.shadowOffset = CGSizeMake(0, -2);
        view.layer.shadowRadius = 5.0;
        view.layer.shadowOpacity = [[self optionsAndDefaultsAxc_optionOrDefaultForKey:AxcUISemiModalOptionKeys.axcUI_shadowOpacity] floatValue];
        view.layer.shouldRasterize = YES;
        view.layer.rasterizationScale = [[UIScreen mainScreen] scale];
        
        [UIView animateWithDuration:duration animations:^{
            if (transitionStyle == AxcSemiModalTransitionStyleSlideUp) {
                view.frame = semiViewFrame;
            } else if (transitionStyle == AxcSemiModalTransitionStyleFadeIn || transitionStyle == AxcSemiModalTransitionStyleFadeInOut) {
                view.alpha = 1.0;
            }
        } completion:^(BOOL finished) {
            if (!finished) return;
            [[NSNotificationCenter defaultCenter] postNotificationName:kSemiModalDidShowNotification
                                                                object:self];
            if (completion) {
                completion();
            }
        }];
    }
}
-(void)AxcUI_updateBackground{
    UIView * target = [self parentTarget];
    UIView * overlay = [target viewWithTag:kSemiModalOverlayTag];
    [self Axc_addOrUpdateParentScreenshotInView:overlay];
}
-(void)AxcUI_dismissSemiModalView {
	[self AxcUI_dismissSemiModalViewWithCompletion:nil];
}

-(void)AxcUI_dismissSemiModalViewWithCompletion:(void (^)(void))completion {
    // 寻找控制器如果可用则推出
    UIViewController * prstingTgt = self;
    UIViewController * presentingController = objc_getAssociatedObject(prstingTgt.view, kSemiModalPresentingViewController);
    while (presentingController == nil && prstingTgt.parentViewController != nil) {
        prstingTgt = prstingTgt.parentViewController;
        presentingController = objc_getAssociatedObject(prstingTgt.view, kSemiModalPresentingViewController);
    }
    if (presentingController) {
        objc_setAssociatedObject(presentingController.view, kSemiModalPresentingViewController, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [presentingController AxcUI_dismissSemiModalViewWithCompletion:completion];
        return;
    }

    // 释放目标
    UIView * target = [self parentTarget];
    UIView * modal = [target viewWithTag:kSemiModalModalViewTag];
    UIView * overlay = [target viewWithTag:kSemiModalOverlayTag];
	NSUInteger transitionStyle = [[self optionsAndDefaultsAxc_optionOrDefaultForKey:AxcUISemiModalOptionKeys.axcUI_transitionStyle] unsignedIntegerValue];
	NSTimeInterval duration = [[self optionsAndDefaultsAxc_optionOrDefaultForKey:AxcUISemiModalOptionKeys.axcUI_animationDuration] doubleValue];
	UIViewController *vc = objc_getAssociatedObject(self, kSemiModalViewController);
	AxcTransitionCompletionBlock dismissBlock = objc_getAssociatedObject(self, kSemiModalDismissBlock);
	
	// 子控制器控制
	[vc willMoveToParentViewController:nil];
	if ([vc respondsToSelector:@selector(beginAppearanceTransition:animated:)]) {
		[vc beginAppearanceTransition:NO animated:YES]; // iOS 6
	}
	
    [UIView animateWithDuration:duration animations:^{
        if (transitionStyle == AxcSemiModalTransitionStyleSlideUp) {
            if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad){
                // 作为视图为中心/焦点
                modal.frame = CGRectMake((target.bounds.size.width - modal.frame.size.width) / 2.0, target.bounds.size.height, modal.frame.size.width, modal.frame.size.height);
            } else {
                modal.frame = CGRectMake(0, target.bounds.size.height, modal.frame.size.width, modal.frame.size.height);
            }
        } else if (transitionStyle == AxcSemiModalTransitionStyleFadeOut || transitionStyle == AxcSemiModalTransitionStyleFadeInOut) {
            modal.alpha = 0.0;
        }
    } completion:^(BOOL finished) {
        [overlay removeFromSuperview];
        [modal removeFromSuperview];
        
        // 子控制器控制
        [vc removeFromParentViewController];
        if ([vc respondsToSelector:@selector(endAppearanceTransition)]) {
            [vc endAppearanceTransition];
        }
        
        if (dismissBlock) {
            dismissBlock();
        }
        
        objc_setAssociatedObject(self, kSemiModalDismissBlock, nil, OBJC_ASSOCIATION_COPY_NONATOMIC);
        objc_setAssociatedObject(self, kSemiModalViewController, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIDeviceOrientationDidChangeNotification object:nil];
    }];
    
    // 开始动画
    UIImageView * ss = (UIImageView*)[overlay.subviews objectAtIndex:0];
	if ([[self optionsAndDefaultsAxc_optionOrDefaultForKey:AxcUISemiModalOptionKeys.axcUI_pushParentBack] boolValue]) {
		[ss.layer addAnimation:[self animationGroupForward:NO] forKey:@"bringForwardAnimation"];
	}
    [UIView animateWithDuration:duration animations:^{
        ss.alpha = 1;
    } completion:^(BOOL finished) {
        if(finished){
            [[NSNotificationCenter defaultCenter] postNotificationName:kSemiModalDidHideNotification
                                                                object:self];
            if (completion) {
                completion();
            }
        }
    }];
}

- (void)AxcUI_resizeSemiView:(CGSize)newSize {
    UIView * target = [self parentTarget];
    UIView * modal = [target viewWithTag:kSemiModalModalViewTag];
    CGRect mf = modal.frame;
    mf.size.width = newSize.width;
    mf.size.height = newSize.height;
    mf.origin.y = target.frame.size.height - mf.size.height;
    UIView * overlay = [target viewWithTag:kSemiModalOverlayTag];
    UIButton * button = (UIButton*)[overlay viewWithTag:kSemiModalDismissButtonTag];
    CGRect bf = button.frame;
    bf.size.height = overlay.frame.size.height - newSize.height;
	NSTimeInterval duration = [[self optionsAndDefaultsAxc_optionOrDefaultForKey:AxcUISemiModalOptionKeys.axcUI_animationDuration] doubleValue];
	[UIView animateWithDuration:duration animations:^{
        modal.frame = mf;
        button.frame = bf;
    } completion:^(BOOL finished) {
        if(finished){
            [[NSNotificationCenter defaultCenter] postNotificationName:kSemiModalWasResizedNotification
                                                                object:self];
        }
    }];
}

@end



#pragma mark - NSObject (AxcUIOptionsAndDefaults)

#import <objc/runtime.h>

@implementation NSObject (AxcUIOptionsAndDefaults)

static char const * const kYMStandardOptionsTableName = "YMStandardOptionsTableName";
static char const * const kYMStandardDefaultsTableName = "YMStandardDefaultsTableName";

- (void)optionsAndDefaultsAxc_registerOptions:(NSDictionary *)options
				  defaults:(NSDictionary *)defaults
{
	objc_setAssociatedObject(self, kYMStandardOptionsTableName, options, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
	objc_setAssociatedObject(self, kYMStandardDefaultsTableName, defaults, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (id)optionsAndDefaultsAxc_optionOrDefaultForKey:(NSString*)optionKey
{
	NSDictionary *options = objc_getAssociatedObject(self, kYMStandardOptionsTableName);
	NSDictionary *defaults = objc_getAssociatedObject(self, kYMStandardDefaultsTableName);
	NSAssert(defaults, @"默认值必须设置当访问选项!");
	return options[optionKey] ?: defaults[optionKey];
}
@end



#pragma mark - UIView (AxcUIFindUIViewController)

@implementation UIView (AxcUIFindUIViewController)
- (UIViewController *) findUIViewControllerAxc_containingViewController {
    UIView * target = self.superview ? self.superview : self;
    return (UIViewController *)[target findUIViewControllerAxc_traverseResponderChainForUIViewController];
}

- (id) findUIViewControllerAxc_traverseResponderChainForUIViewController {
    id nextResponder = [self nextResponder];
    BOOL isViewController = [nextResponder isKindOfClass:[UIViewController class]];
    BOOL isTabBarController = [nextResponder isKindOfClass:[UITabBarController class]];
    if (isViewController && !isTabBarController) {
        return nextResponder;
    } else if(isTabBarController){
        UITabBarController *tabBarController = nextResponder;
        return [tabBarController selectedViewController];
    } else if ([nextResponder isKindOfClass:[UIView class]]) {
        return [nextResponder findUIViewControllerAxc_traverseResponderChainForUIViewController];
    } else {
        return nil;
    }
}
@end
