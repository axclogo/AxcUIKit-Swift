//
//  UIImageView+AxcWebCache.h
//  AxcUIKit
//
//  Created by Axc on 2017/6/6.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "Axc_WebImageCompat.h"
#import "Axc_WebImageManager.h"

@interface UIImageView (AxcWebCache)

- (void)coreAxc_setImageWithPreviousCachedImageWithURL:(NSURL *)url
                                   andPlaceholderImage:(UIImage *)placeholder
                                               options:(Axc_WebimageOptions)options
                                              progress:(Axc_DownloadWebimageDownloaderProgressBlock)progressBlock
                                             completed:(Axc_WebimageCompletionBlock)completedBlock;


@end



