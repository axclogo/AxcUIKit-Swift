//
//  AxcPhotoBrowserView.h
//  AxcUIKit
//
//  Created by Axc on 2017/6/7.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+AxcImageLoader.h"
#import "AxcPhotoBrowserView.h"

typedef enum {
    AxcPhotoBrowserPageControlStyleNumPage,     //数字展示图片数量   Digital display graphics
    AxcPhotoBrowserPageControlStyleDefault  //系统默认 分页条UIPageControl   The system default paging UIPageControl
} AxcPhotoBrowserPageControlStyle;

@class AxcUI_PhotoBrowser;

@protocol AxcPhotoBrowserDelegate <NSObject>

// 长按/点击保存按钮 图片后的回调
// 回调根据长摁 或者 点击按钮来处理
- (void)AxcUI_photoBrowser:(AxcUI_PhotoBrowser *)browser
              saveTypeMode:(AxcPhotoBrowserSaveStyle )saveTypeMode
                     Image:(UIImage *)saveImage;
@required

// 每次即将出现图片的占位图，一般以小图为主
- (UIImage *)AxcUI_photoBrowser:(AxcUI_PhotoBrowser *)browser
       placeholderImageForIndex:(NSInteger)index;
@optional
// 进行加载高清图的URL
- (NSURL *)AxcUI_photoBrowser:(AxcUI_PhotoBrowser *)browser
  highQualityImageURLForIndex:(NSInteger)index;

@end

/** 照片浏览器 */
@interface AxcUI_PhotoBrowser : UIView <UIScrollViewDelegate>

// 必选项：===============
/**
 * 从哪个View动画扩展
 */
@property(nonatomic, strong)UIView *axcUI_convertRectView;
/**
 * 父视图
 */
@property (nonatomic, weak) UIView *axcUI_sourceImagesContainerView;
/**
 * 当前图片的索引
 */
@property (nonatomic, assign) int axcUI_currentImageIndex;
/**
 * 图片个数
 */
@property (nonatomic, assign) NSInteger axcUI_imageCount;
/**
 * 代理
 */
@property (nonatomic, weak) id<AxcPhotoBrowserDelegate> axcUI_photoBrowserDelegate;
/**
 * 展示
 */
- (void)AxcUI_show;

// 可选项：===============

/**
 *  分页模式
 */
@property(nonatomic, assign)AxcPhotoBrowserPageControlStyle axcUI_pageTypeMode;
/**
 * 加载进度指示器大小
 */
@property(nonatomic)CGSize axcUI_progressSize;
/**
 * 加载进度指示器风格
 */
@property(nonatomic, assign)AxcUIProgressViewStyle axcUI_progressViewStyle;
/**
 * 是否在横屏的时候直接满宽度，而不是满高度，一般是在有长图需求的时候设置为YES 默认NO
 */
@property(nonatomic, assign)BOOL axcUI_isFullWidthForLandScape;
/**
 * 是否支持横屏  默认YES
 */
@property(nonatomic, assign)BOOL axcUI_isShouldLandscape;
/**
 * 照片浏览器中 图片之间的margin
 */
@property(nonatomic, assign)CGFloat axcUI_browserImageViewMargin;
/**
 * 照片浏览器中 屏幕旋转时 使用这个时间 来做动画修改图片的展示
 */
@property(nonatomic, assign)float axcUI_rotatingAnimationDuration;
/**
 * 保存的方式：长摁or按钮式
 */
@property(nonatomic, assign)AxcPhotoBrowserSaveStyle  axcUI_saveType;
/**
 * 是否带有VC的适配参数
 */
@property(nonatomic, assign)BOOL axcUI_automaticallyAdjustsScrollViewInsets;



@end
