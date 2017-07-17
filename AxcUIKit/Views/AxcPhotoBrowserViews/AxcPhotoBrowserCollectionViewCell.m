//
//  AxcPhotoBrowserCollectionViewCell.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/5.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcPhotoBrowserCollectionViewCell.h"

@implementation AxcPhotoBrowserCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.imageView.layer.cornerRadius = 5;
    self.imageView.layer.masksToBounds = YES;
    
    self.shadowView.layer.shadowColor = self.imageView.backgroundColor.CGColor;
    self.shadowView.layer.shadowOffset = CGSizeMake(2, 2);
    self.shadowView.layer.shadowOpacity = 0.4;
    self.shadowView.layer.shadowRadius = self.imageView.layer.cornerRadius;
    self.shadowView.layer.cornerRadius = self.imageView.layer.cornerRadius;
    self.shadowView.clipsToBounds = NO;
}

@end
