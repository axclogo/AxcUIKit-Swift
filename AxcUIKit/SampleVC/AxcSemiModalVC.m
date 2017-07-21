//
//  AxcSemiModalVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/4.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcSemiModalVC.h"

#import "AxcSemiModalHeaderView.h"
#import "AxcSemiModalPresentView.h"

#import "AxcSemiModalPresentVC.h"


@interface AxcSemiModalVC ()<
UITableViewDelegate
,UITableViewDataSource
,AxcSemiModalHeaderViewDelegate

>


@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic, strong) NSArray *titleArray;
@property(nonatomic, strong)NSDictionary *options;
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic, strong)AxcSemiModalHeaderView *headerView;
@property(nonatomic, strong)AxcSemiModalPresentView *presentView;

@property(nonatomic, strong)NSArray *subtitleArray;


@end

@implementation AxcSemiModalVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self.view addSubview:self.tableView];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    // NSDictionary字典传参，无先后顺序，设置即可动态调整  ************************************************
    switch (indexPath.section) {
        case 0: // View
            
            switch (indexPath.row) {
                case 0:  // 默认基础方式推出View
                    [self AxcUI_presentSemiView:self.presentView];
                    break;
                case 1:  // 通过设置参数推出View
                    [self AxcUI_presentSemiView:self.presentView
                                    withOptions:self.options];
                    break;
                case 2:  // 通过设置参数推出View + Block回调
                    [self AxcUI_presentSemiView:self.presentView
                                    withOptions:self.options
                                     completion:^{
                                         NSLog(@"回调");
                                     }];
                    break;
                default:
                    break;
            }
            break;
        case 1: // VC
            switch (indexPath.section) {
                case 0:
                    [self AxcUI_presentSemiViewController:[[AxcSemiModalPresentVC alloc] init]];
                    break;
                case 1:
                    [self AxcUI_presentSemiViewController:[[AxcSemiModalPresentVC alloc] init]
                                              withOptions:self.options];
                    break;
                case 2:
                    [self AxcUI_presentSemiViewController:[[AxcSemiModalPresentVC alloc] init]withOptions:self.options
                                               completion:^{
                                                   NSLog(@"VC推出完成");
                                               }
                                             dismissBlock:^{
                                                 NSLog(@"VC 已 Dismiss");
                                             }];
                    break;
                    
                default:
                    break;
            }
            break;
        default:
            break;
    }
}

// 防止循环引用
- (BOOL)AxcUI_navigationShouldPopOnBackButton{
    [self.presentView removeFromSuperview];
    self.presentView = nil;
    return YES;
}


#pragma mark - 代理区
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *Arr = self.dataArray[section];
    return Arr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"axc"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"axc"];
    }
    NSArray *Arr = self.dataArray[indexPath.section];
    cell.textLabel.text = [NSString stringWithFormat:@"%@",Arr[indexPath.row]];
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textColor = [UIColor AxcUI_colorWithHexCode:@"1296db"];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    Arr = self.subtitleArray[indexPath.section];
    cell.detailTextLabel.text = Arr[indexPath.row];
    cell.detailTextLabel.font = [UIFont systemFontOfSize:10];
    cell.detailTextLabel.textColor = [UIColor AxcUI_OrangeColor];
    return cell;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (section) {
        return nil;
    }
    return self.headerView;
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (!section) {
        return 340;
    }
    return 30;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.titleArray[section];
}
- (void)AxcSemiModalHeaderViewOption:(NSDictionary *)option{
    self.options = option;
}

#pragma mark - 懒加载区

- (AxcSemiModalPresentView *)presentView{ // 推出的View
    if (!_presentView) {
        _presentView = [[AxcSemiModalPresentView alloc] initWithFrame:
                        CGRectMake(0, [UIScreen mainScreen].bounds.size.height - 200, [UIScreen mainScreen].bounds.size.width, 200)];
        _presentView.backgroundColor = RGB(116, 225, 186);
    }
    return _presentView;
}

- (AxcSemiModalHeaderView *)headerView{
    if (!_headerView) {
        _headerView = [[AxcSemiModalHeaderView alloc] init];
        _headerView.delegate = self;
    }
    return _headerView;
}
- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray =
        @[@"推出View",@"推出VC"];
    }
    return _titleArray;
}
- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[@[@"默认基础方式推出View",@"通过设置参数推出View",@"通过设置参数推出View + Block回调"],
                       @[@"默认基础方式推出VC",@"通过设置参数推出VC",@"通过设置参数推出VC + Block回调"]];
    }
    return _dataArray;
}
- (NSArray *)subtitleArray{
    if (!_subtitleArray) {
        _subtitleArray = @[@[@"",@"可通过上方控制板设置属性",@"可通过上方控制板设置属性"],@[@"",@"可通过上方控制板设置属性",@"可通过上方控制板设置属性"]];
    }
    return _subtitleArray;
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                  style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 40;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}


@end
