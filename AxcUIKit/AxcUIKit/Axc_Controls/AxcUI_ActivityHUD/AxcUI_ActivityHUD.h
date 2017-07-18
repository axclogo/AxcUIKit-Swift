
#import <UIKit/UIKit.h>

#import "AxcUI_ActivityIndicatorView.h"

/**
 *  宏指针定义 __nonnull 类型
 *
 */
NS_ASSUME_NONNULL_BEGIN

// 动画指示器效果
typedef NS_ENUM(NSInteger, AxcActivityHUDIndicatorStyle) {
    AxcActivityHUDIndicatorStyleScalingDots,                 // 环形圆loader
    AxcActivityHUDIndicatorStyleLeadingDots,                 // 环形圆loader
    AxcActivityHUDIndicatorStyleMinorArc,                    // 双圆弧旋转
    AxcActivityHUDIndicatorStyleDynamicArc,                  // 单圆弧长度递增递减旋转
    AxcActivityHUDIndicatorStyleArcInCircle,                 // 单圆弧固长旋转
    
    AxcActivityHUDIndicatorStyleSpringBall,                  // 上下大小弹球
    AxcActivityHUDIndicatorStyleScalingBars,                 // 粗竖条从左到右依次变长
    AxcActivityHUDIndicatorStyleTriangleCircle,              // 三实心球顺时针三角旋转
    // 从此扩展
    AxcActivityHUDIndicatorStyleNineDots,                // 九个点
    AxcActivityHUDIndicatorStyleTriplePulse,             // 频繁水波
    AxcActivityHUDIndicatorStyleFiveDots,                // 奥运五环上上下下
    AxcActivityHUDIndicatorStyleRotatingSquares,         // 旋转方块
    AxcActivityHUDIndicatorStyleDoubleBounce,            // 同心大小水波圆
    
    AxcActivityHUDIndicatorStyleTwoDots,                 // 左右大小圆
    AxcActivityHUDIndicatorStyleThreeDots,               // 三个点同时渐入渐出
    AxcActivityHUDIndicatorStyleBallPulse,               // 三个点从左到右依次大小
    AxcActivityHUDIndicatorStyleBallClipRotate,          // 缺口圆转圈大小
    AxcActivityHUDIndicatorStyleBallClipRotatePulse,     // 中心实心圆大小，外圆双圆弧转
    
    AxcActivityHUDIndicatorStyleBallClipRotateMultiple,  // 中心空心圆大小，外圆双圆弧转
    AxcActivityHUDIndicatorStyleBallRotate,              // 类似百度加载
    AxcActivityHUDIndicatorStyleBallZigZag,              // 双圆画沙漏
    AxcActivityHUDIndicatorStyleBallZigZagDeflect,       // 双圆画三角
    AxcActivityHUDIndicatorStyleBallTrianglePath,        // 顺时针三空心圆三角画圆
    
    AxcActivityHUDIndicatorStyleBallScale,               // 单圆从小到大
    AxcActivityHUDIndicatorStyleLineScale,               // 竖条从左到右依次变长
    AxcActivityHUDIndicatorStyleLineScaleParty,          // 竖条随机长短
    AxcActivityHUDIndicatorStyleBallScaleMultiple,       // 三圆呼吸
    AxcActivityHUDIndicatorStyleBallPulseSync,           // 波浪三圆
    
    AxcActivityHUDIndicatorStyleBallBeat,                // 呼吸三圆
    AxcActivityHUDIndicatorStyleLineScalePulseOut,       // 竖条从中向两边扩展
    AxcActivityHUDIndicatorStyleScalePulseOutRapid,      // 竖条从中向两边扩展2
    AxcActivityHUDIndicatorStyleBallScaleRipple,         // 空心圆从小变大渐出
    AxcActivityHUDIndicatorStyleBallScaleRippleMultiple, // 多个空心圆从小变大渐出
    
    AxcActivityHUDIndicatorStyleTriangleSkewSpin,        // 三角翻转
    AxcActivityHUDIndicatorStyleBallGridBeat,            // 九个点随机透明
    AxcActivityHUDIndicatorStyleBallGridPulse,           // 九个点随机大小
    AxcActivityHUDIndicatorStyleRotatingSandglass,       // 双圆慢速画沙漏
    AxcActivityHUDIndicatorStyleRotatingTrigons,         // 逆时针三空心圆三角画圆
    
    AxcActivityHUDIndicatorStyleTripleRings,             // 慢速多个空心圆从小变大渐出
    AxcActivityHUDIndicatorStyleCookieTerminator,        // 吃豆人
    AxcActivityHUDIndicatorStyleBallSpinFadeLoader       // 环形圆loader
};

