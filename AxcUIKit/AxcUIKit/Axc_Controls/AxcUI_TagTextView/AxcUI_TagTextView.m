//
// Created by zorro on 15/12/28.
//

#import "AxcUI_TagTextView.h"

#import "UIColor+AxcColor.h"
#import "AxcUI_Label.h"
#pragma mark - -----AxcTagTextConfig-----

@implementation AxcTagTextConfig

- (instancetype)init {
    self = [super init];
    if (self) {
        _axcUI_tagTextFont = [UIFont systemFontOfSize:14.0f];
        
        _axcUI_tagTextColor = [UIColor AxcUI_ConcreteColor];
        _axcUI_tagSelectedTextColor = [UIColor whiteColor];
        
        _axcUI_tagBackgroundColor = [UIColor clearColor];
        _axcUI_tagSelectedBackgroundColor = [UIColor AxcUI_ConcreteColor];
        
        _axcUI_tagCornerRadius = 4.0f;
        _axcUI_tagSelectedCornerRadius = 4.0f;
        
        _axcUI_tagBorderWidth = 1.0f;
        _axcUI_tagSelectedBorderWidth = 1.0f;
        
        _axcUI_tagBorderColor = [UIColor AxcUI_ConcreteColor];
        _axcUI_tagSelectedBorderColor = [UIColor AxcUI_CloudColor];
        
        _axcUI_tagExtraSpace = CGSizeMake(14, 14);
    }
    return self;
}

- (instancetype)copyWithZone:(NSZone *)zone {
    AxcTagTextConfig *newConfig = [AxcTagTextConfig new];
    newConfig.axcUI_tagTextFont = [_axcUI_tagTextFont copyWithZone:zone];
    
    newConfig.axcUI_tagTextColor = [_axcUI_tagTextColor copyWithZone:zone];
    newConfig.axcUI_tagSelectedTextColor = [_axcUI_tagSelectedTextColor copyWithZone:zone];
    
    newConfig.axcUI_tagBackgroundColor = [_axcUI_tagBackgroundColor copyWithZone:zone];
    newConfig.axcUI_tagSelectedBackgroundColor = [_axcUI_tagSelectedBackgroundColor copyWithZone:zone];
    
    newConfig.axcUI_tagCornerRadius = _axcUI_tagCornerRadius;
    newConfig.axcUI_tagSelectedCornerRadius = _axcUI_tagSelectedCornerRadius;
    
    newConfig.axcUI_tagBorderWidth = _axcUI_tagBorderWidth;
    newConfig.axcUI_tagSelectedBorderWidth = _axcUI_tagSelectedBorderWidth;
    
    newConfig.axcUI_tagBorderColor = [_axcUI_tagBorderColor copyWithZone:zone];
    newConfig.axcUI_tagSelectedBorderColor = [_axcUI_tagSelectedBorderColor copyWithZone:zone];
    
    newConfig.axcUI_tagShadowColor = [_axcUI_tagShadowColor copyWithZone:zone];
    newConfig.axcUI_tagShadowOffset = _axcUI_tagShadowOffset;
    newConfig.axcUI_tagShadowRadius = _axcUI_tagShadowRadius;
    newConfig.axcUI_tagShadowOpacity = _axcUI_tagShadowOpacity;
    
    newConfig.axcUI_tagExtraSpace = _axcUI_tagExtraSpace;
    
    return newConfig;
}

@end

#pragma mark - -----Axc_TagTextLabel-----

// 同时包装为圆角和阴影
@interface Axc_TagTextLabel : UIView
@property (nonatomic, strong) AxcTagTextConfig *config;
@property (nonatomic, strong) AxcUI_Label *label;
@property (assign, nonatomic) BOOL selected;
@end

@implementation Axc_TagTextLabel

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit {
    _label = [[AxcUI_Label alloc] initWithFrame:self.bounds];
    _label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:_label];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    _label.frame = self.bounds;
    self.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:_label.bounds
                                                       cornerRadius:_label.layer.cornerRadius].CGPath;
}

- (void)sizeToFit {
    [_label sizeToFit];
    CGRect frame = self.frame;
    frame.size = _label.frame.size;
    self.frame = frame;
}

- (CGSize)sizeThatFits:(CGSize)size {
    return [_label sizeThatFits:size];
}

- (CGSize)intrinsicContentSize {
    return _label.intrinsicContentSize;
}

@end

#pragma mark - -----AxcUI_TagTextView-----

