//
//  SampleBaseVC.h
//  AxcUIKit
//
//  Created by Axc on 2017/6/3.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AxcUIKit.h"

@interface SampleBaseVC : UIViewController



@property(nonatomic, strong) AxcUI_Label *instructionsLabel;


- (void)AxcBase_addRightBarButtonItemSystemItem:(UIBarButtonSystemItem)systemItem;
- (void)AxcBase_clickRightBtn:(UIBarButtonItem *)sender;

- (void)AxcBase_addRightBarButtonItems:(NSArray *)items;
- (void)AxcBase_clickRightItems:(UIBarButtonItem *)sender;


@end
