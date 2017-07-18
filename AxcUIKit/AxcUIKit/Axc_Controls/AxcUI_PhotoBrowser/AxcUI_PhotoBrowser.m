//
//  AxcPhotoBrowserView.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/7.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcUI_PhotoBrowser.h"

#import "UIImageView+AxcWebCache.h"
#import "AxcUI_Toast.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@implementation AxcUI_PhotoBrowser 
{
    UIScrollView *_scrollView;
    BOOL _hasShowedFistView;
    UILabel *_indexLabel;
    UIButton *_saveButton;
    UIActivityIndicatorView *_indicatorView;
    UIView *_contentView;
    UIPageControl *_pageControl;
    NSInteger initialImageIndex;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor]; // 背景色黑
        self.axcUI_progressSize = CGSizeMake(100, 100);
        self.axcUI_isShouldLandscape = YES; // 默认YES
        self.axcUI_browserImageViewMargin = 10; // 默认间距10
        self.axcUI_rotatingAnimationDuration = 0.35; // 默认旋转动画时间
    }
    return self;
}

- (void)didMoveToSuperview{
    
    [self setupScrollView];
    
    [self setupToolbars];
}


- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)setupToolbars
{
    UILabel *indexLabel = [[UILabel alloc] init];
    indexLabel.textAlignment = NSTextAlignmentCenter;
    indexLabel.textColor = [UIColor whiteColor];
    indexLabel.font = [UIFont boldSystemFontOfSize:20];
    indexLabel.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.3f];
    indexLabel.bounds = CGRectMake(0, 0, 80, 30);
    indexLabel.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, 30);
    indexLabel.layer.cornerRadius = 15;
    indexLabel.clipsToBounds = YES;
    if (self.axcUI_imageCount > 1) {
        indexLabel.text = [NSString stringWithFormat:@"1/%ld", (long)self.axcUI_imageCount];
        _indexLabel = indexLabel;
        [self addSubview:indexLabel];
    }
    
    UIPageControl *page = [[UIPageControl alloc] init];
    page.pageIndicatorTintColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
    page.currentPageIndicatorTintColor = [UIColor whiteColor];
    page.numberOfPages = self.axcUI_imageCount;
    [self addSubview:page];
    _pageControl = page;
    
//    [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(self.bounds.size.width * 0.5 - _pageControl.frame.size.width * 0.5);
//        make.top.mas_equalTo(self.bounds.size.height - 30 - 37);
//    }];
    CGRect frame = _pageControl.frame;
    frame.origin.y = self.bounds.size.height - 30 - 37;
    frame.origin.x = self.bounds.size.width * 0.5 - _pageControl.frame.size.width * 0.5;
    _pageControl.frame = frame;
    
    if (self.axcUI_imageCount == 1) {
        _pageControl.hidden = YES;
    }
    BOOL showNumPage = self.axcUI_pageTypeMode == AxcPhotoBrowserPageControlStyleNumPage ? YES : NO;
    if (showNumPage) {
        [_pageControl removeFromSuperview];
        _pageControl = nil;
    } else {
        [_indexLabel removeFromSuperview];
        _indexLabel = nil;
    }
}

#pragma mark 保存图像
- (UIImage *)saveImageWithImage{
    int index = _scrollView.contentOffset.x / _scrollView.bounds.size.width;
    AxcPhotoBrowserView *currentView = _scrollView.subviews[index];
    return currentView.imageview.image;
}

- (void)setAxcUI_currentImageIndex:(int)axcUI_currentImageIndex{
    initialImageIndex = _axcUI_currentImageIndex = axcUI_currentImageIndex;
}

- (void)setupScrollView
{
    _scrollView = [[UIScrollView alloc] init];
    _scrollView.delegate = self;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.pagingEnabled = YES;
    [self addSubview:_scrollView];
    
    for (int i = 0; i < self.axcUI_imageCount; i++) {
        AxcPhotoBrowserView *view = [[AxcPhotoBrowserView alloc] init];
        view.imageview.tag = i;
        __weak __typeof(self)weakSelf = self;
        view.singleTapBlock = ^(UITapGestureRecognizer *recognizer){
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf photoClick:recognizer];
        };
        view.longTabBlock = ^(UILongPressGestureRecognizer *recognizer) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            [strongSelf photoLongClick:recognizer];
        };
        view.saveTabBlock = ^(UIButton *sender) {
            __strong __typeof(weakSelf)strongSelf = weakSelf;
            if ([strongSelf.axcUI_photoBrowserDelegate respondsToSelector:@selector(AxcUI_photoBrowser:saveTypeMode:Image:)]) {
                [strongSelf.axcUI_photoBrowserDelegate AxcUI_photoBrowser:strongSelf
                                                        saveTypeMode:AxcPhotoBrowserStyleButtonSave
                                                               Image:[self saveImageWithImage]];
            }
        };
        
        [_scrollView addSubview:view];
    }
    [self setupImageOfImageViewForIndex:self.axcUI_currentImageIndex];
    
}


