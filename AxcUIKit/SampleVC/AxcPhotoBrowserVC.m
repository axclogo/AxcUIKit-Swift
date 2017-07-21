//
//  AxcPhotoBrowserVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/7.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcPhotoBrowserVC.h"

#import "AxcPhotoBrowserCollectionViewCell.h"


@interface AxcPhotoBrowserVC ()
<UICollectionViewDelegate
,UICollectionViewDataSource
,UICollectionViewDelegateFlowLayout
,AxcPhotoBrowserDelegate

>
@property (nonatomic, strong) UISegmentedControl *progressSegmented;
@property (nonatomic, strong) UILabel *segmentedLabel;
@property (nonatomic, strong) UIButton *clearCacheButton;



@property(nonatomic,strong)UICollectionView *collectionView;
@property(nonatomic, strong)NSArray *dataArray;

@end

@implementation AxcPhotoBrowserVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.progressSegmented];
    [self.view addSubview:self.segmentedLabel];
    [self.view addSubview:self.clearCacheButton];
    
    self.instructionsLabel.text = @"上方分栏控制器可控制加载指示器风格，与扩展类添加进度指示器演示相同。\n具体设置参数请参照‘AxcUI_PhotoBrowser.h’\nProgress相关扩展也在其中，与类方法相同的设置即可使用";
}

#pragma mark - 业务逻辑
- (void)AxcUI_photoBrowser:(AxcUI_PhotoBrowser *)browser
              saveTypeMode:(AxcPhotoBrowserSaveStyle)saveTypeMode
                     Image:(UIImage *)saveImage{
    // 当图片发生互动（长摁/按钮）保存时发生的回调。saveTypeMode根据之前设定的互动模式来反馈相应的操作
    if (saveTypeMode == AxcPhotoBrowserStyleLongTapSave) {
        NSLog(@"长摁");
    }else{
        NSLog(@"按钮");
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    AxcPhotoBrowserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"axc"
                                                                                        forIndexPath:indexPath];
    // 使用初始化和重写SET方法，设置即可调用，无先后顺序，设置即可动态调整  ************************************************
    AxcUI_PhotoBrowser *browser = [[AxcUI_PhotoBrowser alloc] init];
    browser.axcUI_sourceImagesContainerView = self.view;                        // 设置父视图
    browser.axcUI_imageCount = self.dataArray.count;                            // 设置图片总数
    browser.axcUI_currentImageIndex = (int )indexPath.row;                      // 设置当前索引
    browser.axcUI_photoBrowserDelegate = self;                                  // 设置代理回调
    browser.axcUI_convertRectView = cell;                                       // 设置扩展动画/放大效果的View
    browser.axcUI_progressSize = CGSizeMake(70, 70);                            // 设置加载指示器大小
    browser.axcUI_progressViewStyle = self.progressSegmented.selectedSegmentIndex;    // 设置加载指示器风格
    browser.axcUI_pageTypeMode = AxcPhotoBrowserPageControlStyleNumPage;                                // 设置索引展示模式
    browser.axcUI_saveType = AxcPhotoBrowserStyleButtonSave;                     // 设置互动模式：按钮保存/长摁保存
                                                                                // 如果带有高度适配参数则需要调整适应
    browser.axcUI_automaticallyAdjustsScrollViewInsets = self.automaticallyAdjustsScrollViewInsets;
    [browser AxcUI_show];                                                       // 展示
}


