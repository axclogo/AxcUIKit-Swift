//
//  UIImageView+AxcLoader.m
//  ImageLoaderAnimation
//
//  Created by Rounak Jain on 28/12/14.
//  Copyright (c) 2014 Rounak Jain. All rights reserved.
//

#import "UIImageView+AxcImageLoader.h"
#import "objc/runtime.h"

#import "AxcUIKit.h"

static NSString * const kprogressView = @"axcUI_progressView";
static NSString * const kprogressViewStyle = @"axcUI_progressViewStyle";


@implementation UIImageView (AxcImageLoader)


- (void)setAxcUI_progressView:(AxcBaseProgressView *)axcUI_progressView{
    [self willChangeValueForKey:kprogressView];
    objc_setAssociatedObject(self, &kprogressView,
                             axcUI_progressView,
                             
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kprogressView];
}

- (AxcBaseProgressView *)axcUI_progressView{
    AxcBaseProgressView *loaderView = objc_getAssociatedObject(self, &kprogressView);
    if (!loaderView) {
        switch (self.axcUI_progressViewStyle) {
            case AxcUIProgressViewStyleTranPieProgressView:
                loaderView = [[AxcUI_TranPieProgressView alloc] init];
                break;
            case AxcUIProgressViewStylePieProgressView:
                loaderView = [[AxcUI_PieProgressView alloc] init];
                break;
            case AxcUIProgressViewStyleLoopProgressView:
                loaderView = [[AxcUI_LoopProgressView alloc] init];
                break;
            case AxcUIProgressViewStyleBallProgressView:
                loaderView = [[AxcUI_BallProgressView alloc] init];
                break;
            case AxcUIProgressViewStyleLodingProgressView:
                loaderView = [[AxcUI_LodingProgressView alloc] init];
                break;
            case AxcUIProgressViewStylePieLoopProgressView:
                loaderView = [[AxcUI_PieLoopProgressView alloc] init];
                break;
            default:
                break;
        }
        [self settingLoaderView:loaderView];
    }

    return loaderView;
}

- (void)setAxcUI_progressViewStyle:(AxcUIProgressViewStyle )axcUI_progressViewStyle{
    [self willChangeValueForKey:kprogressViewStyle];
    objc_setAssociatedObject(self, &kprogressViewStyle,
                             @(axcUI_progressViewStyle),
                             OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:kprogressView];
    Class Progressclass ;
    switch (axcUI_progressViewStyle) {
        case AxcUIProgressViewStyleTranPieProgressView:
            Progressclass = [AxcUI_TranPieProgressView class];
            break;
        case AxcUIProgressViewStylePieProgressView:
            Progressclass = [AxcUI_PieProgressView class];
            break;
        case AxcUIProgressViewStyleLoopProgressView:
            Progressclass = [AxcUI_LoopProgressView class];
            break;
        case AxcUIProgressViewStyleBallProgressView:
            Progressclass = [AxcUI_BallProgressView class];
            break;
        case AxcUIProgressViewStyleLodingProgressView:
            Progressclass = [AxcUI_LodingProgressView class];
            break;
        case AxcUIProgressViewStylePieLoopProgressView:
            Progressclass = [AxcUI_PieLoopProgressView class];
            break;
        default:
            break;
    }
    AxcBaseProgressView *loaderView = objc_getAssociatedObject(self, &kprogressView);
    if (![loaderView isKindOfClass:Progressclass]) { // 判断当前风格类是否与所使用的不同，如果不同则替换指针
        CGFloat progress = loaderView.axcUI_progress;
        [loaderView removeFromSuperview]; // 可执行清空内存泄漏的函数
        loaderView = nil;
        switch (axcUI_progressViewStyle) {
            case AxcUIProgressViewStyleTranPieProgressView:
                loaderView = [[AxcUI_TranPieProgressView alloc] init];
                break;
            case AxcUIProgressViewStylePieProgressView:
                loaderView = [[AxcUI_PieProgressView alloc] init];
                break;
            case AxcUIProgressViewStyleLoopProgressView:
                loaderView = [[AxcUI_LoopProgressView alloc] init];
                break;
            case AxcUIProgressViewStyleBallProgressView:
                loaderView = [[AxcUI_BallProgressView alloc] init];
                break;
            case AxcUIProgressViewStyleLodingProgressView:
                loaderView = [[AxcUI_LodingProgressView alloc] init];
                break;
            case AxcUIProgressViewStylePieLoopProgressView:
                loaderView = [[AxcUI_PieLoopProgressView alloc] init];
                break;
            default:
                break;
        }
        [self settingLoaderView:loaderView];
        loaderView.axcUI_progress = progress;
    }
}

- (AxcUIProgressViewStyle)axcUI_progressViewStyle{
    return [objc_getAssociatedObject(self, &kprogressViewStyle) integerValue];
}


- (void)settingLoaderView:(AxcBaseProgressView *)loaderView{
    loaderView.axcUI_X = self.axcUI_Width / 2 - self.axcUI_Width / 4;
    loaderView.axcUI_Y = self.axcUI_Height / 2 - self.axcUI_Height / 4;
    loaderView.axcUI_Size = CGSizeMake(self.axcUI_Width / 2, self.axcUI_Height / 2);
    [loaderView AxcUI_autoresizingMaskWideAndHigh];
    [self setAxcUI_progressView:loaderView];
    [self addSubview:loaderView];
}



- (void)AxcUI_removeAxcUI_progressViewAnimation:(BOOL )animation{
    if (animation) {
        self.axcUI_progressView.axcUI_progress = 0;
        [UIView animateWithDuration:0.3
                         animations:^{
                             self.axcUI_progressView.alpha = 0;
                             self.axcUI_progressView.transform = CGAffineTransformMakeScale(2,2);
                         }completion:^(BOOL finished) {
                             [self AxcUI_removeAxcUI_progressView];
                         }];
    }else{
        [self AxcUI_removeAxcUI_progressView];
    }
}

- (void)AxcUI_removeAxcUI_progressView{
    self.axcUI_progressView.axcUI_progress = 0;
    self.axcUI_progressView.alpha = 0;
    [self.axcUI_progressView removeFromSuperview];
    self.axcUI_progressView = nil;
}

@end
