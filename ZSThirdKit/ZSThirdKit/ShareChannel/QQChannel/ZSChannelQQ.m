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
#import <TencentOpenAPI/QQApiInterfaceObject.h>


@interface ZSChannelQQ ()<TencentSessionDelegate, QQApiInterfaceDelegate, ZSOpProcessProtocol>

@property (nonatomic, copy) NSString *appKey;
@property (nonatomic) TencentOAuth *auth;

@end

@implementation ZSChannelQQ

- (instancetype)init
{
    if (self = [super init]) {
        self.channelName = @"QQ好友";
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

- (void)setupWithInfo:(NSDictionary *)info
{
    NSString *appKey = info[@"appKey"];
    self.appKey = appKey;
}

//分享
- (void)shareInfo:(ZShareInfo *)shareInfo
{
    __unused TencentOAuth *auth = self.auth;
    [self reqWithInfo:shareInfo finish:^(SendMessageToQQReq *req) {
        if (!req) {
            NSError *error = ZSThirdError(ZSThirdErrorCodeUnsupport, @"不支持分享该类型数据");
            [self didFail:error];
        }
        else{
            QQApiSendResultCode shareRes;
            if (self.scene == ZSChannelQQSceneChat){
                shareRes = [QQApiInterface sendReq:req];
            }
            else{
                shareRes = [QQApiInterface SendReqToQZone:req];
            }
            if (shareRes != EQQAPISENDSUCESS) {
                NSError *error = ZSThirdError(ZSThirdErrorCodeUnknown, @"分享失败");
                [self didFail:error];
            }
        }
    }];
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
    //就算没装客户端，QQ也支持网页登录
    return YES;
}

- (BOOL)couldShare
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
        authInfo.openId = self.auth.openId;
        authInfo.channelKey = self.channelKey;
        
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
    if (!resp.errorDescription){
        [self didSuccess:nil];
    }
    else if ([resp.errorDescription isEqualToString:@"the user give up the current operation"]){
        [self didCancel];
    }
    else{
        NSError *error = ZSThirdError(ZSThirdErrorCodeUnknown, resp.errorDescription);
        [self didFail:error];
    }
}

- (void)getUserInfoResponse:(APIResponse *)response
{
    
}

/**
 处理QQ在线状态的回调
 */
- (void)isOnlineResponse:(NSDictionary *)response
{
    NSLog(@"处理QQ在线状态的回调");
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

- (ZSChannelQQScene)scene
{
    return ZSChannelQQSceneChat;
}

- (void)reqWithInfo:(ZShareInfo *)info finish:(ZSSimpleCallBack)finish
{
    QQApiObject *obj;
    if ([info isKindOfClass:[ZShareText class]]) {
        //文本
        ZShareText *textInfo = (ZShareText *)info;
        obj = [QQApiTextObject objectWithText:textInfo.text];
    }
    else if ([info isKindOfClass:[ZShareImage class]]){
        //图片
        ZShareImage *imageInfo = (ZShareImage *)info;
        if (self.scene == ZSChannelQQSceneChat) {
            obj = [QQApiImageObject objectWithData:UIImageJPEGRepresentation(imageInfo.image, 0.9)
                                  previewImageData:nil
                                             title:imageInfo.title
                                       description:nil];
        }
        else{
            obj =[QQApiImageArrayForQZoneObject objectWithimageDataArray:@[UIImageJPEGRepresentation(imageInfo.image, 0.9)] title:imageInfo.title extMap:nil];
        }
        
    }
    else if ([info isKindOfClass:[ZShareWebPage class]]){
        //网页
        ZShareWebPage *webPageInfo = (ZShareWebPage *)info;
        obj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:webPageInfo.url]
                                       title:webPageInfo.title
                                 description:webPageInfo.desc
                            previewImageData:webPageInfo.thumbnailData];
    }
    else if ([info isKindOfClass:[ZShareMusic class]]){
        //音频
        ZShareMusic *musicInfo = (ZShareMusic *)info;
        NSURL *url = [NSURL URLWithString:musicInfo.musicUrl];
        QQApiAudioObject *audioObj = [QQApiAudioObject objectWithURL:url
                                                               title:musicInfo.title
                                                         description:musicInfo.description
                                                    previewImageData:musicInfo.thumbnailData];
        audioObj.flashURL = [NSURL URLWithString:musicInfo.musicDataUrl];
        obj = audioObj;
    }
    SendMessageToQQReq *req;
    if (obj) {
        req = [SendMessageToQQReq reqWithContent:obj];
    }
    if (finish) {
        finish(req);
    }
}

@end