// 入场特效
typedef NS_ENUM(NSInteger, AxcActivityHUDAppearAnimationType) {
    AxcActivityHUDAppearAnimationTypeSlideFromTop,
    AxcActivityHUDAppearAnimationTypeSlideFromBottom,
    AxcActivityHUDAppearAnimationTypeSlideFromLeft,
    AxcActivityHUDAppearAnimationTypeSlideFromRight,
    AxcActivityHUDAppearAnimationTypeZoomIn,
    AxcActivityHUDAppearAnimationTypeFadeIn
};

// 出场特效
typedef NS_ENUM(NSInteger, AxcActivityHUDDisappearAnimationType) {
    AxcActivityHUDDisappearAnimationTypeSlideToTop,
    AxcActivityHUDDisappearAnimationTypeSlideToBottom,
    AxcActivityHUDDisappearAnimationTypeSlideToLeft,
    AxcActivityHUDDisappearAnimationTypeSlideToRight,
    AxcActivityHUDDisappearAnimationTypeZoomOut,
    AxcActivityHUDDisappearAnimationTypeFadeOut
};

// 其他特效
typedef NS_ENUM(NSInteger, AxcActivityHUDOverlayType) {
    AxcActivityHUDOverlayTypeNone,
    AxcActivityHUDOverlayTypeBlur,
    AxcActivityHUDOverlayTypeTransparent,
    AxcActivityHUDOverlayTypeShadow
};


/** 加载动画指示器 */
@interface AxcUI_ActivityHUD : UIView

#pragma mark - properties

/**
 *  Toast的线框颜色
 */
@property (strong, nonatomic) UIColor *axcUI_borderColor;

/**
 *  Toast边缘线宽，默认0
 */
@property (nonatomic,assign) CGFloat axcUI_borderWidth;
/**
 *  Toast的风格
 */
@property(nonatomic,assign) AxcActivityHUDOverlayType axcUI_overlayType;
/**
 *  Toast圆角值
 */
@property (nonatomic,assign) CGFloat axcUI_cornerRadius;

/**
 *  所有动画指示器的渲染颜色默认颜色：light grey.
 */
@property (strong, nonatomic) UIColor *axcUI_indicatorColor;

/**
 *  是否允许点击背景，默认YES
 */
@property (nonatomic,assign) BOOL axcUI_isTheOnlyActiveView;

/**
 *  入场动画风格
 */
@property(nonatomic,assign) AxcActivityHUDAppearAnimationType axcUI_appearAnimationType;

/**
 *  退场动画风格
 */
@property(nonatomic,assign) AxcActivityHUDDisappearAnimationType axcUI_disappearAnimationType;

/**
 *  动画指示控件
 */
@property(nonatomic, strong) AxcUI_ActivityIndicatorView *__nullable axcUI_activityIndicatorView;




#pragma mark - 触发方法
/**
 *  默认展示
 */
- (void)AxcUI_show;
/**
 *  根据风格展示
 */
- (void)AxcUI_showWithType:(AxcActivityHUDIndicatorStyle)type;
/**
 *  自定义动画展示
 */
- (void)AxcUI_showWithShape:(void (^)(CAShapeLayer *, CAReplicatorLayer *))shape
            animationGroup:(void (^)(CAAnimationGroup *))animation;
/**
 *  自定义GIF展示
 */
- (void)AxcUI_showWithGIFName:(NSString *)GIFName;
/**
 *  根据文字展示
 */
- (void)AxcUI_showWithText:(NSString *)text shimmering:(BOOL)shimmering;
/**
 *  刷新展示文字
 */
- (void)AxcUI_updateText:(NSString *)text shimmering:(BOOL)shimmering;
/**
 *  移除时展示的文字、动画时间、成功与否
 */
- (void)AxcUI_dismissWithText:(NSString * __nullable )text delay:(CGFloat)delay success:(BOOL)success;
/**
 *  移除时展示的文字、动画时间、成功与否，附带回调
 *
 */
- (void)AxcUI_dismissWithText:(NSString * __nullable )text delay:(CGFloat)delay success:(BOOL)success completion:(void (^ __nullable)(BOOL finished))completion;
/**
 *  默认移除方式
 */
- (void)AxcUI_dismiss;
/**
 *  对错移除方式
 */
- (void)AxcUI_dismissWithSuccess:(BOOL)success;

@end


/**
 *  宏指针定义下文
 */
NS_ASSUME_NONNULL_END
