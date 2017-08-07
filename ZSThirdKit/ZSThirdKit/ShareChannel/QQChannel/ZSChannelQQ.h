//
//  ZSChannelQQ.h
//  ZSharekit
//
//  Created by zhaosheng on 2017/8/2.
//  Copyright © 2017年 zs. All rights reserved.
//

#import "ZSChannelBase.h"
#import "ZSThirdKitManager.h"

typedef NS_ENUM(NSInteger, ZSChannelQQType){
    ZSChannelQQTypeQQ = 0,
    ZSChannelQQTypeQQZone = 1
};

@interface ZSChannelQQ : ZSChannelBase

@property (nonatomic) ZSChannelQQType qqType;

@end
