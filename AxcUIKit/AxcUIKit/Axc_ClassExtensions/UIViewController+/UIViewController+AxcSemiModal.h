//
//  UIViewController+AxcSemiModal.h
//  AxcUIKit
//
//  Created by Axc on 2017/6/3.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>




#define kSemiModalDidShowNotification @"kSemiModalDidShowNotification"
#define kSemiModalDidHideNotification @"kSemiModalDidHideNotification"
#define kSemiModalWasResizedNotification @"kSemiModalWasResizedNotification"

extern const struct AxcSemiModalOption {
	__unsafe_unretained NSString *axcUI_traverseParentHierarchy; // 默认 YES.
	__unsafe_unretained NSString *axcUI_pushParentBack;		   // 默认 YES.
	__unsafe_unretained NSString *axcUI_animationDuration; // 动画秒 默认 0.5.
	__unsafe_unretained NSString *axcUI_parentAlpha;       // 背景透明度 默认 0.5.
    __unsafe_unretained NSString *axcUI_parentScale;       // 父子视图比 默认 0.8
	__unsafe_unretained NSString *axcUI_shadowOpacity;     // 阴影比 默认 0.8
	__unsafe_unretained NSString *axcUI_transitionStyle;   // 枚举 AxcSemiModalOptionTransitionStyle
    __unsafe_unretained NSString *axcUI_disableCancel;     // 禁用取消 默认 NO.
    __unsafe_unretained NSString *axcUI_backgroundView;    // 同名.
} AxcUISemiModalOptionKeys;

typedef NS_ENUM(NSUInteger, AxcSemiModalTransitionStyle) {
	AxcSemiModalTransitionStyleSlideUp,
	AxcSemiModalTransitionStyleFadeInOut,
	AxcSemiModalTransitionStyleFadeIn,
	AxcSemiModalTransitionStyleFadeOut,
};

typedef void (^AxcTransitionCompletionBlock)(void);

@interface UIViewController (AxcSemiModal)

/**
 显示一个视图控制器
 @param vc           视图控制器显示semi-modally;它的视图的框架。
 @param options	     枚举 AxcUISemiModalOptionKeys .
 @param completion   -[vc viewDidAppear:] 之后会调用.
 @param dismissBlock 推出的UI被销毁后执行
 */
-(void)AxcUI_presentSemiViewController:(UIViewController*)vc
					 withOptions:(NSDictionary*)options
					  completion:(AxcTransitionCompletionBlock)completion
					dismissBlock:(AxcTransitionCompletionBlock)dismissBlock;
/**
 显示一个View
 @param view         viewsemi-modally;它的视图框架。
 @param options	     枚举 AxcUISemiModalOptionKeys .
 @param completion   完成之后会调用.
 */
-(void)AxcUI_presentSemiView:(UIView*)view
		   withOptions:(NSDictionary*)options
			completion:(AxcTransitionCompletionBlock)completion;

// 重载方案
-(void)AxcUI_presentSemiViewController:(UIViewController*)vc;
-(void)AxcUI_presentSemiViewController:(UIViewController*)vc withOptions:(NSDictionary*)options;
-(void)AxcUI_presentSemiView:(UIView*)vc;
-(void)AxcUI_presentSemiView:(UIView*)view withOptions:(NSDictionary*)options;

// 刷新背景
-(void)AxcUI_updateBackground;
// 删除、释放、更新
// 特殊情况需要调用，例如通知中心检测到未被销毁等
-(void)AxcUI_resizeSemiView:(CGSize)newSize;
-(void)AxcUI_dismissSemiModalView;
-(void)AxcUI_dismissSemiModalViewWithCompletion:(AxcTransitionCompletionBlock)completion;

@end





#pragma mark - 其他扩展类别 ----------------------------------------

@interface NSObject (AxcUIOptionsAndDefaults)
- (void)optionsAndDefaultsAxc_registerOptions:(NSDictionary *)options
                                     defaults:(NSDictionary *)defaults;
- (id)optionsAndDefaultsAxc_optionOrDefaultForKey:(NSString*)optionKey;
@end
//  ************************************************



@interface UIView (AxcUIFindUIViewController)
- (UIViewController *) findUIViewControllerAxc_containingViewController;
- (id) findUIViewControllerAxc_traverseResponderChainForUIViewController;
@end
//  ************************************************
