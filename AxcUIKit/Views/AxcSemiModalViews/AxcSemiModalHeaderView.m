//
//  AxcSemiModalHeaderView.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/4.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcSemiModalHeaderView.h"
#import "UIViewController+AxcSemiModal.h"

#import <Masonry.h>

@implementation AxcSemiModalHeaderView

- (instancetype)init{
    if (self == [super init]) {
        self.backgroundColor = [UIColor AxcUI_colorWithHexColor:@"7dc5eb"];
        self.options = [NSMutableDictionary dictionary];
        [self createUI];
    }
    return self;
}

- (void)createUI{

    __weak typeof(self) WeakSelf = self;
    [self.bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(0);
        make.height.mas_equalTo(40);
    }];
    [self.traverseParentHierarchy mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WeakSelf.mas_top).offset(40);
        make.left.mas_equalTo(WeakSelf.mas_left).offset(10);
    }];
    [self.traverseParentHierarchyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(WeakSelf.traverseParentHierarchy.mas_top).offset(-5);
        make.left.mas_equalTo(WeakSelf.traverseParentHierarchy.mas_left).offset(0);
    }];
    self.traverseParentHierarchyLabel.text = @"导航栏动画";
    
    [self.pushParentBack mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WeakSelf.traverseParentHierarchy.mas_top).offset(0);
        make.centerX.mas_equalTo(0);
    }];
    [self.pushParentBackLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(WeakSelf.pushParentBack.mas_top).offset(-5);
        make.centerX.mas_equalTo(0);
    }];
    self.pushParentBackLabel.text = @"背景翻转动画";
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WeakSelf.pushParentBack.mas_top).offset(0);
        make.right.mas_equalTo(-10);
    }];
    [self.backgroundViewLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(WeakSelf.backgroundView.mas_top).offset(-5);
        make.right.mas_equalTo(-10);
    }];
    self.backgroundViewLabel.text = @"添加背景View";
    
    
    [self.animationDuration mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WeakSelf.traverseParentHierarchy.mas_bottom).offset(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-130);
    }];
    [self.animationDurationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WeakSelf.animationDuration.mas_top).offset(0);
        make.left.mas_equalTo(WeakSelf.animationDuration.mas_right).offset(5);
        make.right.mas_equalTo(WeakSelf.mas_right).offset(-5);
        make.height.mas_equalTo(WeakSelf.animationDuration.mas_height);
    }];
    
    [self.parentAlpha mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WeakSelf.animationDuration.mas_bottom).offset(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-130);
    }];
    [self.parentAlphaLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WeakSelf.parentAlpha.mas_top).offset(0);
        make.left.mas_equalTo(WeakSelf.parentAlpha.mas_right).offset(5);
        make.right.mas_equalTo(WeakSelf.mas_right).offset(-5);
        make.height.mas_equalTo(WeakSelf.parentAlpha.mas_height);
    }];
    
    [self.parentScale mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WeakSelf.parentAlpha.mas_bottom).offset(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-130);
    }];
    [self.parentScaleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WeakSelf.parentScale.mas_top).offset(0);
        make.left.mas_equalTo(WeakSelf.parentScale.mas_right).offset(5);
        make.right.mas_equalTo(WeakSelf.mas_right).offset(-5);
        make.height.mas_equalTo(WeakSelf.parentScale.mas_height);
    }];
    
    [self.shadowOpacity mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WeakSelf.parentScale.mas_bottom).offset(10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-130);
    }];
    [self.shadowOpacityLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WeakSelf.shadowOpacity.mas_top).offset(0);
        make.left.mas_equalTo(WeakSelf.shadowOpacity.mas_right).offset(5);
        make.right.mas_equalTo(WeakSelf.mas_right).offset(-5);
        make.height.mas_equalTo(WeakSelf.shadowOpacity.mas_height);
    }];
    
    [self.transitionStyle mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(WeakSelf.bottomLabel.mas_top).offset(-10);
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
    }];
    [self.transitionStyleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(WeakSelf.transitionStyle.mas_left).offset(0);
        make.right.mas_equalTo(WeakSelf.transitionStyle.mas_right).offset(0);
        make.bottom.mas_equalTo(WeakSelf.transitionStyle.mas_top).offset(-5);
    }];
    self.transitionStyleLabel.text = @"设置推出风格：‘提起’、‘渐入渐出’、’渐入‘、‘渐出’";
    
    [self setInstructionsText];
}

- (void)setInstructionsText{
    self.animationDurationLabel.text = [NSString stringWithFormat:@"动画时间：%.2f",self.animationDuration.value];
    self.parentAlphaLabel.text = [NSString stringWithFormat:@"背景透明：%.2f",self.parentAlpha.value];
    self.parentScaleLabel.text = [NSString stringWithFormat:@"视图比例：%.2f",self.parentScale.value];
    self.shadowOpacityLabel.text = [NSString stringWithFormat:@"阴影比例：%.2f",self.shadowOpacity.value];
}

