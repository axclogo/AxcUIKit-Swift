//
//  ViewController.m
//  AxcUIKit
//
//  Created by Axc_5324 on 17/4/19.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "ViewController.h"


#import "SampleBaseVC.h"

#import "PYSearch.h" // 导入搜索成品控件(稍微经过AxcUIKit美化了下)

#define NO_SearchEesults @"没有搜索结果哟~"

@interface ViewController ()<
UITableViewDelegate
,UITableViewDataSource
,PYSearchViewControllerDelegate
>

@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property(nonatomic, strong) NSArray *sectionTitleArray;
@property(nonatomic, strong) NSMutableArray *controlsNameArray;
@property(nonatomic, strong) NSArray *recommendArray;

@end

@implementation ViewController

- (void)viewDidLoad{
    [super viewDidLoad];
    
    
    [self.view addSubview:self.tableView];
    self.navigationController.interactivePopGestureRecognizer.enabled = NO; // 禁用 iOS7 返回手势
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                                         target:self
                                                                                         action:@selector(clickRightSearchBtn)];
}
// 点击了搜索
- (void)clickRightSearchBtn{
    __weak typeof(self) WeakSelf = self;
    PYSearchViewController *searchViewController = [PYSearchViewController
     searchViewControllerWithHotSearches:self.recommendArray
     searchBarPlaceholder:@"搜索相关示例"
     didSearchBlock:^(PYSearchViewController *searchViewController,
                      UISearchBar *searchBar,
                      NSString *searchText) {
         if (searchText.length < 15) { // 手动搜索
             [WeakSelf AxcUI_ShowToast_WithSearchText:searchText
                             SearchViewController:searchViewController];
         }else{ // 全文搜索
             [WeakSelf AxcUI_SearchVC_WithText:searchText];
         }
     }];
    searchViewController.hotSearchStyle = PYHotSearchStyleColorfulTag;
    searchViewController.searchHistoryStyle = PYSearchHistoryStyleColorfulTag;
    searchViewController.delegate = self;
    [self.navigationController pushViewController:searchViewController animated:YES];
}



#pragma mark - PYSearchViewControllerDelegate
- (void)searchViewController:(PYSearchViewController *)searchViewController
         searchTextDidChange:(UISearchBar *)seachBar
                  searchText:(NSString *)searchText{
    [self AxcUI_ShowToast_WithSearchText:searchText
                    SearchViewController:searchViewController];
}
- (void)searchViewController:(PYSearchViewController *)searchViewController
   didSelectHotSearchAtIndex:(NSInteger)index
                  searchText:(NSString *)searchText{
    [self AxcUI_ShowToast_WithSearchText:searchText
                    SearchViewController:searchViewController];
}
- (void)searchViewController:(PYSearchViewController *)searchViewController
didSelectSearchHistoryAtIndex:(NSInteger)index
                  searchText:(NSString *)searchText{
    [self AxcUI_ShowToast_WithSearchText:searchText
                    SearchViewController:searchViewController];
}
- (void)didClickCancel:(PYSearchViewController *)searchViewController{
    if (searchViewController.searchBar.text.length) {
        searchViewController.searchBar.text = @"";
        searchViewController.searchSuggestions = [NSArray array];
    }else{
        [searchViewController.navigationController popViewControllerAnimated:YES];
    }
    
}
#pragma mark - 复用函数
// 添加提示
- (void)AxcUI_ShowToast_WithSearchText:(NSString *)searchText
                  SearchViewController:(PYSearchViewController *)searchViewController{
    if (searchText.length) {
        NSArray *searchSuggestionsM = [self AxcUI_ArrangementVC_WithText:searchText];
        if (!searchSuggestionsM.count) {
            [AxcUI_Toast AxcUI_showCenterWithText: NO_SearchEesults];
            return;
        }
        searchViewController.searchSuggestions = searchSuggestionsM;
    }
}

