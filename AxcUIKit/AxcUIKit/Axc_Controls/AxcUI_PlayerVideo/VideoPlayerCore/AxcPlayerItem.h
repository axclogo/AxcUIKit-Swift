//
//  AxcPlayerItem.h
//  AxcUIKit
//
//  Created by Axc_5324 on 17/7/19.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AxcPlayerItemAsset : NSObject

@property (nonatomic, copy) NSString *type;
@property (nonatomic, strong) NSURL *URL;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithType:(NSString *)type URL:(NSURL *)URL;

@end


@interface AxcPlayerItem : NSObject

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *assetTitle;

@property (nonatomic, readonly) NSUInteger duration;
@property (nonatomic, readonly) NSUInteger currentSeconds;
@property (nonatomic, readonly) NSUInteger bufferedSeconds;

@property (nonatomic, strong, readonly) AxcPlayerItemAsset *playingAsset;
@property (nonatomic, strong) NSArray<AxcPlayerItemAsset *> *assets;

@end
