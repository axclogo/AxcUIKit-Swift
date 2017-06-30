//
//  TestTwoVC.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/3.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "TestTwoVC.h"

#import "AxcUI_PhotoBrowser.h"

#import "Axc_ImageCache.h"

#import "AxcUI_Toast.h"

@interface TestTwoVC ()<UITableViewDelegate,UITableViewDataSource>
{
    NSArray *array;

}


@property (nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong)UIImageView *imageView;
@property(nonatomic, strong)UISlider *parentScale;

@end

@implementation TestTwoVC

- (void)viewDidLoad{
    [super viewDidLoad];
    
    AxcUI_BarrageView *drawMarqueeView0   = [[AxcUI_BarrageView alloc] initWithFrame:CGRectMake(0, 104, self.view.frame.size.width, 20)];
    drawMarqueeView0.axcUI_barrageDelegate         = self;
    drawMarqueeView0.axcUI_barrageMarqueeDirection  = AxcBarrageMovementStyleRightFromLeft;
    [self.view addSubview:drawMarqueeView0];
    [drawMarqueeView0 AxcUI_addContentView:[self createLabelWithText:@"夏天是个很好的季节, 而夏天然后是简书的推荐作者, 喜欢分享!"
                                                           textColor:[UIColor blackColor]]];
    [drawMarqueeView0 AxcUI_startAnimation];
    
    drawMarqueeView0.axcUI_barrageSpeed = 3;
    drawMarqueeView0.axcUI_barrageMarqueeDirection  = AxcBarrageMovementStyleLeftFromRight;
    
    
}

#pragma mark -
- (UILabel *)createLabelWithText:(NSString *)text textColor:(UIColor *)textColor {
    
    NSString *string = [NSString stringWithFormat:@" %@ ", text];
    CGFloat width = [string widthWithStringAttribute:@{NSFontAttributeName : [UIFont systemFontOfSize:14.f]}];
    UILabel  *label  = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, width, 20)];
    label.font       = [UIFont systemFontOfSize:14.f];
    label.text       = string;
    label.textColor  = textColor;
    return label;
}

@end
@implementation NSString (XTAdd)
- (CGFloat)widthWithStringAttribute:(NSDictionary <NSString *, id> *)attribute {
    
    NSParameterAssert(attribute);
    
    CGFloat width = 0;
    
    if (self.length) {
        
        CGRect rect = [self boundingRectWithSize:CGSizeMake(MAXFLOAT, 0)
                                         options:NSStringDrawingTruncatesLastVisibleLine |NSStringDrawingUsesLineFragmentOrigin |
                       NSStringDrawingUsesFontLeading
                                      attributes:attribute
                                         context:nil];
        
        width = rect.size.width;
    }
    
    return width;
}
@end
