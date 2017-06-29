//
//  AxcUI_PhotoBrowserView.h
//  AxcUIKit
//
//  Created by Axc on 2017/6/7.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AxcImageLoader.h"


typedef enum {
    AxcPhotoBrowserStyleLongTapSave,     // 长摁保存
    AxcPhotoBrowserStyleButtonSave  // 按钮保存
} AxcPhotoBrowserSaveStyle;


@interface AxcUI_PhotoBrowserView : UIView
@property (nonatomic,strong) UIScrollView *scrollview;
@property (nonatomic,strong) UIImageView *imageview;

@property(nonatomic, assign)CGSize axcUI_progressSize;
@property(nonatomic, assign)AxcUIProgressViewStyle axcUI_progressViewStyle;
@property(nonatomic, assign)BOOL axcUI_isFullWidthForLandScape;
//是否支持横屏
@property(nonatomic, assign)BOOL axcUI_isShouldLandscape;
// 照片浏览器中 屏幕旋转时 使用这个时间 来做动画修改图片的展示
@property(nonatomic, assign)float axcUI_rotatingAnimationDuration;

@property(nonatomic, assign)AxcPhotoBrowserSaveStyle  axcUI_saveType;


@property (nonatomic, assign) BOOL beginLoadingImage;
@property (nonatomic, strong) void (^singleTapBlock)(UITapGestureRecognizer *recognizer);
@property (nonatomic,strong) void (^longTabBlock)(UILongPressGestureRecognizer *recognizer);
@property (nonatomic,strong) void (^saveTabBlock)(UIButton *sender);
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
@property (nonatomic,strong) UILongPressGestureRecognizer *longTap;

@end
