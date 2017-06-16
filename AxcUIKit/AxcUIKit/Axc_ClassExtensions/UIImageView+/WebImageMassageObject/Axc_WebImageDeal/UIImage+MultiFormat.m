//
//  UIImage+MultiFormat.m
//  AxcUIKit
//
//  Created by Axc on 2017/6/6.
//  Copyright © 2017年 Axc_5324. All rights reserved.
//

#import "UIImage+MultiFormat.h"
#import "UIImage+AxcLoadGIF.h"
#import "NSData+ImageContentType.h"
#import <ImageIO/ImageIO.h>



@implementation UIImage (MultiFormat)

+ (UIImage *)coreAxc_imageWithData:(NSData *)data {
    if (!data) {
        return nil;
    }
    
    UIImage *image;
    NSString *imageContentType = [NSData coreAxc_contentTypeForImageData:data];
    if ([imageContentType isEqualToString:@"image/gif"]) {
        image = [UIImage coreAxc_animatedGIFWithData:data];
    }
    else {
        image = [[UIImage alloc] initWithData:data];
        UIImageOrientation orientation = [self CoreAxc_imageOrientationFromImageData:data];
        if (orientation != UIImageOrientationUp) {
            image = [UIImage imageWithCGImage:image.CGImage
                                        scale:image.scale
                                  orientation:orientation];
        }
    }
    
    
    return image;
}


+(UIImageOrientation)CoreAxc_imageOrientationFromImageData:(NSData *)imageData {
    UIImageOrientation result = UIImageOrientationUp;
    CGImageSourceRef imageSource = CGImageSourceCreateWithData((__bridge CFDataRef)imageData, NULL);
    if (imageSource) {
        CFDictionaryRef properties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, NULL);
        if (properties) {
            CFTypeRef val;
            int exifOrientation;
            val = CFDictionaryGetValue(properties, kCGImagePropertyOrientation);
            if (val) {
                CFNumberGetValue(val, kCFNumberIntType, &exifOrientation);
                result = [self coreAxc_exifOrientationToiOSOrientation:exifOrientation];
            } // else - if 这不是设置
            CFRelease((CFTypeRef) properties);
        } else {
        }
        CFRelease(imageSource);
    }
    return result;
}

+ (UIImageOrientation) coreAxc_exifOrientationToiOSOrientation:(int)exifOrientation {
    UIImageOrientation orientation = UIImageOrientationUp;
    switch (exifOrientation) {
        case 1:
            orientation = UIImageOrientationUp;
            break;
        case 3:
            orientation = UIImageOrientationDown;
            break;
        case 8:
            orientation = UIImageOrientationLeft;
            break;
        case 6:
            orientation = UIImageOrientationRight;
            break;
        case 2:
            orientation = UIImageOrientationUpMirrored;
            break;
        case 4:
            orientation = UIImageOrientationDownMirrored;
            break;
        case 5:
            orientation = UIImageOrientationLeftMirrored;
            break;
        case 7:
            orientation = UIImageOrientationRightMirrored;
            break;
        default:
            break;
    }
    return orientation;
}



@end
