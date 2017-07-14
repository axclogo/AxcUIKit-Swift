//
//  AxcUI_BadgeView.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/12.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcUI_BadgeView.h"
#import "AxcTween.h"
#import "AxcTweenTimingFunctions.h"

#import "UIImage+AxcImageName.h"

#define kDefaultaxcUI_tintColor               [UIColor redColor]
#define kDefaultBorderColor             [UIColor clearColor]
#define kDefaultBorderWidth             1.0f
#define kElasticDuration                0.5f
#define kFromRadiusScaleCoefficient     0.09f
#define kToRadiusScaleCoefficient       0.05f
#define kMaxDistanceScaleCoefficient    8.0f
#define kFollowTimeInterval             0.016f
#define kBombDuration                   0.5f
#define kValidRadius                    20.0f
#define kDefaultFontSize                16.0f

#define kPaddingSize                    10.0f

CGFloat distanceBetweenPoints (CGPoint p1, CGPoint p2) {
    CGFloat deltaX = p2.x - p1.x;
    CGFloat deltaY = p2.y - p1.y;
    return sqrt(deltaX*deltaX + deltaY*deltaY);
};

@interface AxcUI_BadgeView () {
    UIControl*              _overlayView;       //拖动时self依附的view
//    UIView*                 self.superview;   //原self容器
    CGFloat                 _viscosity;         //粘度
    CGSize                  _size;              //圆大小
    CGPoint                 _originPoint;       //源点
    CGFloat                 _radius;            //圆半径
    BOOL                    _padding;           //配置内边距
    
    CGPoint                 _fromPoint;
    CGPoint                 _toPoint;
    CGFloat                 _fromRadius;
    CGFloat                 _toRadius;
    
    CGPoint                 _elasticBeginPoint;
    
    BOOL                    _missed;
    BOOL                    _beEnableDragDrop;
    CGFloat                 _maxDistance;
    CGFloat                 _distance;
    AxcTweenOperation*       _activeTweenOperation;
    
    UILabel*                _textLabel;
    UIImageView*            _bombImageView;
    
    CAShapeLayer*           _shapeLayer;
    
    UIPanGestureRecognizer* _panGestureRecognizer;
}

@property (nonatomic, strong) UIControl* overlayView;

@end

@implementation AxcUI_BadgeView


- (void)awakeFromNib {
    [super awakeFromNib];
    _padding = YES;
    [self setup];
}

- (instancetype)init{
    if (self == [super init]) {
        [self setup];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    return [self initWithFrame:frame axcUI_dragdropCompletion:nil];
}

- (instancetype)initWithFrame:(CGRect)frame
           axcUI_dragdropCompletion:(void(^)())axcUI_dragdropCompletion {
    self = [super initWithFrame:frame];
    if (self) {
        self.axcUI_dragdropCompletion = axcUI_dragdropCompletion;
        [self setup];
    }
    return self;
}

- (void)setup {
    //为了便于拖拽，扩大空间区域
    _size = self.frame.size;
    
    if (!_padding) {
        CGRect wapperFrame = self.frame;
        wapperFrame.origin.x -= kPaddingSize;
        wapperFrame.origin.y -= kPaddingSize;
        wapperFrame.size.width += kPaddingSize*2;
        wapperFrame.size.height += kPaddingSize*2;
        self.frame = wapperFrame;
        _padding = YES;
    }
    
    self.backgroundColor = [UIColor clearColor];
    
    _axcUI_tintColor = kDefaultaxcUI_tintColor;
    _axcUI_hiddenWhenZero = YES;
    _axcUI_fontSizeAutoFit = NO;
    
    _shapeLayer = [CAShapeLayer new];
    [self.layer addSublayer:_shapeLayer];
    _shapeLayer.frame = CGRectMake(0, 0, _size.width, _size.height);
    _shapeLayer.fillColor = _axcUI_tintColor.CGColor;
    
    _radius = _size.width/2;
    _originPoint = CGPointMake(kPaddingSize+_radius, kPaddingSize+_radius);
    
    //爆炸效果
    UIImage* image0 = [UIImage AxcUI_axcUIBoundleImageName:@"AxcUI_BadgeView_bomb0"];
    UIImage* image1 = [UIImage AxcUI_axcUIBoundleImageName:@"AxcUI_BadgeView_bomb1"];
    UIImage* image2 = [UIImage AxcUI_axcUIBoundleImageName:@"AxcUI_BadgeView_bomb2"];
    UIImage* image3 = [UIImage AxcUI_axcUIBoundleImageName:@"AxcUI_BadgeView_bomb3"];
    UIImage* image4 = [UIImage AxcUI_axcUIBoundleImageName:@"AxcUI_BadgeView_bomb4"];
    
    _bombImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 34, 34)];
    _bombImageView.animationImages = @[image0, image1, image2, image3, image4, ];
    //
    _bombImageView.animationRepeatCount = 1;
    _bombImageView.animationDuration = kBombDuration;
    [self addSubview:_bombImageView];
    
    //文字
    _textLabel = [[UILabel alloc] initWithFrame:CGRectMake(kPaddingSize, kPaddingSize, _size.width, _size.width)];
    _textLabel.textColor = [UIColor whiteColor];
    _textLabel.font = [UIFont systemFontOfSize:kDefaultFontSize];
    _textLabel.textAlignment = NSTextAlignmentCenter;
    _textLabel.text = @"";
    [self addSubview:_textLabel];
    
    //拖动手势
    _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(onGestureAction:)];
    [_panGestureRecognizer setDelaysTouchesBegan:YES];
    [_panGestureRecognizer setDelaysTouchesEnded:YES];
    [self addGestureRecognizer:_panGestureRecognizer];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self reset];
}

