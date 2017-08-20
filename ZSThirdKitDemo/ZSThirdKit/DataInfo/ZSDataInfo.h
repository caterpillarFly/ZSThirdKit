//
//  ZSDataInfo.h
//  ZSThirdKit
//
//  Created by zhaosheng on 2017/8/14.
//  Copyright © 2017年 zs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSChannelHeaderFile.h"

#pragma mark --登录用户信息

typedef NS_ENUM(NSInteger, ZSUserSexType){
    ZSUserSexUnknown = 0,
    ZSUserSexMale,
    ZSUserSexFemale
};

@interface ZSUserInfo : NSObject

@property (nonatomic) ZSUserSexType sex;
@property (nonatomic) ZSChannelType channelType;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *profile;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;

@end


#pragma mark --授权信息
@interface ZSAuthInfo : NSObject

@property (nonatomic) ZSChannelType channelType;
@property (nonatomic, copy) NSString *openId;
@property (nonatomic, copy) NSString *unionId;      //微信独有
@property (nonatomic, copy) NSString *token;
@property (nonatomic) long long expire;

@end

