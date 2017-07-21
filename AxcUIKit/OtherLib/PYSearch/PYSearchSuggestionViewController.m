//
//  GitHub: https://github.com/iphone5solo/PYSearch
//  Created by CoderKo1o.
//  Copyright © 2016 iphone5solo. All rights reserved.
//

#import "PYSearchSuggestionViewController.h"
#import "PYSearchConst.h"

#import "UITableViewCell+AxcAnimation.h"
#import "UIColor+AxcColor.h"
#import "NSString+AxcReplaceRichText.h"
#import "NSString+AxcTextCalculation.h"

@interface PYSearchSuggestionViewController ()

@property (nonatomic, assign) UIEdgeInsets originalContentInset;


@end

@implementation PYSearchSuggestionViewController

+ (instancetype)searchSuggestionViewControllerWithDidSelectCellBlock:(PYSearchSuggestionDidSelectCellBlock)didSelectCellBlock
{
    PYSearchSuggestionViewController *searchSuggestionVC = [[PYSearchSuggestionViewController alloc] init];
    searchSuggestionVC.didSelectCellBlock = didSelectCellBlock;
    searchSuggestionVC.automaticallyAdjustsScrollViewInsets = NO;
    return searchSuggestionVC;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    if ([self.tableView respondsToSelector:@selector(setCellLayoutMarginsFollowReadableWidth:)]) { // For the adapter iPad
        self.tableView.cellLayoutMarginsFollowReadableWidth = NO;
    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboradFrameDidChange:) name:UIKeyboardDidShowNotification object:nil];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}



- (void)keyboradFrameDidChange:(NSNotification *)notification
{
    [self setSearchSuggestions:_searchSuggestions];
}

#pragma mark - setter
- (void)setSearchSuggestions:(NSArray<NSString *> *)searchSuggestions
{
    _searchSuggestions = [searchSuggestions copy];
    
    [self.tableView reloadData];
    
    if (!UIEdgeInsetsEqualToEdgeInsets(self.originalContentInset, UIEdgeInsetsZero) && !UIEdgeInsetsEqualToEdgeInsets(self.originalContentInset, UIEdgeInsetsMake(-30, 0, 30 - 64, 0))) {
        self.tableView.contentInset =  self.originalContentInset;
    }
    self.tableView.contentOffset = CGPointMake(0, -self.tableView.contentInset.top);
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInSearchSuggestionView:)]) {
        return [self.dataSource numberOfSectionsInSearchSuggestionView:tableView];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.dataSource respondsToSelector:@selector(searchSuggestionView:numberOfRowsInSection:)]) {
        return [self.dataSource searchSuggestionView:tableView numberOfRowsInSection:section];
    }
    return self.searchSuggestions.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataSource respondsToSelector:@selector(searchSuggestionView:cellForRowAtIndexPath:)]) {
        UITableViewCell *cell= [self.dataSource searchSuggestionView:tableView cellForRowAtIndexPath:indexPath];
        if (cell) return cell;
    }
    
    static NSString *cellID = @"PYSearchSuggestionCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.backgroundColor = [UIColor clearColor];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
//        UIImageView *line = [[UIImageView alloc] initWithImage: [NSBundle py_imageNamed:@"cell-content-line"]];
//        line.py_height = 0.5;
//        line.alpha = 0.7;
//        line.py_x = PYSEARCH_MARGIN;
//        line.py_y = [self AxcUI_getHeightForRow:self.searchSuggestions[indexPath.row]] - 0.5;
//        line.py_width = PYScreenW;
//        [cell.contentView addSubview:line];
    }
    cell.imageView.image = [NSBundle py_imageNamed:@"search"];
    cell.textLabel.text = self.searchSuggestions[indexPath.row];
    cell.textLabel.numberOfLines = 0;
    if (indexPath.row % 2) {
        cell.backgroundColor = [UIColor AxcUI_CloudColor];
    }else{
        cell.backgroundColor = [UIColor whiteColor];
    }
    if (self.searchKeyWord) {
        cell.textLabel.attributedText = [cell.textLabel.text AxcUI_markWords:self.searchKeyWord
                                                                   withColor:[UIColor AxcUI_OrangeColor]];
    }
   
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    if ([self.dataSource respondsToSelector:@selector(searchSuggestionView:heightForRowAtIndexPath:)]) {
//        return [self.dataSource searchSuggestionView:tableView heightForRowAtIndexPath:indexPath];
//    }
    return [self AxcUI_getHeightForRow:self.searchSuggestions[indexPath.row]];
}

- (CGFloat )AxcUI_getHeightForRow:(NSString *)str{
    CGFloat width = [str AxcUI_widthWithStringFontSize:14];
    CGFloat difference = 70;
    if (width > SCREEN_WIDTH - difference) {
        NSInteger multiple = width/(SCREEN_WIDTH - difference);
        return multiple *30 +24;
    }
    return 44.0;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    self.originalContentInset = self.tableView.contentInset;
    
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell AxcUI_cellAppearAnimateStyle:AxcCellAppearAnimateStyleRightToLeft indexPath:indexPath];
}
#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (self.didSelectCellBlock) self.didSelectCellBlock([tableView cellForRowAtIndexPath:indexPath]);
}

@end
