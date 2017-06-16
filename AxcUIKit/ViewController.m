//
//  ViewController.m
//  AxcUIKit
//
//  Created by Axc_5324 on 17/4/19.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "ViewController.h"


#import "SampleBaseVC.h"

@interface ViewController ()<
UITableViewDelegate
,UITableViewDataSource

>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) NSArray *sectionTitleArray;

@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    [self.view addSubview:self.tableView];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO; // 禁用 iOS7 返回手势
}

#pragma mark - 代理区
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *Arr = self.dataArray[section];
    return Arr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.sectionTitleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"axc"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"axc"];
    }
    NSArray *Arr = self.dataArray[indexPath.section];
    NSDictionary *dic = Arr[indexPath.row];
    cell.textLabel.text = [NSString stringWithFormat:@"(%ld)\t%@",indexPath.row + 1,dic[@"controlsName"]];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor AxcUI_colorWithHexCode:@"1296db"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.detailTextLabel.text = dic[@"describeName"];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:15];
    cell.detailTextLabel.textColor = [UIColor AxcUI_colorWithHexCode:@"b0a4e3"];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *Arr = self.dataArray[indexPath.section];
    NSDictionary *dic = Arr[indexPath.row];
    NSString *VC_Name = dic[@"VCName"];
    Class class = NSClassFromString(VC_Name);
    SampleBaseVC *viewController = [[class alloc]init];
    Arr = self.dataArray[indexPath.section];
    dic = Arr[indexPath.row];
    viewController.title = dic[@"describeName"];
    viewController.navigationItem.prompt = [NSString stringWithFormat:@"示例文件名称: %@",dic[@"VCName"]];
    [self.navigationController pushViewController:viewController animated:YES];
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.sectionTitleArray[section];
}
-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section{
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    header.textLabel.textAlignment = NSTextAlignmentCenter;
    header.textLabel.textColor = [UIColor AxcUI_ConcreteColor];
    header.textLabel.font = [UIFont systemFontOfSize:14];
}


#pragma mark - 懒加载
- (NSMutableArray *)dataArray{
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
        NSMutableArray *Group1 = [NSMutableArray array];
        [Group1 addObject:@{@"controlsName":@"View+",@"describeName":@"添加晃动动画",@"VCName":@"AxcViewSharkVC"}];
        [Group1 addObject:@{@"controlsName":@"View+",@"describeName":@"添加文字闪动效果",@"VCName":@"AxcShimmeringViewVC"}];
        [Group1 addObject:@{@"controlsName":@"ImageView+",@"describeName":@"轻量加载图片",@"VCName":@"AxcLoadImageVC"}];
        [Group1 addObject:@{@"controlsName":@"ImageView+",@"describeName":@"添加Progress",@"VCName":@"AxcImageLoaderVC"}];
        [Group1 addObject:@{@"controlsName":@"CollectionView+",@"describeName":@"长摁拖动排序",@"VCName":@"AxcCellRearrangeVC"}];
        [Group1 addObject:@{@"controlsName":@"TableView+",@"describeName":@"下拉放大头图",@"VCName":@"AxcScrollCoverVC"}];
        [Group1 addObject:@{@"controlsName":@"TextField+",@"describeName":@"占位符参数修改",@"VCName":@"AxcModifyPlaceholderVC"}];
        [Group1 addObject:@{@"controlsName":@"ViewController+",@"describeName":@"动画推出View/VC",@"VCName":@"AxcSemiModalVC"}];

        [Group1 addObject:@{@"controlsName":@"测试",@"describeName":@"测试",@"VCName":@"TestTwoVC"}];

        NSMutableArray *Group2 = [NSMutableArray array];
        [Group2 addObject:@{@"controlsName":@"AxcUI_ActivityHUD",@"describeName":@"加载指示器",@"VCName":@"AxcActivityHUDVC"}];
        [Group2 addObject:@{@"controlsName":@"AxcUI_Label",@"describeName":@"动态设置文字边距",@"VCName":@"AxcLabelVC"}];
        [Group2 addObject:@{@"controlsName":@"AxcUI_ProgressView",@"describeName":@"进度指示器",@"VCName":@"AxcProgressViewVC"}];
        [Group2 addObject:@{@"controlsName":@"AxcUI_PhotoBrowser",@"describeName":@"照片浏览器",@"VCName":@"AxcPhotoBrowserVC"}];
        [Group2 addObject:@{@"controlsName":@"AxcUI_Toast",@"describeName":@"弹出式提醒",@"VCName":@"AxcToastVC"}];
        
        [_dataArray addObject:Group1];
        [_dataArray addObject:Group2];
    }
    return _dataArray;
}
- (NSArray *)sectionTitleArray{
    if (!_sectionTitleArray) {
        _sectionTitleArray = @[@"扩展类",@"控件类"];
    }
    return _sectionTitleArray;
}
- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame];
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (void)viewWillAppear:(BOOL)animated{
    self.title = @"AxcUIKit Sample";
}
- (void)viewWillDisappear:(BOOL)animated{
    self.title = @"";
}

@end
