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

/*
 * 所有渠道的基类，在分类里面实现了ZSOpProcessProtocol协议，这个协议的方法，是每个步骤（比如分享，登录等）操作完成之后的处理；
 * 之所以放在分类里实现，是为了让外部不能调用；外部也不应该直接调用协议的方法
 * 需要继承自ZSChannelBase的子类，也该在分类里面实现ZSOpProcessProtocol协议
 */

@interface ZSChannelBase : NSObject

//渠道未安装回调，这个block需要自己显示设置
@property (nonatomic) ZSNotSupportBlock notSupportBlock;
//渠道名称，可以在配置文件中配置，若未配置，渠道初始化会给个默认名称
@property (nonatomic, copy) NSString *channelName;
//渠道类型，各个渠道初始化的时候会自己赋值
@property (nonatomic, readonly) ZSChannelType channelType;
//以下三个icon，可以配置(只支持imageNamed:方式配置)，也可以自己设置
//正常的icon
@property (nonatomic) UIImage *normalIcon;
//选中的icon
@property (nonatomic) UIImage *selectedIcon;
//高亮的icon
@property (nonatomic) UIImage *highlightedIcon;
//保存用户自己和渠道相关的信息
@property (nonatomic) id userInfo;




//设置渠道相关的信息，比如appKey（必须），appSecret（微信必须）等信息；
//子类覆写，必须先调用基类的方法
- (void)setupWithInfo:(NSDictionary *)info NS_REQUIRES_SUPER;




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



//设置分享渠道请求自己App的回调
- (void)setRequestBlock:(ZSOpSuccessBlock)requestBlock;




//接住外部OpenUrl回调
- (BOOL)handleOpenURL:(NSURL *)url;



@end
