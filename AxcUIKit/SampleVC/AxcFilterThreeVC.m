//
//  AxcFilterTwoVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/3.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcFilterThreeVC.h"
#import "AxcFilterTwoCollectionViewCell.h"


@interface AxcFilterThreeVC ()<
UICollectionViewDataSource,
UICollectionViewDelegate,
UICollectionViewDelegateFlowLayout
,UINavigationControllerDelegate
, UIImagePickerControllerDelegate

>


//系统照片选择控制器
@property(nonatomic, strong)UIImagePickerController *imagePickerController;
@property(nonatomic,strong)UIImageView *MainImageView;
@property(nonatomic, strong)UIImage *originalImage; // 原图

@property (nonatomic, strong) UICollectionView *collectionView;
@property(nonatomic, strong)NSArray *titleArray;

@property(nonatomic, strong)UILabel *filterNameLabel;

// 优化：防止重复渲染引起的卡顿现象
@property(nonatomic, strong)NSMutableDictionary *CellImageDic;

@end

@implementation AxcFilterThreeVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.view addSubview:self.MainImageView];
    [self.view addSubview:self.collectionView];
    
    __weak typeof(self) WeakSelf = self;
    [self.filterNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WeakSelf.MainImageView.mas_bottom).offset(10);
        make.centerX.mas_equalTo(0);
    }];
    
    self.instructionsLabel.text = @"涉及到的为图形运算函数，主要以\nvImageConvolve_ARGB8888为主的渲染方式\n更多函数请查阅相关API";
    // 相关函数此扩展中：UIImage+AxcSpecialEffectsDrawing.h
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    self.MainImageView.image = self.originalImage.copy;             // 恢复成原图
    if (indexPath.row != 0) { // 如果选择的不是原图
        // 重写SET传值，无先后顺序，设置即可动态调整  ************************************************
        self.MainImageView.axcUI_imageAlgorithmStyle = indexPath.row - 1;     // 然后设置运算函数
    }
    self.filterNameLabel.text = [NSString stringWithFormat:@"当前函数：%@",self.titleArray[indexPath.row]];
    // 可以如下自行调用
//    self.MainImageView.image = [self.MainImageView.image AxcUI_drawingWithSharpen];
}






- (void)SelectImage{
    [self presentViewController:self.imagePickerController animated:YES completion:nil];
}

#pragma mark - Delegate代理回调区
#pragma mark 图片选择器选择图片代理方法
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //关闭图片选择器
    [self dismissViewControllerAnimated:YES completion:nil];
    //取得选择图片
    UIImage *selectedImage=[info objectForKey:UIImagePickerControllerOriginalImage];
    self.MainImageView.image = selectedImage;
    self.originalImage = selectedImage;
    [self.CellImageDic removeAllObjects];  // 移除所有缓存的渲染图
    [self.collectionView reloadData];
}
#pragma mark - UICollectionViewDataSource 代理委托
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSString *imageKey = [NSString stringWithFormat:@"axc%ld",indexPath.row];
    
    AxcFilterTwoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"axc"
                                                                                     forIndexPath:indexPath];
    cell.backgroundColor = [UIColor AxcUI_ConcreteColor];
    
    if (![self.CellImageDic objectForKey:imageKey]) { // 防止多次重复渲染，选择把渲染过的图片缓存起来
        cell.imageView.image = self.MainImageView.image;
        if (indexPath.row != 0) { // 第一个元素原图
            cell.imageView.axcUI_imageAlgorithmStyle = indexPath.row - 1;
        }
        UIImage *image = cell.imageView.image;
        [self.CellImageDic setValue:image forKey:imageKey];
    }else{      // 取出缓存图，赋值给展示
        UIImage *image = (UIImage *)[self.CellImageDic objectForKey:imageKey];
        cell.imageView.image = image;
    }
    
    cell.titleLabel.text = self.titleArray[indexPath.row];
    
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return  CGSizeMake(100,120);
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(10, 10, 10, 10);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 10;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 5;
}






#pragma mark - 懒加载区
- (UIImageView *)MainImageView{
    if (!_MainImageView) {
        _MainImageView = [[UIImageView alloc] init];
        _MainImageView.axcUI_Size = CGSizeMake(250, 250);
        _MainImageView.axcUI_CenterX = self.view.axcUI_CenterX;
        _MainImageView.axcUI_Y = 100;
        _MainImageView.backgroundColor = [UIColor AxcUI_CloudColor];
        _MainImageView.contentMode = UIViewContentModeScaleAspectFit;
        _MainImageView.image = self.originalImage = [UIImage imageNamed:@"test_5.jpg"];
        _MainImageView.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self
                                                                             action:@selector(SelectImage)];
        [_MainImageView addGestureRecognizer:tap];
    }
    return _MainImageView;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.view.axcUI_Height - 280,
                                                                             self.view.axcUI_Width, 150)
                                             collectionViewLayout:layout];
        _collectionView.bounces = NO;
        _collectionView.backgroundColor = [UIColor AxcUI_CloudColor]; // 预设颜色
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.alwaysBounceVertical = YES;
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        [_collectionView registerNib:[UINib nibWithNibName:@"AxcFilterTwoCollectionViewCell"
                                                    bundle:nil]
          forCellWithReuseIdentifier:@"axc"];
        
    }
    return _collectionView;
}


- (UIImagePickerController *)imagePickerController{
    if (!_imagePickerController) {
        [AxcUI_Toast AxcUI_showCenterWithText:@"正在打开相册..."];
        _imagePickerController=[[UIImagePickerController alloc]init];
        _imagePickerController.delegate =self;
    }
    return _imagePickerController;
}

- (NSMutableDictionary *)CellImageDic{
    if (!_CellImageDic) {
        _CellImageDic = [NSMutableDictionary dictionary];
    }
    return _CellImageDic;
}

- (UILabel *)filterNameLabel{
    if (!_filterNameLabel) {
        _filterNameLabel = [[UILabel alloc] init];
        _filterNameLabel.font = [UIFont systemFontOfSize:14];
        _filterNameLabel.textAlignment = NSTextAlignmentCenter;
        _filterNameLabel.textColor = [UIColor AxcUI_AmethystColor];
        _filterNameLabel.axcUI_Width = 100;
        _filterNameLabel.axcUI_Height = 40;
        _filterNameLabel.text = @"当前函数：原图";
        [self.view addSubview:_filterNameLabel];
    }
    return _filterNameLabel;
}


- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"原图",@"马赛克",@"高斯模糊",@"边缘锐化",@"浮雕",@"锐化",@"进一步锐化",@"膨胀/扩张",@"侵蚀",@"均衡运算"];
    }
    return _titleArray;
}

@end