- (void)dealloc {
    [self removeGestureRecognizer:_panGestureRecognizer];
}

- (void)setAxcUI_hiddenWhenZero:(BOOL)axcUI_hiddenWhenZero{
    _axcUI_hiddenWhenZero = axcUI_hiddenWhenZero;
    self.axcUI_text = self.axcUI_text;
    [self setNeedsDisplay];
}

- (void)setAxcUI_fontSizeAutoFit:(BOOL)axcUI_fontSizeAutoFit{
    _axcUI_fontSizeAutoFit = axcUI_fontSizeAutoFit;
    self.axcUI_text = self.axcUI_text;
    [self setNeedsDisplay];
    if (!axcUI_fontSizeAutoFit) {
        _textLabel.font = self.axcUI_font;
    }
}

- (void)setAxcUI_tintColor:(UIColor *)axcUI_tintColor{
    _axcUI_tintColor = axcUI_tintColor?axcUI_tintColor:kDefaultaxcUI_tintColor;
    _shapeLayer.fillColor = _axcUI_tintColor.CGColor;
}

- (void)setAxcUI_font:(UIFont *)axcUI_font {
    _axcUI_font = axcUI_font;
    [_textLabel setFont:axcUI_font];
}

- (void)setAxcUI_fontSize:(CGFloat)axcUI_fontSize {
    _axcUI_fontSize = axcUI_fontSize;
    [_textLabel setFont:[_textLabel.font fontWithSize:axcUI_fontSize]];
}

- (void)setAxcUI_text:(NSString *)axcUI_text {
    _axcUI_text = [axcUI_text copy];
    
    _textLabel.text = axcUI_text;
    _textLabel.hidden = NO;
    
    self.hidden = NO;
    if (_axcUI_hiddenWhenZero
        && ([axcUI_text isEqualToString:@"0"] || [axcUI_text isEqualToString:@""])) {
        self.hidden = YES;
    }
    
    [self reset];
}

- (void)setAxcUI_textColor:(UIColor *)axcUI_textColor {
    _axcUI_textColor = axcUI_textColor;
    _textLabel.textColor = _axcUI_textColor;
}

- (void)reset {
    _fromPoint = _originPoint;
    _toPoint = _fromPoint;
    _maxDistance = kMaxDistanceScaleCoefficient*_radius;
    _beEnableDragDrop = YES;
    
    [self updateRadius];
}

- (void)update:(AxcTweenPeriod*)period {
    CGFloat c = period.tweenedValue;
    if (isnan(c) || c > 10000000.0f || c < -10000000.0f) return;
    
    if (_missed) {
        CGFloat x = (_distance != 0)?((_toPoint.x-_elasticBeginPoint.x)*c/_distance):0;
        CGFloat y = (_distance != 0)?((_toPoint.y-_elasticBeginPoint.y)*c/_distance):0;
        
        _fromPoint = CGPointMake(_elasticBeginPoint.x+x, _elasticBeginPoint.y+y);
    } else {
        CGFloat x = (_distance != 0)?((_fromPoint.x - _elasticBeginPoint.x)*c/_distance):0;
        CGFloat y = (_distance != 0)?((_fromPoint.y - _elasticBeginPoint.y)*c/_distance):0;
        
        _toPoint = CGPointMake(_elasticBeginPoint.x+x, _elasticBeginPoint.y+y);
    }
    
    [self updateRadius];
}


- (void)updateRadius {
    CGFloat r = distanceBetweenPoints(_fromPoint, _toPoint);
    
    _fromRadius = _radius-kFromRadiusScaleCoefficient*r;
    _toRadius = _radius-kToRadiusScaleCoefficient*r;
    _viscosity = (_maxDistance != 0)?(1.0-r/_maxDistance):1.0f;
    
    if (_axcUI_fontSizeAutoFit) {
        _textLabel.font = [_textLabel.font fontWithSize:(_textLabel.text.length)?((2*_toRadius)/(1.2*_textLabel.text.length)):kDefaultFontSize];
    }
    _textLabel.center = _toPoint;
    
    [self setNeedsDisplay];
}


