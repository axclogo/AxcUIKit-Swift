//
//  AxcActivityIndicatorViewCell.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/17.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcActivityIndicatorViewCell.h"

@implementation AxcActivityIndicatorViewCell

- (void)awakeFromNib {
    [super awakeFromNib];

    

}

- (void)setActivityIndicatorViewType:(AxcActivityIndicatorAnimationType )type{
    if (!self.axcUI_activityIndicatorView) {
        self.axcUI_activityIndicatorView = [[AxcUI_ActivityIndicatorView alloc]
                                            initWithType:(AxcActivityIndicatorAnimationType)type
                                            tintColor:[UIColor whiteColor]];
        CGFloat width = self.bounds.size.width ;
        CGFloat height = self.bounds.size.height ;
        
        self.axcUI_activityIndicatorView.frame = CGRectMake(0, 0, width, height);
        [self addSubview:self.axcUI_activityIndicatorView];
        [self.axcUI_activityIndicatorView AxcUI_startAnimating];
    }
}



- (void)dealloc{
    [self.axcUI_activityIndicatorView AxcUI_stopAnimating];
    self.axcUI_activityIndicatorView = nil;
}

@end
