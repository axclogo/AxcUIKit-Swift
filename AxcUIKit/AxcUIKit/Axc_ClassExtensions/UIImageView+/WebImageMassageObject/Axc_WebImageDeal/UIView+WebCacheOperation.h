//
//  UIView+WebCacheOperation.h
//  AxcUIKit
//
//  Created by Axc on 2017/6/6.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Axc_WebImageManager.h"

@interface UIView (WebCacheOperation)

- (void)coreAxc_setImageLoadOperation:(id)operation forKey:(NSString *)key;

/**
 *  取消当前UIView所有操作
 */
- (void)coreAxc_cancelImageLoadOperationWithKey:(NSString *)key;

/**
 *  只是删除操作对应于当前UIView和 key
 */
- (void)coreAxc_removeImageLoadOperationWithKey:(NSString *)key;

@end