- (void)controllAction:(UIControl *)sender{
    switch (sender.tag - 100) {
        case 0: // animationDuration
            [self.options setObject:@(((UISlider *)sender).value) forKey:AxcUISemiModalOptionKeys.axcUI_animationDuration];
            break;
        case 1: // parentAlpha
            [self.options setObject:@(((UISlider *)sender).value) forKey:AxcUISemiModalOptionKeys.axcUI_parentAlpha];
            break;
        case 2: // parentScale
            [self.options setObject:@(((UISlider *)sender).value) forKey:AxcUISemiModalOptionKeys.axcUI_parentScale];
            break;
        case 3: // shadowOpacity
            [self.options setObject:@(((UISlider *)sender).value) forKey:AxcUISemiModalOptionKeys.axcUI_shadowOpacity];
            break;
            
        case 4: // traverseParentHierarchy
            [self.options setObject:@(((UISwitch *)sender).on) forKey:AxcUISemiModalOptionKeys.axcUI_traverseParentHierarchy];
            break;
        case 5: // pushParentBack
            [self.options setObject:@(((UISwitch *)sender).on) forKey:AxcUISemiModalOptionKeys.axcUI_pushParentBack];
            break;
        case 6: // backgroundView
            if (((UISwitch *)sender).on) {
                [self.options setObject:self.presentBackgroundView forKey:AxcUISemiModalOptionKeys.axcUI_backgroundView];
            }else{
                [self.options removeObjectForKey:AxcUISemiModalOptionKeys.axcUI_backgroundView];
            }
            break;
        case 7: // transitionStyle
            [self.options setObject:@(((UISegmentedControl *)sender).selectedSegmentIndex)
                             forKey:AxcUISemiModalOptionKeys.axcUI_transitionStyle];
            break;
            
        default:
            break;
    }
    [self setInstructionsText];

    [_delegate AxcSemiModalHeaderViewOption:self.options];
}

#pragma mark - 懒加载区
- (UIImageView *)presentBackgroundView{
    if (!_presentBackgroundView) {
        _presentBackgroundView = [[UIImageView alloc] initWithFrame:CGRectMake(0,
                                                                          [UIScreen mainScreen].bounds.size.height - 200,
                                                                          [UIScreen mainScreen].bounds.size.width, 200)];
        _presentBackgroundView.backgroundColor = [UIColor AxcUI_OrangeColor];
        _presentBackgroundView.image = [UIImage AxcUI_setImageNamed:@"test_2.jpg"];
    }
    return _presentBackgroundView;
}

