//
//  ZSThirdProtocol.h
//  ZSThirdKit
//
//  Created by zhaosheng on 2017/8/11.
//  Copyright © 2017年 zs. All rights reserved.
//

#ifndef ZSThirdProtocol_h
#define ZSThirdProtocol_h

@class ZSAuthInfo;

@protocol ZSOpProcessProtocol <NSObject>

@optional

//登录成功之后调用
- (void)didLogin:(ZSAuthInfo *)authInfo;


//取消操作之后调用
- (void)didCancel;


//失败之后调用
- (void)didFail:(NSError *)error;


//成功之后调用
- (void)didSuccess:(id)data;

@end



@protocol ZSConfigProtocol <NSObject>


//渠道对应的标示
- (NSArray<NSString *> *)channelKeys;

//
- (NSString *)channelClassNameWithKey:(NSString *)channelKey;


//渠道对应的信息，主要是appKey，appSecret等信息
- (NSDictionary *)channelInfoWithKey:(NSString *)channelKey;

@end

#endif /* ZSThirdProtocol_h */