@interface AxcUI_TagTextView () <AxcTagViewDataSource, AxcTagViewDelegate>
@property (strong, nonatomic) NSMutableArray <Axc_TagTextLabel *> *tagLabels;
@property (strong, nonatomic) AxcUI_TagView *tagView;
@end

@implementation AxcUI_TagTextView

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
    if (_tagView) {
        return;
    }

    _axcUI_enableTagSelection = YES;
    _tagLabels = [NSMutableArray new];

    _axcUI_defaultConfig = [AxcTagTextConfig new];

    _tagView = [[AxcUI_TagView alloc] initWithFrame:self.bounds];
    _tagView.axcUI_tagViewDelegate = self;
    _tagView.axcUI_tagViewDataSource = self;
    _tagView.axcUI_horizontalSpacing = 8;
    _tagView.axcUI_verticalSpacing = 8;
    [self addSubview:_tagView];
}

#pragma mark - 适配函数

- (CGSize)intrinsicContentSize {
    return [_tagView intrinsicContentSize];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    if (!CGRectEqualToRect(_tagView.frame, self.bounds)) {
        [self updateAllLabelStyleAndFrame];
        _tagView.frame = self.bounds;
        [_tagView setNeedsLayout];
        [_tagView layoutIfNeeded];
        [self invalidateIntrinsicContentSize];
    }
}

#pragma mark - 复用函数

- (void)AxcUI_reloadData {
    [self updateAllLabelStyleAndFrame];
    [_tagView AxcUI_reloadData];
    [self invalidateIntrinsicContentSize];
}

- (void)AxcUI_addTag:(NSString *)tag {
    [self AxcUI_insertTag:tag atIndex:_tagLabels.count];
}

- (void)AxcUI_addTag:(NSString *)tag withConfig:(AxcTagTextConfig *)config {
    [self AxcUI_insertTag:tag atIndex:_tagLabels.count withConfig:config];
}

- (void)AxcUI_addTags:(NSArray <NSString *> *)tags {
    [self AxcUI_insertTags:tags atIndex:_tagLabels.count withConfig:_axcUI_defaultConfig copyConfig:NO];
}

- (void)AxcUI_addTags:(NSArray<NSString *> *)tags withConfig:(AxcTagTextConfig *)config {
    [self AxcUI_insertTags:tags atIndex:_tagLabels.count withConfig:config copyConfig:YES];
}

- (void)AxcUI_insertTag:(NSString *)tag atIndex:(NSUInteger)index {
    if ([tag isKindOfClass:[NSString class]]) {
        [self AxcUI_insertTags:@[tag] atIndex:index withConfig:_axcUI_defaultConfig copyConfig:NO];
    }
}

- (void)AxcUI_insertTag:(NSString *)tag atIndex:(NSUInteger)index withConfig:(AxcTagTextConfig *)config {
    if ([tag isKindOfClass:[NSString class]]) {
        [self AxcUI_insertTags:@[tag] atIndex:index withConfig:config copyConfig:YES];
    }
}

- (void)AxcUI_insertTags:(NSArray<NSString *> *)tags atIndex:(NSUInteger)index {
    [self AxcUI_insertTags:tags atIndex:index withConfig:_axcUI_defaultConfig copyConfig:NO];
}

- (void)AxcUI_insertTags:(NSArray<NSString *> *)tags atIndex:(NSUInteger)index withConfig:(AxcTagTextConfig *)config {
    [self AxcUI_insertTags:tags atIndex:index withConfig:config copyConfig:YES];
}

- (void)AxcUI_insertTags:(NSArray<NSString *> *)tags atIndex:(NSUInteger)index withConfig:(AxcTagTextConfig *)config copyConfig:(BOOL)copyConfig {
    if (![tags isKindOfClass:[NSArray class]] || index > _tagLabels.count || ![config isKindOfClass:[AxcTagTextConfig class]]) {
        return;
    }
    
    if (copyConfig) {
        config = [config copy];
    }
    
    NSMutableArray *newTagLabels = [NSMutableArray new];
    for (NSString *tagText in tags) {
        Axc_TagTextLabel *label = [self newLabelForTagText:[tagText description] withConfig:config];
        [newTagLabels addObject:label];
    }
    [_tagLabels insertObjects:newTagLabels atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(index, newTagLabels.count)]];
    [self AxcUI_reloadData];
}

