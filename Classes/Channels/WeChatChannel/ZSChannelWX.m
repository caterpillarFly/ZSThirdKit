//
//  ZSChannelWX.m
//  ZSThirdKit
//
//  Created by zhaosheng on 2017/8/8.
//  Copyright © 2017年 zs. All rights reserved.
//

#import "ZSChannelWX.h"
#import <WXApi.h>
#import <WXApiObject.h>

@interface ZSChannelWX () <WXApiDelegate, ZSOpProcessProtocol>

@property (nonatomic) BOOL hasRegistered;
@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, copy) NSString *appSecret;
@property (nonatomic, copy) NSString *universalLink;

@end

@implementation ZSChannelWX

- (instancetype)init
{
    if (self = [super init]) {
        self.channelName = @"微信好友";
    }
    return self;
}

- (enum WXScene)scene
{
    return WXSceneSession;
}

- (BOOL)handleOpenURL:(NSURL *)url userActivity:(NSUserActivity *)userActivity
{
    [self registerApp];
    if (userActivity) {
        return [WXApi handleOpenUniversalLink:userActivity delegate:self];
    }
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)couldLogin
{
    [self registerApp];
    return [WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi];
}

- (BOOL)couldShare
{
    [self registerApp];
    return [WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi];
}

- (void)registerApp
{
    if (!self.hasRegistered) {
        @synchronized (self) {
            if (!self.hasRegistered) {
                BOOL result = [WXApi registerApp:self.appKey universalLink:self.universalLink];
                self.hasRegistered = result;
            }
        }
    }
}

- (void)setupWithInfo:(NSDictionary *)info
{
    [super setupWithInfo:info];
    self.appKey = info[@"appKey"];
    self.appSecret = info[@"appSecret"];
    self.universalLink = info[@"universalLink"];
}

- (ZSChannelType)channelType
{
    return ZSChannelTypeWX;
}

- (void)login
{
    [self registerApp];
    
    SendAuthReq *authReq = [SendAuthReq new];
    authReq.scope = @"snsapi_userinfo";
    authReq.state = @"xx";
    
    @weakify(self)
    [WXApi sendReq:authReq completion:^(BOOL success) {
        @strongify(self)
        if (!success) {
            NSError *error = ZSChannelError(ZSChannelErrorCodeUnknown, @"登录失败");
            [self didFail:error];
        }
    }];
}

- (void)shareInfo:(ZShareInfo *)info
{
    [self registerApp];
    
    @weakify(self)
    [self reqWithInfo:info finish:^(SendMessageToWXReq *req) {
        @strongify(self)
        if (!req) {
            NSError *error = ZSChannelError(ZSChannelErrorCodeUnsupport, @"不支持分享该类型数据");
            [self didFail:error];
        }
        else{
            [WXApi sendReq:req completion:^(BOOL success) {
                @strongify(self)
                if (!success) {
                    NSError *error = ZSChannelError(ZSChannelErrorCodeUnknown, @"分享请求失败");
                    [self didFail:error];
                }
            }];
        }
    }];
    
}

#pragma mark --WXApiDelegate
- (void)onReq:(BaseReq *)req
{
    //收到一个来自微信的请求
    if ([req isKindOfClass:[LaunchFromWXReq class]]) {
        LaunchFromWXReq *launchReq = (LaunchFromWXReq *)req;
        WXMediaMessage *msg = launchReq.message;
        [self didRequest:msg];
    }
}

- (void)onResp:(BaseResp *)resp
{
    //收到来自微信的响应
    switch (resp.errCode) {
        case WXSuccess:{
            if ([resp isKindOfClass:[SendAuthResp class]]) {
                //登录的响应
                SendAuthResp *authResp = (SendAuthResp *)resp;
                if (authResp.code.length){
                    @weakify(self)
                    [self accessTokenWithCode:authResp.code
                                      success:^(ZSChannelBase *channel, ZSAuthInfo *authInfo) {
                                          @strongify(self)
                                          [self didSuccess:authInfo];
                                      }fail:^(ZSChannelBase *channel, NSError *error) {
                                          @strongify(self)
                                          [self didFail:error];
                                      }];
                }
                else{
                    [self didCancel];
                }
            }
            else if ([resp isKindOfClass:[SendMessageToWXResp class]]){
                [self didSuccess:nil];
            }
            break;
        }
        case WXErrCodeUserCancel:
            [self didCancel];
            break;
        default:{
            NSString *errorInfo = resp.errStr ?: @"操作失败";
            NSError *error = ZSChannelError(resp.errCode, errorInfo);
            [self didFail:error];
            break;
        }
    }
}

