//
//  UITextField+AxcModifyPlaceholder.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/4.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "UITextField+AxcModifyPlaceholder.h"

#import <objc/runtime.h>

//static NSString * const kPlaceholderLabel = @"axcUI_PlaceholderLabel";
static NSString * const ksystemPlaceholderLabel = @"_placeholderLabel";


@implementation UITextField (AxcModifyPlaceholder)

-(void)setAxcUI_PlaceholderLabel:(UILabel *)axcUI_PlaceholderLabel{
    [self willChangeValueForKey:ksystemPlaceholderLabel];
    objc_setAssociatedObject(self, &ksystemPlaceholderLabel,
                             axcUI_PlaceholderLabel,
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:ksystemPlaceholderLabel];
}


- (UILabel *)axcUI_PlaceholderLabel{
    UILabel *label = (UILabel *)[self valueForKeyPath:ksystemPlaceholderLabel];
    return label;
}


@end