- (UISegmentedControl *)transitionStyle{
    if (!_transitionStyle) {
        _transitionStyle = [[UISegmentedControl alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        [_transitionStyle insertSegmentWithTitle:@"FadeOut" atIndex:0 animated:NO];
        [_transitionStyle insertSegmentWithTitle:@"FadeIn" atIndex:0 animated:NO];
        [_transitionStyle insertSegmentWithTitle:@"FadeInOut" atIndex:0 animated:NO];
        [_transitionStyle insertSegmentWithTitle:@"SlideUp" atIndex:0 animated:NO];
        _transitionStyle.selectedSegmentIndex = 0;
        [_transitionStyle addTarget:self action:@selector(controllAction:) forControlEvents:UIControlEventValueChanged];
        _transitionStyle.tag = 100 + 7;
        [self addSubview:_transitionStyle];
    }
    return _transitionStyle;
}
- (UISlider *)animationDuration{
    if (!_animationDuration) {
        _animationDuration = [[UISlider alloc] init];
        [_animationDuration addTarget:self action:@selector(controllAction:) forControlEvents:UIControlEventValueChanged];
        _animationDuration.minimumValue = 0;
        _animationDuration.maximumValue = 3;
        _animationDuration.value = 0.5;
        _animationDuration.tag = 100 + 0;
        [self addSubview:_animationDuration];
    }
    return _animationDuration;
}
- (UISlider *)parentAlpha{
    if (!_parentAlpha) {
        _parentAlpha = [[UISlider alloc] init];
        [_parentAlpha addTarget:self action:@selector(controllAction:) forControlEvents:UIControlEventValueChanged];
        _parentAlpha.minimumValue = 0;
        _parentAlpha.maximumValue = 1;
        _parentAlpha.value = 0.5;
        _parentAlpha.tag = 100 + 1;
        [self addSubview:_parentAlpha];
    }
    return _parentAlpha;
}
- (UISlider *)parentScale{
    if (!_parentScale) {
        _parentScale = [[UISlider alloc] init];
        [_parentScale addTarget:self action:@selector(controllAction:) forControlEvents:UIControlEventValueChanged];
        _parentScale.minimumValue = 0;
        _parentScale.maximumValue = 1;
        _parentScale.value = 0.8;
        _parentScale.tag = 100 + 2;
        [self addSubview:_parentScale];
    }
    return _parentScale;
}
- (UISlider *)shadowOpacity{
    if (!_shadowOpacity) {
        _shadowOpacity = [[UISlider alloc] init];
        [_shadowOpacity addTarget:self action:@selector(controllAction:) forControlEvents:UIControlEventValueChanged];
        _shadowOpacity.minimumValue = 0;
        _shadowOpacity.maximumValue = 1;
        _shadowOpacity.value = 0.8;
        _shadowOpacity.tag = 100 + 3;
        [self addSubview:_shadowOpacity];
    }
    return _shadowOpacity;
}

- (UISwitch *)traverseParentHierarchy{
    if (!_traverseParentHierarchy) {
        _traverseParentHierarchy = [[UISwitch alloc] init];
        [_traverseParentHierarchy addTarget:self action:@selector(controllAction:) forControlEvents:UIControlEventValueChanged];
        _traverseParentHierarchy.tag = 100 + 4;
        _traverseParentHierarchy.on = YES;
        [self addSubview:_traverseParentHierarchy];
    }
    return _traverseParentHierarchy;
}
- (UISwitch *)pushParentBack{
    if (!_pushParentBack) {
        _pushParentBack = [[UISwitch alloc] init];
        [_pushParentBack addTarget:self action:@selector(controllAction:) forControlEvents:UIControlEventValueChanged];
        _pushParentBack.tag = 100 + 5;
        _pushParentBack.on = YES;
        [self addSubview:_pushParentBack];
    }
    return _pushParentBack;
}
- (UISwitch *)backgroundView{
    if (!_backgroundView) {
        _backgroundView = [[UISwitch alloc] init];
        [_backgroundView addTarget:self action:@selector(controllAction:) forControlEvents:UIControlEventValueChanged];
        _backgroundView.tag = 100 + 6;
        [self addSubview:_backgroundView];
    }
    return _backgroundView;
}

- (UILabel *)bottomLabel{
    if (!_bottomLabel) {
        _bottomLabel = [[AxcUI_Label alloc] init];
        _bottomLabel.backgroundColor = RGB(239, 239, 244);
        _bottomLabel.font = [UIFont systemFontOfSize:12.8];
        _bottomLabel.text = @"推出View";
        _bottomLabel.textColor = RGB(112, 113, 117);
        _bottomLabel.axcUI_textEdgeInsets = UIEdgeInsetsMake(10,20,5,0);
        [self addSubview:_bottomLabel];
    }
    return _bottomLabel;
}

#pragma mark 说明Label懒加载区
- (AxcInstructionsLabel *)traverseParentHierarchyLabel{
    if (!_traverseParentHierarchyLabel) {
        _traverseParentHierarchyLabel = [[AxcInstructionsLabel alloc] init];
        [self addSubview:_traverseParentHierarchyLabel];
    }
    return _traverseParentHierarchyLabel;
}
- (AxcInstructionsLabel *)pushParentBackLabel{
    if (!_pushParentBackLabel) {
        _pushParentBackLabel = [[AxcInstructionsLabel alloc] init];
        [self addSubview:_pushParentBackLabel];
    }
    return _pushParentBackLabel;
}
- (AxcInstructionsLabel *)backgroundViewLabel{
    if (!_backgroundViewLabel) {
        _backgroundViewLabel = [[AxcInstructionsLabel alloc] init];
        [self addSubview:_backgroundViewLabel];
    }
    return _backgroundViewLabel;
}


- (AxcInstructionsLabel *)animationDurationLabel{
    if (!_animationDurationLabel) {
        _animationDurationLabel = [[AxcInstructionsLabel alloc] init];
        [self addSubview:_animationDurationLabel];
    }
    return _animationDurationLabel;
}
- (AxcInstructionsLabel *)parentAlphaLabel{
    if (!_parentAlphaLabel) {
        _parentAlphaLabel = [[AxcInstructionsLabel alloc] init];
        [self addSubview:_parentAlphaLabel];
    }
    return _parentAlphaLabel;
}
- (AxcInstructionsLabel *)parentScaleLabel{
    if (!_parentScaleLabel) {
        _parentScaleLabel = [[AxcInstructionsLabel alloc] init];
        [self addSubview:_parentScaleLabel];
    }
    return _parentScaleLabel;
}
- (AxcInstructionsLabel *)shadowOpacityLabel{
    if (!_shadowOpacityLabel) {
        _shadowOpacityLabel = [[AxcInstructionsLabel alloc] init];
        [self addSubview:_shadowOpacityLabel];
    }
    return _shadowOpacityLabel;
}



- (AxcInstructionsLabel *)transitionStyleLabel{
    if (!_transitionStyleLabel) {
        _transitionStyleLabel = [[AxcInstructionsLabel alloc] init];
        [self addSubview:_transitionStyleLabel];
    }
    return _transitionStyleLabel;
}

@end

@implementation AxcInstructionsLabel

- (instancetype)init{
    if (self == [super init]) {
        self.font = [UIFont systemFontOfSize:14];
        self.textAlignment = NSTextAlignmentCenter;
        self.textColor = [UIColor whiteColor];
        self.axcUI_Width = 100;
        self.axcUI_Height = 30;
    }
    return self;
}


@end

