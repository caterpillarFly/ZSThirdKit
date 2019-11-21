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
@property (nonatomic, copy) NSString *universalLink;

@end

@implementation ZSChannelQQ

- (instancetype)init
{
    if (self = [super init]) {
        self.channelName = @"QQ好友";
    }
    return self;
}

- (BOOL)handleOpenURL:(NSURL *)url userActivity:(NSUserActivity *)userActivity
{
    if (userActivity) {
        return [QQApiInterface handleOpenUniversallink:url delegate:self];
    }
    else{
        if ([TencentOAuth HandleOpenURL:url]){
            return YES;
        }
        else{
            return [QQApiInterface handleOpenURL:url delegate:self];
        }
    }
}

- (void)setupWithInfo:(NSDictionary *)info
{
    [super setupWithInfo:info];
    self.appKey = info[@"appKey"];
    self.universalLink = info[@"universalLink"];
}

- (ZSChannelType)channelType
{
    return ZSChannelTypeQQ;
}

//登录
- (void)login
{
    //QQ空间SSO登录
    NSArray *permissionArr = @[kOPEN_PERMISSION_GET_USER_INFO,
                               kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                               kOPEN_PERMISSION_ADD_TOPIC,
                               kOPEN_PERMISSION_GET_INFO,
                               kOPEN_PERMISSION_GET_OTHER_INFO,
                               kOPEN_PERMISSION_UPLOAD_PIC];
    
    if (![self.auth authorize:permissionArr inSafari:NO])
    {
        NSError *error = ZSChannelError(ZSChannelErrorCodeUnsupport, @"登录失败");
        [self didFail: error];
    }
}

//分享
- (void)shareInfo:(ZShareInfo *)shareInfo
{
    [self reqWithInfo:shareInfo finish:^(SendMessageToQQReq *req) {
        if (!req) {
            NSError *error = ZSChannelError(ZSChannelErrorCodeUnsupport, @"不支持分享该类型数据");
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
                NSError *error = ZSChannelError(ZSChannelErrorCodeUnknown, @"分享失败");
                [self didFail:error];
            }
        }
    }];
}

- (void)getUserInfo:(ZSAuthInfo *)authInfo
{
    BOOL res = [self.auth getUserInfo];
    if (!res) {
        NSError *error = ZSChannelError(ZSChannelErrorCodeFail, @"获取用户信息失败");
        [self didFail:error];
    }
}

- (BOOL)couldLogin
{
    //就算没装客户端，QQ也支持网页登录
    return YES;
}

- (BOOL)couldShare
{
    __unused TencentOAuth *auth = self.auth;
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
        authInfo.channelType = self.channelType;
        
        [self didSuccess:authInfo];
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
        NSError *error = ZSChannelError(ZSChannelErrorCodeUnknown, @"登录失败");
        [self didFail:error];
    }
    
    NSLog(@"qq登录失败");
}

//登录时网络有问题
- (void)tencentDidNotNetWork
{
    NSLog(@"qq登录网络有问题");
    NSError *error = ZSChannelError(kOpenSDKErrorNetwork, @"登录失败");
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
        NSError *error = ZSChannelError(ZSChannelErrorCodeUnknown, resp.errorDescription);
        [self didFail:error];
    }
}

- (void)getUserInfoResponse:(APIResponse *)response
{
    NSLog(@"QQ用户信息");
    if (response.errorMsg.length) {
        NSError *error = ZSChannelError(response.retCode, response.errorMsg);
        [self didFail:error];
    }
    else{
        ZSUserInfo *userinfo = [ZSUserInfo new];
        userinfo.channelType = self.channelType;
        userinfo.nickname = response.jsonResponse[@"nickname"];
        userinfo.city = response.jsonResponse[@"city"];
        userinfo.province = response.jsonResponse[@"province"];
        
        NSString *profileKey = @"figureurl_qq_2";
        if (self.scene == ZSChannelQQSceneChat) {
            profileKey = @"figureurl_2";
        }
        userinfo.profile = response.jsonResponse[profileKey];
        
        userinfo.sex = ZSUserSexUnknown;
        NSString *gender = response.jsonResponse[@"gender"];
        if ([gender isEqualToString:@"男"]){
            userinfo.sex = ZSUserSexMale;
        }
        else if ([gender isEqualToString:@"女"]){
            userinfo.sex = ZSUserSexFemale;
        }
        
        [self didSuccess:userinfo];
    }
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
                if (self.universalLink.length) {
                    _auth = [[TencentOAuth alloc] initWithAppId:self.appKey andUniversalLink:self.universalLink andDelegate:self];
                }
                else{
                    _auth = [[TencentOAuth alloc] initWithAppId:self.appKey andDelegate:self];
                }
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
                                                         description:musicInfo.desc
                                                    previewImageData:musicInfo.thumbnailData];
        audioObj.flashURL = [NSURL URLWithString:musicInfo.musicDataUrl];
        obj = audioObj;
    }
    else if ([info isKindOfClass:[ZShareVideo class]]){
        ZShareVideo *videoInfo = (ZShareVideo *)info;
        NSURL *url = [NSURL URLWithString:videoInfo.videoUrl];
        QQApiVideoObject *vidoeObj = [QQApiVideoObject objectWithURL:url
                                                               title:videoInfo.title
                                                         description:videoInfo.desc
                                                    previewImageData:videoInfo.thumbnailData];
        vidoeObj.flashURL = [NSURL URLWithString:videoInfo.videoStreamUrl];
        obj = vidoeObj;
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
