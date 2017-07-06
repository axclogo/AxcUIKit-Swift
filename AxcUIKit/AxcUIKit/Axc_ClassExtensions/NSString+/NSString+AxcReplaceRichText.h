//
//  NSString+AxcReplaceRichText.h
//  AxcUIKit
//
//  Created by Axc on 2017/7/6.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (AxcReplaceRichText)

/**
 *  传入需要标注的文字、颜色、字体
 */
- (NSMutableAttributedString *)AxcUI_markWords:(NSString *)markWords
                                     withColor:(UIColor *)color
                                 MarkWordsFont:(UIFont *)font;



@end