// 排列出所有结果
- (NSArray *)AxcUI_ArrangementVC_WithText:(NSString *)searchText{
    NSMutableArray *searchSuggestionsM = [NSMutableArray array];
    for (NSDictionary *searchDic in self.controlsNameArray) {
        NSString *name = searchDic[@"name"];
        // 谓词搜索，不区分大小写
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self contains [cd] %@",searchText];
        if ([@[name] filteredArrayUsingPredicate:predicate].count) {
            [searchSuggestionsM addObject:name];
        }else if ([name rangeOfString:searchText].location != NSNotFound) {
            [searchSuggestionsM addObject:name];
        }
    }
    return searchSuggestionsM;
}
// 搜索VC
- (void)AxcUI_SearchVC_WithText:(NSString *)searchText{
    for (NSDictionary *searchDic in self.controlsNameArray) {
        NSString *name = searchDic[@"name"];
        if ([name isEqualToString:searchText]) {
            NSInteger section = [searchDic[@"section"] intValue];
            NSInteger row = [searchDic[@"row"] intValue];
            [self AxcUI_PushSampleVC_WithIndexPath:[NSIndexPath indexPathForRow:row
                                                                      inSection:section]];
            break;
        }
    }
}
// 推出VC
- (void)AxcUI_PushSampleVC_WithIndexPath:(NSIndexPath *)indexPath{
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
    cell.detailTextLabel.font = [UIFont systemFontOfSize:14];
    cell.detailTextLabel.textColor = [UIColor AxcUI_colorWithHexCode:@"b0a4e3"];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self AxcUI_PushSampleVC_WithIndexPath:indexPath];
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
        [Group1 addObject:@{@"controlsName":@"View+",@"describeName":@"快速切圆角",@"VCName":@"AxcRectCornerVC"}];
        [Group1 addObject:@{@"controlsName":@"View+",@"describeName":@"快速添加消息数量气泡",@"VCName":@"AxcQuickBadgeViewVC"}];
        [Group1 addObject:@{@"controlsName":@"View+",@"describeName":@"快速添加可交互气泡",@"VCName":@"AxcQuickBadgeInteractionVC"}];
        
        [Group1 addObject:@{@"controlsName":@"ImageView+",@"describeName":@"轻量加载图片",@"VCName":@"AxcLoadImageVC"}];
        [Group1 addObject:@{@"controlsName":@"ImageView+",@"describeName":@"添加Progress",@"VCName":@"AxcImageLoaderVC"}];
        [Group1 addObject:@{@"controlsName":@"ImageView+",@"describeName":@"基础滤镜渲染",@"VCName":@"AxcFilterVC"}];
        [Group1 addObject:@{@"controlsName":@"ImageView+",@"describeName":@"自定义/预设滤镜渲染",@"VCName":@"AxcFilterTwoVC"}];
        [Group1 addObject:@{@"controlsName":@"ImageView+",@"describeName":@"形态学图像运算",@"VCName":@"AxcFilterThreeVC"}];
        
        [Group1 addObject:@{@"controlsName":@"Image+",@"describeName":@"快速生成二维码",@"VCName":@"AxcQRCodeVC"}];
        
        [Group1 addObject:@{@"controlsName":@"Button+",@"describeName":@"Button快速布局",@"VCName":@"AxcButtonLayoutVC"}];
        [Group1 addObject:@{@"controlsName":@"Button+",@"describeName":@"Button快速设置倒计时",@"VCName":@"AxcButtonCountDownVC"}];
        
        [Group1 addObject:@{@"controlsName":@"Label+",@"describeName":@"Label长按复制剪贴板",@"VCName":@"AxcCopyableVC"}];
        [Group1 addObject:@{@"controlsName":@"CollectionView+",@"describeName":@"长摁拖动排序",@"VCName":@"AxcCellRearrangeVC"}];
        [Group1 addObject:@{@"controlsName":@"TableView+",@"describeName":@"空集的占位View",@"VCName":@"AxcEmptyDataVC"}];
        [Group1 addObject:@{@"controlsName":@"TextField+",@"describeName":@"占位符参数修改",@"VCName":@"AxcModifyPlaceholderVC"}];
        [Group1 addObject:@{@"controlsName":@"ViewController+",@"describeName":@"动画推出View/VC",@"VCName":@"AxcSemiModalVC"}];

        [Group1 addObject:@{@"controlsName":@"测试",@"describeName":@"测试",@"VCName":@"TestTwoVC"}];

        NSMutableArray *Group2 = [NSMutableArray array];

        
        [Group2 addObject:@{@"controlsName":@"AxcUI_ActivityIndicatorView",@"describeName":@"动画View",@"VCName":@"AxcActivityIndicatorViewVC"}];
        [Group2 addObject:@{@"controlsName":@"AxcUI_ActivityHUD",@"describeName":@"加载指示器",@"VCName":@"AxcActivityHUDVC"}];
        
        [Group2 addObject:@{@"controlsName":@"AxcUI_BarrageView",@"describeName":@"独立弹幕/视图容器",@"VCName":@"AxcBarrageViewVC"}];
        [Group2 addObject:@{@"controlsName":@"AxcUI_BarrageScrollEngine",@"describeName":@"弹幕渲染引擎",@"VCName":@"AxcBarrageScrollEngineVC"}];
        
        [Group2 addObject:@{@"controlsName":@"AxcUI_BadgeView",@"describeName":@"消息数量气泡",@"VCName":@"AxcBadgeViewVC"}];
        [Group2 addObject:@{@"controlsName":@"AxcUI_BadgeInteractionView",@"describeName":@"可交互气泡",@"VCName":@"AxcBadgeInteractionViewVC"}];
        
        [Group2 addObject:@{@"controlsName":@"AxcUI_Label",@"describeName":@"动态设置文字边距",@"VCName":@"AxcLabelVC"}];
        
        [Group2 addObject:@{@"controlsName":@"AxcUI_NumberScrollView",@"describeName":@"数字滚动控件",@"VCName":@"AxcNumberScrollViewVC"}];
        [Group2 addObject:@{@"controlsName":@"AxcUI_NumberUnitField",@"describeName":@"数字输入控件",@"VCName":@"AxcNumberUnitFieldVC"}];
        
        [Group2 addObject:@{@"controlsName":@"AxcUI_ProgressView",@"describeName":@"进度指示器",@"VCName":@"AxcProgressViewVC"}];
        [Group2 addObject:@{@"controlsName":@"AxcUI_PhotoBrowser",@"describeName":@"照片浏览器",@"VCName":@"AxcPhotoBrowserVC"}];
        
        [Group2 addObject:@{@"controlsName":@"AxcUI_StarRatingView",@"describeName":@"星级评分器",@"VCName":@"StarRatingViewVC"}];
        
        [Group2 addObject:@{@"controlsName":@"AxcUI_TagView",@"describeName":@"自定义ViewTag标签",@"VCName":@"AxcTagViewVC"}];
        [Group2 addObject:@{@"controlsName":@"AxcUI_TagTextView",@"describeName":@"文字样式Tag标签",@"VCName":@"AxcTagTextViewVC"}];

        [Group2 addObject:@{@"controlsName":@"AxcUI_Toast",@"describeName":@"弹出式提醒",@"VCName":@"AxcToastVC"}];
        
        [_dataArray addObject:Group1];
        [_dataArray addObject:Group2];
    }
    return _dataArray;
}
// 推荐组
- (NSArray *)recommendArray{
    if (!_recommendArray) {
        _recommendArray = @[@"动画推出View/VC",@"弹幕",@"Tag标签",@"动画",@"长摁拖动排序",@"Image",@"AxcUI",@"气泡"];
    }
    return _recommendArray;
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

- (NSMutableArray *)controlsNameArray{
    if (!_controlsNameArray) {
        _controlsNameArray = [NSMutableArray array];
        int i = 0;
        for (NSArray *sectionArr in self.dataArray) {
            NSString *Controltype = self.sectionTitleArray[i];
            int j = 0;
            for (NSDictionary *searchDic in sectionArr) {
                NSString *controlsName = searchDic[@"controlsName"];
                NSString *describeName = searchDic[@"describeName"];
                NSString *SearchNameStr = [NSString stringWithFormat:@"%@ - %@（%@）",Controltype,controlsName,describeName];
                [_controlsNameArray addObject:@{@"name":SearchNameStr,
                                                @"section":@(i),
                                                @"row":@(j)}];
                j ++;
            }
            i ++;
        }
    }
    return _controlsNameArray;
}

- (void)viewWillAppear:(BOOL)animated{
    self.title = @"AxcUIKit Sample";
}
- (void)viewWillDisappear:(BOOL)animated{
    self.title = @"";
}

@end
