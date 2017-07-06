//
//  NSString+AxcReplaceRichText.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/6.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "NSString+AxcReplaceRichText.h"

@implementation NSString (AxcReplaceRichText)

- (NSMutableAttributedString *)AxcUI_markWords:(NSString *)markWords
                                     withColor:(UIColor *)color
                                 MarkWordsFont:(UIFont *)font{
    NSMutableAttributedString *mutableAttributedStr = [[NSMutableAttributedString alloc] initWithString:self];
    if (color == nil) {
        color = [UIColor redColor];
    }
    //    NSArray *array = [allStr componentsSeparatedByString:specifiStr];//array.cout-1是所有字符特殊字符出现的次数
    NSRange searchRange = NSMakeRange(0, [self length]);
    NSRange range;
    //拿到所有的相同字符的range
    while
        ((range = [self rangeOfString:markWords options:0 range:searchRange]).location != NSNotFound) {
            //改变多次搜索时searchRange的位置
            searchRange = NSMakeRange(NSMaxRange(range), [self length] - NSMaxRange(range));
            //设置富文本
            [mutableAttributedStr addAttribute:NSForegroundColorAttributeName value:color range:range];
            [mutableAttributedStr addAttribute:NSFontAttributeName value:font range:range];
        }
    return mutableAttributedStr;
}

@end
