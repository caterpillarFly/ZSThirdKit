//
//  NSData+ZSExt.h
//  ZSLifeCircleDemo
//
//  Created by zhaosheng on 2017/10/18.
//  Copyright © 2017年 zs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (ZSExt)

+ (NSData *)compressImageData:(NSData *)aImageData belowSize:(NSUInteger)aSize;

@end
