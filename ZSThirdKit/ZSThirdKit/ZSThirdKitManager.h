//
//  ZSThirdKitManager.h
//  ZSThirdKit
//
//  Created by zhaosheng on 2017/8/7.
//  Copyright © 2017年 zs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSChannelBase.h"

@interface ZSThirdKitManager : NSObject

//三方登录的渠道，非三方登录，则为nil
@property (nonatomic) ZSChannelBase *loginedChannel;

//当前操作的渠道，操作结束之后，会置为nil
@property (nonatomic) ZSChannelBase *currentChannel;

//它会持有代理，代理不能释放，否则channelWithKey:和validChannels等方法将会没有效果
@property (nonatomic) id<ZSConfigProtocol> delegate;


+ (instancetype)sharedManager;


//接住外部openurl回调
- (BOOL)handleOpenURL:(NSURL *)url;



//根据key，返回对应的channel，并且会配置好相应的信息（appKey，appScete等）
- (ZSChannelBase *)channelWithKey:(NSString *)key;



//客户端支持分享的渠道，没安装的不会返回
- (NSArray<ZSChannelBase *> *)validChannels;


//清除保留的渠道等信息
- (void)clear;


@end
