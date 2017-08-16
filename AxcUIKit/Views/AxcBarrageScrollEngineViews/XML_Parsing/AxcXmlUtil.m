//
//  AxcXmlUtil.m
//  AxcUIKit
//
//  Created by Axc on 2017/7/1.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcXmlUtil.h"
#import "AxcUI_BarrageModelBase.h"
#import "AxcUI_BarrageScrollEngine.h"

#import "AxcUI_BarrageScrollEngine+Tools.h"


typedef void(^callBackBlock)(BarrageDataModel *model);


@implementation AxcXmlUtil



+ (NSDictionary *)dicWithObj:(id)obj{
    NSMutableDictionary <NSNumber *,NSMutableArray <AxcUI_BarrageModelBase *> *> *dic = [NSMutableDictionary dictionary];
    
    UIFont *font = [UIFont systemFontOfSize:13];
    NSInteger danMufontSpecially = AxcBarrageShadowStyleNone;
    
    [self danMuWithBilibiliData:obj block:^(BarrageDataModel *model) {
        NSInteger time = model.time;
        if (!dic[@(time)]){
            dic[@(time)] = [NSMutableArray array];
        }
        AxcUI_BarrageModelBase *danmaku = [AxcUI_BarrageScrollEngine barrageWithText:model.message
                                                                               color:model.color
                                                                         spiritStyle:model.mode
                                                                         shadowStyle:danMufontSpecially
                                                                            fontSize: font.pointSize
                                                                                font:font];
        danmaku.appearTime = model.time;
        [dic[@(time)] addObject: danmaku];
    }];
    
    return dic;
}

#pragma mark - 私有方法

//b站解析方式
// 本来是XML的，但是作为示例不大想用三方库解析，所以就改成json了
+ (void)danMuWithBilibiliData:(NSData*)data block:(callBackBlock)block{
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
    NSDictionary *iDic = [dic objectForKey:@"i"];
    NSArray *array = [iDic objectForKey:@"d"];
    for (NSDictionary *ele in array) {
        NSString *strtimr = [ele objectForKey:@"-p"];
        NSArray* strArr = [strtimr componentsSeparatedByString:@","];
        BarrageDataModel* model = [[BarrageDataModel alloc] init];
        model.time = [strArr[0] floatValue];
        model.mode = [strArr[1] intValue];
        model.color = [strArr[3] intValue];
        model.message = [ele objectForKey:@"#text"];
        if (block) block(model);
    }
}

@end
