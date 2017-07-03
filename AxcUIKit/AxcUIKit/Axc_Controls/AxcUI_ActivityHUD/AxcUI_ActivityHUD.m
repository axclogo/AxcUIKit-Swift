
#import "AxcUI_ActivityHUD.h"

#import "UIColor+AxcColor.h"
#import "UIImage+AxcLoadGIF.h"
#import "UILabel+AxcShimmering.h"




#define DURATION_BASE 0.7
#define TEXT_WIDTH BoundsWidthFor(Screen)/2.8
#define TEXT_FONT_SIZE 14


// 防止宏定义在h文件被其他文件引用干扰，选择在m文件中
#define Screen                    [UIScreen mainScreen]
// 常见 marco
#define FrameFor(view)            (view).frame
#define FrameSizeFor(view)        (view).frame.size
#define FrameWidthFor(view)       (view).frame.size.width
#define FrameHeightFor(view)      (view).frame.size.height
#define FrameOriginFor(view)      (view).frame.origin
#define FrameOriginX(view)        (view).frame.origin.x
#define FrameOriginY(view)        (view).frame.origin.y
#define FrameCenterFor(view)      (view).center
#define FrameCenterXFor(view)     (view).center.x
#define FrameCenterYFor(view)     (view).center.y
#define BoundsFor(view)           (view).bounds
#define BoundsSizeFor(view)       (view).bounds.size
#define BoundsWidthFor(view)      (view).bounds.size.width
#define BoundsHeightFor(view)     (view).bounds.size.height
#define BoundsOriginFor(view)     (view).bounds.origin
#define BoundsOriginXFor(view)    (view).bounds.origin.x
#define BoundsOriginYFor(view)    (view).bounds.origin.y
#define BoundsCenterXFor(view)    BoundsWidthFor(view)/2
#define BoundsCenterYFor(view)    BoundsHeightFor(view)/2
#define BoundsCenterFor(view)     CGPointMake(BoundsCenterXFor(view), BoundsCenterYFor(view))
// Convenient marco
#define ViewFrame                 FrameFor(self)
#define ViewFrameSize             FrameSizeFor(self)
#define ViewFrameWidth            FrameWidthFor(self)
#define ViewFrameHeight           FrameHeightFor(self)
#define ViewFrameOrigin           FrameOriginFor(self)
#define ViewFrameX                FrameOriginX(self)
#define ViewFrameY                FrameOriginY(self)
#define ViewFrameCenter           FrameCenterFor(self)
#define ViewFrameCenterX          FrameCenterXFor(self)
#define ViewFrameCenterY          FrameCenterYFor(self)
#define ViewBounds                BoundsFor(self)
#define ViewBoundsSize            BoundsSizeFor(self)
#define ViewBoundsWidth           BoundsWidthFor(self)
#define ViewBoundsHeight          BoundsHeightFor(self)
#define ViewBoundsOrigin          BoundsOriginFor(self)
#define ViewBoundsX               BoundsOriginXFor(self)
#define ViewBoundsY               BoundsOriginYFor(self)
#define ViewBoundsCenterX         BoundsWidthFor(self)/2
#define ViewBoundsCenterY         BoundsHeightFor(self)/2
#define ViewBoundsCenter          CGPointMake(BoundsCenterXFor(self), BoundsCenterYFor(self))

#define DefaultEnum 8

@interface AxcUI_ActivityHUD ()

// mask 覆盖View
@property (strong, nonatomic) UIView *overlay;
// Layer图层
@property (strong, nonatomic) CAReplicatorLayer *replicatorLayer;
@property (strong, nonatomic) CAShapeLayer *indicatorCAShapeLayer;
// 添加的自定义图片ImageView
@property (strong, nonatomic) UIImageView *imageView;

// 当前风格的设置
@property AxcActivityHUDIndicatorStyle currentTpye;

// 开启指标
@property BOOL useProvidedIndicator;


@end

@implementation AxcUI_ActivityHUD

- (instancetype)init {
    self = [super init];
    
    if (self) {
        self.frame = [self originalFrame];
        self.alpha = 0.7;
        self.backgroundColor = [UIColor blackColor];
        self.layer.cornerRadius = 5.0;
        self.axcUI_isTheOnlyActiveView = YES;
        self.axcUI_indicatorColor = [UIColor whiteColor];
        self.axcUI_appearAnimationType = AxcActivityHUDAppearAnimationTypeFadeIn;
        self.axcUI_disappearAnimationType = AxcActivityHUDDisappearAnimationTypeFadeOut;
        self.overlay = AxcActivityHUDOverlayTypeNone;
        [self addNotificationObserver];
    }
    return self;
}












