//
//  AxcUI_PhotoBrowserView.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/7.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcUI_PhotoBrowserView.h"

#import "AxcBaseProgressView.h"
#import "UIImageView+AxcWebCache.h"
#import "UIImageView+AxcImageLoader.h"
#import "UIView+AxcExtension.h"
#import "UIColor+AxcColor.h"

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wdeprecated-declarations"

@interface AxcUI_PhotoBrowserView() <UIScrollViewDelegate>
@property (nonatomic,strong) AxcBaseProgressView *progressView;
@property (nonatomic,strong) UITapGestureRecognizer *doubleTap;
@property (nonatomic,strong) UITapGestureRecognizer *singleTap;
@property (nonatomic, strong) NSURL *imageUrl;
@property (nonatomic, strong) UIImage *placeHolderImage;
@property (nonatomic, strong) UIButton *reloadButton;
@property (nonatomic, assign) BOOL hasLoadedImage;

@property(nonatomic, strong)UIButton *saveButton;
@end

@implementation AxcUI_PhotoBrowserView

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.scrollview];
        [self addGestureRecognizer:self.doubleTap];
        [self addGestureRecognizer:self.singleTap];
        [self addGestureRecognizer:self.longTap];
    }
    return self;
}
#pragma mark 双击
- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer{
    if (!self.hasLoadedImage) {
        return;
    }
    CGPoint touchPoint = [recognizer locationInView:self];
    if (self.scrollview.zoomScale <= 1.0) {
        
        CGFloat scaleX = touchPoint.x + self.scrollview.contentOffset.x;
        CGFloat sacleY = touchPoint.y + self.scrollview.contentOffset.y;
        [self.scrollview zoomToRect:CGRectMake(scaleX, sacleY, 10, 10) animated:YES];
        
    } else {
        [self.scrollview setZoomScale:1.0 animated:YES];
    }
}
#pragma mark 单击
- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer{
    if (self.singleTapBlock) {
        self.singleTapBlock(recognizer);
    }
}
#pragma mark - 长按
-(void)handleLongTap:(UILongPressGestureRecognizer *)recognizer {
    if (self.longTabBlock) {
        self.longTabBlock(recognizer);
    }
}
// 设置保存风格
- (void)setAxcUI_saveType:(AxcPhotoBrowserSaveStyle)axcUI_saveType{
    _axcUI_saveType = axcUI_saveType;
    if (_axcUI_saveType != AxcPhotoBrowserStyleLongTapSave) {
        [self removeGestureRecognizer:self.longTap];
        self.saveButton.hidden = NO;
    }
}

// 设置ProGress风格
- (void)setAxcUI_progressViewStyle:(AxcUIProgressViewStyle )axcUI_progressViewStyle{
    _axcUI_progressViewStyle = axcUI_progressViewStyle;
    self.imageview.axcUI_progressViewStyle = _axcUI_progressViewStyle;
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder{
    if (_reloadButton) {
        [_reloadButton removeFromSuperview];
    }
    _imageUrl = url;
    _placeHolderImage = placeholder;
    __weak __typeof(self)weakSelf = self;
    _imageview.contentMode = UIViewContentModeScaleAspectFit;
    [_imageview coreAxc_setImageWithPreviousCachedImageWithURL:url
                                           andPlaceholderImage:placeholder
                                                       options:Axc_WebimageRetryFailed
                                                      progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                                                          weakSelf.imageview.axcUI_progressView.axcUI_progress =
                                                          (CGFloat)receivedSize / expectedSize;
                                                          weakSelf.imageview.axcUI_progressView.axcUI_Size = weakSelf.axcUI_progressSize;
                                                          weakSelf.imageview.axcUI_progressView.axcUI_CenterX =
                                                          (weakSelf.imageview.axcUI_Width / 2) ;
                                                          weakSelf.imageview.axcUI_progressView.axcUI_CenterY =
                                                          (weakSelf.imageview.axcUI_Height / 2) ;
                                                      } completed:^(UIImage *image, NSError *error, coreAxc_ImageCache_remakesType cacheType, NSURL *imageURL) {
                                                          [weakSelf.imageview AxcUI_removeAxcUI_progressViewAnimation:NO];
                                                          weakSelf.imageview.axcUI_progressView.axcUI_progress = 1;
                                                          _imageview.contentMode = 0;
                                                          weakSelf.imageview.axcUI_progressViewStyle = _axcUI_progressViewStyle;

                                                          if (error) {
                                                              UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                                              weakSelf.reloadButton = button;
                                                              button.layer.cornerRadius = 2;
                                                              button.clipsToBounds = YES;
                                                              button.bounds = CGRectMake(0, 0, 200, 60);
                                                              button.center = CGPointMake([UIScreen mainScreen].bounds.size.width * 0.5, [UIScreen mainScreen].bounds.size.height * 0.5);
                                                              button.titleLabel.font = [UIFont systemFontOfSize:14];
                                                              button.backgroundColor = [UIColor colorWithRed:0.1f green:0.1f blue:0.1f alpha:0.3f];
                                                              [button setTitle:@"加载失败，点击重新加载" forState:UIControlStateNormal];
                                                              [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
                                                              [button addTarget:weakSelf action:@selector(reloadImage) forControlEvents:UIControlEventTouchUpInside];
                                                              
                                                              [weakSelf addSubview:button];
                                                              return;
                                                          }
                                                          weakSelf.hasLoadedImage = YES;
                                                          [weakSelf adjustFrame];
                                                      }];
}

- (void)onDeviceOrientationChangeWithObserver{
    [self onDeviceOrientationChange];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onDeviceOrientationChange) name:UIDeviceOrientationDidChangeNotification object:nil];
}

