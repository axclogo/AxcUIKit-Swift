//
//  AxcBaseProgressView.h
//  AxcUIKit
//
//  Created by Axc_5324 on 17/6/5.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//


#import <UIKit/UIKit.h>

#define BaseColorMaker(r, g, b, a) [UIColor colorWithRed:((r) / 255.0) green:((g) / 255.0) blue:((b) / 255.0) alpha:(a)]

#define BaseProgressViewItemMargin 10

#define BaseProgressViewFontScale (MIN(self.frame.size.width, self.frame.size.height) / 100.0)

#define BaseProgressViewBackgroundColor BaseColorMaker(240, 240, 240, 0.9)



@interface AxcBaseProgressView : UIView

/**
 *  加载进度
 */
@property (nonatomic, assign) CGFloat axcUI_progress;

/**
 *  移除时的动画效果，默认YES
 */
@property(nonatomic, assign)BOOL axcUI_removeAnimation;




- (void)setCenterProgressText:(NSString *)text withAttributes:(NSDictionary *)attributes;



- (void)dismiss;

+ (id)progressView;



@end