- (UIBezierPath* )bezierPathWithFromPoint:(CGPoint)fromPoint
                                  toPoint:(CGPoint)toPoint
                               fromRadius:(CGFloat)fromRadius
                                 toRadius:(CGFloat)toRadius scale:(CGFloat)scale{
    
    if (isnan(fromRadius) || isnan(toRadius)||isnan(fromRadius)||isnan(toRadius)) return nil;
    
    UIBezierPath* path = [[UIBezierPath alloc] init];
    CGFloat r = distanceBetweenPoints(fromPoint, toPoint);
    CGFloat offsetY = fabs(fromRadius-toRadius);
    if (r <= offsetY) {
        CGPoint center;
        CGFloat radius;
        if (fromRadius >= toRadius) {
            center = fromPoint;
            radius = fromRadius;
        } else {
            center = toPoint;
            radius = toRadius;
        }
        [path addArcWithCenter:center radius:radius startAngle:0 endAngle:2*M_PI clockwise:YES];
    } else {
        CGFloat originX = toPoint.x - fromPoint.x;
        CGFloat originY = toPoint.y - fromPoint.y;
        
        CGFloat fromOriginAngel = (originX >= 0)?atan(originY/originX):(atan(originY/originX)+M_PI);
        CGFloat fromOffsetAngel = (fromRadius >= toRadius)?acos(offsetY/r):(M_PI-acos(offsetY/r));
        CGFloat fromStartAngel = fromOriginAngel + fromOffsetAngel;
        CGFloat fromEndAngel = fromOriginAngel - fromOffsetAngel;
        
        CGPoint fromStartPoint = CGPointMake(fromPoint.x+cos(fromStartAngel)*fromRadius, fromPoint.y+sin(fromStartAngel)*fromRadius);
        
        CGFloat toOriginAngel = (originX < 0)?atan(originY/originX):(atan(originY/originX)+M_PI);
        CGFloat toOffsetAngel = (fromRadius < toRadius)?acos(offsetY/r):(M_PI-acos(offsetY/r));
        CGFloat toStartAngel = toOriginAngel + toOffsetAngel;
        CGFloat toEndAngel = toOriginAngel - toOffsetAngel;
        CGPoint toStartPoint = CGPointMake(toPoint.x+cos(toStartAngel)*toRadius, toPoint.y+sin(toStartAngel)*toRadius);
        
        CGPoint middlePoint = CGPointMake(fromPoint.x+(toPoint.x-fromPoint.x)/2, fromPoint.y+(toPoint.y-fromPoint.y)/2);
        CGFloat middleRadius = (fromRadius+toRadius)/2;
        
        CGPoint fromControlPoint = CGPointMake(middlePoint.x+sin(fromOriginAngel)*middleRadius*scale, middlePoint.y-cos(fromOriginAngel)*middleRadius*scale);
        
        CGPoint toControlPoint = CGPointMake(middlePoint.x+sin(toOriginAngel)*middleRadius*scale, middlePoint.y-cos(toOriginAngel)*middleRadius*scale);
        
        [path moveToPoint:fromStartPoint];
        
        //绘制from弧形
        [path addArcWithCenter:fromPoint radius:fromRadius startAngle:fromStartAngel endAngle:fromEndAngel clockwise:YES];
        
        //绘制from到to之间的贝塞尔曲线
        if (r > (fromRadius+toRadius)) {
            [path addQuadCurveToPoint:toStartPoint controlPoint:fromControlPoint];
        }
        
        //绘制to弧形
        [path addArcWithCenter:toPoint radius:toRadius startAngle:toStartAngel endAngle:toEndAngel clockwise:YES];
        
        //绘制to到from之间的贝塞尔曲线
        if (r > (fromRadius+toRadius)) {
            [path addQuadCurveToPoint:fromStartPoint controlPoint:toControlPoint];
        }
    }
    
    [path closePath];
    
    return path;
}

- (void)drawRect:(CGRect)rect {
    UIBezierPath* path = [self bezierPathWithFromPoint:_fromPoint toPoint:_toPoint fromRadius:_fromRadius toRadius:_toRadius scale:_viscosity];
    _shapeLayer.path = path.CGPath;
}

#pragma mark - Touch
- (void)onGestureAction:(UIPanGestureRecognizer* )gesture {
    if (!_beEnableDragDrop) return;
    
    CGPoint point = [gesture locationInView:self];
    switch (gesture.state) {
        case UIGestureRecognizerStateBegan: {
            [self touchesBegan:point];
            break;
        }
        case UIGestureRecognizerStateEnded:
            [self touchesEnded:point];
            break;
        case UIGestureRecognizerStateChanged:
            [self touchesMoved:point];
            break;
        default:
            break;
    }
}

