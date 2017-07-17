//
//  AxcLabelVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/4.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcLabelVC.h"


@interface AxcLabelVC ()


@property(nonatomic, strong)AxcUI_Label *axcLabel;

@property(nonatomic, strong)UISlider *topSlider;
@property(nonatomic, strong)UISlider *leftSlider;
@property(nonatomic, strong)UISlider *rightSlider;
@property(nonatomic, strong)UISlider *bottomSlider;

@property(nonatomic, strong)UILabel *labelTextTop;
@property(nonatomic, strong)UILabel *labelTextLeft;
@property(nonatomic, strong)UILabel *labelTextRight;
@property(nonatomic, strong)UILabel *labelTextBottom;

@property(nonatomic, assign)CGFloat height;

@end

@implementation AxcLabelVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    _height = 340;
    
    [self.view addSubview:self.axcLabel];
    
    [self.view addSubview:self.topSlider];
    [self.view addSubview:self.leftSlider];
    [self.view addSubview:self.rightSlider];
    [self.view addSubview:self.bottomSlider];
    
    self.labelTextTop.text = @"文字距Label的Top边距";
    self.labelTextLeft.text = @"文字距Label的Left边距";
    self.labelTextRight.text = @"文字距Label的Right边距";
    self.labelTextBottom.text = @"文字距Label的Bottom边距";
    
    self.instructionsLabel.text = @"每次改变参数后都会调用setNeedsDisplay方法，\n一般在初始化的时候根据UI设计图设置好文字边距即可";
}

- (void)controllAction:(UISlider *)sender{
    UIEdgeInsets textEdgeInsets = self.axcLabel.axcUI_textEdgeInsets;
    switch (sender.tag - 100) {
        // 调用setNeedsDisplay和重写STE & drawTextInRect，无先后顺序，设置即可动态调整  ************************************************
        case 0: // top
            self.axcLabel.axcUI_textEdgeInsets = UIEdgeInsetsMake(sender.value,
                                                                  textEdgeInsets.left,
                                                                  textEdgeInsets.bottom,
                                                                  textEdgeInsets.right);
            break;
        case 1: // left
            self.axcLabel.axcUI_textEdgeInsets = UIEdgeInsetsMake(textEdgeInsets.top,
                                                                  sender.value,
                                                                  textEdgeInsets.bottom,
                                                                  textEdgeInsets.right);
            break;
        case 2: // right
            self.axcLabel.axcUI_textEdgeInsets = UIEdgeInsetsMake(textEdgeInsets.top,
                                                                  textEdgeInsets.left,
                                                                  textEdgeInsets.bottom,
                                                                  sender.value);
            break;
        case 3: // bottom
            self.axcLabel.axcUI_textEdgeInsets = UIEdgeInsetsMake(textEdgeInsets.top,
                                                                  textEdgeInsets.left,
                                                                  sender.value,
                                                                  textEdgeInsets.right);
            break;
            
        default:
            break;
    }
    
}

#pragma mark - 懒加载
- (AxcUI_Label *)axcLabel{
    if (!_axcLabel) {
        _axcLabel = [[AxcUI_Label alloc] initWithFrame:CGRectMake(50, 100, self.view.axcUI_Width - 100, 250)];
        _axcLabel.backgroundColor = [UIColor AxcUI_CloudColor];
        _axcLabel.font = [UIFont systemFontOfSize:14];
        _axcLabel.text = @"setNeedsDisplay,主要是为了绘图而存在的，每次调用它，会标记为这个view需要重新绘制，在下次绘制周期中，会调用drawRect方法来绘制我们的视图，还可以通过setNeedsDisplayInRect(rect: CGRect)这个函数来指定重新绘制的rect";
        _axcLabel.textColor = [UIColor AxcUI_AsbestosColor];
        _axcLabel.numberOfLines = 0;
    }
    return _axcLabel;
}


