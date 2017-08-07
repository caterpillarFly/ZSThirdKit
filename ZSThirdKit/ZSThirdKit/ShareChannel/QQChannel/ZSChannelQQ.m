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


@interface ZSChannelQQ ()<TencentSessionDelegate, QQApiInterfaceDelegate>

@property (nonatomic) TencentOAuth *auth;

@end

@implementation ZSChannelQQ

- (instancetype)init
{
    if (self = [super init]) {
        self.channelName = @"QQ";
    }
    return self;
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    if ([TencentOAuth HandleOpenURL:url])
        return YES;
    else
        return [QQApiInterface handleOpenURL:url delegate:self];
}

- (void)shareInfo:(ZShareInfo *)shareInfo
{
    QQApiObject *obj = [self sendObjWithShareInfo:shareInfo];
    if (obj) {
        SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:obj];
        if (!req) {
            NSError *error = ZSThirdError(ZSThirdErrorCodeUnsupport, @"不支持分享该类型数据");
            [self didFail:error];
        }
        else{
            QQApiSendResultCode shareRes;
            
        }
    }
    else{
        NSError *error = ZSThirdError(ZSThirdErrorCodeUnsupport, @"不支持分享该类型数据");
        [self didFail:error];
    }
}

//登录
- (void)login
{
    //QQ空间SSO登录
    NSArray *permissionArr = @[kOPEN_PERMISSION_GET_USER_INFO,
                               kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                               kOPEN_PERMISSION_ADD_SHARE,
                               kOPEN_PERMISSION_ADD_TOPIC,
                               kOPEN_PERMISSION_GET_INFO,
                               kOPEN_PERMISSION_GET_OTHER_INFO,
                               kOPEN_PERMISSION_UPLOAD_PIC];
    
    if (![self.auth authorize:permissionArr inSafari:NO])
    {
        NSError *error = ZSThirdError(ZSThirdErrorCodeUnsupport, @"qq登录失败");
        [self didFail: error];
    }
    else{
        [ZSThirdKitManager sharedManager].currentChannel = self;
    }
}

- (BOOL)couldLogin
{
    return ([QQApiInterface isQQInstalled] && [QQApiInterface isQQSupportApi]);
}

#pragma mark -- TencentLoginDelegate

//登录成功的回调
- (void)tencentDidLogin
{
    NSLog(@"qq登录成功");
    if (self.auth.accessToken) {
        ZSAuthInfo *authInfo = [ZSAuthInfo new];
        authInfo.token = self.auth.accessToken;
        authInfo.expire = [self.auth.expirationDate timeIntervalSince1970];
        authInfo.userId = self.auth.openId;
        
        [self didLogin:authInfo];
    }
    else{
        [self didCancel];
    }
}

//登录失败的回调
- (void)tencentDidNotLogin:(BOOL)cancelled
{
    if (cancelled){
        [self didCancel];
    }
    else{
        NSError *error = ZSThirdError(ZSThirdErrorCodeUnknown, @"qq登录失败");
        [self didFail:error];
    }
    
    NSLog(@"qq登录失败");
}

//登录时网络有问题
- (void)tencentDidNotNetWork
{
    NSLog(@"qq登录网络有问题");
    NSError *error = ZSThirdError(kOpenSDKErrorNetwork, @"qq登录失败");
    [self didFail:error];
}


#pragma mark --QQApiInterfaceDelegate
/**
 处理来至QQ的请求
 */
- (void)onReq:(QQBaseReq *)req
{
    NSLog(@"处理来至QQ的请求");
}

/**
 处理来至QQ的响应
 */
- (void)onResp:(QQBaseResp *)resp
{
    NSLog(@"处理来至QQ的响应");
}


#pragma mark --Getter
- (TencentOAuth *)auth
{
    if (!_auth) {
        @synchronized (self) {
            if (!_auth) {
                _auth = [[TencentOAuth alloc] initWithAppId:self.appKey andDelegate:self];
            }
        }
    }
    return _auth;
}

- (QQApiObject *)sendObjWithShareInfo:(ZShareInfo *)info
{
    QQApiObject *obj;
    if ([info isKindOfClass:[ZShareText class]]) {
        ZShareText *textInfo = (ZShareText *)info;
        obj = [QQApiTextObject objectWithText:textInfo.text];
    }
    else if ([info isKindOfClass:[ZShareImage class]]){
        ZShareImage *imageInfo = (ZShareImage *)info;
        obj = [QQApiImageObject objectWithData:UIImageJPEGRepresentation(imageInfo.image, 0.9)
                              previewImageData:nil
                                         title:nil
                                   description:nil];
    }
    else if ([info isKindOfClass:[ZShareWebPage class]]){
        ZShareWebPage *webPageInfo = (ZShareWebPage *)info;
        obj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:webPageInfo.url]
                                       title:webPageInfo.title
                                 description:webPageInfo.desc
                            previewImageData:webPageInfo.thumbnailData];
    }
    return obj;
}

@end
