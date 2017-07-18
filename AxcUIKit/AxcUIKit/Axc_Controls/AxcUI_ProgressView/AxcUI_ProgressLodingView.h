//
//  AxcUI_ProgressLodingView.h
//  AxcUIKit
//
//  Created by Axc_5324 on 17/6/5.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "AxcBaseProgressView.h"


/** 自行运转的加载指示器（需要手动释放） */
@interface AxcUI_ProgressLodingView : AxcBaseProgressView

/** 释放计时器 */
- (void)removeTimer;


@end
