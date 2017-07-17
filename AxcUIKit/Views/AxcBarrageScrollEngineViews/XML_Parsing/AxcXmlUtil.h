//
//  AxcXmlUtil.h
//  AxcUIKit
//
//  Created by Axc on 2017/7/1.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "BarrageDataModel.h"




@interface AxcXmlUtil : NSObject

/**
 *  把对象转成时间字典
 *
 *  @param obj   对象b站是NSData
 *
 *  @return 时间字典
 */
+ (NSDictionary *)dicWithObj:(id)obj;


@end



