//
//  NSBundle+AxcUIKitBundle.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/19.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "NSBundle+AxcUIKitBundle.h"

#import "AxcUIKit.h"


@implementation NSBundle (AxcUIKitBundle)


+ (NSBundle *)AxcUIKitBundle {
    NSURL *bundle = [self AxcUIKitBundleURL];
    return bundle == nil ? [NSBundle mainBundle] : [self bundleWithURL:[self AxcUIKitBundleURL]];
}

+ (NSURL *)AxcUIKitBundleURL {
    NSBundle *bundle = [NSBundle bundleForClass:[AxcUIKit class]];
    return [bundle URLForResource:@"AxcUIKit" withExtension:@"bundle"];
}

@end
