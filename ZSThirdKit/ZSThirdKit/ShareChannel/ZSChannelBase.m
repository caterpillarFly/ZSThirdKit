//
//  ZSChannelBase.m
//  ZSharekit
//
//  Created by zhaosheng on 2017/8/2.
//  Copyright © 2017年 zs. All rights reserved.
//

#import "ZSChannelBase.h"

@interface ZSChannelBase ()

//子类需要覆写的方法
- (void)login;
- (void)shareInfo:(ZShareInfo *)shareInfo;

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

- (BOOL)isSupportShareInfo:(ZShareInfo *)shareInfo
{
    return NO;
}

- (BOOL)couldLogin
{
    return NO;
}

- (void)login:(ZSAuthBlock)authBlock
{
    self.authBlock = authBlock;
    if ([self couldLogin]) {
        [self login];
    }
    else{
        if (self.notSupportBlock) {
            self.notSupportBlock(self);
        }
        [self clear];
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

- (void)shareInfo:(ZShareInfo *)shareInfo success:(ZSOpSuccessBlock)success fail:(ZSOpFailBlock)fail cancel:(ZSOpCancelBlock)cancel
{
    self.successBlock = success;
    self.failBlock = fail;
    self.cancelBlock = cancel;
    
    if ([self couldLogin]) {
        [self shareInfo:shareInfo];
        [ZSThirdKitManager sharedManager].currentChannel = self;
    }
    else{
        if (self.notSupportBlock) {
            self.notSupportBlock(self);
        }
        [self clear];
    }
}

- (void)didFail:(NSError *)error
{
    if (self.failBlock) {
        self.failBlock(self, error);
    }
    [self clear];
}

- (void)didCancel
{
    if (self.cancelBlock) {
        self.cancelBlock(self);
    }
    [self clear];
}

- (void)didLogin:(ZSAuthInfo *)authInfo
{
    if (self.authBlock) {
        self.authBlock(self, authInfo);
    }
    [self clear];
}

- (void)didSuccess:(id)data
{
    if (self.successBlock) {
        self.successBlock(self, data);
    }
    [self clear];
}

- (void)clear
{
    self.successBlock = nil;
    self.failBlock = nil;
    self.cancelBlock = nil;
    self.authBlock = nil;
    self.notSupportBlock = nil;
    
    [ZSThirdKitManager sharedManager].currentChannel = nil;
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    return NO;
}


@end
