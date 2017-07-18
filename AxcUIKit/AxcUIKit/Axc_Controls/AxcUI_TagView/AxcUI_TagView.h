//
//  AxcUI_TagView.h
//  AxcUIKit
//
//  Created by Axc on 2017/7/5.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AxcUI_TagView;

/**
 * 标签的滚动方向
 */
typedef NS_ENUM(NSInteger, AxcTagViewScrollDirectionStyle) {
    AxcTagViewScrollDirectionStyleVertical = 0,     // 默认上下滚动
    AxcTagViewScrollDirectionStyleHorizontal = 1    // 左右滚动
};

/**
 * 标签的排列风格
 */
typedef NS_ENUM(NSInteger, AxcTagViewAlignmentStyle) {
    AxcTagViewAlignmentStyleLeft = 0,             // 默认左对齐
    AxcTagViewAlignmentStyleCenter,               // 居中式排列
    AxcTagViewAlignmentStyleRight,                // 右对齐
    AxcTagViewAlignmentStyleFillByExpandingSpace, // 水平间距填充
    AxcTagViewAlignmentStyleFillByExpandingWidth  // 补充宽度自动补齐填充
};

/**
 * 标签代理回调
 */
@protocol AxcTagViewDelegate <NSObject>
@required
- (CGSize)AxcUI_tagView:(AxcUI_TagView *)tagView
      sizeForTagAtIndex:(NSUInteger)index;

@optional
- (BOOL)AxcUI_tagView:(AxcUI_TagView *)tagView
      shouldSelectTag:(UIView *)tagView
              atIndex:(NSUInteger)index;

- (void)AxcUI_tagView:(AxcUI_TagView *)tagView
         didSelectTag:(UIView *)tagView
              atIndex:(NSUInteger)index;

- (void)AxcUI_tagView:(AxcUI_TagView *)tagView
    updateContentSize:(CGSize)contentSize;
@end

/**
 * 标签数据源
 */
@protocol AxcTagViewDataSource <NSObject>
@required
- (NSUInteger)AxcUI_numberOfTagsInTagView:(AxcUI_TagView *)tagView;

- (UIView *)AxcUI_tagView:(AxcUI_TagView *)tagView
          tagViewForIndex:(NSUInteger)index;
@end


/** Tag多元素View标签展示控件 */
@interface AxcUI_TagView : UIView
@property (nonatomic, weak) id <AxcTagViewDataSource> axcUI_tagViewDataSource;
@property (nonatomic, weak) id <AxcTagViewDelegate> axcUI_tagViewDelegate;

/**
 * 里面的ScrollView
 */
@property (nonatomic, strong, readonly) UIScrollView *axcUI_scrollView;

/**
 * 滚动方式枚举
 */
@property (nonatomic, assign) AxcTagViewScrollDirectionStyle axcUI_scrollDirection;

/**
 * 标签的适配排列风格
 */
@property (nonatomic, assign) AxcTagViewAlignmentStyle axcUI_alignment;

/**
 * 展现的行数。0意味着没有限制,默认是0 1垂直和水平。
 */
@property (nonatomic, assign) NSUInteger axcUI_numberOfLines;

/**
 * 水平空间之间的距离,默认是4。
 */
@property (nonatomic, assign) CGFloat axcUI_horizontalSpacing;

/**
 * 垂直空间之间的距离,默认是4。
 */
@property (nonatomic, assign) CGFloat axcUI_verticalSpacing;

/**
 * 内容嵌入UIEdgeInsetsMake(2, 2, 2, 2)
 */
@property (nonatomic, assign) UIEdgeInsets axcUI_contentInset;

/**
 * 真正的标签内容的大小
 */
@property (nonatomic, assign, readonly) CGSize axcUI_contentSize;

/**
 * 内容高度开启 Default = NO，自动更新内容
 */
@property (nonatomic, assign) BOOL axcUI_manualCalculateHeight;

/**
 * Default = 0，自动更新内容
 */
@property (nonatomic, assign) CGFloat axcUI_preferredMaxLayoutWidth;

/**
 * 滚动方式 Scroll indicator
 */
@property (nonatomic, assign) BOOL axcUI_showsHorizontalScrollIndicator;
/**
 * 滚动方式 Scroll indicator
 */
@property (nonatomic, assign) BOOL axcUI_showsVerticalScrollIndicator;

/**
 * 刷新数据
 */
- (void)AxcUI_reloadData;

@end
