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
    
    NSDictionary *info;
    
    switch (channelType) {
        case ZSChannelTypeWX:{
            info = @{@"appKey"      :   @"xxxxxxxxx",
                     @"appSecert"   :   @"xxxxxxxxx",
                     @"channelName" :   @"微信好友",
                     @"normalIcon"  :   @"",
                     @"selectedIcon":   @"",
                     @"highlightedIcon" : @"",
                     @"universalLink" : @""
                     };
            break;
        }
        case ZSChannelTypePYQ:{
            info = @{@"appKey"      :   @"xxxxxxxxx",
                     @"appSecert"   :   @"xxxxxxxxx",
                     @"channelName" :   @"朋友圈",
                     @"normalIcon"  :   @"",
                     @"selectedIcon":   @"",
                     @"highlightedIcon" : @"",
                     @"universalLink" : @""
                     };
            break;
        }
        case ZSChannelTypeQQ:{
            info = @{@"appKey"      :   @"xxxxxxxxx",
                     @"channelName" :   @"QQ好友",
                     @"normalIcon"  :   @"图片名称",
                     @"selectedIcon":   @"",
                     @"highlightedIcon" : @""
                     };
            break;
        }
        case ZSChannelTypeQQZone:{
            info = @{@"appKey"      :   @"xxxxxxxxx",
                     @"channelName" :   @"QQ空间",
                     @"normalIcon"  :   @"",
                     @"selectedIcon":   @"",
                     @"highlightedIcon" : @""
                     };
            break;
        }
        case ZSChannelTypeSinaWB:{
            info = @{@"appKey"      :   @"xxxxxxxxx",
                     @"appSecert"   :   @"xxxxxxxxx",
                     @"redirectURI" :   @"xxxxxxxxx",
                     @"channelName" :   @"微博",
                     @"normalIcon"  :   @"",
                     @"selectedIcon":   @"",
                     @"highlightedIcon" : @""
                     };
            break;
        }
        default:
            break;
    }
    
    return info;
}


@end
