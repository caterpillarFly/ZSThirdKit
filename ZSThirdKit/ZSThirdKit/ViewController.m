//
//  ViewController.m
//  ZSThirdKit
//
//  Created by zhaosheng on 2017/8/7.
//  Copyright © 2017年 zs. All rights reserved.
//

#import "ViewController.h"
#import "ZSChannelQQ.h"
#import "ZSChannelWX.h"
#import "ZSChannelSinaWB.h"
#import "ZSThirdHeaderFile.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    @weakify(self)
    [self addMenu:@"qq登录" callback:^(id sender, id data) {
        @strongify(self)
        [self qqlogin];
    }];
    
    [self addMenu:@"QQ分享图片" callback:^(id sender, id data) {
        @strongify(self)
        [self qqShareImage];
    }];
    
    [self addMenu:@"QQ分享文字" callback:^(id sender, id data) {
        @strongify(self)
        [self qqShareText];
    }];
    
    [self addMenu:@"QQ分享网页" callback:^(id sender, id data) {
        @strongify(self)
        [self qqShareWebPage];
    }];
    
    [self addMenu:@"微信登录" callback:^(id sender, id data) {
        @strongify(self)
        [self wxLogin];
    }];
    
    [self addMenu:@"微信分享文字" callback:^(id sender, id data) {
        @strongify(self)
        [self wxShareText];
    }];
    
    [self addMenu:@"微信分享图片" callback:^(id sender, id data) {
        @strongify(self)
        [self wxShareImage];
    }];
    
    [self addMenu:@"微信分享网页" callback:^(id sender, id data) {
        @strongify(self)
        [self wxShareWebPage];
    }];
    
    [self addMenu:@"微信分享音乐" callback:^(id sender, id data) {
        @strongify(self)
        [self wxShareMusic];
    }];
    
    [self addMenu:@"新浪微博登录" callback:^(id sender, id data) {
        @strongify(self)
        [self wbLogin];
    }];
    [self addMenu:@"新浪微博分享文字" callback:^(id sender, id data) {
        @strongify(self)
        [self wbShareText];
    }];
    [self addMenu:@"新浪微博分享图片" callback:^(id sender, id data) {
        @strongify(self)
        [self wbShareImage];
    }];
    [self addMenu:@"新浪微博分享网页" callback:^(id sender, id data) {
        @strongify(self)
        [self wbShareWebPage];
    }];
    [self addMenu:@"新浪微博分享音乐" callback:^(id sender, id data) {
        @strongify(self)
        [self wbShareMusic];
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)qqlogin
{
    ZSChannelQQ *qq = [ZSChannelQQ new];
    [qq setupWithInfo:@{@"appKey":@"1105787459"}];
    [qq login:^(ZSChannelBase *channel, ZSAuthInfo *authInfo) {
        NSLog(@"登录成功");
    }];
}

- (void)qqShareImage
{
    ZShareImage *imageInfo = [self shareImage];
    ZSChannelQQ *qq = [self channelQQ];
    
    [qq shareInfo:imageInfo success:^(ZSChannelBase *channel, id data) {
        NSLog(@"分享成功..........");
    } fail:^(ZSChannelBase *channel, NSError *error) {
        NSLog(@"分享失败：%@..........", [error description]);
    } cancel:^(ZSChannelBase *channel) {
        NSLog(@"分享取消..........");
    }];
}

- (void)qqShareText
{
    ZSChannelQQ *qq = [self channelQQ];
    ZShareText *shareInfo = [self shareText];
    
    [qq shareInfo:shareInfo success:^(ZSChannelBase *channel, id data) {
        NSLog(@"分享成功..........");
    } fail:^(ZSChannelBase *channel, NSError *error) {
        NSLog(@"分享失败：%@..........", [error description]);
    } cancel:^(ZSChannelBase *channel) {
        NSLog(@"分享取消..........");
    }];
}

- (void)qqShareWebPage
{
    ZSChannelQQ *qq = [self channelQQ];
    ZShareWebPage *shareInfo = [self shareWebpage];
    
    [qq shareInfo:shareInfo success:^(ZSChannelBase *channel, id data) {
        NSLog(@"分享成功..........");
    } fail:^(ZSChannelBase *channel, NSError *error) {
        NSLog(@"分享失败：%@..........", [error description]);
    } cancel:^(ZSChannelBase *channel) {
        NSLog(@"分享取消..........");
    }];
}

- (void)wxLogin
{
    ZSChannelWX *wx = [self channelWX];
    [wx login:^(ZSChannelBase *channel, ZSAuthInfo *authInfo) {
        NSLog(@"微信登录成功");
    }];
}

- (void)wxShareText
{
    ZSChannelWX *wx = [self channelWX];
    ZShareText *shareInfo = [self shareText];
    
    [wx shareInfo:shareInfo success:^(ZSChannelBase *channel, id data) {
        NSLog(@"分享成功..........");
    } fail:^(ZSChannelBase *channel, NSError *error) {
        NSLog(@"分享失败：%@..........", [error description]);
    } cancel:^(ZSChannelBase *channel) {
        NSLog(@"分享取消..........");
    }];
}

- (void)wxShareImage
{
    ZSChannelWX *wx = [self channelWX];
    ZShareImage *shareInfo = [self shareImage];
    
    [wx shareInfo:shareInfo success:^(ZSChannelBase *channel, id data) {
        NSLog(@"分享成功..........");
    } fail:^(ZSChannelBase *channel, NSError *error) {
        NSLog(@"分享失败：%@..........", [error description]);
    } cancel:^(ZSChannelBase *channel) {
        NSLog(@"分享取消..........");
    }];
}

- (void)wxShareWebPage
{
    ZSChannelWX *wx = [self channelWX];
    ZShareWebPage *shareInfo = [self shareWebpage];
    
    [wx shareInfo:shareInfo success:^(ZSChannelBase *channel, id data) {
        NSLog(@"分享成功..........");
    } fail:^(ZSChannelBase *channel, NSError *error) {
        NSLog(@"分享失败：%@..........", [error description]);
    } cancel:^(ZSChannelBase *channel) {
        NSLog(@"分享取消..........");
    }];
}

- (void)wxShareMusic
{
    ZSChannelWX *wx = [self channelWX];
    ZShareMusic *shareInfo = [self shareMusic];
    
    [wx shareInfo:shareInfo success:^(ZSChannelBase *channel, id data) {
        NSLog(@"分享成功..........");
    } fail:^(ZSChannelBase *channel, NSError *error) {
        NSLog(@"分享失败：%@..........", [error description]);
    } cancel:^(ZSChannelBase *channel) {
        NSLog(@"分享取消..........");
    }];
}

- (void)wbLogin
{
    ZSChannelSinaWB *wb = [self channelWB];
    [wb login:^(ZSChannelBase *channel, ZSAuthInfo *authInfo) {
        NSLog(@"新浪微博登录成功......");
    }];
}

- (void)wbShareText
{
    ZSChannelSinaWB *wb = [self channelWB];
    ZShareText *shareInfo = [self shareText];
    [wb shareInfo:shareInfo success:^(ZSChannelBase *channel, id data) {
        NSLog(@"分享成功..........");
    } fail:^(ZSChannelBase *channel, NSError *error) {
        NSLog(@"分享失败：%@..........", [error description]);
    } cancel:^(ZSChannelBase *channel) {
        NSLog(@"分享取消..........");
    }];
}

- (void)wbShareImage
{
    ZSChannelSinaWB *wb = [self channelWB];
    ZShareImage *shareInfo = [self shareImage];
    
    [wb shareInfo:shareInfo success:^(ZSChannelBase *channel, id data) {
        NSLog(@"分享成功..........");
    } fail:^(ZSChannelBase *channel, NSError *error) {
        NSLog(@"分享失败：%@..........", [error description]);
    } cancel:^(ZSChannelBase *channel) {
        NSLog(@"分享取消..........");
    }];
}

- (void)wbShareWebPage
{
    ZSChannelSinaWB *wb = [self channelWB];
    ZShareWebPage *shareInfo = [self shareWebpage];
    
    [wb shareInfo:shareInfo success:^(ZSChannelBase *channel, id data) {
        NSLog(@"分享成功..........");
    } fail:^(ZSChannelBase *channel, NSError *error) {
        NSLog(@"分享失败：%@..........", [error description]);
    } cancel:^(ZSChannelBase *channel) {
        NSLog(@"分享取消..........");
    }];
}

- (void)wbShareMusic
{
    ZSChannelSinaWB *wb = [self channelWB];
    ZShareMusic *shareInfo = [self shareMusic];
    
    [wb shareInfo:shareInfo success:^(ZSChannelBase *channel, id data) {
        NSLog(@"分享成功..........");
    } fail:^(ZSChannelBase *channel, NSError *error) {
        NSLog(@"分享失败：%@..........", [error description]);
    } cancel:^(ZSChannelBase *channel) {
        NSLog(@"分享取消..........");
    }];
}

- (ZSChannelQQ *)channelQQ
{
    ZSChannelQQ *qq = [ZSChannelQQ new];
    [qq setupWithInfo:@{@"appKey":@"1105787459"}];
    return qq;
}

- (ZSChannelWX *)channelWX
{
    ZSChannelWX *wx = [ZSChannelWX new];
    [wx setupWithInfo:@{@"appKey":@"wxf6d4fc0792ef3783", @"appSecert":@"3a9523bcc8a35d664fac915796ce84ec"}];
    return wx;
}

- (ZSChannelSinaWB *)channelWB
{
    ZSChannelSinaWB *wb = [ZSChannelSinaWB new];
    [wb setupWithInfo:@{@"appKey":@"1843267010", @"appSecert":@"b2f5b2b661babaa3c01b57312decffd7", @"redirectURI":@"http://music.10086.cn"}];
    return wb;
}

- (ZShareText *)shareText
{
    ZShareText *shareInfo = [ZShareText new];
    shareInfo.text = @"今天晚上点了一份小炒肉，一共花了29元钱，感觉好肉疼，太贵了，以后要节约，尽量不要在外面吃饭";
    return shareInfo;
}

- (ZShareWebPage *)shareWebpage
{
    ZShareWebPage *shareInfo = [ZShareWebPage new];
    shareInfo.desc = @"分享一首好听的音乐，真的很好听，试一试你就知道了";
    shareInfo.title = @"音乐";
    shareInfo.url = @"http://i.y.qq.com/v8/playsong.html?hostuin=0&songid=&songmid=002x5Jje3eUkXT&_wv=1&source=qq&appshare=iphone&media_mid=002x5Jje3eUkXT";
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"thumbnail.jpg"];
    shareInfo.thumbnailData = [NSData dataWithContentsOfFile:path];
    
    return shareInfo;
}

