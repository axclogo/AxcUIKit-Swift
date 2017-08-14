//
//  SampleBaseVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/3.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "SampleBaseVC.h"


@interface SampleBaseVC ()


@property(nonatomic, assign) CGFloat instructionsLabelHeight;


@end

@implementation SampleBaseVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.instructionsLabelHeight = 100;
    
    
    // 设置Bar半透明属性
    //    self.navigationController.navigationBar.translucent               = YES;
    
    // 设置开启Push后右滑返回手势
    //    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    
    // 设置取消ScrollerView自适应属性
    //    self.automaticallyAdjustsScrollViewInsets                         = NO;
    
    // 设置默认滑动时不隐藏NavBar导航条
    //    self.navigationController.hidesBarsOnSwipe                        = NO;
    
    // 设置子类的NavBar上的渲染颜色
    //    self.navigationController.navigationBar.tintColor         = [UIColor whiteColor];
    
    // 设置NavBar底层View的颜色
    //    self.navigationController.navigationBar.backgroundColor   = [UIColor clearColor];
    
    // 设置NavBar顶层View的颜色
    //    self.navigationController.navigationBar.barTintColor      = [UIColor clearColor];
    
    // 设置子类的Tabbar风格
    //    self.navigationController.navigationBar.barStyle          = UIBarStyleBlack;
    
}
- (void)AxcBase_addRightBarButtonItems:(NSArray *)items{
    NSMutableArray *arr_M = [NSMutableArray array];
    [items enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIBarButtonItem *btn = [[UIBarButtonItem alloc] initWithTitle:obj
                                                                style:UIBarButtonItemStyleDone
                                                               target:self
                                                               action:@selector(AxcBase_clickRightItems:)];
        btn.tag = idx + 5324;
        [arr_M addObject:btn];
    }];
    self.navigationItem.rightBarButtonItems = arr_M;
}
- (void)AxcBase_clickRightItems:(UIBarButtonItem *)sender{}


- (void)AxcBase_addRightBarButtonItemSystemItem:(UIBarButtonSystemItem)systemItem{
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]
                                              initWithBarButtonSystemItem:systemItem
                                              target:self
                                              action:@selector(AxcBase_clickRightBtn:)];
}
- (void)AxcBase_clickRightBtn:(UIBarButtonItem *)sender{}


// MARK:Alent函数
// 弹出一个Alent
- (void)AxcBase_PopAlertViewWithTitle:(NSString *)title
                              Message:(NSString *)message
                              Actions:(NSArray <NSString *>*)actions
                              handler:(void (^ __nullable)(UIAlertAction *action))handler{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:title
                                                                             message:message
                                                                      preferredStyle:UIAlertControllerStyleAlert];
    [actions enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        UIAlertAction *action = [UIAlertAction actionWithTitle:obj
                                                         style:UIAlertActionStyleDefault
                                                       handler:^(UIAlertAction *action) {
                                                           handler(action);
                                                       }];
        [alertController addAction:action];
    }];
    [self presentViewController:alertController animated:YES completion:nil];
}
// 弹出一个警告框
- (void)AxcBase_PopAlertWarningMessage:(NSString *)message{
    [self AxcBase_PopAlertViewWithTitle:@"警告"
                                Message:message
                                Actions:@[@"确定"]
                                handler:nil];
}
// 弹出一个提示框
- (void)AxcBase_PopAlertPromptMessage:(NSString *)message
                            OKHandler:(void (^ __nullable)(UIAlertAction *action))OKHandler
                        cancelHandler:(void (^ __nullable)(UIAlertAction *action))cancelHandler{
    [self AxcBase_PopAlertViewWithTitle:@"提示"
                                Message:message
                                Actions:@[@"确定",@"取消"]
                                handler:^(UIAlertAction * _Nonnull action) {
                                    if ([action.title isEqualToString:@"确定"]) {
                                        OKHandler(action);
                                    }else cancelHandler(action);
                                }];
}


- (UILabel *)instructionsLabel{
    if (!_instructionsLabel) {
        _instructionsLabel = [[AxcUI_Label alloc] initWithFrame:CGRectMake(0, self.view.axcUI_Height - self.instructionsLabelHeight,
                                                                       self.view.axcUI_Width, self.instructionsLabelHeight)];
        _instructionsLabel.font = [UIFont systemFontOfSize:15];
        _instructionsLabel.textAlignment = NSTextAlignmentCenter;
        _instructionsLabel.textColor = [UIColor AxcUI_AmethystColor];
        _instructionsLabel.backgroundColor = [UIColor AxcUI_CloudColor];
        _instructionsLabel.alpha = 0.8;
        _instructionsLabel.numberOfLines = 0;
        _instructionsLabel.axcUI_textEdgeInsets = UIEdgeInsetsMake(0,10,0,10);
        [_instructionsLabel AxcUI_autoresizingMaskLeftAndRight]; // 调用比例适配
        [self.view addSubview:_instructionsLabel];
    }
    return _instructionsLabel;
}


- (void)dealloc{
    // 只要控制器执行此方法，代表VC以及其控件全部已安全从内存中撤出。
    // ARC除去了手动管理内存，但不代表能控制循环引用，虽然去除了内存销毁概念，但引入了新的概念--对象被持有。
    // 框架在使用后能完全从内存中销毁才是最好的优化
    // 不明白ARC和内存泄漏的请自行谷歌，此示例已加入内存检测功能，如果有内存泄漏会alent进行提示
    NSLog(@"控制器%s调用情况，已销毁%@",__func__,self);
}

@end
