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
#import "ZSThirdProtocol.h"
#import "ZSThirdKitManager.h"


@interface ZSChannelBase : NSObject

@property (nonatomic) ZSOpSuccessBlock successBlock;
@property (nonatomic) ZSOpCancelBlock cancelBlock;
@property (nonatomic) ZSOpFailBlock failBlock;
@property (nonatomic) ZSNotSupportBlock notSupportBlock;
@property (nonatomic) ZSAuthBlock authBlock;
//渠道名称
@property (nonatomic, copy) NSString *channelName;
//渠道对应的key，用来标示渠道
@property (nonatomic, copy) NSString *channelKey;


//设置渠道相关的信息，比如appKey（必须），appSecret（微信必须）等信息；
- (void)setupWithInfo:(NSDictionary *)info;


//客户端是否支持分享
- (BOOL)couldShare;


//登录
- (void)login:(ZSAuthBlock)auth
         fail:(ZSOpFailBlock)fail
       cancel:(ZSOpCancelBlock)cancel;


//登录之后，获取用户的头像，昵称等信息
- (void)getUserInfo:(ZSSimpleCallBack)finish;


//发起分享请求
- (void)shareInfo:(ZShareInfo *)shareInfo
          success:(ZSOpSuccessBlock)success
             fail:(ZSOpFailBlock)fail
           cancel:(ZSOpCancelBlock)cancel;


//接住外部OpenUrl回调
- (BOOL)handleOpenURL:(NSURL *)url;

@end