#pragma mark - AxcUI_photoBrowser 代理区
- (UIImage *)AxcUI_photoBrowser:(AxcUI_PhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index{
    // 返回当前索引的placeholderImage，这里使用小图加载的缓存作为占位
    return [Axc_WebimageCache AxcUI_getAxcImageWithCacheKey:self.dataArray[index]];
}
- (NSURL *)AxcUI_photoBrowser:(AxcUI_PhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index{
    // 返回当前索引的高清图
    NSString *HDurlStr = [self.dataArray[index] stringByReplacingOccurrencesOfString:@"thumbnail" withString:@"bmiddle"];
    // 替换关键字来实现高清/动图的加载
    return [NSURL URLWithString:HDurlStr];
}

#pragma mark ------------other
- (void)click_clearCacheButton{
    [Axc_WebimageCache AxcUI_imageCachePurge];
    [self.collectionView reloadData];
    [AxcUI_Toast AxcUI_showCenterWithText:@"释放缓存成功！"];
}



#pragma mark - collectionView 代理区
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    AxcPhotoBrowserCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"axc"
                                                                                        forIndexPath:indexPath];
    [cell.imageView AxcUI_queueSetImageWithURL:_dataArray[indexPath.row]
                              placeholderImage:@"placeholder.jpg"];
    
    return cell;
}
#pragma mark - 懒加载
- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[@"http://ww2.sinaimg.cn/thumbnail/904c2a35jw1emu3ec7kf8j20c10epjsn.jpg",
                       @"http://ww2.sinaimg.cn/thumbnail/98719e4agw1e5j49zmf21j20c80c8mxi.jpg",
                       @"http://ww2.sinaimg.cn/thumbnail/67307b53jw1epqq3bmwr6j20c80axmy5.jpg",
                       @"http://ww2.sinaimg.cn/thumbnail/9ecab84ejw1emgd5nd6eaj20c80c8q4a.jpg",
                       @"http://ww2.sinaimg.cn/thumbnail/642beb18gw1ep3629gfm0g206o050b2a.gif",
                       @"http://ww1.sinaimg.cn/thumbnail/9be2329dgw1etlyb1yu49j20c82p6qc1.jpg",
                       @"http://ww4.sinaimg.cn/thumbnail/62faf073jw1ds4rt49wbqg.gif",
                       @"http://ww4.sinaimg.cn/thumbnail/e7811e72gw1f203mg21mkj21390qotcj.jpg",
                       @"http://ww4.sinaimg.cn/thumbnail/62d6e23fjw1f7xsos68euj20ku0v8419.jpg"];
    } // bmiddle
    // large
    return _dataArray;
}
- (UIButton *)clearCacheButton{
    if (!_clearCacheButton) {
        _clearCacheButton = [[UIButton alloc] initWithFrame:CGRectMake(10, self.view.axcUI_Height - 160,
                                                                       self.view.axcUI_Width - 20, 40)];
        [_clearCacheButton addTarget:self action:@selector(click_clearCacheButton) forControlEvents:UIControlEventTouchUpInside];
        [_clearCacheButton setTitle:@"释放图片遗留缓存" forState:UIControlStateNormal];
        [_clearCacheButton setTitleColor:[UIColor AxcUI_CloudColor] forState:UIControlStateNormal];
        _clearCacheButton.backgroundColor = [UIColor AxcUI_EmeraldColor];
        _clearCacheButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _clearCacheButton;
}
- (UILabel *)segmentedLabel{
    if (!_segmentedLabel) {
        _segmentedLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.view.axcUI_Height - 260,
                                                                    self.view.axcUI_Width - 20, 30)];
        _segmentedLabel.font = [UIFont systemFontOfSize:14];
        _segmentedLabel.textColor = [UIColor AxcUI_OrangeColor];
        _segmentedLabel.textAlignment = NSTextAlignmentCenter;
        _segmentedLabel.text = @"选择图片浏览器中加载图片的风格";
    }
    return _segmentedLabel;
}
- (UISegmentedControl *)progressSegmented{
    if (!_progressSegmented) {
        _progressSegmented = [[UISegmentedControl alloc] initWithItems:@[@"透明饼图",
                                                                       @"实心饼图",
                                                                       @"循环圆框",
                                                                       @"填充球体",
                                                                       @"加载模式",
                                                                       @"同心循环"]];
        _progressSegmented.frame = CGRectMake(10, self.view.axcUI_Height - 220,
                                                self.view.axcUI_Width - 20, 30);
        _progressSegmented.selectedSegmentIndex = 0;
    }
    return _progressSegmented;
}
- (UICollectionView *)collectionView{
    if (!_collectionView) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionVertical;
        flowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        flowLayout.itemSize = CGSizeMake(100, 100);
        _collectionView = [[UICollectionView alloc] initWithFrame:self.view.bounds collectionViewLayout:flowLayout];
        _collectionView.axcUI_Height = _collectionView.axcUI_Height - 270;
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor AxcUI_CloudColor];
        [self.view addSubview:_collectionView];
        [_collectionView registerNib:[UINib nibWithNibName:@"AxcPhotoBrowserCollectionViewCell"
                                                    bundle:nil]
          forCellWithReuseIdentifier:@"axc"];
    }
    return _collectionView;
}





@end