- (void)setupImageOfImageViewForIndex:(NSInteger)index{
    AxcPhotoBrowserView *view = _scrollView.subviews[index];
    if (view.beginLoadingImage) return;
    if ([self highQualityImageURLForIndex:index]) {
        [view setImageWithURL:[self highQualityImageURLForIndex:index] placeholderImage:[self placeholderImageForIndex:index]];
    } else {
        view.imageview.image = [self placeholderImageForIndex:index];
    }
    view.beginLoadingImage = YES;
}


- (void)layoutSubviews{
    [super layoutSubviews];
    
    CGRect rect = self.bounds;
    rect.size.width += self.axcUI_browserImageViewMargin * 2;
    _scrollView.bounds = rect;
    _scrollView.center = CGPointMake(self.bounds.size.width *0.5, self.bounds.size.height *0.5);
    
    CGFloat y = 0;
    __block CGFloat w = _scrollView.frame.size.width - self.axcUI_browserImageViewMargin * 2;
    CGFloat h = _scrollView.frame.size.height;

    [_scrollView.subviews enumerateObjectsUsingBlock:^(AxcPhotoBrowserView *obj, NSUInteger idx, BOOL *stop) {
        CGFloat x = self.axcUI_browserImageViewMargin + idx * (self.axcUI_browserImageViewMargin * 2 + w);
        obj.frame = CGRectMake(x, y, w, h);
        obj.axcUI_progressSize = self.axcUI_progressSize;
        obj.axcUI_progressViewStyle = self.axcUI_progressViewStyle;
        obj.axcUI_isFullWidthForLandScape = self.axcUI_isFullWidthForLandScape;
        obj.axcUI_isShouldLandscape = self.axcUI_isShouldLandscape;
        obj.axcUI_rotatingAnimationDuration = self.axcUI_rotatingAnimationDuration;
        obj.axcUI_saveType = self.axcUI_saveType;
    }];
    
    _scrollView.contentSize = CGSizeMake(_scrollView.subviews.count * _scrollView.frame.size.width, _scrollView.frame.size.height);
    _scrollView.contentOffset = CGPointMake(self.axcUI_currentImageIndex * _scrollView.frame.size.width, 0);
    
    if (!_hasShowedFistView) {
        [self showFirstImage];
    }
    
    _indexLabel.bounds = CGRectMake(0, 0, 80, 30);
    _indexLabel.center = CGPointMake(self.bounds.size.width * 0.5, 30);
    _saveButton.frame = CGRectMake(30, self.bounds.size.height - 70, 55, 30);

    
    if (_pageControl) {
        CGRect frame = _pageControl.frame;
        frame.origin.y = self.bounds.size.height - 30 - 37;
        frame.origin.x = self.bounds.size.width * 0.5 - _pageControl.frame.size.width * 0.5;
        _pageControl.frame = frame;

    }
}


- (void)AxcUI_show{
    _contentView = [[UIView alloc] init];
    _contentView.backgroundColor = self.backgroundColor;
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    _contentView.center = window.center;
    _contentView.bounds = window.bounds;
    
    self.center = CGPointMake(_contentView.bounds.size.width * 0.5, _contentView.bounds.size.height * 0.5);
    self.bounds = CGRectMake(0, 0, _contentView.bounds.size.width, _contentView.bounds.size.height);
    
    [_contentView addSubview:self];
    
    window.windowLevel = UIWindowLevelStatusBar+10.0f;
    [self performSelector:@selector(onDeviceOrientationChangeWithObserver) withObject:nil afterDelay:0.3 + 0.2];
    
    [window addSubview:_contentView];
}
- (void)onDeviceOrientationChangeWithObserver{
    [self onDeviceOrientationChange];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

#pragma mark - 屏幕翻转调用
-(void)onDeviceOrientationChange
{
    if (!self.axcUI_isShouldLandscape) {
        return;
    }
    AxcPhotoBrowserView *currentView = _scrollView.subviews[self.axcUI_currentImageIndex];
    [currentView.scrollview setZoomScale:1.0 animated:YES];
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    
    CGRect screenBounds = [UIScreen mainScreen].bounds;

    if (UIDeviceOrientationIsLandscape(orientation)) {
        [UIView animateWithDuration:self.axcUI_rotatingAnimationDuration delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [[UIApplication sharedApplication] setStatusBarOrientation:(UIInterfaceOrientation)orientation];
            self.transform = (orientation==UIDeviceOrientationLandscapeRight)?CGAffineTransformMakeRotation(M_PI*1.5):CGAffineTransformMakeRotation(M_PI/2);
            self.bounds = CGRectMake(0, 0, screenBounds.size.height, screenBounds.size.width);
            [self setNeedsLayout];
            [self layoutIfNeeded];
        } completion:nil];
    }else if (orientation==UIDeviceOrientationPortrait){
        [UIView animateWithDuration:self.axcUI_rotatingAnimationDuration delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [[UIApplication sharedApplication] setStatusBarOrientation:(UIInterfaceOrientation)orientation];
            self.transform = (orientation==UIDeviceOrientationPortrait)?CGAffineTransformIdentity:CGAffineTransformMakeRotation(M_PI);
            self.bounds = screenBounds;
            [self setNeedsLayout];
            [self layoutIfNeeded];
        } completion:nil];
    }
}

