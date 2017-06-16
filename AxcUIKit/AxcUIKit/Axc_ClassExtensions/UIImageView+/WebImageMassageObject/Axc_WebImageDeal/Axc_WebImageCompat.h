//
//  Axc_WebimageCompat.h
//  AxcUIKit
//
//  Created by Axc on 2017/6/6.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <TargetConditionals.h>




#import <UIKit/UIKit.h>



#undef coreAxc_dispatchQueueRelease
#undef coreAxc_dispatchQueueSetterSementics
#define coreAxc_dispatchQueueRelease(q)
#define coreAxc_dispatchQueueSetterSementics strong


extern UIImage *coreAxc_scaledImageForKey(NSString *key, UIImage *image);

typedef void(^Axc_WebimageNoParamsBlock)();

extern NSString *const Axc_WebimageErrorDomain;

#define dispatch_main_sync_safe(block)\
    if ([NSThread isMainThread]) {\
        block();\
    } else {\
        dispatch_sync(dispatch_get_main_queue(), block);\
    }

#define dispatch_main_async_safe(block)\
    if ([NSThread isMainThread]) {\
        block();\
    } else {\
        dispatch_async(dispatch_get_main_queue(), block);\
    }
