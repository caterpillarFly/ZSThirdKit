//
//  ZSChannelSinaWB.m
//  ZSThirdKit
//
//  Created by zhaosheng on 2017/8/10.
//  Copyright © 2017年 zs. All rights reserved.
//

#import "ZSChannelSinaWB.h"
#import <WeiboSDK.h>

@interface ZSChannelSinaWB ()<WeiboSDKDelegate>

@property (nonatomic, copy) NSString *appKey;
@property (nonatomic, copy) NSString *appSecret;
@property (nonatomic, copy) NSString *redirectURI;

@property (nonatomic) BOOL hasRegistered;

@end

@implementation ZSChannelSinaWB

- (BOOL)couldLogin
{
    return YES;
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    return [WeiboSDK handleOpenURL:url delegate:self];
}

- (void)setupWithInfo:(NSDictionary *)info
{
    self.appKey = info[@"appKey"];
    self.appSecret = info[@"appSecret"];
    self.redirectURI = info[@"redirectURI"];
    if (!self.redirectURI) {
        self.redirectURI = @"https://";
    }
}

- (void)login
{
    [self registerApp];
    [ZSThirdKitManager sharedManager].currentChannel = self;
    
    WBAuthorizeRequest *authReq = [WBAuthorizeRequest request];
    authReq.redirectURI = self.redirectURI;
    authReq.scope = @"all";
    
    [WeiboSDK sendRequest:authReq];
}

- (void)shareInfo:(ZShareInfo *)shareInfo
{
    [self registerApp];
    [self reqWithInfo:shareInfo finish:^(WBSendMessageToWeiboRequest *sender) {
        if (sender) {
            BOOL shareRes = [WeiboSDK sendRequest:sender];
            if (!shareRes) {
                NSError *error = ZSThirdError(ZSThirdErrorCodeUnknown, @"分享失败");
                [self didFail:error];
            }
        }
        else{
            NSError *error = ZSThirdError(ZSThirdErrorCodeDataError, @"分享的数据类型不支持");
            [self didFail:error];
        }
    }];
}

- (void)registerApp
{
    if (!self.hasRegistered) {
        @synchronized (self) {
            if (!self.hasRegistered) {
                [WeiboSDK registerApp:self.appKey];
                self.hasRegistered = YES;
            }
        }
    }
}

#pragma mark --WeiboSDKDelegate
- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    //收到来自微博的请求
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    //收到来自微博的响应
    switch (response.statusCode) {
        case WeiboSDKResponseStatusCodeSuccess:
        {
            if ([response isKindOfClass:[WBAuthorizeResponse class]]){
                WBAuthorizeResponse *authResponse = (WBAuthorizeResponse *)response;
                if (authResponse.accessToken.length) {
                    ZSAuthInfo *authInfo = [ZSAuthInfo new];
                    authInfo.openId = authResponse.userID;
                    authInfo.token = authResponse.accessToken;
                    authInfo.expire = [authResponse.expirationDate timeIntervalSince1970];
                    [self didLogin:authInfo];
                }
                else{
                    [self didCancel];
                }
            }
            else if ([response isKindOfClass:[WBSendMessageToWeiboResponse class]]){
                NSMutableDictionary *dict = [@{@"status":@"success", @"type":@"sendMessage"} mutableCopy];
                if (response.userInfo) dict[@"userInfo"] = response.userInfo;
                if (response.requestUserInfo) dict[@"requestUserInfo"] = response.requestUserInfo;
                [self didSuccess:dict];
            }
            NSLog(@"新浪微博操作成功.......");
            break;
        }
        case WeiboSDKResponseStatusCodeUserCancel:
        case WeiboSDKResponseStatusCodeUserCancelInstall:
            [self didCancel];
            break;
        default:{
            NSError *error = ZSThirdError(ZSThirdErrorCodeUnknown, @"未知错误");
            [self didFail:error];
            NSLog(@"新浪微博操作失败.......");
            break;
        }
    }
}

- (void)reqWithInfo:(ZShareInfo *)info finish:(ZSSimpleCallBack)finish
{
    WBSendMessageToWeiboRequest *request;
    WBMessageObject *messageObj = [WBMessageObject message];
    if ([info isKindOfClass:[ZShareText class]]){
        ZShareText *textInfo = (ZShareText *)info;
        messageObj.text = textInfo.text;
    }
    else if ([info isKindOfClass:[ZShareImage class]]){
        ZShareImage *imageInfo = (ZShareImage *)info;
        messageObj.text = imageInfo.desc;
        
        WBImageObject *imageObj = [WBImageObject object];
        imageObj.imageData = UIImageJPEGRepresentation(imageInfo.image, 1.0);
        messageObj.imageObject = imageObj;
    }
    else if ([info isKindOfClass:[ZShareWebPage class]]){
        ZShareWebPage *webPageInfo = (ZShareWebPage *)info;
        
        WBWebpageObject *webPageObj = [WBWebpageObject object];
        webPageObj.webpageUrl = webPageInfo.url;
        webPageObj.title = webPageInfo.desc;
        webPageObj.description = webPageInfo.desc;
        webPageObj.thumbnailData = webPageInfo.thumbnailData;
        webPageObj.objectID = @"ZSThirdKit";        //一定得设置这个字段，不然无法调起微博客户端
        messageObj.mediaObject = webPageObj;
    }
    else if ([info isKindOfClass:[ZShareMusic class]]){
        ZShareMusic *musicInfo = (ZShareMusic *)info;
        WBMusicObject *musicObj = [WBMusicObject object];
        musicObj.musicUrl = musicInfo.musicUrl;
        musicObj.musicStreamUrl = musicInfo.musicDataUrl;
        musicObj.musicLowBandUrl = musicInfo.musicLowBandUrl;
        musicObj.musicLowBandStreamUrl = musicInfo.musicLowBandDataUrl;
        musicObj.title = musicInfo.desc;
        musicObj.description = musicInfo.desc;
        musicObj.thumbnailData = musicInfo.thumbnailData;
        musicObj.objectID = @"ZSThirdKit";
        messageObj.mediaObject = musicObj;
    }
    else{
        messageObj = nil;
    }
    if (messageObj) {
        request = [WBSendMessageToWeiboRequest requestWithMessage:messageObj];
    }
    if (finish) {
        finish(request);
    }
}



@end
