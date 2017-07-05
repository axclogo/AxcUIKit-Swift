//
//  AxcUI_TagView.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/5.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcUI_TagView.h"

@interface AxcUI_TagView ()
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, assign) BOOL needsLayoutTagViews;
@end

@implementation AxcUI_TagView

#pragma mark - Init

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }

    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInit];
    }

    return self;
}

- (void)commonInit {
    if (_scrollView) {
        return;
    }
    
    _axcUI_horizontalSpacing = 4;
    _axcUI_verticalSpacing = 4;
    _axcUI_contentInset = UIEdgeInsetsMake(2, 2, 2, 2);
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.backgroundColor = [UIColor clearColor];
    _scrollView.userInteractionEnabled = YES;
    [self addSubview:_scrollView];
    
    _containerView = [[UIView alloc] initWithFrame:_scrollView.bounds];
    _containerView.backgroundColor = [UIColor clearColor];
    _containerView.userInteractionEnabled = YES;
    [_scrollView addSubview:_containerView];
    
    UITapGestureRecognizer *tapGesture = [UITapGestureRecognizer new];
    [tapGesture addTarget:self action:@selector(onTapGesture:)];
    [_containerView addGestureRecognizer:tapGesture];
    
    [self setNeedsLayoutTagViews];
}

#pragma mark - 复用函数

- (void)AxcUI_reloadData {
    if (![self isDelegateAndDataSourceValid]) {
        return;
    }
    
    // 删除所有标签视图
    [_containerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    // 更新标签视图Rect
    [self setNeedsLayoutTagViews];
    [self layoutTagViews];
    
    // 添加
    for (NSUInteger i = 0; i < [_axcUI_tagViewDataSource AxcUI_numberOfTagsInTagView:self]; i++) {
        [_containerView addSubview:[_axcUI_tagViewDataSource AxcUI_tagView:self tagViewForIndex:i]];
    }
    
    [self invalidateIntrinsicContentSize];
}

#pragma mark - 手势
- (void)onTapGesture:(UITapGestureRecognizer *)tapGesture {
    if (![self.axcUI_tagViewDataSource respondsToSelector:@selector(AxcUI_numberOfTagsInTagView:)] ||
        ![self.axcUI_tagViewDataSource respondsToSelector:@selector(AxcUI_tagView:tagViewForIndex:)] ||
        ![self.axcUI_tagViewDelegate respondsToSelector:@selector(AxcUI_tagView:didSelectTag:atIndex:)]) {
        return;
    }
    
    CGPoint tapPoint = [tapGesture locationInView:_containerView];
    
    for (NSUInteger i = 0; i < [self.axcUI_tagViewDataSource AxcUI_numberOfTagsInTagView:self]; i++) {
        UIView *tagView = [self.axcUI_tagViewDataSource AxcUI_tagView:self tagViewForIndex:i];
        if (CGRectContainsPoint(tagView.frame, tapPoint)) {
            if ([self.axcUI_tagViewDelegate respondsToSelector:@selector(AxcUI_tagView:shouldSelectTag:atIndex:)]) {
                if ([self.axcUI_tagViewDelegate AxcUI_tagView:self shouldSelectTag:tagView atIndex:i]) {
                    [self.axcUI_tagViewDelegate AxcUI_tagView:self didSelectTag:tagView atIndex:i];
                }
            } else {
                [self.axcUI_tagViewDelegate AxcUI_tagView:self didSelectTag:tagView atIndex:i];
            }
        }
    }
}

#pragma mark - 覆盖

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!CGRectEqualToRect(_scrollView.frame, self.bounds)) {
        _scrollView.frame = self.bounds;
        [self setNeedsLayoutTagViews];
        [self layoutTagViews];
        _containerView.frame = (CGRect){CGPointZero, _scrollView.contentSize};
        [self invalidateIntrinsicContentSize];
    }
    [self layoutTagViews];
}

