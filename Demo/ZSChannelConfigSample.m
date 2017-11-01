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
    //配置信息的键名称不得更改，目前只解析了appKey，appSecert，redirectURI，channelName
    //channelName可选，其它三个请按照demo传递
    //qq渠道配置信息
    NSDictionary *qqinfo = @{@"appKey"      :   @"xxxxxxxxx",
                             @"channelName" :   @"QQ好友"
                             };
    //qq空间
    NSDictionary *qqzone = @{@"appKey"      :   @"xxxxxxxxx",
                             @"channelName" :   @"QQ空间"
                             };
    //微信
    NSDictionary *wxinfo = @{@"appKey"      :   @"xxxxxxxxx",
                             @"appSecert"   :   @"xxxxxxxxx",
                             @"channelName" :   @"微信好友"
                             };
    //朋友圈
    NSDictionary *wxpyq = @{@"appKey"      :   @"xxxxxxxxx",
                             @"appSecert"   :   @"xxxxxxxxx",
                             @"channelName" :   @"朋友圈"
                             };
    //新浪微博
    NSDictionary *wbinfo = @{@"appKey"      :   @"xxxxxxxxx",
                             @"appSecert"   :   @"xxxxxxxxx",
                             @"redirectURI" :   @"xxxxxxxxx",
                             @"channelName" :   @"微博"
                             };
    
    NSDictionary *channelInfoMap = @{@(ZSChannelTypeWX)      :   wxinfo,
                                     @(ZSChannelTypePYQ)     :   wxpyq,
                                     @(ZSChannelTypeQQ)      :   qqinfo,
                                     @(ZSChannelTypeQQZone)  :   qqzone,
                                     @(ZSChannelTypeSinaWB)  :   wbinfo};
    
    return channelInfoMap[@(channelType)];
}

@end
