//
//  NSString+AxcTextCalculation.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/30.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "NSString+AxcTextCalculation.h"

@implementation NSString (AxcTextCalculation)

- (CGFloat)AxcUI_widthWithStringAttribute:(NSDictionary <NSString *, id> *)attribute{
    return [self AxcUI_rectWithStringAttribute:attribute].size.width;
}
- (CGFloat)AxcUI_heightWithStringAttribute:(NSDictionary <NSString *, id> *)attribute{
    return [self AxcUI_rectWithStringAttribute:attribute].size.height;
}

- (CGFloat)AxcUI_widthWithStringFontSize:(CGFloat)font{
    return [self AxcUI_rectWithStringAttribute:@{NSFontAttributeName : [UIFont systemFontOfSize:font]}].size.width;
}
- (CGFloat)AxcUI_heightWithStringFontSize:(CGFloat)font{
    return [self AxcUI_rectWithStringAttribute:@{NSFontAttributeName : [UIFont systemFontOfSize:font]}].size.height;
}

- (CGRect )AxcUI_rectWithStringFont:(CGFloat )font{
    return [self AxcUI_rectWithStringAttribute:@{NSFontAttributeName : [UIFont systemFontOfSize:font]}];
}

- (CGFloat)AxcUI_widthWithStringFont:(UIFont *)font{
    return [self AxcUI_rectWithStringAttribute:@{NSFontAttributeName : font}].size.width;
}
- (CGFloat)AxcUI_heightWithStringFont:(UIFont *)font{
    return [self AxcUI_rectWithStringAttribute:@{NSFontAttributeName : font}].size.height;
}



- (CGRect )AxcUI_rectWithStringAttribute:(NSDictionary <NSString *, id> *)attribute{
    NSParameterAssert(attribute);
    CGRect rect = CGRectZero;
    if (self.length) {
        rect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                  options:NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                               attributes:attribute
                                  context:nil];
    }
    return rect;
}


@end