- (CGSize)intrinsicContentSize {
    return _scrollView.contentSize;
}

#pragma mark - 布局

- (void)layoutTagViews {
    if (!_needsLayoutTagViews || ![self isDelegateAndDataSourceValid]) {
        return;
    }
    
    if (_axcUI_scrollDirection == AxcTagViewScrollDirectionStyleVertical) {
        [self layoutTagViewsForVerticalDirection];
    } else {
        [self layoutTagViewsForHorizontalDirection];
    }
    
    _needsLayoutTagViews = NO;
    [self invalidateIntrinsicContentSize];
}

- (void)layoutTagViewsForVerticalDirection {
    NSUInteger count = [_axcUI_tagViewDataSource AxcUI_numberOfTagsInTagView:self];
    NSUInteger currentLineTagsCount = 0;
    CGFloat totalWidth = (_axcUI_manualCalculateHeight && _axcUI_preferredMaxLayoutWidth > 0) ? _axcUI_preferredMaxLayoutWidth : CGRectGetWidth(self.bounds);
    CGFloat maxLineWidth = totalWidth - _axcUI_contentInset.left - _axcUI_contentInset.right;
    CGFloat currentLineX = 0;
    CGFloat currentLineMaxHeight = 0;
    
    NSMutableArray <NSNumber *> *eachLineMaxHeightNumbers = [NSMutableArray new];
    NSMutableArray <NSNumber *> *eachLineWidthNumbers = [NSMutableArray new];
    NSMutableArray <NSNumber *> *eachLineTagCountNumbers = [NSMutableArray new];
    
    // 得到每一行最大高度、宽度和标签
    for (NSUInteger i = 0; i < count; i++) {
        CGSize tagSize = [_axcUI_tagViewDelegate AxcUI_tagView:self sizeForTagAtIndex:i];
        if (currentLineX + tagSize.width > maxLineWidth) {
            [eachLineMaxHeightNumbers addObject:@(currentLineMaxHeight)];
            [eachLineWidthNumbers addObject:@(currentLineX - _axcUI_horizontalSpacing)];
            [eachLineTagCountNumbers addObject:@(currentLineTagsCount)];
            currentLineTagsCount = 0;
            currentLineMaxHeight = 0;
            currentLineX = 0;
        }
        
        
        // 行数限制
        if (_axcUI_numberOfLines != 0) {
            UIView *tagView = [_axcUI_tagViewDataSource AxcUI_tagView:self tagViewForIndex:i];
            tagView.hidden = eachLineWidthNumbers.count >= _axcUI_numberOfLines;
        }
        
        currentLineX += tagSize.width + _axcUI_horizontalSpacing;
        currentLineTagsCount += 1;
        currentLineMaxHeight = MAX(tagSize.height, currentLineMaxHeight);
    }
    
    // 添加最后一个
    [eachLineMaxHeightNumbers addObject:@(currentLineMaxHeight)];
    [eachLineWidthNumbers addObject:@(currentLineX - _axcUI_horizontalSpacing)];
    [eachLineTagCountNumbers addObject:@(currentLineTagsCount)];
    
    // 添加行限制
    if (_axcUI_numberOfLines != 0) {
        eachLineWidthNumbers = [[eachLineWidthNumbers subarrayWithRange:NSMakeRange(0, MIN(eachLineWidthNumbers.count, _axcUI_numberOfLines))] mutableCopy];
        eachLineMaxHeightNumbers = [[eachLineMaxHeightNumbers subarrayWithRange:NSMakeRange(0, MIN(eachLineMaxHeightNumbers.count, _axcUI_numberOfLines))] mutableCopy];
        eachLineTagCountNumbers = [[eachLineTagCountNumbers subarrayWithRange:NSMakeRange(0, MIN(eachLineTagCountNumbers.count, _axcUI_numberOfLines))] mutableCopy];
    }
    
    // 准备
    [self layoutEachLineTagsWithMaxLineWidth:maxLineWidth
                               numberOfLines:eachLineTagCountNumbers.count
                            eachLineTagCount:eachLineTagCountNumbers
                               eachLineWidth:eachLineWidthNumbers
                           eachLineMaxHeight:eachLineMaxHeightNumbers];
}

