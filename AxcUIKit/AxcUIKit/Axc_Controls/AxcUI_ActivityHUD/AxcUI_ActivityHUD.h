
#import <UIKit/UIKit.h>

#import "AxcUI_ActivityIndicatorView.h"


// 动画指示器效果
typedef NS_ENUM(NSInteger, AxcUIActivityHUDIndicatorType) {
    AxcUIActivityHUDIndicatorTypeScalingDots,                 // 环形圆loader
    AxcUIActivityHUDIndicatorTypeLeadingDots,                 // 环形圆loader
    AxcUIActivityHUDIndicatorTypeMinorArc,                    // 双圆弧旋转
    AxcUIActivityHUDIndicatorTypeDynamicArc,                  // 单圆弧长度递增递减旋转
    AxcUIActivityHUDIndicatorTypeArcInCircle,                 // 单圆弧固长旋转
    
    AxcUIActivityHUDIndicatorTypeSpringBall,                  // 上下大小弹球
    AxcUIActivityHUDIndicatorTypeScalingBars,                 // 粗竖条从左到右依次变长
    AxcUIActivityHUDIndicatorTypeTriangleCircle,              // 三实心球顺时针三角旋转
    // 从此扩展
    AxcUIActivityHUDIndicatorTypeTypeNineDots,                // 九个点
    AxcUIActivityHUDIndicatorTypeTypeTriplePulse,             // 频繁水波
    AxcUIActivityHUDIndicatorTypeTypeFiveDots,                // 奥运五环上上下下
    AxcUIActivityHUDIndicatorTypeTypeRotatingSquares,         // 旋转方块
    AxcUIActivityHUDIndicatorTypeTypeDoubleBounce,            // 同心大小水波圆
    
    AxcUIActivityHUDIndicatorTypeTypeTwoDots,                 // 左右大小圆
    AxcUIActivityHUDIndicatorTypeTypeThreeDots,               // 三个点同时渐入渐出
    AxcUIActivityHUDIndicatorTypeTypeBallPulse,               // 三个点从左到右依次大小
    AxcUIActivityHUDIndicatorTypeTypeBallClipRotate,          // 缺口圆转圈大小
    AxcUIActivityHUDIndicatorTypeTypeBallClipRotatePulse,     // 中心实心圆大小，外圆双圆弧转
    
    AxcUIActivityHUDIndicatorTypeTypeBallClipRotateMultiple,  // 中心空心圆大小，外圆双圆弧转
    AxcUIActivityHUDIndicatorTypeTypeBallRotate,              // 类似百度加载
    AxcUIActivityHUDIndicatorTypeTypeBallZigZag,              // 双圆画沙漏
    AxcUIActivityHUDIndicatorTypeTypeBallZigZagDeflect,       // 双圆画三角
    AxcUIActivityHUDIndicatorTypeTypeBallTrianglePath,        // 顺时针三空心圆三角画圆
    
    AxcUIActivityHUDIndicatorTypeTypeBallScale,               // 单圆从小到大
    AxcUIActivityHUDIndicatorTypeTypeLineScale,               // 竖条从左到右依次变长
    AxcUIActivityHUDIndicatorTypeTypeLineScaleParty,          // 竖条随机长短
    AxcUIActivityHUDIndicatorTypeTypeBallScaleMultiple,       // 三圆呼吸
    AxcUIActivityHUDIndicatorTypeTypeBallPulseSync,           // 波浪三圆
    
    AxcUIActivityHUDIndicatorTypeTypeBallBeat,                // 呼吸三圆
    AxcUIActivityHUDIndicatorTypeTypeLineScalePulseOut,       // 竖条从中向两边扩展
    AxcUIActivityHUDIndicatorTypeTypeScalePulseOutRapid,      // 竖条从中向两边扩展2
    AxcUIActivityHUDIndicatorTypeTypeBallScaleRipple,         // 空心圆从小变大渐出
    AxcUIActivityHUDIndicatorTypeTypeBallScaleRippleMultiple, // 多个空心圆从小变大渐出
    
    AxcUIActivityHUDIndicatorTypeTypeTriangleSkewSpin,        // 三角翻转
    AxcUIActivityHUDIndicatorTypeTypeBallGridBeat,            // 九个点随机透明
    AxcUIActivityHUDIndicatorTypeTypeBallGridPulse,           // 九个点随机大小
    AxcUIActivityHUDIndicatorTypeTypeRotatingSandglass,       // 双圆慢速画沙漏
    AxcUIActivityHUDIndicatorTypeTypeRotatingTrigons,         // 逆时针三空心圆三角画圆
    
    AxcUIActivityHUDIndicatorTypeTypeTripleRings,             // 慢速多个空心圆从小变大渐出
    AxcUIActivityHUDIndicatorTypeTypeCookieTerminator,        // 吃豆人
    AxcUIActivityHUDIndicatorTypeTypeBallSpinFadeLoader       // 环形圆loader
};

