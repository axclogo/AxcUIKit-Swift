//
//  UITableViewCell+AxcAnimation.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/11.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "UITableViewCell+AxcAnimation.h"

#import "UIView+AxcExtension.h"
/**
 *  获取屏幕宽度和高度
 */
#define BA_SCREEN_WIDTH ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) || ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ? [[UIScreen mainScreen] bounds].size.width : [[UIScreen mainScreen] bounds].size.height)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@implementation UITableViewCell (AxcAnimation)

- (void)AxcUI_cellAppearAnimateStyle:(AxcUICellAppearAnimateStyle)type indexPath:(NSIndexPath *)indexPath{// 卡片式动画
    static CGFloat initialDelay = 0.2f;
    static CGFloat stutter = 0.06f;
    switch (type) {
        case AxcUICellAppearAnimateStyleRightToLeft:{
            self.contentView.transform =  CGAffineTransformMakeTranslation(BA_SCREEN_WIDTH, 0);
            [UIView animateWithDuration:1.0f
                                  delay:initialDelay + ((indexPath.row) * stutter)
                 usingSpringWithDamping:0.6
                  initialSpringVelocity:0 options:0 animations:^{
                      self.contentView.transform = CGAffineTransformIdentity;
                  } completion:NULL];
            break;
        }
        case AxcUICellAppearAnimateStyleLeftToRight:{
            self.contentView.transform =  CGAffineTransformMakeTranslation(-BA_SCREEN_WIDTH, 0);
            [UIView animateWithDuration:1.0f
                                  delay:initialDelay + ((indexPath.row) * stutter)
                 usingSpringWithDamping:0.6
                  initialSpringVelocity:0 options:0 animations:^{
                      self.contentView.transform = CGAffineTransformIdentity;
                  } completion:NULL];
            break;
        }
        case AxcUICellAppearAnimateStyleUnfoldRightLeft:{
            self.layer.transform = CATransform3DMakeScale(0.1,0.1,1);
            [UIView animateWithDuration:0.6 animations:^{
                self.layer.transform = CATransform3DMakeScale(1,1,1);
            }];
            break;
        }
        case AxcUICellAppearAnimateStyleLeftAndRightInsert:{
            if (indexPath.row % 2) {
                self.contentView.transform =  CGAffineTransformMakeTranslation(BA_SCREEN_WIDTH, 0);
            }else{
                self.contentView.transform =  CGAffineTransformMakeTranslation(-BA_SCREEN_WIDTH, 0);
            }
            [UIView animateWithDuration:1.0f
                                  delay:0
                 usingSpringWithDamping:0.6
                  initialSpringVelocity:0 options:0 animations:^{
                      self.contentView.transform = CGAffineTransformIdentity;
                  } completion:NULL];
            break;
        }
        case AxcUICellAppearAnimateStyleBottomToTop:{
            self.layer.transform = CATransform3DMakeTranslation(0, SCREEN_HEIGHT, 0);
            [UIView animateWithDuration:1 animations:^{
                self.layer.transform = CATransform3DMakeTranslation(0, 0, 0);
            }];
            
            break;
        }
        case AxcUICellAppearAnimateStyleTopToBottom:{
            self.layer.transform = CATransform3DMakeTranslation(0, -SCREEN_HEIGHT, 0);
            [UIView animateWithDuration:1 animations:^{
                self.layer.transform = CATransform3DMakeTranslation(0, 0, 0);
            }];
            
            break;
        }
        case AxcUICellAppearAnimateStyleOverturn:{
            CATransform3D rotation;
            rotation = CATransform3DMakeRotation( (90.0*M_PI)/180, 0.0, 0.7, 0.4);
            rotation.m44 = 1.0/ -600;
            //阴影
            self.layer.shadowColor = [[UIColor blackColor]CGColor];
            //阴影偏移
            self.layer.shadowOffset = CGSizeMake(10, 10);
            self.alpha = 0;
            self.layer.transform = rotation;
            //锚点
            self.layer.anchorPoint = CGPointMake(0.5, 0.5);
            [UIView beginAnimations:@"rotation" context:NULL];
            [UIView setAnimationDuration:0.8];
            self.layer.transform = CATransform3DIdentity;
            self.alpha = 1;
            self.layer.shadowOffset = CGSizeMake(0, 0);
            [UIView commitAnimations];
            break;
        }
        case AxcUICellAppearAnimateStyleFanShape:{
            

            break;
        }
//        case <#expression#>:break;
//        case <#expression#>:break;
//        case <#expression#>:break;
//        case <#expression#>:break;
//        case <#expression#>:break;
//        case <#expression#>:break;
//        case <#expression#>:break;
//        case <#expression#>:break;
//        case <#expression#>:break;
//        case <#expression#>:break;
    }
    
}


@end