- (void)layoutTagViewsForHorizontalDirection {
    CGFloat totalWidthInOneLine = 0;
    NSInteger count = [_axcUI_tagViewDataSource AxcUI_numberOfTagsInTagView:self];
    _axcUI_numberOfLines = _axcUI_numberOfLines == 0 ? 1 : _axcUI_numberOfLines;
    _axcUI_numberOfLines = MIN(count, _axcUI_numberOfLines);
    
    // 设置帧大小和获取totalWidthInOneLine
    for (NSInteger i = 0; i < count; i++) {
        CGSize tagSize = [_axcUI_tagViewDelegate AxcUI_tagView:self sizeForTagAtIndex:i];
        totalWidthInOneLine += tagSize.width + _axcUI_horizontalSpacing;
    }
    
    // 计算估计每一行的宽度
    CGFloat averageWidthEachLine = totalWidthInOneLine / (CGFloat)_axcUI_numberOfLines + 1;
    
    NSMutableArray <NSNumber *> *eachLineMaxHeightNumbers = [NSMutableArray new];
    NSMutableArray <NSNumber *> *eachLineWidthNumbers = [NSMutableArray new];
    NSMutableArray <NSNumber *> *eachLineTagCountNumbers = [NSMutableArray new];
    CGFloat currentLineMaxHeight = 0;
    CGFloat maxLineWidth = 0;
    CGFloat currentLineX = 0;
    NSUInteger currentLineTagsCount = 0;
    NSUInteger tagIndex = 0;
    
    // 得到每一行最大高度,标签计数和真正的宽度
    for (NSUInteger currentLine = 0; currentLine < _axcUI_numberOfLines; currentLine++) {
        while ((currentLineX < averageWidthEachLine || currentLine == _axcUI_numberOfLines - 1) && tagIndex < count) {
            CGSize tagSize = [_axcUI_tagViewDelegate AxcUI_tagView:self sizeForTagAtIndex:tagIndex];
            currentLineX += tagSize.width + _axcUI_horizontalSpacing;
            currentLineMaxHeight = MAX(tagSize.height, currentLineMaxHeight);
            currentLineTagsCount += 1;
            tagIndex += 1;
        }
        
        maxLineWidth = MAX(currentLineX - _axcUI_horizontalSpacing, maxLineWidth);
        [eachLineTagCountNumbers addObject:@(currentLineTagsCount)];
        [eachLineMaxHeightNumbers addObject:@(currentLineMaxHeight)];
        [eachLineWidthNumbers addObject:@(currentLineX - _axcUI_horizontalSpacing)];
        currentLineX = 0;
        currentLineMaxHeight = 0;
        currentLineTagsCount = 0;
    }
    
    // 更新最大宽度
    maxLineWidth = MAX(CGRectGetWidth(self.frame), maxLineWidth);
    
    // 设置每个标签
    [self layoutEachLineTagsWithMaxLineWidth:maxLineWidth
                               numberOfLines:_axcUI_numberOfLines
                            eachLineTagCount:eachLineTagCountNumbers
                               eachLineWidth:eachLineWidthNumbers
                           eachLineMaxHeight:eachLineMaxHeightNumbers];
}

