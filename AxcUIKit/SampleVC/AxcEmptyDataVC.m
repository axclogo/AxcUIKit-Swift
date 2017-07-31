//
//  AxcEmptyDataVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/11.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcEmptyDataVC.h"
#import "AxcEmptyDataPlaceholderView.h"

#import "AxcEmptyDataTableView.h"
#import "AxcEmptyDataTableView+AxcEmptyData.h"


@interface AxcEmptyDataVC ()<UITableViewDelegate,UITableViewDataSource>


@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)NSMutableArray *strDataArray;
@property(nonatomic,strong)AxcEmptyDataTableView *tableView;
// 占位View
@property(nonatomic, strong)AxcEmptyDataPlaceholderView *placeholderView;
@end

@implementation AxcEmptyDataVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.dataArray = @[]; // 初次展示默认空集
    
    [self.view addSubview:self.tableView];
    
    [self AxcBase_addRightBarButtonItems:@[@"空集",@"有数据"]];
    
    // 重写SET传值，无先后顺序，设置即可动态调整  ************************************************
    // 设置空集时候展示的View
    self.tableView.axcUI_placeHolderView = self.placeholderView;
    
    //  默认YES 自带渐入渐出动画效果，下边这个参数可以关闭
//    self.tableView.axcUI_placeHolderViewAnimations = NO;
    
    // 占位View的“重新加载”按钮的Block回调:
    __weak typeof(self) WeakSelf = self;
    self.placeholderView.clickLoadBtnBlock = ^{
        WeakSelf.dataArray = nil;
        [WeakSelf.tableView reloadData];
    };

    self.instructionsLabel.text = @"此示例实现修改为继承一个TableView类，然后添加类函数，防止因为重写系统TableView函数造成的隐患问题\n另外考虑到框架的全局性，此实现方案已排除在框架之外，仅算是实现示例";
    
}

- (void)AxcBase_clickRightItems:(UIBarButtonItem *)sender{
    switch (sender.tag - 5324) {
        case 0:self.dataArray = @[];break;
        case 1:self.dataArray = nil;break;
        default: break; }
    [self.tableView reloadData];
}


#pragma mark - 代理区
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell AxcUI_cellAppearAnimateStyle:AxcCellAppearAnimateStyleRightToLeft indexPath:indexPath];
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.textLabel.text = self.strDataArray[arc4random()%self.strDataArray.count];
    cell.textLabel.textColor = [UIColor AxcUI_colorWithHexCode:@"1296db"];
    cell.textLabel.font = [UIFont systemFontOfSize:13];

    cell.detailTextLabel.text = self.strDataArray[indexPath.row];
    cell.detailTextLabel.textColor = [UIColor AxcUI_colorWithHexCode:@"b0a4e3"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:12];
    cell.detailTextLabel.numberOfLines = 0;
    cell.imageView.image = [UIImage AxcUI_setImageNamed:self.dataArray[indexPath.row]];
    return cell;
}
- (CGFloat )tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSString *str = self.strDataArray[indexPath.row];
    CGFloat width = [str AxcUI_widthWithStringFontSize:12];
    CGFloat difference = SCREEN_WIDTH - 70;
    if (width > difference) {
        NSInteger heightMultiple = width / difference;
        return  heightMultiple * 30 + 30;
    }
    return 50;
}


#pragma mark - 懒加载区
- (AxcEmptyDataPlaceholderView *)placeholderView{
    if (!_placeholderView) {
        _placeholderView = [[AxcEmptyDataPlaceholderView alloc] init];
        _placeholderView.frame = self.tableView.bounds;
    }
    return _placeholderView;
}

- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = SmallIconImages;
    }
    return _dataArray;
}
- (NSMutableArray *)strDataArray{
    if (!_strDataArray) {
        _strDataArray = [NSMutableArray array];
        for (NSString *str in self.dataArray) {
            if (str) { // 消除警告就用一下吧 =。=
                [_strDataArray addObject:ArcStrArray[arc4random()%ArcStrArray.count]];
            }
        }
    }
    return _strDataArray;
}

- (AxcEmptyDataTableView *)tableView{
    if (!_tableView) {
        _tableView = [[AxcEmptyDataTableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}


@end
