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
    NSDictionary *qqinfo = @{@"appKey"      :   @"1105787459"};
    NSDictionary *wxinfo = @{@"appKey"      :   @"wxf6d4fc0792ef3783",
                             @"appSecert"   :   @"3a9523bcc8a35d664fac915796ce84ec"};
    NSDictionary *wbinfo = @{@"appKey"      :   @"1843267010",
                             @"appSecert"   :   @"b2f5b2b661babaa3c01b57312decffd7",
                             @"redirectURI" :   @"http://music.10086.cn"};
    
    NSDictionary *channelInfoMap = @{@(ZSChannelTypeWX)      :   wxinfo,
                                     @(ZSChannelTypePYQ)     :   wxinfo,
                                     @(ZSChannelTypeQQ)      :   qqinfo,
                                     @(ZSChannelTypeQQZone)  :   qqinfo,
                                     @(ZSChannelTypeSinaWB)  :   wbinfo};
    
    return channelInfoMap[@(channelType)];
}

@end
