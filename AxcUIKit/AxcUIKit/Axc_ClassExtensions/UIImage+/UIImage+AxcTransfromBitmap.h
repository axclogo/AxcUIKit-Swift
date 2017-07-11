//
//  UIImage+AxcTransfromBitmap.h
//  AxcUIKit
//
//  Created by Axc on 2017/7/11.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (AxcTransfromBitmap)

- (UIImage*)AxcUI_transformWidth:(CGFloat)width
                          height:(CGFloat)height;

- (UIImage*)AxcUI_transformSize:(CGSize )size;

@end
