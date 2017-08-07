//
//  ZSChannelQQ.m
//  ZSharekit
//
//  Created by zhaosheng on 2017/8/2.
//  Copyright © 2017年 zs. All rights reserved.
//

#import "ZSChannelQQ.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

@implementation ZSChannelQQ

- (void)shareInfo:(ZShareInfo *)shareInfo success:(ZShareSuccessBlock)success fail:(ZShareFailBlock)fail cancel:(ZShareCancelBlock)cancel
{
    self.successBlock = success;
    self.failBlock = fail;
    self.cancelBlock = cancel;
    
    
}

- (BOOL)couldShare
{
    return YES;
}

//登录
- (void)login
{
    
}

@end
