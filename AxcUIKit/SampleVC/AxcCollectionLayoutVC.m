//
//  AxcCollectionLayoutVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/9/8.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcCollectionLayoutVC.h"

#import "AxcLayoutBaseVC.h"


@interface AxcCollectionLayoutVC ()<UITableViewDelegate,UITableViewDataSource,AxcLayoutBaseVC_Delegate>

@property(nonatomic, strong)NSString *titleStr;

@property(nonatomic,strong)NSArray *dataArray;

@property(nonatomic, strong)UITableView *tableView;

@property(nonatomic, strong)AxcLayoutBaseVC *viewController;

@end

@implementation AxcCollectionLayoutVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = YES;

    // 记录标题
    self.titleStr = self.title;
    
    [self AxcCollectionLayoutVC_createUI];
    [self AxcCollectionLayoutVC_requestData];
}





#pragma mark - 数据请求区
- (void)AxcCollectionLayoutVC_requestData{
    
}

#pragma mark - Delegate代理回调区
#pragma mark - 代理区
- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSDictionary *sectionDic = self.dataArray[section];
    NSArray *rowArr = [sectionDic objectForKey:@"data"];
    return rowArr.count;
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Axc"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Axc"];
    }
    NSDictionary *sectionDic = self.dataArray[indexPath.section];
    NSArray *rowArr = [sectionDic objectForKey:@"data"];
    NSDictionary *rowDic = rowArr[indexPath.row];
    
    cell.textLabel.text = [rowDic objectForKey:@"title"];
    cell.textLabel.font = [UIFont systemFontOfSize:14];
    cell.textLabel.textColor = [UIColor AxcUI_colorWithHexCode:@"1296db"];
    return cell;
}
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    NSDictionary *sectionDic = self.dataArray[section];
    return [sectionDic objectForKey:@"header"];
}
- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 20;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self AxcUI_PushSampleVC_WithIndexPath:indexPath];
}

// 推出VC
- (void)AxcUI_PushSampleVC_WithIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *sectionDic = self.dataArray[indexPath.section];
    NSArray *rowArr = [sectionDic objectForKey:@"data"];
    NSDictionary *rowDic = rowArr[indexPath.row];
    NSString *VC_Name = rowDic[@"VCName"];
    if (VC_Name.length) {
        Class class = NSClassFromString(VC_Name);
        self.viewController = [[class alloc]init];
        self.viewController.delegate = self;
        self.viewController.title = rowDic[@"title"];
        self.viewController.navigationItem.prompt = [NSString stringWithFormat:@"示例文件名称: %@",VC_Name];
        [self.navigationController pushViewController:self.viewController animated:YES];
        self.title = @""; // 这样看起来舒服
    }else{  // 嘤嘤嘤做不完了
        [AxcUI_Toast AxcUI_showCenterWithText:@"asdasda"];
    }
}

// 从上一级回来
- (void)clickGoBack{
    self.title = self.titleStr;
    [self empte];
}

// 返回上一级，置空指针
- (BOOL)AxcUI_navigationShouldPopOnBackButton{
    [self empte];
    return YES;
}

#pragma mark - 复用函数
- (void)empte{
    if (self.viewController) {
        self.viewController.delegate = nil;
        self.viewController = nil;
    }
}



#pragma mark - UI设置区
- (void)AxcCollectionLayoutVC_createUI{
    [self.view addSubview:self.tableView];
}




#pragma mark - SET区

#pragma mark - 懒加载区
- (NSArray *)dataArray{
    if (!_dataArray) {
        _dataArray = @[@{@"header":@"单焦点布局",@"data":@[@{@"VCName":@"AxcLineLayoutVC",@"title":@"线性排布"},
                                                      @{@"VCName":@"",@"title":@"卡片排布"},
                                                      @{@"VCName":@"",@"title":@"堆叠排布"}
                                                      
                                                      ]},
                       @{@"header":@"排面布局",@"data":@[@{@"VCName":@"AxcArrangeLayoutVC",@"title":@"左中右排布"},
                                                     @{@"VCName":@"",@"title":@"瀑布流排布"},
                                                     @{@"VCName":@"",@"title":@"奇偶排布"},
                                                     @{@"VCName":@"",@"title":@"环形排布"},
                                                     @{@"VCName":@"",@"title":@"蜂窝排布"},
                                                     @{@"VCName":@"",@"title":@"3D球形排布"}
                                                     
                                                     ]}];
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
