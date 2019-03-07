//
//  NSData+ZSExt.m
//  ZSLifeCircleDemo
//
//  Created by zhaosheng on 2017/10/18.
//  Copyright © 2017年 zs. All rights reserved.
//

#import "NSData+ZSExt.h"
#import <UIKit/UIKit.h>

@implementation NSData (ZSExt)

+ (NSData *)compressImageData:(NSData *)aImageData belowSize:(NSUInteger)aSize
{
    if (aImageData.length <= aSize)
    {
        return aImageData;
    }
    
    float defaultSacle = 0.7;
    
    NSData *compressedData = nil;
    
    do
    {
        UIImage *orgPreviewImage = [[UIImage alloc] initWithData:aImageData];
        compressedData = UIImageJPEGRepresentation(orgPreviewImage, defaultSacle);
        
        //压缩之后仍然大于阀值，缩小图片质量
        if (compressedData.length > aSize)
        {
            orgPreviewImage = [[UIImage alloc] initWithData:compressedData];
            orgPreviewImage = [self getScaleImage:orgPreviewImage
                                            width:orgPreviewImage.size.width * defaultSacle
                                       imageScale:1];
            aImageData = UIImageJPEGRepresentation(orgPreviewImage, 1.0);
        }
        
    } while (compressedData.length > aSize);
    
    return compressedData;
}

+ (UIImage *)getScaleImage:(UIImage *)org width:(CGFloat)scaleWidth imageScale:(CGFloat)scale
{
    UIImage *originalImage = org;
    
    CGFloat width, height;
    CGFloat tWidth = originalImage.size.width;
    CGFloat tHeight = originalImage.size.height;
    CGFloat rate = tWidth / tHeight;
    
    if (originalImage.size.width < originalImage.size.height)
    {
        width = rate * scaleWidth;
        height = scaleWidth;
    }
    else
    {
        width = scaleWidth;
        height = scaleWidth / rate;
    }
    
    BOOL drawTransposed;
    
    switch (originalImage.imageOrientation)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            drawTransposed = YES;
            break;
            
        default:
            drawTransposed = NO;
    }
    
    CGSize newSize = CGSizeMake(width, height);
    
    CGRect transposedRect;
    if (drawTransposed)
    {
        transposedRect = CGRectMake(0, 0, newSize.height, newSize.width);
    }
    else
    {
        transposedRect = CGRectMake(0, 0, newSize.width, newSize.height);
    }
    
    UIGraphicsBeginImageContextWithOptions(newSize, NO, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextConcatCTM(context, CGAffineTransformIdentity);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
    CGContextSetShouldAntialias(context, NO);
    
    [originalImage drawInRect:transposedRect];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}

@end
