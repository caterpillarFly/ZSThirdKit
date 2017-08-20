//
//  ZSChannelBase.h
//  ZSharekit
//
//  Created by zhaosheng on 2017/8/2.
//  Copyright © 2017年 zs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZShareInfo.h"
#import "ZSDataInfo.h"
#import "ZSChannelHeaderFile.h"
#import "ZSChannelProtocol.h"
#import "ZSChannelManager.h"


@interface ZSChannelBase : NSObject

//操作成功回调
@property (nonatomic) ZSOpSuccessBlock successBlock;
//取消操作回调
@property (nonatomic) ZSOpCancelBlock cancelBlock;
//操作失败回调
@property (nonatomic) ZSOpFailBlock failBlock;
//渠道未安装回调，这个block需要自己显示设置
@property (nonatomic) ZSNotSupportBlock notSupportBlock;
//渠道名称
@property (nonatomic, copy) NSString *channelName;
//渠道类型
@property (nonatomic, readonly) ZSChannelType channelType;




//统一创建实例的方法，所有渠道都通过这个方法创建
+ (instancetype)channelWithType:(ZSChannelType)channelType;




//设置渠道相关的信息，比如appKey（必须），appSecret（微信必须）等信息；
- (void)setupWithInfo:(NSDictionary *)info;



//客户端是否支持分享
- (BOOL)couldShare;




//登录，拿回授权信息，success回调里的参数是ZSAuthInfo
- (void)login:(ZSOpSuccessBlock)success
         fail:(ZSOpFailBlock)fail
       cancel:(ZSOpCancelBlock)cancel;




//登录之后，将登录返回的授权信息拿来获取用户头像，昵称等信息
- (void)getUserInfoWithAuth:(ZSAuthInfo *)authInfo
                    success:(ZSOpSuccessBlock)success
                       fail:(ZSOpFailBlock)fail;




//发起分享请求
- (void)shareInfo:(ZShareInfo *)shareInfo
          success:(ZSOpSuccessBlock)success
             fail:(ZSOpFailBlock)fail
           cancel:(ZSOpCancelBlock)cancel;




//接住外部OpenUrl回调
- (BOOL)handleOpenURL:(NSURL *)url;



@end