typedef NS_ENUM(NSInteger, AxcActivityHUDaxcUI_appearAnimationType) {
    AxcActivityHUDaxcUI_appearAnimationTypeSlideFromTop,
    AxcActivityHUDaxcUI_appearAnimationTypeSlideFromBottom,
    AxcActivityHUDaxcUI_appearAnimationTypeSlideFromLeft,
    AxcActivityHUDaxcUI_appearAnimationTypeSlideFromRight,
    AxcActivityHUDaxcUI_appearAnimationTypeZoomIn,
    AxcActivityHUDaxcUI_appearAnimationTypeFadeIn
};

typedef NS_ENUM(NSInteger, AxcActivityHUDaxcUI_disappearAnimationType) {
    AxcActivityHUDaxcUI_disappearAnimationTypeSlideToTop,
    AxcActivityHUDaxcUI_disappearAnimationTypeSlideToBottom,
    AxcActivityHUDaxcUI_disappearAnimationTypeSlideToLeft,
    AxcActivityHUDaxcUI_disappearAnimationTypeSlideToRight,
    AxcActivityHUDaxcUI_disappearAnimationTypeZoomOut,
    AxcActivityHUDaxcUI_disappearAnimationTypeFadeOut
};

typedef NS_ENUM(NSInteger, AxcActivityHUDOverlayType) {
    AxcActivityHUDOverlayTypeNone,
    AxcActivityHUDOverlayTypeBlur,
    AxcActivityHUDOverlayTypeTransparent,
    AxcActivityHUDOverlayTypeShadow
};


@interface AxcUI_ActivityHUD : UIView

#pragma mark - properties

/**
 *  Toast的线框颜色
 */
@property (strong, nonatomic) UIColor *axcUI_borderColor;

/**
 *  Toast边缘线宽，默认0
 */
@property (nonatomic) CGFloat axcUI_borderWidth;
/**
 *  Toast的风格
 */
@property AxcActivityHUDOverlayType axcUI_overlayType;
/**
 *  Toast圆角值
 */
@property (nonatomic) CGFloat axcUI_cornerRadius;

/**
 *  所有动画指示器的渲染颜色默认颜色：light grey.
 */
@property (strong, nonatomic) UIColor *axcUI_indicatorColor;

/**
 *  是否允许点击背景，默认YES
 */
@property (nonatomic) BOOL axcUI_isTheOnlyActiveView;

/**
 *  入场动画风格
 */
@property AxcActivityHUDaxcUI_appearAnimationType axcUI_appearAnimationType;

/**
 *  退场动画风格
 */
@property AxcActivityHUDaxcUI_disappearAnimationType axcUI_disappearAnimationType;

/**
 *  动画指示控件
 */
@property(nonatomic, strong) AxcUI_ActivityIndicatorView *axcUI_activityIndicatorView;




#pragma mark - 触发方法
/**
 *  默认展示
 */
- (void)AxcUI_show;
/**
 *  根据风格展示
 */
- (void)AxcUI_showWithType:(AxcUIActivityHUDIndicatorType)type;
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
- (void)AxcUI_dismissWithText:(NSString *)text delay:(CGFloat)delay success:(BOOL)success;
/**
 *  移除时展示的文字、动画时间、成功与否，附带回调
 *
 */
- (void)AxcUI_dismissWithText:(NSString *)text delay:(CGFloat)delay success:(BOOL)success completion:(void (^ __nullable)(BOOL finished))completion;
/**
 *  默认移除方式
 */
- (void)AxcUI_dismiss;
/**
 *  对错移除方式
 */
- (void)AxcUI_dismissWithSuccess:(BOOL)success;

@end
