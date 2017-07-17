//
//  AxcUI_BannerView.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/17.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcUI_BannerView.h"
#import "AxcBannerCell.h"

// 总共的item数
// 暂时不清楚原作者为什么要*这么大的数
#define AXC_TOTAL_ITEMS (self.itemCount * 10000)

#define AXC_FOOTER_WIDTH 64.0
#define AXC_PAGE_CONTROL_HEIGHT 32.0

@interface AxcUI_BannerView () <UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, strong) UICollectionViewFlowLayout *flowLayout;

@property (nonatomic, strong) AxcBannerFooter *footer;
@property (nonatomic, strong, readwrite) UIPageControl *axcUI_pageControl;

@property (nonatomic, assign) NSInteger itemCount;
@property (nonatomic, strong) NSTimer *timer;

@end

@implementation AxcUI_BannerView

@synthesize axcUI_scrollInterval = _axcUI_scrollInterval;
@synthesize axcUI_autoScroll = _axcUI_autoScroll;
@synthesize axcUI_shouldLoop =_axcUI_shouldLoop;
@synthesize axcUI_pageControl = _axcUI_pageControl;

static NSString *banner_item = @"banner_item";
static NSString *banner_footer = @"banner_footer";

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        [self commonInit];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    if (self = [super initWithCoder:aDecoder]) {
        [self commonInit];
    }
    return self;
}

- (void)commonInit
{
    [self addSubview:self.collectionView];
    [self addSubview:self.axcUI_pageControl];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self updateSubviewsFrame];
}

- (void)updateSubviewsFrame{
    // collectionView
    self.flowLayout.itemSize = self.bounds.size;
    self.flowLayout.footerReferenceSize = CGSizeMake(AXC_FOOTER_WIDTH, self.frame.size.height);
    self.collectionView.frame = self.bounds;
    [self.collectionView reloadData];
    
    // pageControl
    if (CGRectEqualToRect(self.axcUI_pageControlFrame, CGRectZero)) {
        // 若未对pageControl设置过frame, 则使用以下默认frame
        CGFloat w = self.frame.size.width;
        CGFloat h = AXC_PAGE_CONTROL_HEIGHT;
        CGFloat x = 0;
        CGFloat y = self.frame.size.height - h;
        self.axcUI_pageControl.frame = CGRectMake(x, y, w, h);
    }
    [self fixDefaultPosition];
}

// 配置默认起始位置
- (void)fixDefaultPosition
{
    if (self.itemCount == 0) {
        return;
    }
    
    if (self.axcUI_shouldLoop) {
        // 总item数的中间
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:(AXC_TOTAL_ITEMS / 2) inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        [self didScrollItemAtIndex:0];
    } else {
        // 第0个item
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionLeft animated:NO];
        [self didScrollItemAtIndex:0];
    }
}

- (void)didScrollItemAtIndex:(NSInteger)index{
    self.axcUI_pageControl.currentPage = index;
    
    if ([self.axcUI_bannerDelegate respondsToSelector:@selector(AxcUI_banner:didScrollToItemAtIndex:)]) {
        [self.axcUI_bannerDelegate AxcUI_banner:self didScrollToItemAtIndex:index];
    }
}

#pragma mark - Reload

- (void)AxcUI_reloadData{
    if (!self.axcUI_bannerDataSource || self.itemCount == 0) {
        return;
    }
    // 设置pageControl总页数
    self.axcUI_pageControl.numberOfPages = self.itemCount;
    // 刷新数据
    [self.collectionView reloadData];
    // 开启定时器
    [self AxcUI_startTimer];
}

#pragma mark - NSTimer

- (void)AxcUI_stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

- (void)AxcUI_startTimer
{
    if (!self.axcUI_autoScroll) return;
    
    [self AxcUI_stopTimer];
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:self.axcUI_scrollInterval target:self selector:@selector(axcUI_autoScrollToNextItem) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

// 定时器方法
- (void)axcUI_autoScrollToNextItem
{
    if (self.itemCount == 0 ||
        self.itemCount == 1 ||
        !self.axcUI_autoScroll)
    {
        return;
    }
    
    NSIndexPath *currentIndexPath = [[self.collectionView indexPathsForVisibleItems] firstObject];
    NSUInteger currentItem = currentIndexPath.item;
    NSUInteger nextItem = currentItem + 1;
    
    if(nextItem >= AXC_TOTAL_ITEMS) {
        return;
    }
    
    if (self.axcUI_shouldLoop)
    {
        // 无限往下翻页
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextItem inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionLeft
                                            animated:YES];
    } else {
        if ((currentItem % self.itemCount) == self.itemCount - 1) {
            // 当前最后一张, 回到第0张
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionLeft
                                                animated:YES];
        } else {
            // 往下翻页
            [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:nextItem inSection:0]
                                        atScrollPosition:UICollectionViewScrollPositionLeft
                                                animated:YES];
        }
    }
}


