//
//  AxcActivityIndicatorViewCell.h
//  AxcUIKit
//
//  Created by Axc on 2017/6/17.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AxcUI_ActivityIndicatorView.h"

@interface AxcActivityIndicatorViewCell : UICollectionViewCell

@property(nonatomic, strong)AxcUI_ActivityIndicatorView *axcUI_activityIndicatorView;


- (void)setActivityIndicatorViewType:(AxcActivityIndicatorAnimationStyle )type;

@end
