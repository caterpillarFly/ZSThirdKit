//
//  ZSThirdConfigSample.m
//  ZSThirdKit
//
//  Created by zhaosheng on 2017/8/11.
//  Copyright © 2017年 zs. All rights reserved.
//

#import "ZSThirdConfigSample.h"

@implementation ZSThirdConfigSample

- (NSArray<NSString *> *)channelKeys
{
    return @[ZSChannelWXKey,
             ZSChannelPYQKey,
             ZSChannelSinaWBKey,
             ZSChannelQQZoneKey,
             ZSChannelQQKey];
}

- (NSString *)channelClassNameWithKey:(NSString *)channelKey
{
    NSDictionary *classNameMap = @{ZSChannelWXKey      :   @"ZSChannelWX",
                                   ZSChannelPYQKey     :   @"ZSChannelPYQ",
                                   ZSChannelQQZoneKey  :   @"ZSChannelQQZone",
                                   ZSChannelQQKey      :   @"ZSChannelQQ",
                                   ZSChannelSinaWBKey  :   @"ZSChannelSinaWB"};
    NSString *className = classNameMap[channelKey];
    return className;
}

- (NSDictionary *)channelInfoWithKey:(NSString *)channelKey
{
    NSDictionary *qqinfo = @{@"appKey"      :   @"1105787459"};
    NSDictionary *wxinfo = @{@"appKey"      :   @"wxf6d4fc0792ef3783",
                             @"appSecert"   :   @"3a9523bcc8a35d664fac915796ce84ec"};
    NSDictionary *wbinfo = @{@"appKey"      :   @"1843267010",
                             @"appSecert"   :   @"b2f5b2b661babaa3c01b57312decffd7",
                             @"redirectURI" :   @"http://music.10086.cn"};
    
    NSDictionary *channelInfoMap = @{ZSChannelWXKey      :   wxinfo,
                                     ZSChannelPYQKey     :   wxinfo,
                                     ZSChannelQQZoneKey  :   qqinfo,
                                     ZSChannelQQKey      :   qqinfo,
                                     ZSChannelSinaWBKey  :   wbinfo};
    
    return channelInfoMap[channelKey];
}

@end