-(void)onDeviceOrientationChange{
    if (!self.axcUI_isShouldLandscape) {
        return;
    }
    [self.scrollview setZoomScale:1.0 animated:YES];
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

- (void)reloadImage
{
    [self setImageWithURL:_imageUrl placeholderImage:_placeHolderImage];
}
///////////////////////////////////////////////
- (void)layoutSubviews{
    [super layoutSubviews];
    self.scrollview.frame = self.bounds;
    [self adjustFrame];
}

- (void)adjustFrame{
    CGRect frame = self.scrollview.frame;
    if (self.imageview.image) {
        CGSize imageSize = self.imageview.image.size;
        CGRect imageFrame = CGRectMake(0, 0, imageSize.width, imageSize.height);
        if (self.axcUI_isFullWidthForLandScape) {
            CGFloat ratio = frame.size.width/imageFrame.size.width;
            imageFrame.size.height = imageFrame.size.height*ratio;
            imageFrame.size.width = frame.size.width;
        } else{
            if (frame.size.width<=frame.size.height) {
                CGFloat ratio = frame.size.width/imageFrame.size.width;
                imageFrame.size.height = imageFrame.size.height*ratio;
                imageFrame.size.width = frame.size.width;
            }else{
                CGFloat ratio = frame.size.height/imageFrame.size.height;
                imageFrame.size.width = imageFrame.size.width*ratio;
                imageFrame.size.height = frame.size.height;
            }
        }
        
        self.imageview.frame = imageFrame;
        self.scrollview.contentSize = self.imageview.frame.size;
        self.imageview.center = [self centerOfScrollViewContent:self.scrollview];

        CGFloat maxScale = frame.size.height/imageFrame.size.height;
        maxScale = frame.size.width/imageFrame.size.width>maxScale?frame.size.width/imageFrame.size.width:maxScale;
        maxScale = maxScale>0.6f?maxScale:0.6f;
        self.scrollview.minimumZoomScale = 0.6f;
        self.scrollview.maximumZoomScale = maxScale;
        self.scrollview.zoomScale = 1.0f;
    }else{
        frame.origin = CGPointZero;
        self.imageview.frame = frame;
        self.scrollview.contentSize = self.imageview.frame.size;
    }
    self.scrollview.contentOffset = CGPointZero;

}

- (CGPoint)centerOfScrollViewContent:(UIScrollView *)scrollView
{
    CGFloat offsetX = (scrollView.bounds.size.width > scrollView.contentSize.width)?
    (scrollView.bounds.size.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.bounds.size.height > scrollView.contentSize.height)?
    (scrollView.bounds.size.height - scrollView.contentSize.height) * 0.5 : 0.0;
    CGPoint actualCenter = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                       scrollView.contentSize.height * 0.5 + offsetY);
    return actualCenter;
}

#pragma mark UIScrollViewDelegate
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    return self.imageview;
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    self.imageview.center = [self centerOfScrollViewContent:scrollView];

}
- (UIScrollView *)scrollview
{
    if (!_scrollview) {
        _scrollview = [[UIScrollView alloc] init];
        _scrollview.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        [_scrollview addSubview:self.imageview];
        _scrollview.delegate = self;
        _scrollview.clipsToBounds = YES;
    }
    return _scrollview;
}

- (UIImageView *)imageview
{
    if (!_imageview) {
        _imageview = [[UIImageView alloc] init];
        _imageview.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height);
        _imageview.userInteractionEnabled = YES;
    }
    return _imageview;
}

- (UITapGestureRecognizer *)doubleTap
{
    if (!_doubleTap) {
        _doubleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
        _doubleTap.numberOfTapsRequired = 2;
        _doubleTap.numberOfTouchesRequired  =1;
    }
    return _doubleTap;
}

- (UITapGestureRecognizer *)singleTap
{
    if (!_singleTap) {
        _singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
        _singleTap.numberOfTapsRequired = 1;
        _singleTap.numberOfTouchesRequired = 1;
        _singleTap.delaysTouchesBegan = YES;
        [_singleTap requireGestureRecognizerToFail:self.doubleTap];
    }
    return _singleTap;
}

-(UILongPressGestureRecognizer *)longTap {
    if (!_longTap) {
        _longTap = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongTap:)];
    }
    return _longTap;
}
- (UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _saveButton.frame = CGRectMake(self.axcUI_Width / 2 - 50, self.axcUI_Height - 50, 100, 28);
        _saveButton.layer.cornerRadius = 2;
        [_saveButton setBackgroundColor:[[UIColor grayColor]colorWithAlphaComponent:0.4]];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        [_saveButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _saveButton.titleLabel.font = [UIFont systemFontOfSize:13];
        [_saveButton addTarget:self action:@selector(click_saveButton:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_saveButton];
    }
    return _saveButton;
}
- (void)click_saveButton:(UIButton *)sender{
    if (self.saveTabBlock) {
        self.saveTabBlock(sender);
    }
}

@end