- (void)layoutEachLineTagsWithMaxLineWidth:(CGFloat)maxLineWidth
                             numberOfLines:(NSUInteger)numberOfLines
                          eachLineTagCount:(NSArray <NSNumber *> *)eachLineTagCount
                             eachLineWidth:(NSArray <NSNumber *> *)eachLineWidth
                         eachLineMaxHeight:(NSArray <NSNumber *> *)eachLineMaxHeight {
 
    CGFloat currentYBase = _axcUI_contentInset.top;
    NSUInteger currentTagIndexBase = 0;
    NSUInteger tagIndex = 0;
    
    for (NSUInteger currentLine = 0; currentLine < numberOfLines; currentLine++) {
        CGFloat currentLineMaxHeight = eachLineMaxHeight[currentLine].floatValue;
        CGFloat currentLineWidth = eachLineWidth[currentLine].floatValue;
        CGFloat currentLineTagsCount = eachLineTagCount[currentLine].unsignedIntegerValue;
        
        // 结合x抵消
        CGFloat currentLineXOffset = 0;
        CGFloat currentLineAdditionWidth = 0;
        CGFloat currentLineX = 0;
        CGFloat acturalaxcUI_horizontalSpacing = _axcUI_horizontalSpacing;
        
        switch (_axcUI_alignment) {
            case AxcTagViewAlignmentStyleLeft:
                currentLineXOffset = _axcUI_contentInset.left;
                break;
            case AxcTagViewAlignmentStyleCenter:
                currentLineXOffset = (maxLineWidth - currentLineWidth) / 2 + _axcUI_contentInset.left;
                break;
            case AxcTagViewAlignmentStyleRight:
                currentLineXOffset = maxLineWidth - currentLineWidth + _axcUI_contentInset.left;
                break;
            case AxcTagViewAlignmentStyleFillByExpandingSpace:
                currentLineXOffset = _axcUI_contentInset.left;
                acturalaxcUI_horizontalSpacing = _axcUI_horizontalSpacing +
                (maxLineWidth - currentLineWidth) / (CGFloat)(currentLineTagsCount - 1);
                currentLineWidth = maxLineWidth;
                break;
            case AxcTagViewAlignmentStyleFillByExpandingWidth:
                currentLineXOffset = _axcUI_contentInset.left;
                currentLineAdditionWidth = (maxLineWidth - currentLineWidth) / (CGFloat)currentLineTagsCount;
                currentLineWidth = maxLineWidth;
                break;
        }
        
        // 当前行
        for (tagIndex = currentTagIndexBase; tagIndex < currentTagIndexBase + currentLineTagsCount; tagIndex++) {
            UIView *tagView = [_axcUI_tagViewDataSource AxcUI_tagView:self tagViewForIndex:tagIndex];
            CGSize tagSize = [_axcUI_tagViewDelegate AxcUI_tagView:self sizeForTagAtIndex:tagIndex];
            
            CGPoint origin;
            origin.x = currentLineXOffset + currentLineX;
            origin.y = currentYBase + (currentLineMaxHeight - tagSize.height) / 2;
            
            tagSize.width += currentLineAdditionWidth;
            if (_axcUI_scrollDirection == AxcTagViewScrollDirectionStyleVertical && tagSize.width > maxLineWidth) {
                tagSize.width = maxLineWidth;
            }
            
            tagView.hidden = NO;
            tagView.frame = (CGRect){origin, tagSize};
            
            currentLineX += tagSize.width + acturalaxcUI_horizontalSpacing;
        }
        
        // 最后行
        currentYBase += currentLineMaxHeight + _axcUI_verticalSpacing;
        currentTagIndexBase += currentLineTagsCount;
    }
    
    // 滑动范围
    maxLineWidth += _axcUI_contentInset.right + _axcUI_contentInset.left;
    CGSize contentSize = CGSizeMake(maxLineWidth, currentYBase - _axcUI_verticalSpacing + _axcUI_contentInset.bottom);
    if (!CGSizeEqualToSize(contentSize, _scrollView.contentSize)) {
        _scrollView.contentSize = contentSize;
        _containerView.frame = (CGRect){CGPointZero, contentSize};
        
        if ([self.axcUI_tagViewDelegate respondsToSelector:@selector(AxcUI_tagView:updateContentSize:)]) {
            [self.axcUI_tagViewDelegate AxcUI_tagView:self updateContentSize:contentSize];
        }
    }
}