#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.axcUI_shouldLoop) {
        return AXC_TOTAL_ITEMS;
    } else {
        return self.itemCount;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AxcBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:banner_item forIndexPath:indexPath];
    if ([self.axcUI_bannerDataSource respondsToSelector:@selector(AxcUI_banner:viewForItemAtIndex:)]) {
        cell.itemView = [self.axcUI_bannerDataSource AxcUI_banner:self viewForItemAtIndex:indexPath.item % self.itemCount];
    }
    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)theCollectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)theIndexPath
{
    UICollectionReusableView *footer = nil;
    
    if(kind == UICollectionElementKindSectionFooter)
    {
        footer = [theCollectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:banner_footer forIndexPath:theIndexPath];
        self.footer = (AxcBannerFooter *)footer;
        
        // 配置footer的提示语
        if ([self.axcUI_bannerDataSource respondsToSelector:@selector(AxcUI_banner:titleForFooterWithState:)]) {
            self.footer.idleTitle = [self.axcUI_bannerDataSource AxcUI_banner:self
                                          titleForFooterWithState:AxcBannerFooterStateIdle];
            self.footer.triggerTitle = [self.axcUI_bannerDataSource AxcUI_banner:self
                                             titleForFooterWithState:AxcBannerFooterStateTrigger];
        }
    }
    
    if (self.axcUI_showFooter) {
        self.footer.hidden = NO;
    } else {
        self.footer.hidden = YES;
    }
    
    return footer;
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.axcUI_bannerDelegate respondsToSelector:@selector(AxcUI_banner:didSelectItemAtIndex:)]) {
        [self.axcUI_bannerDelegate AxcUI_banner:self didSelectItemAtIndex:(indexPath.item % self.itemCount)];
    }
}

- (void)collectionView:(UICollectionView *)collectionView didEndDisplayingCell:(UICollectionViewCell *)cell forItemAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath *currentIndexPath = [[collectionView indexPathsForVisibleItems] firstObject];
    if (currentIndexPath) {
        [self didScrollItemAtIndex:currentIndexPath.item % self.itemCount];
    }
}


#pragma mark - UIScrollViewDelegate
#pragma mark timer相关

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    // 用户滑动的时候停止定时器
    [self AxcUI_stopTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    // 用户停止滑动的时候开启定时器
    [self AxcUI_startTimer];
}

#pragma mark footer相关

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (!self.axcUI_showFooter) return;
    
    static CGFloat lastOffset;
    CGFloat footerDisplayOffset = (scrollView.contentOffset.x - (self.frame.size.width * (self.itemCount - 1)));
    
    // footer的动画
    if (footerDisplayOffset > 0)
    {
        // 开始出现footer
        if (footerDisplayOffset > AXC_FOOTER_WIDTH) {
            if (lastOffset > 0) return;
            self.footer.state = AxcBannerFooterStateTrigger;
        } else {
            if (lastOffset < 0) return;
            self.footer.state = AxcBannerFooterStateIdle;
        }
        lastOffset = footerDisplayOffset - AXC_FOOTER_WIDTH;
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    if (!self.axcUI_showFooter) return;

    CGFloat footerDisplayOffset = (scrollView.contentOffset.x - (self.frame.size.width * (self.itemCount - 1)));
    
    // 通知footer代理
    if (footerDisplayOffset > AXC_FOOTER_WIDTH) {
        if ([self.axcUI_bannerDelegate respondsToSelector:@selector(AxcUI_bannerFooterDidTrigger:)]) {
            [self.axcUI_bannerDelegate AxcUI_bannerFooterDidTrigger:self];
        }
    }
}

#pragma mark - setters & getters
#pragma mark 属性

/**
 *  数据源
 */
- (void)setAxcUI_bannerDataSource:(id<AxcBannerViewDataSource>)axcUI_bannerDataSource{
    _axcUI_bannerDataSource = axcUI_bannerDataSource;
    
    // 刷新数据
    [self AxcUI_reloadData];
    
    // 配置默认起始位置
    [self fixDefaultPosition];
}

- (NSInteger)itemCount{
    if ([self.axcUI_bannerDataSource respondsToSelector:@selector(AxcUI_numberOfItemsInBanner:)]) {
        return [self.axcUI_bannerDataSource AxcUI_numberOfItemsInBanner:self];
    }
    return 0;
}

/**
 *  是否需要循环滚动
 */
- (void)setAxcUI_shouldLoop:(BOOL)axcUI_shouldLoop{
    _axcUI_shouldLoop = axcUI_shouldLoop;
    
    [self AxcUI_reloadData];
    
    // 重置默认起始位置
    [self fixDefaultPosition];
}

- (BOOL)axcUI_shouldLoop
{
    if (self.axcUI_showFooter) {
        // 如果footer存在就不应该有循环滚动
        return NO;
    }
    if (self.itemCount == 1) {
        // 只有一个item也不应该有循环滚动
        return NO;
    }
    return _axcUI_shouldLoop;
}

/**
 *  是否显示footer
 */
- (void)setAxcUI_showFooter:(BOOL)axcUI_showFooter{
    _axcUI_showFooter = axcUI_showFooter;
    
    [self AxcUI_reloadData];
}

