//
//  UIView+AutoresizingMask.m
//  AxcUIKit
//
//  Created by Axc_5324 on 17/4/19.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "UIView+AxcAutoresizingMask.h"

@implementation UIView (AxcAutoresizingMask)

- (void)AxcUI_autoresizingMaskLeftAndRight{
    self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
                            UIViewAutoresizingFlexibleRightMargin;
}

- (void)AxcUI_autoresizingMaskTopAndBottom{
    self.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |
                            UIViewAutoresizingFlexibleBottomMargin;
}

- (void)AxcUI_autoresizingMaskComprehensive{
    self.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin |
                            UIViewAutoresizingFlexibleRightMargin|
                            UIViewAutoresizingFlexibleTopMargin  |
                            UIViewAutoresizingFlexibleBottomMargin;
}

- (void)AxcUI_autoresizingMaskWideAndHigh{
    self.autoresizingMask = UIViewAutoresizingFlexibleWidth |
                            UIViewAutoresizingFlexibleHeight;
}
@end