#pragma mark - 开始大图模式
- (void)showFirstImage{
    if (!self.axcUI_convertRectView) {
        return;
    }
    CGRect rect = [self.axcUI_sourceImagesContainerView convertRect:self.axcUI_convertRectView.frame toView:self];

    UIImageView *tempView = [[UIImageView alloc] init];
    tempView.frame = rect;
    tempView.image = [self placeholderImageForIndex:self.axcUI_currentImageIndex];
    tempView.contentMode = UIViewContentModeScaleAspectFit;
    CGFloat placeImageSizeW = tempView.image.size.width;
    CGFloat placeImageSizeH = tempView.image.size.height;
    if (!placeImageSizeW) {
        return;
    }
    CGRect targetTemp;
    CGFloat placeHolderH = (placeImageSizeH * [UIScreen mainScreen].bounds.size.width)/placeImageSizeW;
    if (placeHolderH <= [UIScreen mainScreen].bounds.size.height) {
        targetTemp = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - placeHolderH) * 0.5 , [UIScreen mainScreen].bounds.size.width, placeHolderH);
    } else {
        targetTemp = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, placeHolderH);
    }
    [self addSubview:tempView];

    _scrollView.hidden = YES;
    _indexLabel.hidden = YES;
    _saveButton.hidden = YES;
    _pageControl.hidden = YES;

    [UIView animateWithDuration:0.3 animations:^{
        tempView.frame = targetTemp;
    } completion:^(BOOL finished) {
        _hasShowedFistView = YES;
        [tempView removeFromSuperview];
        _scrollView.hidden = NO;
        _indexLabel.hidden = NO;
        _saveButton.hidden = NO;
        _pageControl.hidden = NO;
    }];
}

#pragma mark - 代理方法
- (UIImage *)placeholderImageForIndex:(NSInteger)index{
    if ([self.axcUI_photoBrowserDelegate respondsToSelector:@selector(AxcUI_photoBrowser:placeholderImageForIndex:)]) {
        return [self.axcUI_photoBrowserDelegate AxcUI_photoBrowser:self placeholderImageForIndex:index];
    }
    return nil;
}

- (NSURL *)highQualityImageURLForIndex:(NSInteger)index{
    if ([self.axcUI_photoBrowserDelegate respondsToSelector:@selector(AxcUI_photoBrowser:highQualityImageURLForIndex:)]) {
        return [self.axcUI_photoBrowserDelegate AxcUI_photoBrowser:self highQualityImageURLForIndex:index];
    }
    return nil;
}

#pragma mark - scrollview代理方法

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int index = (scrollView.contentOffset.x + _scrollView.bounds.size.width * 0.5) / _scrollView.bounds.size.width;
    _indexLabel.text = [NSString stringWithFormat:@"%d/%ld", index + 1, (long)self.axcUI_imageCount];
    
    _pageControl.currentPage = index;

    long left = index - 1;
    long right = index + 1;
    left = left>0?left : 0;
    right = right>self.axcUI_imageCount?self.axcUI_imageCount:right;
    
    for (long i = left; i < right; i++) {
         [self setupImageOfImageViewForIndex:i];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    int autualIndex = scrollView.contentOffset.x  / _scrollView.bounds.size.width;
    _axcUI_currentImageIndex = autualIndex;
    for (AxcPhotoBrowserView *view in _scrollView.subviews) {
        if (view.imageview.tag != autualIndex) {
                view.scrollview.zoomScale = 1.0;
        }
    }
}

