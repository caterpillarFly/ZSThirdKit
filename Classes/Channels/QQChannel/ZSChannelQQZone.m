//
//  ZSChannelQQZone.m
//  ZSThirdKit
//
//  Created by zhaosheng on 2017/8/10.
//  Copyright © 2017年 zs. All rights reserved.
//

#import "ZSChannelQQZone.h"

@implementation ZSChannelQQZone

- (instancetype)init
{
    if (self = [super init]) {
        self.channelName = @"QQ空间";
    }
    return self;
}

- (ZSChannelQQScene)scene
{
    return ZSChannelQQSceneQQZone;
}

//QQ空间不支持登录
- (BOOL)couldLogin
{
    return NO;
}

- (ZSChannelType)channelType
{
    return ZSChannelTypeQQZone;
}

@end
