//
//  AxcSemiModalPresentVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/4.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcSemiModalPresentVC.h"

#import <Masonry.h>

#import <WebKit/WebKit.h>

#import "AxcUIKit.h"

@interface AxcSemiModalPresentVC ()<
WKNavigationDelegate
>


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) WKWebView *webView;

@end

@implementation AxcSemiModalPresentVC

- (void)viewDidLoad {
    [super viewDidLoad];

        __weak typeof(self) WeakSelf = self;
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(WeakSelf.titleLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-40);
    }];
    
}



- (IBAction)dismissBtn:(id)sender {
    // 使用AxcUIKit框架dismiss来安全销毁
    [self AxcUI_dismissSemiModalView];
}
- (IBAction)refresh:(id)sender {
    [self.webView reload];
}
- (IBAction)segment:(UISegmentedControl *)sender {
    if (sender.numberOfSegments) { // 1
        if ([self.webView canGoForward]) {
            [self.webView goForward];
        }
    }else{
        if ([self.webView canGoBack]) {
            [self.webView goBack];
        }
    }
    sender.selected = NO;
    sender.highlighted = NO;
}

- (void)webView:(WKWebView *)webView didCommitNavigation:(WKNavigation *)navigation{
    __weak typeof(self) WeakSelf = self;
    [webView evaluateJavaScript:@"document.title"
              completionHandler:^(id _Nullable data, NSError * _Nullable error) {
                  WeakSelf.titleLabel.text = data;
              }];
}

- (WKWebView *)webView{
    if (!_webView) {
        _webView = [[WKWebView alloc] init];
        _webView.navigationDelegate = self;
        [_webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:@"https://www.baidu.com/"]]];
        [self.view addSubview:_webView];
    }
    return _webView;
}


- (void)dealloc{
    NSLog(@"AxcSemiModalPresentVC已销毁");
}


@end
