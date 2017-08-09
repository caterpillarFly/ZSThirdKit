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

#import "ZSThirdKitManager.h"

@interface ZSChannelWX () <WXApiDelegate>

@property (nonatomic) BOOL hasRegistered;
@property (nonatomic) NSString *appKey;
@property (nonatomic) NSString *appSecret;

@end

@implementation ZSChannelWX

- (instancetype)init
{
    if (self = [super init]) {
        self.channelName = @"WeChat";
    }
    return self;
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    return [WXApi handleOpenURL:url delegate:self];
}

- (BOOL)couldLogin
{
    [self registerApp];
    return [WXApi isWXAppInstalled] && [WXApi isWXAppSupportApi];
}

- (void)registerApp
{
    if (!self.hasRegistered) {
        @synchronized (self) {
            if (!self.hasRegistered) {
                [WXApi registerApp:self.appKey];
                self.hasRegistered = YES;
            }
        }
    }
}

- (void)setupWithInfo:(NSDictionary *)info
{
    self.appKey = info[@"appKey"];
    self.appSecret = info[@"appSecret"];
}

- (void)login
{
    [self registerApp];
    [ZSThirdKitManager sharedManager].currentChannel = self;
    
    SendAuthReq *authReq = [SendAuthReq new];
    authReq.scope = @"snsapi_userinfo";
    authReq.state = @"com.migu.mobilemusic";
    
    [WXApi sendReq:authReq];
}

- (void)shareInfo:(ZShareInfo *)info
{
    [self registerApp];
    
    [self reqWithInfo:info finish:^(SendMessageToWXReq *req) {
        if (!req) {
            NSError *error = ZSThirdError(ZSThirdErrorCodeUnsupport, @"不支持分享该类型数据");
            [self didFail:error];
        }
        else{
            BOOL sendRes = [WXApi sendReq:req];
            if (!sendRes) {
                NSError *error = ZSThirdError(ZSThirdErrorCodeUnknown, @"分享请求失败");
                [self didFail:error];
            }
        }
    }];
    
}

#pragma mark --WXApiDelegate
- (void)onReq:(BaseReq *)req
{
    //收到一个来自微信的请求
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
                    [self accessTokenWithCode:authResp.code success:^(ZSChannelBase *channel, ZSAuthInfo *authInfo) {
                        @strongify(self)
                        [self didLogin:authInfo];
                    } fail:^(ZSChannelBase *channel, NSError *error) {
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
            NSError *error = ZSThirdError(resp.errCode, resp.errStr);
            [self didFail:error];
            break;
        }
    }
}

- (void)reqWithInfo:(ZShareInfo *)info finish:(ZSSimpleCallBack)finish
{
    SendMessageToWXReq *req = [SendMessageToWXReq new];
    if ([info isKindOfClass:[ZShareText class]]) {
        ZShareText *textInfo = (ZShareText *)info;
        req.bText = YES;
        req.text = textInfo.text;
    }
    else if ([info isKindOfClass:[ZShareImage class]]){
        ZShareImage *imageInfo = (ZShareImage *)info;
        WXMediaMessage *mediaMessage = [self messageWithInfo:imageInfo];
        //[mediaMessage setThumbImage:[imageObj.image thumbnail]];
        WXImageObject *ext = [WXImageObject object];
        ext.imageData = UIImageJPEGRepresentation(imageInfo.image,0.9);
        mediaMessage.mediaObject = ext;
        
        req.message = mediaMessage;
    }
    else if ([info isKindOfClass:[ZShareWebPage class]]){
        ZShareWebPage *webPageInfo = (ZShareWebPage *)info;
        WXMediaMessage *mediaMessage = [self messageWithInfo:webPageInfo];
        WXWebpageObject *ext = [WXWebpageObject object];
        ext.webpageUrl = webPageInfo.url;
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

- (void)accessTokenWithCode:(NSString *)code success:(ZSAuthBlock)success fail:(ZSOpFailBlock)fail
{
    NSString *url =[NSString stringWithFormat:@"https://api.weixin.qq.com/sns/oauth2/access_token?appid=%@&secret=%@&code=%@&grant_type=authorization_code",self.appKey,self.appSecret,code];
    //url = [url stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSURL *tokenUrl = [NSURL URLWithString:url];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:tokenUrl];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (data) {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data
                                                                 options:NSJSONReadingMutableLeaves
                                                                   error:nil];
            if (dict[@"errcode"]){
                //错误
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (fail) {
                        NSError *error = ZSThirdError(ZSThirdErrorCodeDataError, dict[@"errmsg"]);
                        fail(nil, error);
                    }
                });
            }
            else{
                ZSAuthInfo *authInfo = [ZSAuthInfo new];
                authInfo.openId = dict[@"openid"];
                authInfo.token = dict[@"access_token"];
                authInfo.expire = [dict[@"expires_in"] longLongValue];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    if (success) {
                        success(nil, authInfo);
                    }
                });
            }
        }
        else{
            dispatch_async(dispatch_get_main_queue(), ^{
                if (fail) {
                    NSError *error = ZSThirdError(ZSThirdErrorCodeFail, @"获取token时，网络连接失败");
                    fail(nil, error);
                }
            });
        }
    }];
}


@end
