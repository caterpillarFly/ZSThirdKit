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
                             @"channelName" :   @"QQ好友",
                             @"normalIcon"  :   @"图片名称",
                             @"selectedIcon":   @"",
                             @"highlightedIcon" : @""
                             };
    //qq空间
    NSDictionary *qqzone = @{@"appKey"      :   @"xxxxxxxxx",
                             @"channelName" :   @"QQ空间",
                             @"normalIcon"  :   @"",
                             @"selectedIcon":   @"",
                             @"highlightedIcon" : @""
                             };
    //微信
    NSDictionary *wxinfo = @{@"appKey"      :   @"xxxxxxxxx",
                             @"appSecert"   :   @"xxxxxxxxx",
                             @"channelName" :   @"微信好友",
                             @"normalIcon"  :   @"",
                             @"selectedIcon":   @"",
                             @"highlightedIcon" : @""
                             };
    //朋友圈
    NSDictionary *wxpyq = @{@"appKey"      :   @"xxxxxxxxx",
                             @"appSecert"   :   @"xxxxxxxxx",
                             @"channelName" :   @"朋友圈",
                             @"normalIcon"  :   @"",
                             @"selectedIcon":   @"",
                             @"highlightedIcon" : @""
                             };
    //新浪微博
    NSDictionary *wbinfo = @{@"appKey"      :   @"xxxxxxxxx",
                             @"appSecert"   :   @"xxxxxxxxx",
                             @"redirectURI" :   @"xxxxxxxxx",
                             @"channelName" :   @"微博",
                             @"normalIcon"  :   @"",
                             @"selectedIcon":   @"",
                             @"highlightedIcon" : @""
                             };
    
    NSDictionary *channelInfoMap = @{@(ZSChannelTypeWX)      :   wxinfo,
                                     @(ZSChannelTypePYQ)     :   wxpyq,
                                     @(ZSChannelTypeQQ)      :   qqinfo,
                                     @(ZSChannelTypeQQZone)  :   qqzone,
                                     @(ZSChannelTypeSinaWB)  :   wbinfo};
    
    return channelInfoMap[@(channelType)];
}

@end