- (void)reqWithInfo:(ZShareInfo *)info finish:(ZSSimpleCallBack)finish
{
    SendMessageToWXReq *req = [SendMessageToWXReq new];
    req.scene = self.scene;
    if ([info isKindOfClass:[ZShareText class]]) {
        //文本
        ZShareText *textInfo = (ZShareText *)info;
        req.bText = YES;
        req.text = textInfo.text;
    }
    else if ([info isKindOfClass:[ZShareImage class]]){
        //图片
        ZShareImage *imageInfo = (ZShareImage *)info;
        WXMediaMessage *mediaMessage = [self messageWithInfo:imageInfo];
        WXImageObject *ext = [WXImageObject object];
        ext.imageData = UIImageJPEGRepresentation(imageInfo.image,0.9);
        mediaMessage.mediaObject = ext;
        
        req.message = mediaMessage;
    }
    else if ([info isKindOfClass:[ZShareWebPage class]]){
        //网页
        ZShareWebPage *webPageInfo = (ZShareWebPage *)info;
        WXMediaMessage *mediaMessage = [self messageWithInfo:webPageInfo];
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = webPageInfo.url;
        mediaMessage.mediaObject = ext;
        req.message = mediaMessage;
    }
    else if ([info isKindOfClass:[ZShareMusic class]]){
        //音频
        ZShareMusic *musicInfo = (ZShareMusic *)info;
        WXMediaMessage *mediaMessage = [self messageWithInfo:musicInfo];
        WXMusicObject *obj = [WXMusicObject object];
        obj.musicUrl = musicInfo.musicUrl;
        obj.musicDataUrl = musicInfo.musicDataUrl;
        obj.musicLowBandUrl = musicInfo.musicLowBandUrl;
        obj.musicLowBandDataUrl = musicInfo.musicLowBandDataUrl;
        mediaMessage.mediaObject = obj;
        req.message = mediaMessage;
    }
    else if ([info isKindOfClass:[ZShareVideo class]]){
        ZShareVideo *videoInfo = (ZShareVideo *)info;
        WXMediaMessage *mediaMessage = [self messageWithInfo:videoInfo];
        WXVideoObject *obj = [WXVideoObject object];
        obj.videoUrl = videoInfo.videoUrl;
        obj.videoLowBandUrl = videoInfo.videoLowBandUrl;
        mediaMessage.mediaObject = obj;
        req.message = mediaMessage;
    } else if ([info isKindOfClass:[ZShareMiniProgram class]]){
        ZShareMiniProgram *miniProgram = (ZShareMiniProgram *)info;
        WXMediaMessage *mediaMessage = [self messageWithInfo:miniProgram];
        WXMiniProgramObject *ext = [WXMiniProgramObject object];
        ext.webpageUrl = miniProgram.shareUrl;
        ext.hdImageData = miniProgram.originalImageData;
        ext.path = miniProgram.path;
        ext.userName = miniProgram.userName;
        mediaMessage.mediaObject = ext;
        req.message = mediaMessage;
        
    }
    else{
        req = nil;
    }
    
    if (finish) {
        finish(req);
    }
}

- (WXMediaMessage *)messageWithInfo:(ZShareMedia *)info
{
    WXMediaMessage *mediaMessage = [WXMediaMessage message];
    mediaMessage.title = info.title;
    mediaMessage.description = info.desc;
    mediaMessage.thumbData = info.thumbnailData;
    return mediaMessage;
}

- (void)accessTokenWithCode:(NSString *)code success:(ZSOpSuccessBlock)success fail:(ZSOpFailBlock)fail
{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",self.appKey,self.appSecret,code];
    NSURL *tokenUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:tokenUrl];
    
    @weakify(self)
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                               if (data) {
                                   NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                                        options:NSJSONReadingMutableLeaves
                                                                                          error:nil];
                                   if (dict[@"errcode"]){
                                       //错误
                                       if (fail) {
                                           NSError *error = ZSChannelError(ZSChannelErrorCodeDataError, dict[@"errmsg"]);
                                           fail(nil, error);
                                       }
                                   }
                                   else{
                                       @strongify(self)
                                       ZSAuthInfo *authInfo = [ZSAuthInfo new];
                                       authInfo.openId = dict[@"openid"];
                                       authInfo.token = dict[@"access_token"];
                                       authInfo.expire = [dict[@"expires_in"] longLongValue];
                                       authInfo.channelType = self.channelType;
                                       authInfo.unionId = dict[@"unionid"];
                                       
                                       if (success) {
                                           success(nil, authInfo);
                                       }
                                   }
                               }
                               else{
                                   if (fail) {
                                       NSError *error = ZSChannelError(ZSChannelErrorCodeFail, @"网络连接失败");
                                       fail(nil, error);
                                   }
                               }
                           }];
}

- (void)getUserInfo:(ZSAuthInfo *)authInfo
{
    NSString *url = [NSString stringWithFormat:@"https://api.weixin.qq.com/sns/userinfo?access_token=%@&openid=%@", authInfo.token, authInfo.openId];
    NSURL *tokenUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:tokenUrl];
    
    @weakify(self)
    [NSURLConnection sendAsynchronousRequest:request
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
                               
                               @strongify(self)
                               if (data){
                                   NSError *error;
                                   NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                                        options:NSJSONReadingMutableLeaves
                                                                                          error:&error];
                                   if (!error && [dict isKindOfClass:[NSDictionary class]]) {
                                       ZSUserInfo *userInfo = [ZSUserInfo new];
                                       userInfo.channelType = self.channelType;
                                       userInfo.nickname = dict[@"nickname"];
                                       userInfo.profile = dict[@"headimgurl"];
                                       userInfo.province = dict[@"province"];
                                       userInfo.city = dict[@"city"];
                                       userInfo.sex = [dict[@"sex"] integerValue];
                                       
                                       [self didSuccess:userInfo];
                                   }
                                   else{
                                       error = ZSChannelError(ZSChannelErrorCodeDataError, error.description);
                                       [self didFail:error];
                                   }
                               }
                               else{
                                   [self didFail:connectionError];
                               }
                           }];
}


@end
