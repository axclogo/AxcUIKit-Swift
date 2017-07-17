//
//  AxcEmptyDataPlaceholderView.h
//  AxcUIKit
//
//  Created by Axc on 2017/7/11.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^ClikedBlock)();


@interface AxcEmptyDataPlaceholderView : UIView

@property(nonatomic, strong)ClikedBlock clickLoadBtnBlock;

@end