#pragma mark - 预设动画区
- (void)initializeIndicatoeLayerWithType:(AxcActivityHUDIndicatorStyle)type {
    switch (type) {
        case AxcActivityHUDIndicatorStyleScalingDots:[self initializeScalingDots];break;
        case AxcActivityHUDIndicatorStyleLeadingDots:[self initializeLeadingDots];break;
        case AxcActivityHUDIndicatorStyleMinorArc:[self initializeMinorArc];break;
        case AxcActivityHUDIndicatorStyleDynamicArc:[self initializeDynamicArc];break;
        case AxcActivityHUDIndicatorStyleArcInCircle:[self initializeArcInCircle];break;
        case AxcActivityHUDIndicatorStyleSpringBall:[self initializeSpringBall];break;
            
        case AxcActivityHUDIndicatorStyleScalingBars:[self initializeScalingBars];break;
        case AxcActivityHUDIndicatorStyleTriangleCircle:[self initializeTriangleCircle];break;
            // 扩展
        case  AxcActivityHUDIndicatorStyleNineDots:
            [self activityType:AxcActivityHUDIndicatorStyleNineDots - DefaultEnum];break;                // 九个点
        case  AxcActivityHUDIndicatorStyleTriplePulse:
            [self activityType:AxcActivityHUDIndicatorStyleTriplePulse - DefaultEnum];break;             // 频繁水波
        case  AxcActivityHUDIndicatorStyleFiveDots:
            [self activityType:AxcActivityHUDIndicatorStyleFiveDots - DefaultEnum];break;                // 奥运五环上上下下
        case  AxcActivityHUDIndicatorStyleRotatingSquares:
            [self activityType:AxcActivityHUDIndicatorStyleRotatingSquares - DefaultEnum];break;         // 旋转方块
        case  AxcActivityHUDIndicatorStyleDoubleBounce:
           [self activityType:AxcActivityHUDIndicatorStyleDoubleBounce - DefaultEnum];break;             // 同心大小水波圆
            
        case AxcActivityHUDIndicatorStyleTwoDots:
            [self activityType:AxcActivityHUDIndicatorStyleTwoDots - DefaultEnum];break;                 // 左右大小圆
        case AxcActivityHUDIndicatorStyleThreeDots:
            [self activityType:AxcActivityHUDIndicatorStyleThreeDots - DefaultEnum];break;               // 三个点同时渐入渐出
        case AxcActivityHUDIndicatorStyleBallPulse:
            [self activityType:AxcActivityHUDIndicatorStyleBallPulse - DefaultEnum];break;               // 三个点从左到右依次大小
        case AxcActivityHUDIndicatorStyleBallClipRotate:
            [self activityType:AxcActivityHUDIndicatorStyleBallClipRotate - DefaultEnum];break;          // 缺口圆转圈大小
        case AxcActivityHUDIndicatorStyleBallClipRotatePulse:
            [self activityType:AxcActivityHUDIndicatorStyleBallClipRotatePulse - DefaultEnum];break;     // 中心实心圆大小，外圆双圆弧转
            
        case AxcActivityHUDIndicatorStyleBallClipRotateMultiple:
            [self activityType:AxcActivityHUDIndicatorStyleBallClipRotateMultiple - DefaultEnum];break;  // 中心空心圆大小，外圆双圆弧转
        case AxcActivityHUDIndicatorStyleBallRotate:
            [self activityType:AxcActivityHUDIndicatorStyleBallRotate - DefaultEnum];break;              // 类似百度加载
        case AxcActivityHUDIndicatorStyleBallZigZag:
            [self activityType:AxcActivityHUDIndicatorStyleBallZigZag - DefaultEnum];break;              // 双圆画沙漏
        case AxcActivityHUDIndicatorStyleBallZigZagDeflect:
            [self activityType:AxcActivityHUDIndicatorStyleBallZigZagDeflect - DefaultEnum];break;       // 双圆画三角
        case AxcActivityHUDIndicatorStyleBallTrianglePath:
            [self activityType:AxcActivityHUDIndicatorStyleBallTrianglePath - DefaultEnum];break;        // 顺时针三空心圆三角画圆
            
        case AxcActivityHUDIndicatorStyleBallScale:
            [self activityType:AxcActivityHUDIndicatorStyleBallScale - DefaultEnum];break;               // 单圆从小到大
        case AxcActivityHUDIndicatorStyleLineScale:
            [self activityType:AxcActivityHUDIndicatorStyleLineScale - DefaultEnum];break;               // 竖条从左到右依次变长
        case AxcActivityHUDIndicatorStyleLineScaleParty:
            [self activityType:AxcActivityHUDIndicatorStyleLineScaleParty - DefaultEnum];break;          // 竖条随机长短
        case AxcActivityHUDIndicatorStyleBallScaleMultiple:
            [self activityType:AxcActivityHUDIndicatorStyleBallScaleMultiple - DefaultEnum];break;       // 三圆呼吸
        case AxcActivityHUDIndicatorStyleBallPulseSync:
            [self activityType:AxcActivityHUDIndicatorStyleBallPulseSync - DefaultEnum];break;           // 波浪三圆
            
        case AxcActivityHUDIndicatorStyleBallBeat:
            [self activityType:AxcActivityHUDIndicatorStyleBallBeat - DefaultEnum];break;                // 呼吸三圆
        case AxcActivityHUDIndicatorStyleLineScalePulseOut:
            [self activityType:AxcActivityHUDIndicatorStyleLineScalePulseOut - DefaultEnum];break;       // 竖条从中向两边扩展
        case AxcActivityHUDIndicatorStyleScalePulseOutRapid:
            [self activityType:AxcActivityHUDIndicatorStyleScalePulseOutRapid - DefaultEnum];break;      // 竖条从中向两边扩展2
        case AxcActivityHUDIndicatorStyleBallScaleRipple:
            [self activityType:AxcActivityHUDIndicatorStyleBallScaleRipple - DefaultEnum];break;         // 空心圆从小变大渐出
        case AxcActivityHUDIndicatorStyleBallScaleRippleMultiple:
            [self activityType:AxcActivityHUDIndicatorStyleBallScaleRippleMultiple - DefaultEnum];break; // 多个空心圆从小变大渐出
            
        case AxcActivityHUDIndicatorStyleTriangleSkewSpin:
            [self activityType:AxcActivityHUDIndicatorStyleTriangleSkewSpin - DefaultEnum];break;        // 三角翻转
        case AxcActivityHUDIndicatorStyleBallGridBeat:
            [self activityType:AxcActivityHUDIndicatorStyleBallGridBeat - DefaultEnum];break;            // 九个点随机透明
        case AxcActivityHUDIndicatorStyleBallGridPulse:
            [self activityType:AxcActivityHUDIndicatorStyleBallGridPulse - DefaultEnum];break;           // 九个点随机大小
        case AxcActivityHUDIndicatorStyleRotatingSandglass:
            [self activityType:AxcActivityHUDIndicatorStyleRotatingSandglass - DefaultEnum];break;       // 双圆慢速画沙漏
        case AxcActivityHUDIndicatorStyleRotatingTrigons:
            [self activityType:AxcActivityHUDIndicatorStyleRotatingTrigons - DefaultEnum];break;         // 逆时针三空心圆三角画圆
            
        case AxcActivityHUDIndicatorStyleTripleRings:
            [self activityType:AxcActivityHUDIndicatorStyleTripleRings - DefaultEnum];break;             // 慢速多个空心圆从小变大渐出
        case AxcActivityHUDIndicatorStyleCookieTerminator:
            [self activityType:AxcActivityHUDIndicatorStyleCookieTerminator - DefaultEnum];break;        // 吃豆人
        case AxcActivityHUDIndicatorStyleBallSpinFadeLoader:
            [self activityType:AxcActivityHUDIndicatorStyleBallSpinFadeLoader - DefaultEnum];break;      // 环形圆loader
      
    }
}
////////////////////////////
- (void)activityType:(AxcActivityIndicatorAnimationStyle)type{
    self.axcUI_activityIndicatorView = [[AxcUI_ActivityIndicatorView alloc]
                                        initWithType:(AxcActivityIndicatorAnimationStyle)type
                                        tintColor:[UIColor whiteColor]];
    CGFloat width = self.bounds.size.width ;
    CGFloat height = self.bounds.size.height ;
    
    self.axcUI_activityIndicatorView.frame = CGRectMake(0, 0, width, height);
    [self addSubview:self.axcUI_activityIndicatorView];
    [self.axcUI_activityIndicatorView AxcUI_startAnimating];
}

