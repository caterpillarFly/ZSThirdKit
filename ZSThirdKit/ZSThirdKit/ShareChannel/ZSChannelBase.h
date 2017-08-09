//
//  ZSChannelBase.h
//  ZSharekit
//
//  Created by zhaosheng on 2017/8/2.
//  Copyright © 2017年 zs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZShareInfo.h"
#import "ZSThirdHeaderFile.h"
#import "ZSThirdKitManager.h"

@interface ZSChannelBase : NSObject

@property (nonatomic) ZSOpSuccessBlock successBlock;
@property (nonatomic) ZSOpCancelBlock cancelBlock;
@property (nonatomic) ZSOpFailBlock failBlock;
@property (nonatomic) ZSNotSupportBlock notSupportBlock;
@property (nonatomic) ZSAuthBlock authBlock;

//渠道名称
@property (nonatomic, copy) NSString *channelName;

//设置渠道相关的信息，比如appKey（必须），appSecret（微信必须）等信息；
- (void)setupWithInfo:(NSDictionary *)info;

//是否支持分享该类型的信息
- (BOOL)isSupportShareInfo:(ZShareInfo *)shareInfo;


//客户端是否支持登录
- (BOOL)couldLogin;

//登录
- (void)login:(ZSAuthBlock)authBlock;


//登录成功之后调用
- (void)didLogin:(ZSAuthInfo *)authInfo;


//取消操作之后调用
- (void)didCancel;


//失败只有调用
- (void)didFail:(NSError *)error;


//成功之后调用
- (void)didSuccess:(id)data;


//发起分享请求
- (void)shareInfo:(ZShareInfo *)shareInfo
          success:(ZSOpSuccessBlock)success
             fail:(ZSOpFailBlock)fail
           cancel:(ZSOpCancelBlock)cancel;


//接住外部
- (BOOL)handleOpenURL:(NSURL *)url;

@end
