//
// Created by zorro on 15/12/28.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AxcUI_TagView.h"


/**
 * TagText样式构造器
 */
@interface AxcTagTextConfig : NSObject

/**
 * 设置字体
 */
@property (strong, nonatomic) UIFont *axcUI_tagTextFont;
/**********************************************************/
/**
 * 展示字体颜色
 */
@property (strong, nonatomic) UIColor *axcUI_tagTextColor;
/**
 * 选中字体颜色
 */
@property (strong, nonatomic) UIColor *axcUI_tagSelectedTextColor;
/**********************************************************/
/**
 * 展示背景颜色
 */
@property (strong, nonatomic) UIColor *axcUI_tagBackgroundColor;
/**
 * 选中背景颜色
 */
@property (strong, nonatomic) UIColor *axcUI_tagSelectedBackgroundColor;
/**********************************************************/
/**
 * 展示Tag圆角
 */
@property (assign, nonatomic) CGFloat axcUI_tagCornerRadius;
/**
 * 选中Tag圆角
 */
@property (assign, nonatomic) CGFloat axcUI_tagSelectedCornerRadius;
/**********************************************************/
/**
 * 展示Tag线宽
 */
@property (assign, nonatomic) CGFloat axcUI_tagBorderWidth;
/**
 * 选中Tag线宽
 */
@property (assign, nonatomic) CGFloat axcUI_tagSelectedBorderWidth;
/**********************************************************/
/**
 * 展示Tag边线颜色
 */
@property (strong, nonatomic) UIColor *axcUI_tagBorderColor;
/**
 * 选中Tag边线颜色
 */
@property (strong, nonatomic) UIColor *axcUI_tagSelectedBorderColor;
/**********************************************************/
/**
 * 阴影颜色
 */
@property (nonatomic, copy  ) UIColor *axcUI_tagShadowColor;
/**
 * 阴影偏移
 */
@property (nonatomic, assign) CGSize axcUI_tagShadowOffset;
/**
 * 阴影圆角  
 */
@property (nonatomic, assign) CGFloat axcUI_tagShadowRadius;
/**
 * 阴影透明度
 */
@property (nonatomic, assign) CGFloat axcUI_tagShadowOpacity;

/**
 * 标签额外的空间在宽度和高度,将扩大每个标签的大小（一般无需设置）
 */
@property (assign, nonatomic) CGSize axcUI_tagExtraSpace;

@end


@class AxcUI_TagTextView;

@protocol AxcTagTextViewDelegate <NSObject>
// 非必须实现
@optional

/**
 * 当发生点击时，回调当前tagTextView、标签的文字、坐标、当前选中状态
   返回NO则不会执行下面的回调，并且不会带有选中状态
 */
- (BOOL)AxcUI_tagTextView:(AxcUI_TagTextView *)tagTextView
                canTapTag:(NSString *)tagText
                  atIndex:(NSUInteger)index
          currentSelected:(BOOL)currentSelected;
/**
 * 当发生点击时，回调当前tagTextView、标签的文字、坐标、选中状态
 */
- (void)AxcUI_tagTextView:(AxcUI_TagTextView *)tagTextView
                didTapTag:(NSString *)tagText
                  atIndex:(NSUInteger)index
                 selected:(BOOL)selected;
/**
 * 调用刷新函数是会调用该回调
 */
- (void)AxcUI_tagTextView:(AxcUI_TagTextView *)tagTextView
        updateContentSize:(CGSize)contentSize;
@end

/**
 * TagText文字标签展示控件
 */
@interface AxcUI_TagTextView : UIView
// Delegate
@property (weak, nonatomic) id <AxcTagTextViewDelegate> axcUI_tagTextViewDelegate;

/**
 * 里面的ScrollView
 */
@property (nonatomic, strong, readonly) UIScrollView *axcUI_scrollView;

/**
 * 选择标签定义
 */
@property (assign, nonatomic) BOOL axcUI_enableTagSelection;

/**
 * 默认的Tag构造器，可以设定后Set进来
 */
@property (nonatomic, strong) AxcTagTextConfig *axcUI_defaultConfig;

/**
 * 滚动方式/方向
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
 * 标签选择限制,默认是0,意味着没有限制
 */
@property (nonatomic, assign) NSUInteger axcUI_selectionLimit;

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

/**
 * 添加一个默认构造器形态的文字标签
 */
- (void)AxcUI_addTag:(NSString *)tag;

/**
 * 添加一组默认构造器形态的文字标签
 */
- (void)AxcUI_addTags:(NSArray <NSString *> *)tags;

/**
 * 添加一个自定义构造器形态的文字标签
 */
- (void)AxcUI_addTag:(NSString *)tag
          withConfig:(AxcTagTextConfig *)config;

/**
 * 添加一组自定义构造器形态的文字标签
 */
- (void)AxcUI_addTags:(NSArray <NSString *> *)tags
           withConfig:(AxcTagTextConfig *)config;

/**
 * 插入一个默认构造器形态的文字标签
 */
- (void)AxcUI_insertTag:(NSString *)tag
                atIndex:(NSUInteger)index;

/**
 * 插入一组默认构造器形态的文字标签
 */
- (void)AxcUI_insertTags:(NSArray <NSString *> *)tags
                 atIndex:(NSUInteger)index;

/**
 * 插入一个自定义构造器形态的文字标签
 */
- (void)AxcUI_insertTag:(NSString *)tag
                atIndex:(NSUInteger)index
             withConfig:(AxcTagTextConfig *)config;

/**
 * 插入一组自定义构造器形态的文字标签
 */
- (void)AxcUI_insertTags:(NSArray <NSString *> *)tags
                 atIndex:(NSUInteger)index
              withConfig:(AxcTagTextConfig *)config;

/**
 * 移除某个文字的标签
 */
- (void)AxcUI_removeTag:(NSString *)tag;

/**
 * 根据坐标来移除
 */
- (void)AxcUI_removeTagAtIndex:(NSUInteger)index;

/**
 * 移除所有
 */
- (void)AxcUI_removeAllTags;

/**
 * 设置一个标签的选中状态
 */
- (void)AxcUI_setTagAtIndex:(NSUInteger)index
                   selected:(BOOL)selected;

/**
 * 设置一个标签的构造器形态
 */
- (void)AxcUI_setTagAtIndex:(NSUInteger)index
                 withConfig:(AxcTagTextConfig *)config;

/**
 * 设置一个范围内标签的构造器形态
 */
- (void)AxcUI_setTagsInRange:(NSRange)range
                  withConfig:(AxcTagTextConfig *)config;

/**
 * 通过坐标获取标签文字
 */
- (NSString *)AxcUI_getTagAtIndex:(NSUInteger)index;

/**
 * 通过范围获取一组标签文字
 */
- (NSArray <NSString *> *)AxcUI_getTagsInRange:(NSRange)range;

/**
 * 获取标签的构造器
 */
- (AxcTagTextConfig *)AxcUI_getConfigAtIndex:(NSUInteger)index;

/**
 * 获取范围内标签的所有构造器
 */
- (NSArray <AxcTagTextConfig *> *)AxcUI_getConfigsInRange:(NSRange)range;

/**
 * 获取所有标签文字
 */
- (NSArray <NSString *> *)AxcUI_allTags;

/**
 * 获取所有已选中标签文字
 */
- (NSArray <NSString *> *)AxcUI_allSelectedTags;

/**
 * 获取所有未选中标签文字
 */
- (NSArray <NSString *> *)AxcUI_allNotSelectedTags;

@end
