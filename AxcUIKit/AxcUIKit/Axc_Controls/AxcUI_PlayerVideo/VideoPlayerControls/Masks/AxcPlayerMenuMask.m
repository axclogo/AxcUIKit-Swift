//
//  AxcPlayerMenuMask.m
//  AxcUIKit
//
//  Created by Axc_5324 on 17/7/19.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcPlayerMenuMask.h"
#import "AxcUI_PlayerVideo.h"

@interface AxcPlayerMenuMask () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) CAShapeLayer *spinyLayer;

@end

@implementation AxcPlayerMenuMask

- (instancetype)initWithPlayerView:(AxcUI_PlayerView *)playerView {
    self = [super initWithPlayerView:playerView];
    if (self) {
        
        _selectedIndex = -1;
        _menuWidth = 80;
        _menuItemHeight = 40;
        
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.tableView];
        [self.layer addSublayer:self.spinyLayer];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (self.superview == nil) return;
    
    CGFloat height = self.tableView.contentSize.height;
    if (self.menuPosition.y - height - 20 <= 0) {
        height = self.menuPosition.y - 20;
    }
    
    self.frame = CGRectMake(self.menuPosition.x - self.menuWidth/2,
                            self.menuPosition.y - height,
                            self.menuWidth,
                            height);
    
    self.tableView.frame = self.bounds;
    
    [CATransaction setDisableActions:YES];
    self.spinyLayer.position = CGPointMake(self.menuWidth/2 - 10/2, self.bounds.size.height);
    [CATransaction setDisableActions:NO];
}

- (void)selectedIndexDidChanged {
    
}

- (void)reloadData {
    [self.tableView reloadData];
    [self setNeedsLayout];
}

#pragma mark - UITableViewDelegate, UITableViewDataSource

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.menuItemHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
        cell.backgroundColor = [UIColor clearColor];
        cell.contentView.backgroundColor = [UIColor clearColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textAlignment = NSTextAlignmentCenter;
        cell.textLabel.textColor = [UIColor colorWithWhite:0.5 alpha:1];
        cell.textLabel.highlightedTextColor = [UIColor whiteColor];
        cell.selectedBackgroundView = [[UIView alloc] init];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5];
    }
    cell.textLabel.text = self.items[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectedIndex = indexPath.row;
    [self selectedIndexDidChanged];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.items count];
}

#pragma mark - mask

- (void)reload {
    
}

- (void)addAnimationWithCompletion:(void(^)())completion {
    self.alpha = 0;
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 1;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
    }];
}

- (void)removeAnimationWithCompletion:(void(^)())completion {
    [UIView animateWithDuration:0.2 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        if (completion) {
            completion();
        }
        self.alpha = 1;
    }];
}

#pragma mark - getters setters 

- (void)setItems:(NSArray<NSString *> *)items {
    _items = items;
    [self reloadData];
}

- (void)setMenuItemHeight:(CGFloat)menuItemHeight {
    _menuItemHeight = menuItemHeight;
    [self reloadData];
}

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    if (selectedIndex > [self.items count] - 1) return;
    
    _selectedIndex = selectedIndex;
    if (selectedIndex >= 0) {
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0]
                                    animated:NO
                              scrollPosition:UITableViewScrollPositionNone];
    } else {
        NSIndexPath *selectedIndexPath = [self.tableView indexPathForSelectedRow];
        if (selectedIndexPath != nil) {
            [self.tableView deselectRowAtIndexPath:selectedIndexPath animated:NO];
        }
    }
}

- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] init];
        _tableView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.85];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.layer.cornerRadius = 4;
        _tableView.delegate = self;
        _tableView.dataSource = self;
    }
    return _tableView;
}

- (CAShapeLayer *)spinyLayer {
    if (_spinyLayer == nil) {
        _spinyLayer = [CAShapeLayer layer];
        
        CGMutablePathRef path = CGPathCreateMutable();
        CGPathMoveToPoint(path, 0, 0, 0);
        CGPathAddLineToPoint(path, 0, 10, 0);
        CGPathAddLineToPoint(path, 0, 5, 6);
        CGPathAddLineToPoint(path, 0, 0, 0);
        
        _spinyLayer.path = path;
        _spinyLayer.fillColor = [UIColor colorWithWhite:0 alpha:0.85].CGColor;
        _spinyLayer.fillRule = kCAFillRuleEvenOdd;
    }
    return _spinyLayer;
}

@end