- (void)touchesBegan:(CGPoint)point {
    _missed = NO;
    [self becomeUpper];
}

- (UIControl *)overlayView {
    if(!_overlayView) {
        _overlayView = [[UIControl alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _overlayView.backgroundColor = [UIColor clearColor];
    }
    return _overlayView;
}

- (void)becomeUpper {
    if(!self.overlayView.superview){
        NSEnumerator *frontToBackWindows = [UIApplication.sharedApplication.windows reverseObjectEnumerator];
        for (UIWindow *window in frontToBackWindows){
            BOOL windowOnMainScreen = window.screen == UIScreen.mainScreen;
            BOOL windowIsVisible = !window.hidden && window.alpha > 0;
            BOOL windowLevelNormal = window.windowLevel == UIWindowLevelNormal;
            
            if (windowOnMainScreen && windowIsVisible && windowLevelNormal) {
                [window addSubview:self.overlayView];
                break;
            }
        }
    } else {
        [self.overlayView.superview bringSubviewToFront:self.overlayView];
    }
    
//    self.superview = self.superview;
    self.center = [self.superview convertPoint:self.center toView:self.overlayView];
    
    if ([self.superview isKindOfClass:[UITableViewCell class]]
        && self == ((UITableViewCell* )self.superview).accessoryView) {
        ((UITableViewCell* )self.superview).accessoryView = nil;
    }
    
    [self.overlayView addSubview:self];
}

- (void)resignUpper {
    self.center = [_overlayView convertPoint:self.center toView:self.superview];
    
    if ([self.superview isKindOfClass:[UITableViewCell class]]
        && self == ((UITableViewCell* )self.superview).accessoryView) {
        ((UITableViewCell* )self.superview).accessoryView = self;
    } else {
        [self.superview addSubview:self];
    }
    [_overlayView removeFromSuperview];
    _overlayView = nil;
}

- (void)touchesEnded:(CGPoint)point {
    if (!_missed) {
        _elasticBeginPoint = _toPoint;
        _distance = distanceBetweenPoints(_fromPoint, _toPoint);
        
        [[AxcTween sharedInstance] removeTweenOperation:_activeTweenOperation];
        AxcTweenPeriod *period = [AxcTweenPeriod periodWithStartValue:0 endValue:_distance duration:kElasticDuration];
        _activeTweenOperation = [[AxcTween sharedInstance] addTweenPeriod:period target:self selector:@selector(update:) timingFunction:&AxcTweenTimingFunctionElasticOut];
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kElasticDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self resignUpper];
        });
    } else {
        if (CGRectContainsPoint(CGRectMake(_originPoint.x-kValidRadius, _originPoint.y-kValidRadius, 2*kValidRadius, 2*kValidRadius), point)) {
            [self resignUpper];
            [self reset];
        } else {
            _bombImageView.center = _toPoint;
            _toRadius = 0;
            _fromRadius = 0;
            _textLabel.hidden = YES;
            [_bombImageView startAnimating];
            _beEnableDragDrop = NO;
            _activeTweenOperation.updateSelector = nil;
            [[AxcTween sharedInstance] removeTweenOperation:_activeTweenOperation];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(kBombDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self resignUpper];
            });
            [self removeGestureRecognizer:_panGestureRecognizer];

            if (self.axcUI_dragdropCompletion) {
                self.axcUI_dragdropCompletion();
            }
        }
        
        [self setNeedsDisplay];
    }
}

- (void)touchesMoved:(CGPoint)point {
    CGFloat r = distanceBetweenPoints(_fromPoint, point);
    if (_missed) {
        _activeTweenOperation.updateSelector = nil;
        if (!CGPointEqualToPoint(point, CGPointZero)) {
            _fromPoint = _toPoint = point;
            [self updateRadius];
        }
    } else {
        _toPoint = point;
        if (r > _maxDistance) {
            _missed = YES;
            _elasticBeginPoint = _fromPoint;
            _distance = distanceBetweenPoints(_fromPoint, _toPoint);
            
            [[AxcTween sharedInstance] removeTweenOperation:_activeTweenOperation];
            
            AxcTweenPeriod *period = [AxcTweenPeriod periodWithStartValue:0 endValue:_distance duration:kElasticDuration];
            _activeTweenOperation = [[AxcTween sharedInstance] addTweenPeriod:period target:self selector:@selector(update:) timingFunction:&AxcTweenTimingFunctionElasticOut];
        } else {
            [self updateRadius];
        }
    }
    
}

@end