- (void)AxcUI_removeTag:(NSString *)tag {
    if (![tag isKindOfClass:[NSString class]] || tag.length == 0) {
        return;
    }

    NSMutableArray *labelsToRemoved = [NSMutableArray new];
    for (Axc_TagTextLabel *label in _tagLabels) {
        if ([label.label.text isEqualToString:tag]) {
            [labelsToRemoved addObject:label];
        }
    }
    [_tagLabels removeObjectsInArray:labelsToRemoved];
    [self AxcUI_reloadData];
}

- (void)AxcUI_removeTagAtIndex:(NSUInteger)index {
    if (index >= _tagLabels.count) {
        return;
    }

    [_tagLabels removeObjectAtIndex:index];
    [self AxcUI_reloadData];
}

- (void)AxcUI_removeAllTags {
    [_tagLabels removeAllObjects];
    [self AxcUI_reloadData];
}

- (void)AxcUI_setTagAtIndex:(NSUInteger)index selected:(BOOL)selected {
    if (index >= _tagLabels.count) {
        return;
    }

    _tagLabels[index].selected = selected;
    [self AxcUI_reloadData];
}

- (void)AxcUI_setTagAtIndex:(NSUInteger)index withConfig:(AxcTagTextConfig *)config {
    if (index >= _tagLabels.count || ![config isKindOfClass:[AxcTagTextConfig class]]) {
        return;
    }
    
    _tagLabels[index].config = [config copy];
    [self AxcUI_reloadData];
}

- (void)AxcUI_setTagsInRange:(NSRange)range withConfig:(AxcTagTextConfig *)config {
    if (NSMaxRange(range) > _tagLabels.count || ![config isKindOfClass:[AxcTagTextConfig class]]) {
        return;
    }
    
    NSArray *tagLabels = [_tagLabels subarrayWithRange:range];
    config = [config copy];
    for (Axc_TagTextLabel *label in tagLabels) {
        label.config = config;
    }
    [self AxcUI_reloadData];
}

- (NSString *)AxcUI_getTagAtIndex:(NSUInteger)index {
    if (index < _tagLabels.count) {
        return [_tagLabels[index].label.text copy];
    } else {
        return nil;
    }
}

- (NSArray<NSString *> *)AxcUI_getTagsInRange:(NSRange)range {
    if (NSMaxRange(range) <= _tagLabels.count) {
        NSMutableArray *tags = [NSMutableArray new];
        for (Axc_TagTextLabel *label in [_tagLabels subarrayWithRange:range]) {
            [tags addObject:[label.label.text copy]];
        }
        return [tags copy];
    } else {
        return nil;
    }
}

- (AxcTagTextConfig *)AxcUI_getConfigAtIndex:(NSUInteger)index {
    if (index < _tagLabels.count) {
        return [_tagLabels[index].config copy];
    } else {
        return nil;
    }
}

- (NSArray<AxcTagTextConfig *> *)AxcUI_getConfigsInRange:(NSRange)range {
    if (NSMaxRange(range) <= _tagLabels.count) {
        NSMutableArray *configs = [NSMutableArray new];
        for (Axc_TagTextLabel *label in [_tagLabels subarrayWithRange:range]) {
            [configs addObject:[label.config copy]];
        }
        return [configs copy];
    } else {
        return nil;
    }
}

- (NSArray <NSString *> *)AxcUI_allTags {
    NSMutableArray *allTags = [NSMutableArray new];

    for (Axc_TagTextLabel *label in _tagLabels) {
        [allTags addObject:[label.label.text copy]];
    }

    return [allTags copy];
}

- (NSArray <NSString *> *)AxcUI_allSelectedTags {
    NSMutableArray *allTags = [NSMutableArray new];

    for (Axc_TagTextLabel *label in _tagLabels) {
        if (label.selected) {
            [allTags addObject:[label.label.text copy]];
        }
    }

    return [allTags copy];
}

- (NSArray <NSString *> *)AxcUI_allNotSelectedTags {
    NSMutableArray *allTags = [NSMutableArray new];

    for (Axc_TagTextLabel *label in _tagLabels) {
        if (!label.selected) {
            [allTags addObject:[label.label.text copy]];
        }
    }

    return [allTags copy];
}

#pragma mark - AxcTagViewDataSource

- (NSUInteger)AxcUI_numberOfTagsInTagView:(AxcUI_TagView *)tagView {
    return _tagLabels.count;
}

- (UIView *)AxcUI_tagView:(AxcUI_TagView *)tagView tagViewForIndex:(NSUInteger)index {
//    Axc_TagTextLabel *label = _tagLabels[index];
    return _tagLabels[index];
}