- (void)initializeScalingDots {
    CGFloat length = ViewFrameWidth*18/200;
    
    self.indicatorCAShapeLayer = [[CAShapeLayer alloc] init];
    self.indicatorCAShapeLayer.backgroundColor = self.axcUI_indicatorColor.CGColor;
    self.indicatorCAShapeLayer.frame = CGRectMake(0, 0, length, length);
    self.indicatorCAShapeLayer.position = CGPointMake(ViewFrameWidth/2, ViewFrameHeight/5);
    self.indicatorCAShapeLayer.cornerRadius = length/2;
    self.indicatorCAShapeLayer.transform = CATransform3DMakeScale(0.01, 0.01, 0.01);
    
    self.replicatorLayer.instanceCount = 15;
    self.replicatorLayer.instanceDelay = DURATION_BASE*1.2/self.replicatorLayer.instanceCount;
    CGFloat angle = 2*M_PI/self.replicatorLayer.instanceCount;
    self.replicatorLayer.instanceTransform = CATransform3DMakeRotation(angle, 0.0, 0.0, 0.1);
    [self.replicatorLayer addSublayer:self.indicatorCAShapeLayer];
    
}

- (void)initializeLeadingDots {
    CGFloat length = ViewFrameWidth*25/200;
    self.indicatorCAShapeLayer = [[CAShapeLayer alloc] init];
    self.indicatorCAShapeLayer.backgroundColor = self.axcUI_indicatorColor.CGColor;
    self.indicatorCAShapeLayer.frame = CGRectMake(0, 0, length, length);
    self.indicatorCAShapeLayer.position = CGPointMake(ViewFrameWidth/2, ViewFrameHeight/5);
    self.indicatorCAShapeLayer.cornerRadius = length/2;
    self.indicatorCAShapeLayer.shouldRasterize = YES;
    self.indicatorCAShapeLayer.rasterizationScale = Screen.scale;
    
    self.replicatorLayer.instanceCount = 5;
    self.replicatorLayer.instanceDelay = 0.1;
    
    [self.replicatorLayer addSublayer:self.indicatorCAShapeLayer];
}

- (void)initializeMinorArc {
    self.indicatorCAShapeLayer = [[CAShapeLayer alloc] init];
    self.indicatorCAShapeLayer.strokeColor = self.axcUI_indicatorColor.CGColor;
    self.indicatorCAShapeLayer.fillColor = [UIColor clearColor].CGColor;
    self.indicatorCAShapeLayer.lineWidth = ViewFrameWidth/24;
    
    CGFloat length = ViewFrameWidth/5;
    self.indicatorCAShapeLayer.frame = CGRectMake(length, length, length*3, length*3);
    [self.replicatorLayer addSublayer:self.indicatorCAShapeLayer];
}

- (void)initializeDynamicArc {
    // 使用相同的同一indicatorCAShapeLayer
    [self initializeMinorArc];
}

- (void)initializeArcInCircle {
    // 使用相同的同一indicatorCAShapeLayer
    [self initializeMinorArc];
}

- (void)initializeSpringBall {
    CGFloat length = ViewFrameWidth*38/200;
    
    self.indicatorCAShapeLayer = [[CAShapeLayer alloc] init];
    self.indicatorCAShapeLayer.backgroundColor = self.axcUI_indicatorColor.CGColor;
    self.indicatorCAShapeLayer.frame = CGRectMake(0, 0, length, length);
    self.indicatorCAShapeLayer.position = CGPointMake(ViewFrameWidth/2, ViewFrameHeight/5);
    self.indicatorCAShapeLayer.cornerRadius = length/2;
}

- (void)initializeScalingBars {
    self.replicatorLayer.instanceCount = 5;
    
    self.indicatorCAShapeLayer = [[CAShapeLayer alloc] init];
    self.indicatorCAShapeLayer.backgroundColor = self.axcUI_indicatorColor.CGColor;
    CGFloat padding = 10;
    self.indicatorCAShapeLayer.frame = CGRectMake(padding, ViewFrameHeight/4,(ViewFrameWidth-padding*2)*2/3/self.replicatorLayer.instanceCount, ViewFrameHeight/2);
    self.indicatorCAShapeLayer.cornerRadius = FrameWidthFor(self.indicatorCAShapeLayer)/2;
    
    CGFloat distance = (ViewFrameWidth-padding*2)/3/(self.replicatorLayer.instanceCount-1)+FrameWidthFor(self.indicatorCAShapeLayer);
    self.replicatorLayer.instanceTransform = CATransform3DMakeTranslation(distance, 0.0, 0.0);
}

