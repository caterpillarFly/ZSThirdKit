//
//  ZSChannelBase.m
//  ZSharekit
//
//  Created by zhaosheng on 2017/8/2.
//  Copyright © 2017年 zs. All rights reserved.
//

#import "ZSChannelBase.h"
#import "ZSChannelQQZone.h"
#import "ZSChannelPYQ.h"
#import "ZSChannelSinaWB.h"

@interface ZSChannelBase ()<ZSOpProcessProtocol>

//操作成功回调
@property (nonatomic) ZSOpSuccessBlock successBlock;
//取消操作回调
@property (nonatomic) ZSOpCancelBlock cancelBlock;
//操作失败回调
@property (nonatomic) ZSOpFailBlock failBlock;
//渠道类型
@property (nonatomic) ZSChannelType channelType;

/*
 * 以下是子类需要覆写的方法
 */

//channel是否支持登录
- (BOOL)couldLogin;

//每个子类的登录操作
- (void)login;

//每个子类的分享操作
- (void)shareInfo:(ZShareInfo *)shareInfo;

//获取特定渠道的用户信息
- (void)getUserInfo:(ZSAuthInfo *)authInfo;


@end

@implementation ZSChannelBase

+ (instancetype)channelWithType:(ZSChannelType)channelType
{
    ZSChannelBase *base;
    switch (channelType) {
        case ZSChannelTypeQQ:
            base = [ZSChannelQQ new];
            break;
        case ZSChannelTypeQQZone:
            base = [ZSChannelQQZone new];
            break;
        case ZSChannelTypeWX:
            base = [ZSChannelWX new];
            break;
        case ZSChannelTypePYQ:
            base = [ZSChannelPYQ new];
            break;
        case ZSChannelTypeSinaWB:
            base = [ZSChannelSinaWB new];
            break;
        default:
            break;
    }
    if (!base) {
#ifdef DEBUG
        NSAssert(NO, @"不支持的渠道类型");
#endif
    }
    base.channelType = channelType;
    return base;
}


- (void)dealloc
{
    NSLog(@"channel dealloc:%@_%@", self, self.channelName);
}

- (BOOL)couldLogin
{
    return NO;
}

- (BOOL)couldShare
{
    return NO;
}

- (void)login:(ZSOpSuccessBlock)success fail:(ZSOpFailBlock)fail cancel:(ZSOpCancelBlock)cancel
{
    self.successBlock = success;
    self.failBlock = fail;
    self.cancelBlock = cancel;
    
    if ([self couldLogin]) {
        [ZSChannelManager sharedManager].currentChannel = self;
        [self login];
    }
    else{
        [self didNotSupport];
    }
}

- (void)getUserInfoWithAuth:(ZSAuthInfo *)authInfo
                    success:(ZSOpSuccessBlock)success
                       fail:(ZSOpFailBlock)fail
{
    self.successBlock = success;
    self.failBlock = fail;
    
    if ([self couldLogin]) {
        [ZSChannelManager sharedManager].currentChannel = self;
        [self getUserInfo:authInfo];
    }
    else{
        [self didNotSupport];
    }
}

- (void)shareInfo:(ZShareInfo *)shareInfo success:(ZSOpSuccessBlock)success fail:(ZSOpFailBlock)fail cancel:(ZSOpCancelBlock)cancel
{
    self.successBlock = success;
    self.failBlock = fail;
    self.cancelBlock = cancel;
    
    if ([self couldShare]) {
        [ZSChannelManager sharedManager].currentChannel = self;
        [self shareInfo:shareInfo];
    }
    else{
        [self didNotSupport];
    }
}

- (void)login
{
    //子类实现
}

- (void)shareInfo:(ZShareInfo *)shareInfo
{
    //子类实现
}

- (void)setupWithInfo:(NSDictionary *)info
{
    //子类实现
}

- (void)getUserInfo:(ZSAuthInfo *)authInfo
{
    //子类实现
}

- (void)didFail:(NSError *)error
{
    //故意声明一个临时变量持有self，避免clear的时候self被释放
    __unused ZSChannelBase *holder = self;
    [self clear];
    //一定要先clear，后执行block，因为block里面还可能执行channel的其它方法，导致clear错误清除
    if (self.failBlock) {
        self.failBlock(self, error);
    }
}

- (void)didCancel
{
    __unused ZSChannelBase *holder = self;
    [self clear];
    if (self.cancelBlock) {
        self.cancelBlock(self);
    }
}

- (void)didSuccess:(id)data
{
    __unused ZSChannelBase *holder = self;
    [self clear];
    if (self.successBlock) {
        self.successBlock(self, data);
    }
}

- (void)didNotSupport
{
    __unused ZSChannelBase *holder = self;
    [self clear];
    if (self.notSupportBlock) {
        self.notSupportBlock(self);
    }
}

- (void)clear
{
    [[ZSChannelManager sharedManager] clear];
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    return NO;
}


@end
