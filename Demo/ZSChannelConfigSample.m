//
//  ZSChannelConfigSample.m
//  ZSThirdKit
//
//  Created by zhaosheng on 2017/8/14.
//  Copyright © 2017年 zs. All rights reserved.
//

#import "ZSChannelConfigSample.h"

@implementation ZSChannelConfigSample

- (NSDictionary *)channelInfoWithType:(ZSChannelType)channelType
{
    NSDictionary *qqinfo = @{@"appKey"      :   @"xxxxxxx"};
    NSDictionary *wxinfo = @{@"appKey"      :   @"xxxxxxxx",
                             @"appSecert"   :   @"xxxxxxxxx"};
    NSDictionary *wbinfo = @{@"appKey"      :   @"xxxxxxxxx",
                             @"appSecert"   :   @"xxxxxxxxxx",
                             @"redirectURI" :   @"http://music.10086.cn"};
    
    NSDictionary *channelInfoMap = @{@(ZSChannelTypeWX)      :   wxinfo,
                                     @(ZSChannelTypePYQ)     :   wxinfo,
                                     @(ZSChannelTypeQQ)      :   qqinfo,
                                     @(ZSChannelTypeQQZone)  :   qqinfo,
                                     @(ZSChannelTypeSinaWB)  :   wbinfo};
    
    return channelInfoMap[@(channelType)];
}

@end