- (void)initializeTriangleCircle {
    CGFloat length = ViewFrameWidth*25/200;
    
    self.indicatorCAShapeLayer = [[CAShapeLayer alloc] init];
    self.indicatorCAShapeLayer.backgroundColor = self.axcUI_indicatorColor.CGColor;
    self.indicatorCAShapeLayer.frame = CGRectMake(0, 0, length, length);
    self.indicatorCAShapeLayer.position = CGPointMake(ViewFrameWidth/2, ViewFrameHeight/5);
    self.indicatorCAShapeLayer.cornerRadius = length/2;
    self.indicatorCAShapeLayer.shouldRasterize = YES;
    self.indicatorCAShapeLayer.rasterizationScale = Screen.scale;
}
#pragma mark - 公开的SHOW方法重载
//MARK: 默认展示
- (void)AxcUI_show {
    [self AxcUI_showWithType:AxcActivityHUDIndicatorStyleScalingDots];
}
//MARK: 根据风格展示
- (void)AxcUI_showWithType:(AxcActivityHUDIndicatorStyle)type {
    if (!self.superview) {
        [self initializeReplicatorLayer];
        [self initializeIndicatoeLayerWithType:type];
        self.currentTpye = type;
        self.useProvidedIndicator = YES;
        [self communalShowTask];
    }
}
//MARK: 自行设定动画展示
- (void)AxcUI_showWithShape:(void (^)(CAShapeLayer *, CAReplicatorLayer *))shape animationGroup:(void (^)(CAAnimationGroup *))animation {
    if (!self.superview) {
        [self initializeReplicatorLayer];
        self.indicatorCAShapeLayer = [[CAShapeLayer alloc] init];
        self.currentTpye = -1;
        self.useProvidedIndicator = NO;
        if (shape != nil) {
            shape(self.indicatorCAShapeLayer, self.replicatorLayer);
        }
        [self.replicatorLayer addSublayer:self.indicatorCAShapeLayer];
        [self communalShowTask];
        CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc] init];
        if (animation != nil) {
            animation(animationGroup);
        }
        [self.indicatorCAShapeLayer addAnimation:animationGroup forKey:@"customAnimationGroup"];
    }
}
//MARK: 根据GIF图展示
- (void)AxcUI_showWithGIFName:(NSString *)GIFName {
    if (!self.superview) { // 如果没有展示，也就是父视图中没有HUD则执行
        CGFloat length = ViewFrameWidth/5;
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(length, length, length*3, length*3) ];
        self.imageView.layer.cornerRadius = self.self.axcUI_cornerRadius;
        UIImage *gif = [UIImage animatedImageWithAnimatedGIFURL:[[NSBundle mainBundle] URLForResource:GIFName withExtension:nil]];
        self.imageView.image = gif;
        [self addSubview:self.imageView];
        self.useProvidedIndicator = NO;
        [self communalShowTask];
    }
}
//MARK: 根据文字展示，是否开启滑闪效果
- (void)AxcUI_showWithText:(NSString *)text shimmering:(BOOL)shimmering{
    if (!self.superview) {
        CGFloat height = [self heightForText:text]+8;
        self.frame = CGRectMake(0, -height, TEXT_WIDTH, height);
        UILabel *textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        textLabel.numberOfLines = 0;
        textLabel.font = [UIFont systemFontOfSize:TEXT_FONT_SIZE];
        textLabel.textColor = [UIColor AxcUI_InverseColorFor:self.backgroundColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.text = text;
        [self addSubview:textLabel];
        if (shimmering) {
            [textLabel AxcUI_shimmeringEffectStart];
        }
        self.useProvidedIndicator = NO;
        [self communalShowTask];
    }
}
//MARK: 刷新展示文字
- (void)AxcUI_updateText:(NSString *)text shimmering:(BOOL)shimmering {
    if (self.superview) {
        [self removeAllSubviews];
        self.frame = CGRectMake(0, 0, TEXT_WIDTH, [self heightForText:text]+8);
        self.center = BoundsCenterFor(Screen);
        UILabel *textLabel = [[UILabel alloc] initWithFrame:self.bounds];
        textLabel.numberOfLines = 0;
        textLabel.font = [UIFont systemFontOfSize:TEXT_FONT_SIZE];
        textLabel.textColor = [UIColor AxcUI_InverseColorFor:self.backgroundColor];
        textLabel.textAlignment = NSTextAlignmentCenter;
        textLabel.text = text;
        [self addSubview:textLabel];
        if (shimmering) {
            [textLabel AxcUI_shimmeringEffectStart];
        }
        [UIView transitionWithView:self duration:0.3 options:UIViewAnimationOptionTransitionFlipFromLeft animations:nil completion:nil];
    }
}


#pragma mark - 公开的DISMISS方法重载
//MARK: 移除展示文字
- (void)AxcUI_dismissWithText:(NSString *)text delay:(CGFloat)delay
                      success:(BOOL)success
                   completion:(void (^)(BOOL))completion{
    if (self.axcUI_activityIndicatorView) { // 清空动画效果
        [self.axcUI_activityIndicatorView AxcUI_stopAnimating];
        [self.axcUI_activityIndicatorView removeFromSuperview];
        self.axcUI_activityIndicatorView = nil;
    }
    if (self.superview) {
        [self removeAllSubviews];
        // 移除 GIF
        if (self.replicatorLayer != nil) {
            [self.replicatorLayer removeFromSuperlayer];
        }
        if (self.imageView != nil) {
            [self.imageView removeFromSuperview];
        }
        [UIView animateWithDuration:0.3 animations:^{
            self.frame = [self originalFrame];
            self.center = BoundsCenterFor(Screen);
        }];
        __block CGFloat length = BoundsWidthFor(Screen)/10;
        UIImageView *tickCrossImageView = [[UIImageView alloc] initWithFrame:CGRectMake(ViewFrameWidth/2-length/2, length/3, length, length)];
        tickCrossImageView.image = [UIImage imageNamed:success?@"AxcUI_ActivityHUD_successful":@"AxcUI_ActivityHUD_cross"];
        tickCrossImageView.image = [tickCrossImageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        tickCrossImageView.tintColor = [UIColor AxcUI_InverseColorFor:self.backgroundColor];
        [self addSubview:tickCrossImageView];
        [UIView transitionWithView:self duration:0.3 options:UIViewAnimationOptionTransitionFlipFromTop animations:nil completion:nil];
        if (text != nil || text.length != 0 ) {
            // 翻转动画，翻转中替换展示元素
            [UIView animateWithDuration:0.5 animations:^{
                self.frame = CGRectMake(0, 0, TEXT_WIDTH, FrameOriginY(tickCrossImageView)+FrameHeightFor(tickCrossImageView)+8+[self heightForText:text]+4);
                self.center = BoundsCenterFor(Screen);
                tickCrossImageView.frame = CGRectMake(ViewFrameWidth/2-length/2, length/3, length, length);
                
                UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, FrameOriginY(tickCrossImageView)+FrameHeightFor(tickCrossImageView)+8, ViewFrameWidth, [self heightForText:text])];
                textLabel.numberOfLines = 0;
                textLabel.font = [UIFont systemFontOfSize:TEXT_FONT_SIZE];
                textLabel.textColor = [UIColor AxcUI_InverseColorFor:self.backgroundColor];
                textLabel.textAlignment = NSTextAlignmentCenter;
                textLabel.text = text;
                [self addSubview:textLabel];
            }completion:^(BOOL finished) {
                if (completion) {
                    completion(finished);
                }
            }];
        }
        [self addDisappearAnimationWithDelay:delay+0.7];
        if (self.axcUI_isTheOnlyActiveView) {
            for (UIView *view in self.superview.subviews) {
                view.userInteractionEnabled = YES;
            }
        }
    }
}
- (void)AxcUI_dismissWithText:(NSString *)text delay:(CGFloat)delay success:(BOOL)success{
    [self AxcUI_dismissWithText:text delay:delay success:success completion:nil];
}
- (void)AxcUI_dismissWithSuccess:(BOOL)success{
    [self AxcUI_dismissWithText:nil delay:0 success:success completion:nil];
}
//MARK: 移除
- (void)AxcUI_dismiss {
    [self AxcUI_dismissWithText:nil delay:0 success:YES completion:nil];
}