- (ZShareImage *)shareImage
{
    ZShareImage *imageInfo = [ZShareImage new];
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"xxx.jpeg"];
    imageInfo.image = [UIImage imageWithContentsOfFile:path];
    imageInfo.title = @"美女";
    imageInfo.desc = @"这是一个不知名的美女，我也不知道是谁";
    imageInfo.thumbnailData = [NSData dataWithContentsOfFile:path];
    return imageInfo;
}

- (ZShareMusic *)shareMusic
{
    ZShareMusic *shareInfo = [ZShareMusic new];
    shareInfo.desc = @"分享一首好听的音乐，真的很好听，试一试你就知道了";
    shareInfo.title = @"音乐";
    shareInfo.musicUrl = @"http://218.200.227.207:8080/app/v2/controller/share/ringtone.shtml?id=600908000003312837";
    shareInfo.musicDataUrl = @"http://c.musicapp.migu.cn/MIGUM2.0/v1.0/content/sub/listenSong.do?contentId=600908000003312837&ua=Ios_migu&version=5.0.7&netType=01&toneFlag=PQ&copyrightId=6990539Z039&resourceType=0&t=1502356007554&channel=0140070&k=b5c5969d9234228e";
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"thumbnail.jpg"];
    shareInfo.thumbnailData = [NSData dataWithContentsOfFile:path];
    return shareInfo;
}

@end