#pragma mark - AxcTagViewDelegate

- (BOOL)AxcUI_tagView:(AxcUI_TagView *)tagView
      shouldSelectTag:(UIView *)axctagView atIndex:(NSUInteger)index {
    if (_axcUI_enableTagSelection) {
        Axc_TagTextLabel *label = _tagLabels[index];
        if ([self.axcUI_tagTextViewDelegate respondsToSelector:@selector(AxcUI_tagTextView:canTapTag:atIndex:currentSelected:)]) {
            return [self.axcUI_tagTextViewDelegate AxcUI_tagTextView:self
                                                           canTapTag:label.label.text
                                                             atIndex:index
                                                     currentSelected:label.selected];
        } else {
            return YES;
        }
    } else {
        return NO;
    }
}

- (void)AxcUI_tagView:(AxcUI_TagView *)tagView didSelectTag:(UIView *)axctagView atIndex:(NSUInteger)index {
    if (_axcUI_enableTagSelection) {
        Axc_TagTextLabel *label = _tagLabels[index];
        
        if (!label.selected && _axcUI_selectionLimit > 0 && [self AxcUI_allSelectedTags].count + 1 > _axcUI_selectionLimit) {
            return;
        }
        
        label.selected = !label.selected;
        
        if (self.axcUI_alignment == AxcTagViewAlignmentStyleFillByExpandingWidth) {
            [self AxcUI_reloadData];
        } else {
            [self updateStyleAndFrameForLabel:label];
        }
        
        if ([_axcUI_tagTextViewDelegate respondsToSelector:@selector(AxcUI_tagTextView:didTapTag:atIndex:selected:)]) {
            [_axcUI_tagTextViewDelegate AxcUI_tagTextView:self didTapTag:label.label.text atIndex:index selected:label.selected];
        }
    }
}

- (CGSize)AxcUI_tagView:(AxcUI_TagView *)tagView sizeForTagAtIndex:(NSUInteger)index {
    return _tagLabels[index].frame.size;
}

- (void)AxcUI_tagView:(AxcUI_TagView *)tagView updateContentSize:(CGSize)contentSize {
    if ([_axcUI_tagTextViewDelegate respondsToSelector:@selector(AxcUI_tagTextView:updateContentSize:)]) {
        [_axcUI_tagTextViewDelegate AxcUI_tagTextView:self updateContentSize:contentSize];
    }
}

#pragma mark - SET

- (UIScrollView *)axcUI_scrollView {
    return _tagView.axcUI_scrollView;
}

- (CGFloat)axcUI_horizontalSpacing {
    return _tagView.axcUI_horizontalSpacing;
}

- (void)setAxcUI_horizontalSpacing:(CGFloat)axcUI_horizontalSpacing {
    _tagView.axcUI_horizontalSpacing = axcUI_horizontalSpacing;
}

- (CGFloat)axcUI_verticalSpacing {
    return _tagView.axcUI_verticalSpacing;
}

- (void)setAxcUI_verticalSpacing:(CGFloat)axcUI_verticalSpacing {
    _tagView.axcUI_verticalSpacing = axcUI_verticalSpacing;
}

- (CGSize)axcUI_contentSize {
    return _tagView.axcUI_contentSize;
}

- (AxcTagViewScrollDirectionStyle)axcUI_scrollDirection {
    return _tagView.axcUI_scrollDirection;
}

- (void)setAxcUI_scrollDirection:(AxcTagViewScrollDirectionStyle)axcUI_scrollDirection {
    _tagView.axcUI_scrollDirection = axcUI_scrollDirection;
}

- (AxcTagViewAlignmentStyle)axcUI_alignment {
    return _tagView.axcUI_alignment;
}

- (void)setAxcUI_alignment:(AxcTagViewAlignmentStyle)axcUI_alignment {
    _tagView.axcUI_alignment = axcUI_alignment;
}

- (NSUInteger)axcUI_numberOfLines {
    return _tagView.axcUI_numberOfLines;
}

- (void)setAxcUI_numberOfLines:(NSUInteger)axcUI_numberOfLines {
    _tagView.axcUI_numberOfLines = axcUI_numberOfLines;
}

- (UIEdgeInsets)axcUI_contentInset {
    return _tagView.axcUI_contentInset;
}

- (void)setAxcUI_contentInset:(UIEdgeInsets)axcUI_contentInset {
    _tagView.axcUI_contentInset = axcUI_contentInset;
}

