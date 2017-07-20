//
//  AxcPlayerChangeOrientationOperation.h
//  AxcUIKit
//
//  Created by Axc_5324 on 17/7/19.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^AxcPlayerChangeOrientationOperationCompletionHandler)();

@interface AxcPlayerChangeOrientationOperation : NSOperation

+ (instancetype)blockOperationWithBlock:(void (^)(AxcPlayerChangeOrientationOperationCompletionHandler completionHandler))block;

@end