#pragma mark - tap
#pragma mark 双击
- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer{
    AxcPhotoBrowserView *view = (AxcPhotoBrowserView *)recognizer.view;
    CGPoint touchPoint = [recognizer locationInView:self];
    if (view.scrollview.zoomScale <= 1.0) {
    
    CGFloat scaleX = touchPoint.x + view.scrollview.contentOffset.x;
    CGFloat sacleY = touchPoint.y + view.scrollview.contentOffset.y;
    [view.scrollview zoomToRect:CGRectMake(scaleX, sacleY, 10, 10) animated:YES];
        
    } else {
        [view.scrollview setZoomScale:1.0 animated:YES];
    }
    
}

#pragma mark 单击
- (void)photoClick:(UITapGestureRecognizer *)recognizer
{
    AxcPhotoBrowserView *currentView = _scrollView.subviews[self.axcUI_currentImageIndex];
    [currentView.scrollview setZoomScale:1.0 animated:YES];
    _indexLabel.hidden = YES;
    _saveButton.hidden = YES;
    _pageControl.hidden = YES;
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    CGRect screenBounds = [UIScreen mainScreen].bounds;
    if (UIDeviceOrientationIsLandscape(orientation)) {
        [UIView animateWithDuration:0.3f delay:0.0f options:UIViewAnimationOptionBeginFromCurrentState animations:^{
            [[UIApplication sharedApplication] setStatusBarOrientation:(UIInterfaceOrientation)UIDeviceOrientationPortrait];
            self.transform = CGAffineTransformIdentity;
            self.bounds = CGRectMake(0, 0, screenBounds.size.width, screenBounds.size.height);
            [self setNeedsLayout];
            [self layoutIfNeeded];
        } completion:^(BOOL finished) {
            [self hidePhotoBrowser:recognizer];
        }];
    } else {
        [self hidePhotoBrowser:recognizer];
    }
}

#pragma mark - 长按
-(void)photoLongClick:(UILongPressGestureRecognizer *)recognizer {
    if ([_axcUI_photoBrowserDelegate respondsToSelector:@selector(AxcUI_photoBrowser:saveTypeMode:Image:)]) {
        [_axcUI_photoBrowserDelegate AxcUI_photoBrowser:self
                                      saveTypeMode:AxcPhotoBrowserStyleLongTapSave
                                             Image:[self saveImageWithImage]];
    }
}



#pragma mark - 退出大图模式
- (void)hidePhotoBrowser:(UITapGestureRecognizer *)recognizer{
    
    AxcPhotoBrowserView *view = (AxcPhotoBrowserView *)recognizer.view;
    UIImageView *currentImageView = view.imageview;

    CGRect targetTemp = [self.axcUI_sourceImagesContainerView convertRect:self.axcUI_convertRectView.frame toView:self];
    if (self.axcUI_automaticallyAdjustsScrollViewInsets) {
        targetTemp.origin.y = targetTemp.origin.y + 100;
    }
    
    UIImageView *tempImageView = [[UIImageView alloc] init];
    tempImageView.image = currentImageView.image;
    CGFloat tempImageSizeH = tempImageView.image.size.height;
    CGFloat tempImageSizeW = tempImageView.image.size.width;
    if (!tempImageSizeW) {
        return;
    }
    CGFloat tempImageViewH = (tempImageSizeH * [UIScreen mainScreen].bounds.size.width)/tempImageSizeW;
    if (tempImageViewH < [UIScreen mainScreen].bounds.size.height) {
        tempImageView.frame = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - tempImageViewH)*0.5, [UIScreen mainScreen].bounds.size.width, tempImageViewH);
    } else {
        tempImageView.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, tempImageViewH);
    }
    [self addSubview:tempImageView];
    
    _saveButton.hidden = YES;
    _indexLabel.hidden = YES;
    _scrollView.hidden = YES;
    _pageControl.hidden = YES;
    self.backgroundColor = [UIColor clearColor];
    _contentView.backgroundColor = [UIColor clearColor];
    self.window.windowLevel = UIWindowLevelNormal;
    if (initialImageIndex != self.axcUI_currentImageIndex) { // 索引变化
        [UIView animateWithDuration:0.3 animations:^{
            tempImageView.alpha = 0;
        } completion:^(BOOL finished) {
            [_contentView removeFromSuperview];
            [tempImageView removeFromSuperview];
            tempImageView.alpha = 1;
        }];
    }else{
        [UIView animateWithDuration:0.3 animations:^{
            tempImageView.frame = targetTemp;
        } completion:^(BOOL finished) {
            [_contentView removeFromSuperview];
            [tempImageView removeFromSuperview];
        }];
    }
    
}

@end