- (UISlider *)bottomSlider{
    if (!_bottomSlider) {
        _bottomSlider = [[UISlider alloc] initWithFrame:CGRectMake(10,220 + _height, self.view.axcUI_Width - 20, 30)];
        [_bottomSlider addTarget:self action:@selector(controllAction:) forControlEvents:UIControlEventValueChanged];
        _bottomSlider.minimumValue = 0;
        _bottomSlider.maximumValue = 100;
        _bottomSlider.value = 0;
        _bottomSlider.tag = 100 + 3;
    }
    return _bottomSlider;
}
- (UILabel *)labelTextBottom{
    if (!_labelTextBottom) {
        _labelTextBottom = [[UILabel alloc] initWithFrame:CGRectMake(10,190 + _height, self.view.axcUI_Width - 20, 30)];
        _labelTextBottom.font = [UIFont systemFontOfSize:14];
        _labelTextBottom.textColor = [UIColor AxcUI_OrangeColor];
        _labelTextBottom.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_labelTextBottom];
    }
    return _labelTextBottom;
}
- (UISlider *)rightSlider{
    if (!_rightSlider) {
        _rightSlider = [[UISlider alloc] initWithFrame:CGRectMake(10,160 + _height, self.view.axcUI_Width - 20, 30)];
        [_rightSlider addTarget:self action:@selector(controllAction:) forControlEvents:UIControlEventValueChanged];
        _rightSlider.minimumValue = 0;
        _rightSlider.maximumValue = 100;
        _rightSlider.value = 0;
        _rightSlider.tag = 100 + 2;
    }
    return _rightSlider;
}
- (UILabel *)labelTextRight{
    if (!_labelTextRight) {
        _labelTextRight = [[UILabel alloc] initWithFrame:CGRectMake(10,130 + _height, self.view.axcUI_Width - 20, 30)];
        _labelTextRight.font = [UIFont systemFontOfSize:14];
        _labelTextRight.textColor = [UIColor AxcUI_OrangeColor];
        _labelTextRight.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_labelTextRight];
    }
    return _labelTextRight;
}
- (UISlider *)leftSlider{
    if (!_leftSlider) {
        _leftSlider = [[UISlider alloc] initWithFrame:CGRectMake(10,100 + _height, self.view.axcUI_Width - 20, 30)];
        [_leftSlider addTarget:self action:@selector(controllAction:) forControlEvents:UIControlEventValueChanged];
        _leftSlider.minimumValue = 0;
        _leftSlider.maximumValue = 100;
        _leftSlider.value = 0;
        _leftSlider.tag = 100 + 1;
    }
    return _leftSlider;
}
- (UILabel *)labelTextLeft{
    if (!_labelTextLeft) {
        _labelTextLeft = [[UILabel alloc] initWithFrame:CGRectMake(10,70 + _height, self.view.axcUI_Width - 20, 30)];
        _labelTextLeft.font = [UIFont systemFontOfSize:14];
        _labelTextLeft.textColor = [UIColor AxcUI_OrangeColor];
        _labelTextLeft.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_labelTextLeft];
    }
    return _labelTextLeft;
}
- (UISlider *)topSlider{
    if (!_topSlider) {
        _topSlider = [[UISlider alloc] initWithFrame:CGRectMake(10,40 + _height, self.view.axcUI_Width - 20, 30)];
        [_topSlider addTarget:self action:@selector(controllAction:) forControlEvents:UIControlEventValueChanged];
        _topSlider.minimumValue = 0;
        _topSlider.maximumValue = 100;
        _topSlider.value = 0;
        _topSlider.tag = 100 + 0;
    }
    return _topSlider;
}
- (UILabel *)labelTextTop{
    if (!_labelTextTop) {
        _labelTextTop = [[UILabel alloc] initWithFrame:CGRectMake(10,10 + _height , self.view.axcUI_Width - 20, 30)];
        _labelTextTop.font = [UIFont systemFontOfSize:14];
        _labelTextTop.textColor = [UIColor AxcUI_OrangeColor];
        _labelTextTop.textAlignment = NSTextAlignmentCenter;
        [self.view addSubview:_labelTextTop];
    }
    return _labelTextTop;
}






@end