/**
 *  是否自动滑动
 */
- (void)setAxcUI_autoScroll:(BOOL)axcUI_autoScroll
{
    _axcUI_autoScroll = axcUI_autoScroll;
    
    if (axcUI_autoScroll) {
        [self AxcUI_startTimer];
    } else {
        [self AxcUI_stopTimer];
    }
}

- (BOOL)axcUI_autoScroll
{
    if (self.itemCount < 2) {
        // itemCount小于2时, 禁用自动滚动
        return NO;
    }
    return _axcUI_autoScroll;
}

/**
 *  自动滑动间隔时间
 */
- (void)setAxcUI_scrollInterval:(CGFloat)axcUI_scrollInterval{
    _axcUI_scrollInterval = axcUI_scrollInterval;
    
    [self AxcUI_startTimer];
}

- (CGFloat)axcUI_scrollInterval
{
    if (!_axcUI_scrollInterval) {
        _axcUI_scrollInterval = 3.0; // default
    }
    return _axcUI_scrollInterval;
}


/**
 *  重写设置背景颜色
 */
- (void)setBackgroundColor:(UIColor *)backgroundColor
{
    [super setBackgroundColor:backgroundColor];
    
    self.collectionView.backgroundColor = backgroundColor;
}

/**
 *  当前 item 的 index
 */
- (void)setAxcUI_currentIndex:(NSInteger)currentIndex animated:(BOOL)animated
{
    if (self.axcUI_shouldLoop) {
        NSIndexPath *oldCurrentIndexPath = [[self.collectionView indexPathsForVisibleItems] firstObject];
        NSUInteger oldCurrentIndex = oldCurrentIndexPath.item;
        NSUInteger newCurrentIndex = oldCurrentIndex - oldCurrentIndex % self.itemCount + currentIndex;
        if(newCurrentIndex >= AXC_TOTAL_ITEMS) {
            return;
        }
        
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:newCurrentIndex inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionLeft
                                            animated:animated];
        [self didScrollItemAtIndex:newCurrentIndex % self.itemCount];
    } else {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:currentIndex inSection:0]
                                    atScrollPosition:UICollectionViewScrollPositionLeft
                                            animated:animated];
        [self didScrollItemAtIndex:currentIndex];
    }
}
- (void)setAxcUI_currentIndex:(NSInteger)axcUI_currentIndex{
    [self setAxcUI_currentIndex:axcUI_currentIndex animated:NO];
}

- (NSInteger)axcUI_currentIndex{
    return self.axcUI_pageControl.currentPage;
}


#pragma mark 控件

/**
 *  collectionView
 */
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        _collectionView = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:self.flowLayout];
        _collectionView.pagingEnabled = YES;
        _collectionView.alwaysBounceHorizontal = YES; // 小于等于一页时, 允许bounce
        _collectionView.showsHorizontalScrollIndicator = NO;
        _collectionView.scrollsToTop = NO;
        _collectionView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        
        // 注册cell
        [_collectionView registerClass:[AxcBannerCell class] forCellWithReuseIdentifier:banner_item];
        
        // 注册 \ 配置footer
        [_collectionView registerClass:[AxcBannerFooter class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:banner_footer];
        _collectionView.contentInset = UIEdgeInsetsMake(0, 0, 0, -AXC_FOOTER_WIDTH);
    }
    return _collectionView;
}

- (UICollectionViewFlowLayout *)flowLayout
{
    if (!_flowLayout) {
        _flowLayout = [[UICollectionViewFlowLayout alloc] init];
        _flowLayout.minimumInteritemSpacing = 0;
        _flowLayout.minimumLineSpacing = 0;
        _flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _flowLayout.sectionInset = UIEdgeInsetsZero;
    }
    return _flowLayout;
}

/**
 *  pageControl
 */
- (void)setAxcUI_pageControl:(UIPageControl *)axcUI_pageControl{
    // 移除旧oageControl
    [_axcUI_pageControl removeFromSuperview];
    
    // 赋值
    _axcUI_pageControl = axcUI_pageControl;
    
    // 添加新pageControl
    _axcUI_pageControl.userInteractionEnabled = NO;
    _axcUI_pageControl.autoresizingMask = UIViewAutoresizingNone;
    _axcUI_pageControl.backgroundColor = [UIColor redColor];
    [self addSubview:_axcUI_pageControl];
    
    [self AxcUI_reloadData];
}

- (UIPageControl *)axcUI_pageControl{
    if (!_axcUI_pageControl) {
        _axcUI_pageControl = [[UIPageControl alloc] init];
        _axcUI_pageControl.userInteractionEnabled = NO;
        _axcUI_pageControl.autoresizingMask = UIViewAutoresizingNone;
    }
    return _axcUI_pageControl;
}

- (void)setAxcUI_pageControlFrame:(CGRect)axcUI_pageControlFrame{
    _axcUI_pageControlFrame = axcUI_pageControlFrame;
    
    self.axcUI_pageControl.frame = axcUI_pageControlFrame;
}

@end
