//
//  AxcQRCodeVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/29.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcQRCodeVC.h"


@interface AxcQRCodeVC ()


@property(nonatomic, assign)CGFloat QRCodeSideLength;
@property(nonatomic, strong)NSArray *MsgArr;
@property(nonatomic, strong)NSString *QRCodeMsg;
@property(nonatomic, strong)UIColor *QRColor;

@property(nonatomic, strong)UIImageView *qrImageView;

@property(nonatomic, strong)UIButton *ModifyOneBtn;
@property(nonatomic, strong)UIButton *ModifyTwoBtn;
@property(nonatomic, strong)UIButton *ModifyThreeBtn;

@end

@implementation AxcQRCodeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    self.QRCodeSideLength = 200 ;
    self.QRCodeMsg = [self.MsgArr firstObject];
    self.QRColor = [UIColor AxcUI_ArcColor];
    
    
    
    [self autoLayout];
    self.instructionsLabel.text = @"使用类函数入参传值\n只能每次执行一遍该函数才会进行绘制二维码";
    
}




// 类参传值，只能每次执行来达到动态调整  ************************************************
- (void)click_ModifyOneBtn{
    self.QRColor = [UIColor AxcUI_ArcColor];
    self.qrImageView.image = [UIImage AxcUI_codeImageWithString:self.QRCodeMsg
                                                           size:self.QRCodeSideLength
                                                          color:self.QRColor];
}
- (void)click_ModifyTwoBtn{
    self.QRCodeMsg = [self.MsgArr objectAtIndex:arc4random()%self.MsgArr.count];
    self.qrImageView.image = [UIImage AxcUI_codeImageWithString:self.QRCodeMsg
                                                           size:self.QRCodeSideLength
                                                          color:self.QRColor];
}
- (void)click__ModifyThreeBtn{
    self.qrImageView.image = [UIImage AxcUI_codeImageWithString:self.QRCodeMsg
                                                           size:self.QRCodeSideLength
                                                          color:self.QRColor
                                                           icon:[UIImage imageNamed:@"found_icons_4"]
                                                      iconWidth:30];
}





- (void)autoLayout{
    [self.view addSubview:self.qrImageView];
    [self.qrImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(100);
        make.centerX.mas_equalTo(0);
    }];
    
    
    __weak typeof(self) WeakSelf = self;
    [self.ModifyOneBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(WeakSelf.qrImageView.mas_bottom).offset(10);
        make.height.mas_equalTo(44);
    }];
    [self.ModifyTwoBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(WeakSelf.ModifyOneBtn.mas_bottom).offset(10);
        make.height.mas_equalTo(44);
    }];
    [self.ModifyThreeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(20);
        make.right.mas_equalTo(-20);
        make.top.mas_equalTo(WeakSelf.ModifyTwoBtn.mas_bottom).offset(10);
        make.height.mas_equalTo(44);
    }];
}


#pragma mark - 懒加载
- (UIButton *)ModifyThreeBtn{
    if (!_ModifyThreeBtn) {
        _ModifyThreeBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 250, 30)];
        [_ModifyThreeBtn setTitle:@"点击添加头像/Logo" forState:UIControlStateNormal];
        [_ModifyThreeBtn setTitleColor:[UIColor AxcUI_BelizeHoleColor] forState:UIControlStateNormal];
        _ModifyThreeBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _ModifyThreeBtn.backgroundColor = [UIColor AxcUI_CloudColor];
        _ModifyThreeBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_ModifyThreeBtn addTarget:self action:@selector(click__ModifyThreeBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_ModifyThreeBtn];
    }
    return _ModifyThreeBtn;
}
- (UIButton *)ModifyTwoBtn{
    if (!_ModifyTwoBtn) {
        _ModifyTwoBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 250, 30)];
        [_ModifyTwoBtn setTitle:@"点击修改二维码信息" forState:UIControlStateNormal];
        [_ModifyTwoBtn setTitleColor:[UIColor AxcUI_BelizeHoleColor] forState:UIControlStateNormal];
        _ModifyTwoBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _ModifyTwoBtn.backgroundColor = [UIColor AxcUI_CloudColor];
        _ModifyTwoBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_ModifyTwoBtn addTarget:self action:@selector(click_ModifyTwoBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_ModifyTwoBtn];
    }
    return _ModifyTwoBtn;
}
- (UIButton *)ModifyOneBtn{
    if (!_ModifyOneBtn) {
        _ModifyOneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 250, 30)];
        [_ModifyOneBtn setTitle:@"点击修改二维码颜色" forState:UIControlStateNormal];
        [_ModifyOneBtn setTitleColor:[UIColor AxcUI_BelizeHoleColor] forState:UIControlStateNormal];
        _ModifyOneBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        _ModifyOneBtn.backgroundColor = [UIColor AxcUI_CloudColor];
        _ModifyOneBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        [_ModifyOneBtn addTarget:self action:@selector(click_ModifyOneBtn) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_ModifyOneBtn];
    }
    return _ModifyOneBtn;
}
- (UIImageView *)qrImageView{
    if (!_qrImageView) {
        UIImage *qrCodeImage = [UIImage AxcUI_codeImageWithString:self.QRCodeMsg
                                                             size:self.QRCodeSideLength
                                                            color:[UIColor AxcUI_EmeraldColor]];
        _qrImageView = [[UIImageView alloc]initWithImage:qrCodeImage];
        _qrImageView.center = self.view.center;
        _qrImageView.axcUI_Y = _qrImageView.axcUI_Y - 100;
        _qrImageView.layer.cornerRadius = 5;
        _qrImageView.layer.masksToBounds = YES;
        _qrImageView.layer.borderWidth = 1;
        _qrImageView.layer.borderColor =[ [UIColor grayColor] CGColor];
        _qrImageView.axcUI_Size = CGSizeMake(self.QRCodeSideLength, self.QRCodeSideLength);
    }
    return _qrImageView;
}
- (NSArray *)MsgArr{
    if (!_MsgArr) {
        _MsgArr = @[@"https://github.com/axclogo/AxcUIKit-Sample",
                    @"https://github.com/axclogo/AxcUIKit-Sample/tree/master/AxcUIKit.xcodeproj",
                    @"https://github.com/axclogo/AxcUIKit-Sample/blob/master/README.md",
                    @"https://www.baidu.com/",
                    @"https://www.google.se/?gfe_rd=cr&ei=8RAxWd-FMsH18AeyvreoCw",
                    @"http://app.cnmo.com/android/4090/gonglue_f424056.html",
                    @"http://blog.csdn.net/kaitiren/article/details/38513715"];
    }
    return _MsgArr;
}

@end