- (BOOL)axcUI_manualCalculateHeight {
    return _tagView.axcUI_manualCalculateHeight;
}

- (void)setAxcUI_manualCalculateHeight:(BOOL)axcUI_manualCalculateHeight {
    _tagView.axcUI_manualCalculateHeight = axcUI_manualCalculateHeight;
}

- (CGFloat)axcUI_preferredMaxLayoutWidth {
    return _tagView.axcUI_preferredMaxLayoutWidth;
}

- (void)setAxcUI_preferredMaxLayoutWidth:(CGFloat)axcUI_preferredMaxLayoutWidth {
    _tagView.axcUI_preferredMaxLayoutWidth = axcUI_preferredMaxLayoutWidth;
}

- (void)setAxcUI_showsHorizontalScrollIndicator:(BOOL)axcUI_showsHorizontalScrollIndicator {
    _tagView.axcUI_showsHorizontalScrollIndicator = axcUI_showsHorizontalScrollIndicator;
}

- (BOOL)axcUI_showsHorizontalScrollIndicator {
    return _tagView.axcUI_showsHorizontalScrollIndicator;
}

- (void)setaxcUI_showsVerticalScrollIndicator:(BOOL)axcUI_showsVerticalScrollIndicator {
    _tagView.axcUI_showsVerticalScrollIndicator = axcUI_showsVerticalScrollIndicator;
}

- (BOOL)axcUI_showsVerticalScrollIndicator {
    return _tagView.axcUI_showsVerticalScrollIndicator;
}


- (void)updateAllLabelStyleAndFrame {
    for (Axc_TagTextLabel *label in _tagLabels) {
        [self updateStyleAndFrameForLabel:label];
    }
}

- (void)updateStyleAndFrameForLabel:(Axc_TagTextLabel *)label {
    // 刷新适配样式
    AxcTagTextConfig *config = label.config;
    label.label.font = config.axcUI_tagTextFont;
    label.label.textColor = label.selected ? config.axcUI_tagSelectedTextColor : config.axcUI_tagTextColor;
    label.label.backgroundColor = label.selected ? config.axcUI_tagSelectedBackgroundColor : config.axcUI_tagBackgroundColor;
    label.label.layer.cornerRadius = label.selected ? config.axcUI_tagSelectedCornerRadius : config.axcUI_tagCornerRadius;
    label.label.layer.borderWidth = label.selected ? config.axcUI_tagSelectedBorderWidth : config.axcUI_tagBorderWidth;
    label.label.layer.borderColor = (label.selected && config.axcUI_tagSelectedBorderColor) ? config.axcUI_tagSelectedBorderColor.CGColor : config.axcUI_tagBorderColor.CGColor;
    label.label.layer.masksToBounds = YES;
    
    label.layer.shadowColor = (config.axcUI_tagShadowColor ?: [UIColor clearColor]).CGColor;
    label.layer.shadowOffset = config.axcUI_tagShadowOffset;
    label.layer.shadowRadius = config.axcUI_tagShadowRadius;
    label.layer.shadowOpacity = config.axcUI_tagShadowOpacity;
    label.layer.shadowPath = [UIBezierPath bezierPathWithRoundedRect:label.bounds cornerRadius:label.label.layer.cornerRadius].CGPath;
    label.layer.shouldRasterize = YES;
    [label.layer setRasterizationScale:[[UIScreen mainScreen] scale]];
    
    // 刷新适配大小
    CGSize size = [label sizeThatFits:CGSizeZero];
    size.width += config.axcUI_tagExtraSpace.width;
    size.height += config.axcUI_tagExtraSpace.height;
    
    // 宽度限制垂直滚动的方向
    if (self.axcUI_scrollDirection == AxcTagViewScrollDirectionStyleVertical &&
        size.width > (CGRectGetWidth(self.bounds) - self.axcUI_contentInset.left - self.axcUI_contentInset.right)) {
        size.width = (CGRectGetWidth(self.bounds) - self.axcUI_contentInset.left - self.axcUI_contentInset.right);
    }
    
    label.frame = (CGRect){label.frame.origin, size};
}

- (Axc_TagTextLabel *)newLabelForTagText:(NSString *)tagText withConfig:(AxcTagTextConfig *)config {
    Axc_TagTextLabel *label = [Axc_TagTextLabel new];
    label.label.text = tagText;
    label.config = config;
    [self updateStyleAndFrameForLabel:label];
    return label;
}

@end
