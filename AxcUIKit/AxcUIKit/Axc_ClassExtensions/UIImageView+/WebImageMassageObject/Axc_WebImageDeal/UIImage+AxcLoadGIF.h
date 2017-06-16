//
//  UIImage+AxcLoadGIF.h
//  AxcUIKit
//
//  Created by Axc on 2017/6/6.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (GIF)

+ (UIImage *)coreAxc_animatedGIFNamed:(NSString *)name;

+ (UIImage *)coreAxc_animatedGIFWithData:(NSData *)data;

- (UIImage *)coreAxc_animatedImageByScalingAndCroppingToSize:(CGSize)size;

// HUD加载动图专属
+ (UIImage * _Nullable)animatedImageWithAnimatedGIFData:(NSData * _Nonnull)theData;
+ (UIImage * _Nullable)animatedImageWithAnimatedGIFURL:(NSURL * _Nonnull)theURL;
@end
