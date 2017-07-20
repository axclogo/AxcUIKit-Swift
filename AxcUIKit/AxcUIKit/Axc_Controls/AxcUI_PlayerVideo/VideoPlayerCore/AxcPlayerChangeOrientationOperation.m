//
//  AxcPlayerChangeOrientationOperation.m
//  AxcUIKit
//
//  Created by Axc_5324 on 17/7/19.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcPlayerChangeOrientationOperation.h"

@interface AxcPlayerChangeOrientationOperation ()

@property (nonatomic) BOOL operationFinished;
@property (nonatomic) BOOL operationExecuting;

@property (nonatomic, copy) void (^block)();

@end

@implementation AxcPlayerChangeOrientationOperation

+ (instancetype)blockOperationWithBlock:(void (^)(AxcPlayerChangeOrientationOperationCompletionHandler completionHandler))block {
    AxcPlayerChangeOrientationOperation *operation = [[AxcPlayerChangeOrientationOperation alloc] init];
    operation.block = block;
    return operation;
}

- (void)start {
    if ([self isCancelled]) {
        [self willChangeValueForKey:@"isFinished"];
        self.operationFinished = YES;
        [self didChangeValueForKey:@"isFinished"];
        return;
    }
    
    [self willChangeValueForKey:@"isExecuting"];
    [self main];
    self.operationExecuting = YES;
    [self didChangeValueForKey:@"isExecuting"];
    
}

- (void)main {
    if ([self isCancelled]) return;
    
    @autoreleasepool {
        if (self.block != nil) {
            __weak typeof(self) weakSelf = self;
            dispatch_async(dispatch_get_main_queue(), ^{
                weakSelf.block(^{
                    [weakSelf completeOperation];
                });
            });
        }
    };
}

- (void)completeOperation {
    [self willChangeValueForKey:@"isFinished"];
    [self willChangeValueForKey:@"isExecuting"];
    
    self.operationExecuting = NO;
    self.operationFinished = YES;
    
    [self didChangeValueForKey:@"isExecuting"];
    [self didChangeValueForKey:@"isFinished"];
}


- (BOOL)ready {
    return YES;
}

- (BOOL)asynchronous {
    return YES;
}

- (BOOL)isExecuting {
    return self.operationExecuting;
}

- (BOOL)isFinished {
    return self.operationFinished;
}



@end