- (void)setNeedsLayoutTagViews {
    _needsLayoutTagViews = YES;
}

#pragma mark - 代理区 delegate and dataSource

- (BOOL)isDelegateAndDataSourceValid {
    BOOL isValid = _axcUI_tagViewDelegate != nil && _axcUI_tagViewDataSource != nil;
    isValid = isValid && [_axcUI_tagViewDelegate respondsToSelector:@selector(AxcUI_tagView:sizeForTagAtIndex:)];
    isValid = isValid && [_axcUI_tagViewDataSource respondsToSelector:@selector(AxcUI_tagView:tagViewForIndex:)];
    isValid = isValid && [_axcUI_tagViewDataSource respondsToSelector:@selector(AxcUI_numberOfTagsInTagView:)];
    return isValid;
}

#pragma mark - SET

- (UIScrollView *)axcUI_scrollView {
    return _scrollView;
}

- (void)setAxcUI_scrollDirection:(AxcTagViewScrollDirectionStyle)axcUI_scrollDirection {
    _axcUI_scrollDirection = axcUI_scrollDirection;
    [self setNeedsLayoutTagViews];
    [self AxcUI_reloadData];
}

- (void)setAxcUI_alignment:(AxcTagViewAlignmentStyle)axcUI_alignment {
    if (_axcUI_alignment != axcUI_alignment) {
        _axcUI_alignment = axcUI_alignment;
        [self setNeedsLayoutTagViews];
        [self AxcUI_reloadData];
    }
}

- (void)setAxcUI_numberOfLines:(NSUInteger)axcUI_numberOfLines {
    if (_axcUI_numberOfLines != axcUI_numberOfLines) {
        _axcUI_numberOfLines = axcUI_numberOfLines;
        [self setNeedsLayoutTagViews];
        [self AxcUI_reloadData];
    }
}

- (void)setAxcUI_horizontalSpacing:(CGFloat)axcUI_horizontalSpacing {
    _axcUI_horizontalSpacing = axcUI_horizontalSpacing;
    [self setNeedsLayoutTagViews];
}

- (void)setAxcUI_verticalSpacing:(CGFloat)axcUI_verticalSpacing {
    _axcUI_verticalSpacing = axcUI_verticalSpacing;
    [self setNeedsLayoutTagViews];
}

- (void)setAxcUI_contentInset:(UIEdgeInsets)axcUI_contentInset {
    _axcUI_contentInset = axcUI_contentInset;
    [self setNeedsLayoutTagViews];
}

- (CGSize)axcUI_contentSize {
    [self layoutTagViews];
    return _scrollView.contentSize;
}

- (void)setAxcUI_manualCalculateHeight:(BOOL)axcUI_manualCalculateHeight {
    _axcUI_manualCalculateHeight = axcUI_manualCalculateHeight;
    [self setNeedsLayoutTagViews];
}

- (void)setAxcUI_preferredMaxLayoutWidth:(CGFloat)axcUI_preferredMaxLayoutWidth {
    _axcUI_preferredMaxLayoutWidth = axcUI_preferredMaxLayoutWidth;
    [self setNeedsLayoutTagViews];
}

- (void)setAxcUI_showsHorizontalScrollIndicator:(BOOL)axcUI_showsHorizontalScrollIndicator {
    _scrollView.showsHorizontalScrollIndicator = axcUI_showsHorizontalScrollIndicator;
}

- (BOOL)axcUI_showsHorizontalScrollIndicator {
    return _scrollView.showsHorizontalScrollIndicator;
}

- (void)setaxcUI_showsVerticalScrollIndicator:(BOOL)axcUI_showsVerticalScrollIndicator {
    _scrollView.showsVerticalScrollIndicator = axcUI_showsVerticalScrollIndicator;
}

- (BOOL)axcUI_showsVerticalScrollIndicator {
    return _scrollView.showsVerticalScrollIndicator;
}

@end
