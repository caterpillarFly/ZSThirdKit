//
//  ZSChannelBase.m
//  ZSharekit
//
//  Created by zhaosheng on 2017/8/2.
//  Copyright © 2017年 zs. All rights reserved.
//

#import "ZSChannelBase.h"

@interface ZSChannelBase ()<ZSOpProcessProtocol>

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

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
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
        [ZSThirdKitManager sharedManager].currentChannel = self;
        [self login];
    }
    else{
        if (self.notSupportBlock) {
            self.notSupportBlock(self);
        }
    }
}

- (void)getUserInfoWithAuth:(ZSAuthInfo *)authInfo
                    success:(ZSOpSuccessBlock)success
                       fail:(ZSOpFailBlock)fail
{
    self.successBlock = success;
    self.failBlock = fail;
    
    if ([self couldLogin]) {
        [ZSThirdKitManager sharedManager].currentChannel = self;
        [self getUserInfo:authInfo];
    }
    else{
        if (self.notSupportBlock) {
            self.notSupportBlock(self);
        }
    }
}

- (void)shareInfo:(ZShareInfo *)shareInfo success:(ZSOpSuccessBlock)success fail:(ZSOpFailBlock)fail cancel:(ZSOpCancelBlock)cancel
{
    self.successBlock = success;
    self.failBlock = fail;
    self.cancelBlock = cancel;
    
    if ([self couldLogin]) {
        [ZSThirdKitManager sharedManager].currentChannel = self;
        [self shareInfo:shareInfo];
    }
    else{
        if (self.notSupportBlock) {
            self.notSupportBlock(self);
        }
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
    if (self.failBlock) {
        self.failBlock(self, error);
    }
}

- (void)didCancel
{
    if (self.cancelBlock) {
        self.cancelBlock(self);
    }
}

- (void)didSuccess:(id)data
{
    if (self.successBlock) {
        self.successBlock(self, data);
    }
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    return NO;
}


@end
