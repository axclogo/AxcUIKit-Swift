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
 *  传入需要标注的文字、 字体
 */
- (NSMutableAttributedString *)AxcUI_markWords:(NSString *)markWords
                                 MarkWordsFont:(UIFont *)font;
/**
 *  传入需要标注的文字、颜色
 */
- (NSMutableAttributedString *)AxcUI_markWords:(NSString *)markWords
                                     withColor:(UIColor *)color;
/**
 *  传入需要标注的文字、颜色、字体
 */
- (NSMutableAttributedString *)AxcUI_markWords:(NSString *)markWords
                                     withColor:(UIColor *)color
                                 MarkWordsFont:(UIFont *)font;
/**
 *  传入需要标注的文字、富文本属性
 */
- (NSMutableAttributedString *)AxcUI_markWords:(NSString *)markWords
                                 addAttributes:(NSDictionary<NSString *, id> *)attrs;



/* 富文本属性如下： */
/*
 NSFontAttributeName
 NSParagraphStyleAttributeName
 NSForegroundColorAttributeName
 NSBackgroundColorAttributeName
 NSLigatureAttributeName
 NSKernAttributeName
 NSStrikethroughStyleAttributeName
 NSUnderlineStyleAttributeName
 NSStrokeColorAttributeName
 NSStrokeWidthAttributeName
 NSShadowAttributeName
 NSTextEffectAttributeName
 NSAttachmentAttributeName
 NSLinkAttributeName
 NSBaselineOffsetAttributeName
 NSUnderlineColorAttributeName
 NSStrikethroughColorAttributeName
 NSObliquenessAttributeName
 NSExpansionAttributeName
 NSWritingDirectionAttributeName
 NSVerticalGlyphFormAttributeName
*/

@end