#pragma mark - 设置背景黑色的ToastView属性
- (void)addOverlay {
    switch (self.axcUI_overlayType) {
        case AxcActivityHUDOverlayTypeNone:
            // 不存在的
            [self removeShadowOverlay];
            break;
        
        case AxcActivityHUDOverlayTypeBlur:
            [self addBlurOverlay];
            [self removeShadowOverlay];
            break;
            
        case AxcActivityHUDOverlayTypeTransparent:
            [self addTransparentOverlay];
            [self removeShadowOverlay];
            break;
            
        case AxcActivityHUDOverlayTypeShadow:
            [self addShadowOverlay];
            break;
    }
}

- (void)addBlurOverlay {
    UIBlurEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *overlayView = [[UIVisualEffectView alloc] initWithFrame:BoundsFor(Screen)];
    overlayView.effect = blurEffect;
    self.overlay = overlayView;
                              
    [[[UIApplication sharedApplication].windows lastObject] addSubview:self.overlay];
}

- (void)addTransparentOverlay {
    self.overlay = [[UIView alloc] initWithFrame:BoundsFor(Screen)];
    self.overlay.backgroundColor = [UIColor blackColor];
    self.overlay.alpha = self.alpha-.2>0?self.alpha-.2:0.15;
    [[[UIApplication sharedApplication].windows lastObject] addSubview:self.overlay];
}

- (void)addShadowOverlay {
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(2.0, 2.0);
    self.layer.shadowOpacity = 0.5;
}

- (void)removeShadowOverlay{
    self.layer.shadowColor = [UIColor clearColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(0, 0);
    self.layer.shadowOpacity = 0;
}

#pragma mark - 根据动画类型来选择加载 animation
- (void)addAnimation {
    [self.indicatorCAShapeLayer removeAllAnimations];
    switch (self.currentTpye) {
        case AxcActivityHUDIndicatorStyleScalingDots:
            [self addScalingDotsAnimation];
            break;
            
        case AxcActivityHUDIndicatorStyleLeadingDots:
            [self addLeadingDotsAnimation];
            break;
            
        case AxcActivityHUDIndicatorStyleMinorArc:
            [self addMinorArcAnimation];
            break;
            
        case AxcActivityHUDIndicatorStyleDynamicArc:
            [self addDynamicArcAnimation];
            break;
            
        case AxcActivityHUDIndicatorStyleArcInCircle:
            [self addArcInCircleAnimation];
            break;
            
        case AxcActivityHUDIndicatorStyleSpringBall:
            [self addSpringBallAnimation];
            break;
            
        case AxcActivityHUDIndicatorStyleScalingBars:
            [self addScalingBarsAnimation];
            break;
            
        case AxcActivityHUDIndicatorStyleTriangleCircle:
            [self addTriangleCircleAnimation];
            break;
        default:break;
    }
}

- (void)addScalingDotsAnimation {
    [self.indicatorCAShapeLayer addAnimation:[self scaleAnimationFrom:1.0 to:0.1 duration:DURATION_BASE*1.2 repeatTime:INFINITY] forKey:nil];
}

- (void)addLeadingDotsAnimation {
    CGFloat radius = FrameWidthFor(self.replicatorLayer)/2 - FrameWidthFor(self.replicatorLayer)/5;
    CGFloat x = CGRectGetMidX(self.replicatorLayer.frame);
    CGFloat y = CGRectGetMidY(self.replicatorLayer.frame);
    CGFloat startAngle = -M_PI/2;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath addArcWithCenter:CGPointMake(x, y) radius:radius startAngle:startAngle endAngle:startAngle+M_PI*2 clockwise:YES];
    
    CAKeyframeAnimation *leadingAnimation = [[CAKeyframeAnimation alloc] init];
    leadingAnimation.keyPath = @"position";
    leadingAnimation.path = bezierPath.CGPath;
    leadingAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    leadingAnimation.duration = DURATION_BASE+self.replicatorLayer.instanceCount*self.replicatorLayer.instanceDelay;
    
    CABasicAnimation *scaleDownAnimation = [self scaleAnimationFrom:1.0 to:0.3 duration:leadingAnimation.duration*5/12 repeatTime:0];
    
    CABasicAnimation *scaleUpAnimation = [self scaleAnimationFrom:0.3 to:1.0 duration:leadingAnimation.duration-scaleDownAnimation.duration repeatTime:0];
    scaleUpAnimation.beginTime = scaleDownAnimation.duration;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = leadingAnimation.duration+self.replicatorLayer.instanceCount*self.replicatorLayer.instanceDelay;;
    animationGroup.repeatCount = INFINITY;
    animationGroup.animations = @[leadingAnimation, scaleDownAnimation, scaleUpAnimation];
    
    [self.indicatorCAShapeLayer addAnimation:animationGroup forKey:nil];
}

- (void)addMinorArcAnimation {
    CAShapeLayer *oppositeArc = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self.indicatorCAShapeLayer]];
    
    CGFloat length = ViewFrameWidth/5;
    oppositeArc.frame = CGRectMake(length, length, length*3, length*3);
    [self.replicatorLayer addSublayer:oppositeArc];
    
    self.indicatorCAShapeLayer.path = [self arcPathWithStartAngle:-M_PI/4 span:M_PI/2];
    oppositeArc.path = [self arcPathWithStartAngle:M_PI*3/4 span:M_PI/2];
    
    CABasicAnimation *animation = [[CABasicAnimation alloc] init];
    animation.keyPath = @"transform.rotation.z";
    animation.fromValue = [NSNumber numberWithFloat:0.0];
    animation.toValue = [NSNumber numberWithFloat: 2*M_PI];
    animation.duration = DURATION_BASE*1.5;
    animation.repeatCount = INFINITY;
    
    [self.indicatorCAShapeLayer addAnimation:animation forKey:nil];
    [oppositeArc addAnimation:animation forKey:nil];
}

