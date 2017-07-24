//
//  UIViewController+AxcVCBackButtonEvent.h
//  AxcUIKit
//
//  Created by Axc on 2017/7/26.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol AxcVCBackButtonEventProtocol <NSObject>
@optional
// 实现这个协议在VC类来处理“返回”按钮点击
- (BOOL)AxcUI_navigationShouldPopOnBackButton;
@end

@interface UIViewController (AxcVCBackButtonEvent) <AxcVCBackButtonEventProtocol>

@end
