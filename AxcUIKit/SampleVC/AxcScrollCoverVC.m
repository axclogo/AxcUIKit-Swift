//
//  AxcScrollCoverVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/3.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcScrollCoverVC.h"


@interface AxcScrollCoverVC ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation AxcScrollCoverVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.automaticallyAdjustsScrollViewInsets = YES;
    [self.view addSubview:self.tableView];
    
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:self.view.frame];
        _tableView.dataSource = self;
        _tableView.delegate = self;
        _tableView.userInteractionEnabled = YES;

        
        UIImageView *headerCoverImageView =[[UIImageView alloc]
                                            initWithImage:[UIImage AxcUI_setImageNamed:@"test_1.jpg"]]; // 根据图片大小选择加载方式
        headerCoverImageView.frame = CGRectMake(0, 0, self.view.frame.size.width, 200);
        headerCoverImageView.backgroundColor = [UIColor AxcUI_CloudColor]; // 预设颜色
        headerCoverImageView.contentMode = UIViewContentModeScaleAspectFill;
        
        // RunTime传值，无先后顺序，设置即可动态调整  ************************************************
        _tableView.axcUI_CoverView = headerCoverImageView;  // 设置下拉放大View
        _tableView.axcUI_AutomaticCoverHeight = YES;        // 是否根据CoverView的高度自适应高度
    }
    return _tableView;
}

// 调用个小动画效果
- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell AxcUI_cellAppearAnimateStyle:AxcCellAppearAnimateStyleRightToLeft indexPath:indexPath];
}

- (NSInteger )tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID=@"cellID";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (cell==nil) {
        cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue2 reuseIdentifier:ID];
    }
    cell.textLabel.text=@"首标题";
    cell.detailTextLabel.text = @"副标题";
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UILabel *label =   [[UILabel alloc] init];
    label.text = @"我是HeaderView";
    label.textColor = [UIColor whiteColor];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor AxcUI_AsbestosColor];
    return label;
}

- (CGFloat )tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