- (void)addDynamicArcAnimation {
    self.indicatorCAShapeLayer.path = [self arcPathWithStartAngle:-M_PI/2 span:2*M_PI];
    
    CABasicAnimation *strokeEndAnimation = [[CABasicAnimation alloc] init];
    strokeEndAnimation.keyPath = @"strokeEnd";
    strokeEndAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    strokeEndAnimation.toValue = [NSNumber numberWithFloat:1.0];
    strokeEndAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    strokeEndAnimation.duration = DURATION_BASE*2;
    
    CABasicAnimation *strokeStartAnimation = [[CABasicAnimation alloc] init];
    strokeStartAnimation.keyPath = @"strokeStart";
    strokeStartAnimation.beginTime =strokeEndAnimation.duration/4;
    strokeStartAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    strokeStartAnimation.toValue = [NSNumber numberWithFloat:1.0];
    strokeStartAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut];
    strokeStartAnimation.duration = strokeEndAnimation.duration;
    
    CABasicAnimation *rotationAnimation = [[CABasicAnimation alloc] init];
    rotationAnimation.keyPath = @"transform.rotation.z";
    rotationAnimation.fromValue = [NSNumber numberWithFloat:0.0];
    rotationAnimation.toValue = [NSNumber numberWithFloat:2*M_PI];
    rotationAnimation.duration = 2*strokeEndAnimation.duration;
    rotationAnimation.repeatCount = INFINITY;
    
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = strokeEndAnimation.duration+strokeStartAnimation.beginTime;
    animationGroup.repeatCount = INFINITY;
    animationGroup.animations = @[strokeEndAnimation, strokeStartAnimation];
    
    [self.indicatorCAShapeLayer addAnimation:animationGroup forKey:nil];
    [self.indicatorCAShapeLayer addAnimation:rotationAnimation forKey:nil];
}

- (void)addArcInCircleAnimation {
    CAShapeLayer *circleShapeLayer = [[CAShapeLayer alloc] init];
    circleShapeLayer.strokeColor = self.indicatorCAShapeLayer.strokeColor;
    circleShapeLayer.fillColor = [UIColor clearColor].CGColor;
    circleShapeLayer.opacity = self.indicatorCAShapeLayer.opacity-0.8;
    circleShapeLayer.lineWidth = ViewFrameWidth/24;
    circleShapeLayer.path = [self arcPathWithStartAngle:-M_PI span:2*M_PI];
    
    CGFloat length = ViewFrameWidth/5;
    circleShapeLayer.frame = CGRectMake(length, length, length*3, length*3);
    [self.replicatorLayer insertSublayer:circleShapeLayer above:self.indicatorCAShapeLayer];
    
    
    self.indicatorCAShapeLayer.path = [self arcPathWithStartAngle:-M_PI/2 span:M_PI/3];
    
    CABasicAnimation *animation = [[CABasicAnimation alloc] init];
    animation.keyPath = @"transform.rotation.z";
    animation.fromValue = [NSNumber numberWithFloat:0.0];
    animation.toValue = [NSNumber numberWithFloat: 2*M_PI];
    animation.duration = DURATION_BASE*1.5;
    animation.repeatCount = INFINITY;
    
    [self.indicatorCAShapeLayer addAnimation:animation forKey:nil];
}

- (void)addSpringBallAnimation {
    [self.replicatorLayer addSublayer:self.indicatorCAShapeLayer];
    
    CABasicAnimation *fallAnimation = [[CABasicAnimation alloc] init];
    fallAnimation.keyPath = @"position.y";
    fallAnimation.fromValue = [NSNumber numberWithFloat:ViewFrameHeight/5];
    fallAnimation.toValue = [NSNumber numberWithFloat:ViewFrameHeight*4/5];
    fallAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    fallAnimation.duration = DURATION_BASE;
    
    CABasicAnimation * fallScaleAnimation = [self scaleAnimationFrom:1.0 to:0.5 duration:fallAnimation.duration repeatTime:0];
    
    CABasicAnimation *springBackAnimation = [[CABasicAnimation alloc] init];
    springBackAnimation.keyPath = @"position.y";
    springBackAnimation.beginTime =fallAnimation.duration;
    springBackAnimation.fromValue = [NSNumber numberWithFloat:ViewFrameHeight*4/5];
    springBackAnimation.toValue = [NSNumber numberWithFloat:ViewFrameHeight/5];
    springBackAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    springBackAnimation.duration = fallAnimation.duration;
    
    CABasicAnimation *springBackScaleAnimation = [self scaleAnimationFrom:0.5 to:1.0 duration:springBackAnimation.duration repeatTime:0];
    springBackScaleAnimation.beginTime = springBackAnimation.beginTime;
   
    CAAnimationGroup *animationGroup = [CAAnimationGroup animation];
    animationGroup.duration = fallAnimation.duration+springBackAnimation.duration;
    animationGroup.repeatCount = INFINITY;
    animationGroup.animations = @[fallAnimation, fallScaleAnimation,springBackAnimation, springBackScaleAnimation];
    
    [self.indicatorCAShapeLayer addAnimation:animationGroup forKey:nil];
}

- (void)addScalingBarsAnimation {
    [self.replicatorLayer addSublayer:self.indicatorCAShapeLayer];
    self.replicatorLayer.instanceDelay = DURATION_BASE/6;
    
    CABasicAnimation *scaleUpAnimation = [self scaleAnimationFrom:1.0 to:1.2 duration:self.replicatorLayer.instanceDelay repeatTime:0];
    CABasicAnimation *scaleDownAnimation = [self scaleAnimationFrom:1.2 to:1.0 duration:self.replicatorLayer.instanceDelay repeatTime:0];
    scaleDownAnimation.beginTime = scaleUpAnimation.duration;
    
    CAAnimationGroup *animationGroup = [[CAAnimationGroup alloc] init];
    animationGroup.duration = (scaleUpAnimation.duration+scaleDownAnimation.duration)+(self.replicatorLayer.instanceCount-1)*self.replicatorLayer.instanceDelay;
    animationGroup.repeatCount = INFINITY;
    animationGroup.animations = @[scaleUpAnimation, scaleDownAnimation];
    
    [self.indicatorCAShapeLayer addAnimation:animationGroup forKey:nil];
}

