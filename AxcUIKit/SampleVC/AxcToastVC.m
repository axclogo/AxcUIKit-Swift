//
//  ViewController.m
//  AxcUI_Toast
//
//  Created by Axc on 2017/6/2.
//  Copyright © 2017年 Axc. All rights reserved.
//

#import "AxcToastVC.h"


@interface AxcToastVC ()<
UITableViewDelegate,
UITableViewDataSource
>


@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong)NSArray *dataArray;
@property(nonatomic,strong)NSArray *titleArray;
@property(nonatomic,assign)CGFloat showTime;

@end

@implementation AxcToastVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    self.showTime = 1;
    [self.view addSubview:self.tableView];
}

#pragma mark - 逻辑触发区
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *arr = self.dataArray[indexPath.section];
    NSString *showText = arr[indexPath.row];
    switch (indexPath.section) {
            // 随时可以调用，方便调试时查看各项参数 ************************************************
        case 0: // 顶部
            switch (indexPath.row) {
                case 0:[AxcUI_Toast AxcUI_showTopWithText:showText];break;
                case 1:[AxcUI_Toast AxcUI_showTopWithText:showText duration:_showTime];break;
                case 2:[AxcUI_Toast AxcUI_showTopWithText:showText topOffset:100];break;
                case 3:[AxcUI_Toast AxcUI_showTopWithText:showText topOffset:100 duration:_showTime];break;
                default:break;
            }
            break;
        case 1: // 中部
            switch (indexPath.row) {
                case 0:[AxcUI_Toast AxcUI_showCenterWithText:showText];break;
                case 1:[AxcUI_Toast AxcUI_showCenterWithText:showText duration:_showTime];break;
                default:break;
            }
            break;
        case 2: // 下部
            switch (indexPath.row) {
                case 0:[AxcUI_Toast AxcUI_showBottomWithText:showText];break;
                case 1:[AxcUI_Toast AxcUI_showBottomWithText:showText duration:_showTime];break;
                case 2:[AxcUI_Toast AxcUI_showBottomWithText:showText bottomOffset:100];break;
                case 3:[AxcUI_Toast AxcUI_showBottomWithText:showText bottomOffset:100 duration:_showTime];break;
                default:break;
            }
            break;
            
        default:break;
    }
}


#pragma mark - 代理区
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *arr = self.dataArray[section];
    return arr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.titleArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Axc"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Axc"];
    }
    NSArray *arr = self.dataArray[indexPath.section];
    cell.textLabel.text = arr[indexPath.row];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor AxcUI_colorWithHexCode:@"1296db"];
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    return self.titleArray[section];
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}
#pragma mark - 懒加载区

- (NSArray *)titleArray{
    if (!_titleArray) {
        _titleArray = @[@"上方显示",@"中间显示",@"下方显示"];
    }
    return _titleArray;
}

- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[@[@"上方显示",@"上方显示+自定义停留时间",@"上方显示+自定义距顶端距离",@"上方显示+自定义距顶端距离+自定义停留时间"],
                       @[@"中间显示",@"中间显示+自定义停留时间"],
                       @[@"下方显示",@"下方显示+自定义停留时间",@"下方显示+自定义距底端距离",@"下方显示+自定义距底端距离+自定义停留时间"]];
    }
    return _dataArray;
}


- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds
                                                  style:UITableViewStyleGrouped];
        _tableView.axcUI_Y = _tableView.axcUI_Y + 10;
        _tableView.axcUI_Height = _tableView.axcUI_Height - 10;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 40;
        _tableView.tableFooterView = [UIView new];
    }
    return _tableView;
}



@end
