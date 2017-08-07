//
//  ZSThirdKitManager.m
//  ZSThirdKit
//
//  Created by zhaosheng on 2017/8/7.
//  Copyright © 2017年 zs. All rights reserved.
//

#import "ZSThirdKitManager.h"

@implementation ZSThirdKitManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static ZSThirdKitManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [ZSThirdKitManager new];
    });
    return manager;
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    return [self.currentChannel handleOpenURL:url];
}

@end