- (void)addTriangleCircleAnimation {
    CGPoint topPoint = self.indicatorCAShapeLayer.position;
    CGPoint leftPoint = CGPointMake(topPoint.x-ViewFrameHeight*3*sqrt(3)/20, topPoint.y+ViewFrameHeight*9/20);
    CGPoint rightPoint = CGPointMake(topPoint.x+ViewFrameHeight*3*sqrt(3)/20, topPoint.y+ViewFrameHeight*9/20);
    
    [self.replicatorLayer addSublayer:self.indicatorCAShapeLayer];
    
    CAShapeLayer *leftCircle = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self.indicatorCAShapeLayer]];
    leftCircle.position = leftPoint;
    [self.replicatorLayer addSublayer:leftCircle];
    
    CAShapeLayer *rightCircle = [NSKeyedUnarchiver unarchiveObjectWithData:[NSKeyedArchiver archivedDataWithRootObject:self.indicatorCAShapeLayer]];
    rightCircle.position = rightPoint;
    [self.replicatorLayer addSublayer:rightCircle];
    
    NSArray *vertexs = @[[NSValue valueWithCGPoint:topPoint],
                         [NSValue valueWithCGPoint:leftPoint],
                         [NSValue valueWithCGPoint:rightPoint]];
    
    [self.indicatorCAShapeLayer addAnimation:[self keyFrameAnimationWithPath:[self trianglePathWithStartPoint:topPoint vertexs:vertexs] duration:DURATION_BASE*3] forKey:nil];
    [rightCircle addAnimation:[self keyFrameAnimationWithPath:[self trianglePathWithStartPoint:leftPoint vertexs:vertexs] duration:DURATION_BASE*3] forKey:nil];
    [leftCircle addAnimation:[self keyFrameAnimationWithPath:[self trianglePathWithStartPoint:rightPoint vertexs:vertexs] duration:DURATION_BASE*3] forKey:nil];
}

#pragma mark - 入场动画 animation
- (void)addAppearAnimation {
    switch (self.axcUI_appearAnimationType) {
        case AxcActivityHUDAppearAnimationTypeSlideFromTop:
            [self addSlideFromTopAppearAnimation];
            break;
            
        case AxcActivityHUDAppearAnimationTypeSlideFromBottom:
            [self addSlideFromBottomAppearAnimation];
            break;
            
        case AxcActivityHUDAppearAnimationTypeSlideFromLeft:
            [self addSlideFromLeftAppearAnimation];
            break;
            
        case AxcActivityHUDAppearAnimationTypeSlideFromRight:
            [self addSlideFromRightAppearAnimation];
            break;
            
        case AxcActivityHUDAppearAnimationTypeZoomIn:
            [self addZoomInAppearAnimation];
            break;
            
        case AxcActivityHUDAppearAnimationTypeFadeIn:
            [self addFadeInAppearAnimation];
            break;
    }
}

- (void)addFadeInAppearAnimation {
    CGFloat originalAlpha = self.alpha;
    self.alpha = 0.0;
    
    self.center = BoundsCenterFor(Screen);
    
    [UIView animateWithDuration:0.35 animations:^{
        self.alpha = originalAlpha;
    } completion:^(BOOL finished) {
        if (finished && self.useProvidedIndicator) {
            [self addAnimation];
        }
    }];
}

- (void)addSlideFromTopAppearAnimation {
    self.center = CGPointMake(BoundsCenterXFor(Screen), -ViewFrameHeight);
    
    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.center = BoundsCenterFor(Screen);
    } completion:^(BOOL finished) {
        if (finished && self.useProvidedIndicator) {
            [self addAnimation];
        }
    }];
}

- (void)addSlideFromBottomAppearAnimation {
    self.center = CGPointMake(BoundsCenterXFor(Screen), BoundsHeightFor(Screen)+ViewFrameHeight);
    
    [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.center = BoundsCenterFor(Screen);
    } completion:^(BOOL finished) {
        if (finished && self.useProvidedIndicator) {
            [self addAnimation];
        }
    }];
}

- (void)addSlideFromLeftAppearAnimation {
    self.center = CGPointMake(-ViewFrameWidth, BoundsCenterYFor(Screen));
    
    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.center = BoundsCenterFor(Screen);
    } completion:^(BOOL finished) {
        if (finished && self.useProvidedIndicator) {
            [self addAnimation];
        }
    }];
}

- (void)addSlideFromRightAppearAnimation {
    self.center = CGPointMake(BoundsWidthFor(Screen)+ViewFrameWidth, BoundsCenterYFor(Screen));
    
    [UIView animateWithDuration:0.4 delay:0.0 usingSpringWithDamping:0.6 initialSpringVelocity:1.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.center = BoundsCenterFor(Screen);
    } completion:^(BOOL finished) {
        if (finished && self.useProvidedIndicator) {
            [self addAnimation];
        }
    }];
}

- (void)addZoomInAppearAnimation {
    self.center = BoundsCenterFor(Screen);
    
    self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.001, 0.001);
    [UIView animateWithDuration:0.15 animations:^{
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.transform = CGAffineTransformIdentity;
                
                if (finished && self.useProvidedIndicator) {
                    [self addAnimation];
                }
            }];
        }];
    }];
}

#pragma mark - 离场动画 animation
- (void)addDisappearAnimationWithDelay:(CGFloat)delay {
    switch (self.axcUI_disappearAnimationType) {
        case AxcActivityHUDDisappearAnimationTypeSlideToTop:
            [self addSlideToTopDissappearAnimationWithDelay:delay];
            break;
            
        case AxcActivityHUDDisappearAnimationTypeSlideToBottom:
            [self addSlideToBottomDissappearAnimationWithDelay:delay];
            break;
            
        case AxcActivityHUDDisappearAnimationTypeSlideToLeft:
            [self addSlideToLeftDissappearAnimationWithDelay:delay];
            break;
            
        case AxcActivityHUDDisappearAnimationTypeSlideToRight:
            [self addSlideToRightDissappearAnimationWithDelay:delay];
            break;
            
        case AxcActivityHUDDisappearAnimationTypeZoomOut:
            [self addZoomOutDisappearAnimationWithDelay:delay];
            break;
            
        case AxcActivityHUDDisappearAnimationTypeFadeOut:
            [self addFadeOutDisappearAnimationWithDelay:delay];
            break;
    }
}

- (void)addFadeOutDisappearAnimationWithDelay:(CGFloat)delay {
    CGFloat originalAlpha = self.alpha;
    
    [UIView animateWithDuration:0.35 delay:delay options:kNilOptions  animations:^{
        self.alpha = 0.0;
    } completion:^(BOOL finished) {
        self.alpha = originalAlpha;
        [self removeFromSuperview];
    }];
}

