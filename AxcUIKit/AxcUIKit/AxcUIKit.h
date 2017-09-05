//
//  AxcUIKit.h
//  AxcUIKit
//
//  Created by Axc_5324 on 17/4/19.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <Foundation/Foundation.h>




#pragma mark - 类扩展
// MARK: UIView+
#import "UIView+AxcShaking.h"                 // 左右晃动的动画扩展
#import "UIView+AxcShimmeringView.h"          // 为View添加闪动效果
#import "UIView+AxcRectCorner.h"              // 快速切圆角
#import "UIView+BadgeInteractionView.h"       // 给View添加交互气泡
#import "UIView+BadgeView.h"                  // 给View添加消息数量气泡

// MARK: UITextField+
#import "UITextField+AxcModifyPlaceholder.h"  // UITextField快速修改Placeholder属性

// MARK: UIImage+
#import "UIImage+AxcImageName.h"              // 为Image扩展根据图片大小来是否加入内存缓存
#import "UIImage+AxcQRCode.h"                 // Image扩展自动生成二维码
#import "UIImage+AxcSpecialEffectsDrawing.h"  // 图像算法/形态学图像处理
#import "UIImage+AxcImageRotating.h"          // 图像旋转

// MARK: UIImageView+
#import "UIImageView+AxcNetworkLoadImage.h"   // 根据AFN和SD结合简单封装的一套异步加载图片的小型框架
#import "UIImageView+AxcImageLoader.h"        // ImageView自动添加Progress指示器扩展
#import "UIImageView+AxcWebCache.h"           // ImageView的图片处理
#import "UIImageView+AxcFilter.h"             // 快速滤镜扩展

// MARK: UILabel+
#import "UILabel+AxcCopyable.h"               // Label添加长摁复制功能

// MARK: UIButton+
#import "UIButton+AxcButtonContentLayout.h"   // Button按钮布局的扩展
#import "UIButton+AxcButtonCountDown.h"       // Button快速设置倒计时扩展

// 因为其中涉及到类方法修改系统函数的特性，所以决定删除这个Api，增加一种示例来解决
// MARK: UITableView+
//#import "UITableView+AxcEmptyData.h"          // TableView无数据时添加占位View

// MARK: UICollectionView+
#import "UICollectionView+AxcCellRearrange.h" // UICollectionView可长摁拖动的扩展 iOS9以后可以调用系统方案

// MARK: UIViewController+
#import "UIViewController+AxcSemiModal.h"     // VC推出动画效果框架扩展


#pragma mark - 工具类
/***********************************工具类***************************************/
// MARK: NSString+
#import "NSString+AxcTextCalculation.h"       // 工具类，计算文字宽和高
#import "NSString+AxcReplaceRichText.h"       // 修改文本中部分字体的属性
// MARK: UIImage+
#import "UIImage+AxcTransfromZoom.h"          // 图片缩放扩展
// MARK: UIView+
#import "UIView+AxcExtension.h"               // 可修改属性的类扩展
#import "UIView+AxcAutoresizingMask.h"        // 自动拉伸的类扩展

// MARK: UILabel+
#import "UILabel+AxcShimmering.h"             // 文字闪动效果(框架内部Api)
// MARK: UIColor+
#import "UIColor+AxcColor.h"                  // COLOR扩展颜色类
// MARK: UITableViewCell+
#import "UITableViewCell+AxcAnimation.h"      // UITableViewCell预设动画
// MARK: UIViewController+
#import "UIViewController+AxcVCBackButtonEvent.h" //获取返回按钮的点击事件

#import "Axc_WebimageCache.h"                 // 清理图片缓存的工具



#pragma mark - 控件类
#import "AxcUI_Label.h" // 自定义文字内边距Label
#import "AxcUI_Toast.h" // 弹出式提醒块
// --------- 进度指示器
#import "AxcUI_ProgressTranPieView.h"
#import "AxcUI_ProgressPieView.h"
#import "AxcUI_ProgressLoopView.h"
#import "AxcUI_ProgressBallView.h"
#import "AxcUI_ProgressLodingView.h"
#import "AxcUI_ProgressPieLoopView.h"
// ------------------
#import "AxcUI_PhotoBrowser.h"          // 图片预览器
#import "AxcUI_ActivityHUD.h"           // HUD指示器
#import "AxcUI_BarrageView.h"           // 弹幕容器View
#import "AxcBarrageRenderHeader.h"      // 弹幕动态渲染引擎
#import "AxcUI_StarRatingView.h"        // 星级评分控件
#import "AxcUI_NumberUnitField.h"       // 单位数字输入
#import "AxcUI_NumberScrollView.h"      // 数字滚动展示
#import "AxcUI_TagView.h"               // 自定义View标签
#import "AxcUI_TagTextView.h"           // 文字样式标签
#import "AxcUI_BadgeInteractionView.h"  // 可交互气泡控件
#import "AxcUI_BadgeView.h"             // 消息展示型气泡
#import "AxcUI_BannerView.h"            // 横幅控件
#import "AxcUI_PlayerVideo.h"           // 视频播放器
#import "AxcUI_UserInteractionControl.h"// 交互动画控制器
#import "AxcUI_CollectionLayout.h"      // 预设布局库







@interface AxcUIKit : NSObject

@end
