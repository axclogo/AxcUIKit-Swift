//
//  SampleBaseVC.h
//  AxcUIKit
//
//  Created by Axc on 2017/6/3.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AxcUIKit.h"



/** 宏指针定义 __nonnull 类型 */
NS_ASSUME_NONNULL_BEGIN

@interface SampleBaseVC : UIViewController



@property(nonatomic, strong) AxcUI_Label *instructionsLabel;


- (void)AxcBase_addRightBarButtonItemSystemItem:(UIBarButtonSystemItem)systemItem;
- (void)AxcBase_clickRightBtn:(UIBarButtonItem *)sender;

- (void)AxcBase_addRightBarButtonItems:(NSArray *)items;
- (void)AxcBase_clickRightItems:(UIBarButtonItem *)sender;



// MARK:Alent函数
/** 弹出一个Alent */
- (void)AxcBase_PopAlertViewWithTitle:(NSString *)title
                              Message:(NSString *)message
                              Actions:(NSArray <NSString *>*)actions
                              handler:(void (^ __nullable)(UIAlertAction *action))handler;

/** 弹出一个警告Alent */
- (void)AxcBase_PopAlertWarningMessage:(NSString *)message;

/** 弹出一个提示Alent */
- (void)AxcBase_PopAlertPromptMessage:(NSString *)message
                            OKHandler:(void (^ __nullable)(UIAlertAction *action))OKHandler
                        cancelHandler:(void (^ __nullable)(UIAlertAction *action))cancelHandler;

@end

/** 宏指针定义下文 */
NS_ASSUME_NONNULL_END