- (void)addSlideToTopDissappearAnimationWithDelay:(CGFloat)delay {
    [UIView animateWithDuration:0.25 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.center = CGPointMake(BoundsCenterXFor(Screen), -ViewFrameHeight);
    } completion:^(BOOL finished) {
         [self removeFromSuperview];
    }];
}
- (void)addSlideToBottomDissappearAnimationWithDelay:(CGFloat)delay {
    [UIView animateWithDuration:0.25 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.center = CGPointMake(BoundsCenterXFor(Screen), BoundsHeightFor(Screen)+ViewFrameHeight);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)addSlideToLeftDissappearAnimationWithDelay:(CGFloat)delay {
    [UIView animateWithDuration:0.15 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.center = CGPointMake(-ViewFrameWidth, BoundsCenterYFor(Screen));
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)addSlideToRightDissappearAnimationWithDelay:(CGFloat)delay {
    [UIView animateWithDuration:0.15 delay:delay options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.center = CGPointMake(BoundsWidthFor(Screen)+ViewFrameWidth, BoundsCenterYFor(Screen));
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)addZoomOutDisappearAnimationWithDelay:(CGFloat)delay {
    [UIView animateWithDuration:0.15 delay:delay options:kNilOptions animations:^{
        self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.1, 1.1);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1 animations:^{
            self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.9, 0.9);
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:0.1 animations:^{
                self.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.01, 0.01);;
                
                [self removeFromSuperview];
            }];
        }];
    }];
}




#pragma mark - 重写SET方法，将其参数属性赋值给Layer层
- (void)setAxcUI_borderColor:(UIColor *)axcUI_borderColor {
    if (axcUI_borderColor.CGColor != self.layer.borderColor) {
        self.layer.borderColor = axcUI_borderColor.CGColor;
    }
}

- (void)setAxcUI_borderWidth:(CGFloat)axcUI_borderWidth {
    if (axcUI_borderWidth != self.layer.borderWidth) {
        self.layer.borderWidth = axcUI_borderWidth;
    }
}

- (void)setAxcUI_cornerRadius:(CGFloat)axcUI_cornerRadius {
    if (axcUI_cornerRadius != self.layer.cornerRadius) {
        self.layer.cornerRadius = axcUI_cornerRadius;
    }
}
#pragma mark - 工具类
- (CGRect)originalFrame {
    CGFloat length = BoundsWidthFor(Screen)/6;
    return CGRectMake(-2*length, -2*length, length, length);
}

- (void)removeAllSubviews {
    if (self.subviews.count > 0) {
        for (UIView *sub in self.subviews) {
            [sub removeFromSuperview];
        }
    }
}

- (void)communalShowTask {
    [self addOverlay];
    
    [[[UIApplication sharedApplication].windows lastObject] addSubview:self];
    [self.superview bringSubviewToFront:self];
    
    [self addAppearAnimation];
    
    if (self.axcUI_isTheOnlyActiveView) {
        for (UIView *view in self.superview.subviews) {
            view.userInteractionEnabled = NO;
        }
    }
}


- (CGPathRef)arcPathWithStartAngle:(CGFloat)startAngle span:(CGFloat)span {
    CGFloat radius = ViewFrameWidth/2 - ViewFrameWidth/5;
    CGFloat x = FrameWidthFor(self.indicatorCAShapeLayer)/2;
    CGFloat y = FrameHeightFor(self.indicatorCAShapeLayer)/2;
    
    UIBezierPath *arcPath = [UIBezierPath bezierPath];
    [arcPath addArcWithCenter:CGPointMake(x, y) radius:radius startAngle:startAngle endAngle:startAngle+span clockwise:YES];
    return arcPath.CGPath;
}

- (CGFloat)heightForText:(NSString *)text{
    
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:text attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:TEXT_FONT_SIZE]}];
    CGRect rect = [attributedText boundingRectWithSize:(CGSize){TEXT_WIDTH, CGFLOAT_MAX} options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    return ceil(rect.size.height);
}



- (CABasicAnimation *)scaleAnimationFrom:(CGFloat)fromValue to:(CGFloat)toValue  duration:(CFTimeInterval)duration repeatTime:(CGFloat)repeat {
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    animation.fromValue = @(fromValue);
    animation.toValue = @(toValue);
    animation.duration = duration;
    animation.repeatCount = repeat;
    
    return animation;
}

- (UIBezierPath *)trianglePathWithStartPoint:(CGPoint)startPoint vertexs:(NSArray *)vertexs {
    CGPoint topPoint  = [[vertexs objectAtIndex:0] CGPointValue];
    CGPoint leftPoint  = [[vertexs objectAtIndex:1] CGPointValue];
    CGPoint rightPoint  = [[vertexs objectAtIndex:2] CGPointValue];
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    
    if (CGPointEqualToPoint(startPoint, topPoint) ) {
        [path moveToPoint:startPoint];
        [path addLineToPoint:rightPoint];
        [path addLineToPoint:leftPoint];
    } else if (CGPointEqualToPoint(startPoint, leftPoint)) {
        [path moveToPoint:startPoint];
        [path addLineToPoint:topPoint];
        [path addLineToPoint:rightPoint];
    } else {
        [path moveToPoint:startPoint];
        [path addLineToPoint:leftPoint];
        [path addLineToPoint:topPoint];
    }
    
    [path closePath];
    
    return path;
}

- (CAKeyframeAnimation *)keyFrameAnimationWithPath:(UIBezierPath *)path duration:(NSTimeInterval)duration {
    CAKeyframeAnimation *animation = [[CAKeyframeAnimation alloc] init];
    animation.keyPath = @"position";
    animation.path = path.CGPath;
    animation.duration = duration;
    animation.repeatCount = INFINITY;
    
    return animation;
}
#pragma mark - Other
- (void)addNotificationObserver { // 通知中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addAnimation) name:UIApplicationWillEnterForegroundNotification object:nil];
}

- (void)initializeReplicatorLayer { // Layer层面
    self.replicatorLayer = [[CAReplicatorLayer alloc] init];
    self.replicatorLayer.frame = CGRectMake(0, 0, ViewFrameWidth, ViewFrameHeight);
    self.replicatorLayer.backgroundColor = [UIColor clearColor].CGColor;
    
    [self.layer addSublayer:self.replicatorLayer];
}
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)removeFromSuperview {
    if (self.overlay != nil) {
        [self.overlay removeFromSuperview];
    }
    if (self.imageView != nil) {
        [self.imageView removeFromSuperview];
    }
    [self removeAllSubviews];
    self.layer.sublayers = nil;
    self.transform = CGAffineTransformIdentity;
    self.frame = [self originalFrame];
    [super removeFromSuperview];
}

@end


