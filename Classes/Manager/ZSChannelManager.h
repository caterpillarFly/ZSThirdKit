//
//  ZSChannelManager.h
//  ZSThirdKit
//
//  Created by zhaosheng on 2017/8/14.
//  Copyright © 2017年 zs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSChannelBase.h"

@interface ZSChannelManager : NSObject

//当前操作的渠道，操作结束之后，会置为nil
@property (nonatomic) ZSChannelBase *currentChannel;

//它会持有代理，代理不能释放，不然初始化出来的channel，没有appKey等info
@property (nonatomic) id<ZSConfigProtocol> delegate;


+ (instancetype)sharedManager;



//接住外部openurl回调
- (BOOL)handleOpenURL:(NSURL *)url
    sourceApplication:(NSString *)sourceApplication
         userActivity:(NSUserActivity *)userActivity
         requestBlock:(ZSOpSuccessBlock)requestBlock;



//根据type，返回对应的channel，并且会配置好相应的信息（appKey，appScete等）
- (ZSChannelBase *)channelWithType:(ZSChannelType)channelType;


//根据type，返回对应的channel，并设置未安装block回调
- (ZSChannelBase *)channelWithType:(ZSChannelType)channelType notInstallBlock:(ZSNotSupportBlock)block;



//客户端支持分享的渠道，没安装的不会返回（QQ，QQ空间，微信，朋友圈，新浪微博）
- (NSArray<ZSChannelBase *> *)validChannels;


//清除保留的渠道等信息
- (void)clear;

@end
