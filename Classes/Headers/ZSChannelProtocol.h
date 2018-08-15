//
//  ZSThirdProtocol.h
//  ZSThirdKit
//
//  Created by zhaosheng on 2017/8/11.
//  Copyright © 2017年 zs. All rights reserved.
//

#ifndef ZSChannelProtocol_h
#define ZSChannelProtocol_h
#import "ZSChannelHeaderFile.h"


@class ZSAuthInfo;

@protocol ZSOpProcessProtocol <NSObject>

@optional


//取消操作之后调用
- (void)didCancel;


//失败之后调用
- (void)didFail:(NSError *)error;


//成功之后调用
- (void)didSuccess:(id)data;



@end



@protocol ZSConfigProtocol <NSObject>


//渠道对应的信息，主要是appKey，appSecret等信息
- (NSDictionary *)channelInfoWithType:(ZSChannelType)channelType;



@end

#endif /* ZSThirdProtocol_h */
