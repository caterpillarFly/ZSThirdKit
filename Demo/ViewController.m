//
//  ViewController.m
//  ZSThirdKit
//
//  Created by zhaosheng on 2017/8/7.
//  Copyright © 2017年 zs. All rights reserved.
//

#import "ViewController.h"
#import "ZSChannelManager.h"
#import "ZSChannelConfigSample.h"
#import "NSData+ZSExt.h"

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    ZSChannelConfigSample *config = [ZSChannelConfigSample new];
    [ZSChannelManager sharedManager].delegate = config;
    
    [self addMenu:@"清理channel" callback:^(id sender, id data) {
        [[ZSChannelManager sharedManager] clear];
    }];
    
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
    
    [self addMenu:@"QQ分享音乐" callback:^(id sender, id data) {
        @strongify(self)
        [self qqShareMusic];
    }];
    
    [self addMenu:@"QQ分享视频" callback:^(id sender, id data) {
        @strongify(self)
        [self qqShareVideo];
    }];
    
    [self addMenu:@"QQ空间分享网页" callback:^(id sender, id data) {
        @strongify(self);
        [self qqzoneShareWebPage];
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
    
    [self addMenu:@"微信分享视频" callback:^(id sender, id data) {
        @strongify(self)
        [self wxShareVideo];
    }];
    
    [self addMenu:@"朋友圈分享网页" callback:^(id sender, id data) {
        @strongify(self)
        [self pyqShareWebPage];
    }];
    
    [self addMenu:@"朋友圈分享视频" callback:^(id sender, id data) {
        @strongify(self)
        [self pyqShareVideo];
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
    [self addMenu:@"新浪微博分享视频" callback:^(id sender, id data) {
        @strongify(self)
        [self wbShareVideo];
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)qqlogin
{
    ZSChannelBase *qq = [self channelQQ];
    
    @weakify(qq)
    [qq login:^(ZSChannelBase *channel, ZSAuthInfo *authInfo) {
        NSLog(@"登录成功");
        @strongify(qq)
        [qq getUserInfoWithAuth:authInfo success:^(ZSChannelBase *channel, id data) {
            NSLog(@"成功获取qq用户信息---------------");
        } fail:^(ZSChannelBase *channel, NSError *error) {
            NSLog(@"获取qq用户信息失败***************");
        }];
    } fail:^(ZSChannelBase *channel, NSError *error) {
        NSLog(@"登录失败");
    } cancel:^(ZSChannelBase *channel) {
        NSLog(@"取消登录");
    }];
}

- (void)qqShareImage
{
    ZShareImage *imageInfo = [self shareImage];
    ZSChannelBase *qq = [self channelQQ];
    
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
    ZSChannelBase *qq = [self channelQQ];
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
    ZSChannelBase *qq = [self channelQQ];
    ZShareWebPage *shareInfo = [self shareWebpage];
    
    [qq shareInfo:shareInfo success:^(ZSChannelBase *channel, id data) {
        NSLog(@"分享成功..........");
    } fail:^(ZSChannelBase *channel, NSError *error) {
        NSLog(@"分享失败：%@..........", [error description]);
    } cancel:^(ZSChannelBase *channel) {
        NSLog(@"分享取消..........");
    }];
}

- (void)qqShareMusic
{
    ZSChannelBase *qq = [self channelQQ];
    ZShareMusic *shareInfo = [self shareMusic];
    
    [qq shareInfo:shareInfo success:^(ZSChannelBase *channel, id data) {
        NSLog(@"分享成功..........");
    } fail:^(ZSChannelBase *channel, NSError *error) {
        NSLog(@"分享失败：%@..........", [error description]);
    } cancel:^(ZSChannelBase *channel) {
        NSLog(@"分享取消..........");
    }];
}

- (void)qqShareVideo
{
    ZSChannelBase *qq = [self channelQQ];
    ZShareVideo *shareInfo = [self shareVideo];
    
    [qq shareInfo:shareInfo success:^(ZSChannelBase *channel, id data) {
        NSLog(@"分享成功..........");
    } fail:^(ZSChannelBase *channel, NSError *error) {
        NSLog(@"分享失败：%@..........", [error description]);
    } cancel:^(ZSChannelBase *channel) {
        NSLog(@"分享取消..........");
    }];
}

- (void)qqzoneShareWebPage
{
    ZSChannelBase *qqzone = [self channelQQZone];
    ZShareWebPage *shareInfo = [self shareWebpage];
    
    [qqzone shareInfo:shareInfo success:^(ZSChannelBase *channel, id data) {
        NSLog(@"分享成功..........");
    } fail:^(ZSChannelBase *channel, NSError *error) {
        NSLog(@"分享失败：%@..........", [error description]);
    } cancel:^(ZSChannelBase *channel) {
        NSLog(@"分享取消..........");
    }];
}

- (void)wxLogin
{
    ZSChannelBase *wx = [self channelWX];
    @weakify(wx)
    [wx login:^(ZSChannelBase *channel, ZSAuthInfo *authInfo) {
        NSLog(@"登录成功");
        @strongify(wx)
        [wx getUserInfoWithAuth:authInfo success:^(ZSChannelBase *channel, id data) {
            NSLog(@"成功获取微信用户信息---------------");
        } fail:^(ZSChannelBase *channel, NSError *error) {
            NSLog(@"获取微信用户信息失败***************");
        }];
    } fail:^(ZSChannelBase *channel, NSError *error) {
        NSLog(@"登录失败");
    } cancel:^(ZSChannelBase *channel) {
        NSLog(@"取消登录");
    }];
}

- (void)wxShareText
{
    ZSChannelBase *wx = [self channelWX];
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
    ZSChannelBase *wx = [self channelWX];
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
    ZSChannelBase *wx = [self channelWX];
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
    ZSChannelBase *wx = [self channelWX];
    ZShareMusic *shareInfo = [self shareMusic];
    
    [wx shareInfo:shareInfo success:^(ZSChannelBase *channel, id data) {
        NSLog(@"分享成功..........");
    } fail:^(ZSChannelBase *channel, NSError *error) {
        NSLog(@"分享失败：%@..........", [error description]);
    } cancel:^(ZSChannelBase *channel) {
        NSLog(@"分享取消..........");
    }];
}

- (void)wxShareVideo
{
    ZSChannelBase *wx = [self channelWX];
    ZShareVideo *shareInfo = [self shareVideo];
    
    [wx shareInfo:shareInfo success:^(ZSChannelBase *channel, id data) {
        NSLog(@"分享成功..........");
    } fail:^(ZSChannelBase *channel, NSError *error) {
        NSLog(@"分享失败：%@..........", [error description]);
    } cancel:^(ZSChannelBase *channel) {
        NSLog(@"分享取消..........");
    }];
}

- (void)pyqShareWebPage
{
    ZSChannelBase *pyq = [self channelPYQ];
    ZShareWebPage *shareInfo = [self shareWebpage];
    
    [pyq shareInfo:shareInfo success:^(ZSChannelBase *channel, id data) {
        NSLog(@"分享成功..........");
    } fail:^(ZSChannelBase *channel, NSError *error) {
        NSLog(@"分享失败：%@..........", [error description]);
    } cancel:^(ZSChannelBase *channel) {
        NSLog(@"分享取消..........");
    }];
}

- (void)pyqShareVideo
{
    ZSChannelBase *pyq = [self channelPYQ];
    ZShareVideo *shareInfo = [self shareVideo];
    
    [pyq shareInfo:shareInfo success:^(ZSChannelBase *channel, id data) {
        NSLog(@"分享成功..........");
    } fail:^(ZSChannelBase *channel, NSError *error) {
        NSLog(@"分享失败：%@..........", [error description]);
    } cancel:^(ZSChannelBase *channel) {
        NSLog(@"分享取消..........");
    }];
}

- (void)wbLogin
{
    ZSChannelBase *wb = [self channelWB];
    @weakify(wb)
    [wb login:^(ZSChannelBase *channel, ZSAuthInfo *authInfo) {
        NSLog(@"登录成功");
        @strongify(wb)
        [wb getUserInfoWithAuth:authInfo success:^(ZSChannelBase *channel, id data) {
            NSLog(@"成功获取微博用户信息---------------");
        } fail:^(ZSChannelBase *channel, NSError *error) {
            NSLog(@"获取微博用户信息失败***************");
        }];
    } fail:^(ZSChannelBase *channel, NSError *error) {
        NSLog(@"登录失败");
    } cancel:^(ZSChannelBase *channel) {
        NSLog(@"取消登录");
    }];
}

- (void)wbShareText
{
    ZSChannelBase *wb = [self channelWB];
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
    ZSChannelBase *wb = [self channelWB];
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
    ZSChannelBase *wb = [self channelWB];
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
    ZSChannelBase *wb = [self channelWB];
    ZShareMusic *shareInfo = [self shareMusic];
    
    [wb shareInfo:shareInfo success:^(ZSChannelBase *channel, id data) {
        NSLog(@"分享成功..........");
    } fail:^(ZSChannelBase *channel, NSError *error) {
        NSLog(@"分享失败：%@..........", [error description]);
    } cancel:^(ZSChannelBase *channel) {
        NSLog(@"分享取消..........");
    }];
}

- (void)wbShareVideo
{
    ZSChannelBase *wb = [self channelWB];
    ZShareVideo *shareInfo = [self shareVideo];
    
    [wb shareInfo:shareInfo success:^(ZSChannelBase *channel, id data) {
        NSLog(@"分享成功..........");
    } fail:^(ZSChannelBase *channel, NSError *error) {
        NSLog(@"分享失败：%@..........", [error description]);
    } cancel:^(ZSChannelBase *channel) {
        NSLog(@"分享取消..........");
    }];
}

- (ZSChannelBase *)channelQQ
{
    ZSChannelBase *qq = [[ZSChannelManager sharedManager] channelWithType:ZSChannelTypeQQ];
    return qq;
}

- (ZSChannelBase *)channelQQZone
{
    ZSChannelBase *qqzone = [[ZSChannelManager sharedManager] channelWithType:ZSChannelTypeQQZone];
    return qqzone;
}

- (ZSChannelBase *)channelWX
{
    ZSChannelBase *wx = [[ZSChannelManager sharedManager] channelWithType:ZSChannelTypeWX];
    return wx;
}

- (ZSChannelBase *)channelPYQ
{
    ZSChannelBase *pyq = [[ZSChannelManager sharedManager] channelWithType:ZSChannelTypePYQ];
    return pyq;
}

- (ZSChannelBase *)channelWB
{
    ZSChannelBase *wb = [[ZSChannelManager sharedManager] channelWithType:ZSChannelTypeSinaWB];
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
    shareInfo.title = @"网页分享测试";
    shareInfo.url = @"http://i.y.qq.com/v8/playsong.html?hostuin=0&songid=&songmid=002x5Jje3eUkXT&_wv=1&source=qq&appshare=iphone&media_mid=002x5Jje3eUkXT";
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"xxx.jpeg"];
    shareInfo.thumbnailData = [NSData dataWithContentsOfFile:path];
    NSInteger limitSize = 32 * 1024;
    if (shareInfo.thumbnailData.length > limitSize) {
        shareInfo.thumbnailData = [NSData compressImageData:shareInfo.thumbnailData belowSize:limitSize];
    }
    
    return shareInfo;
}

- (ZShareImage *)shareImage
{
    ZShareImage *imageInfo = [ZShareImage new];
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"xxx.jpeg"];
    imageInfo.image = [UIImage imageWithContentsOfFile:path];
    imageInfo.title = @"图片分享测试";
    imageInfo.desc = @"这是一个不知名的美女，我也不知道是谁";
    imageInfo.thumbnailData = [NSData dataWithContentsOfFile:path];
    return imageInfo;
}

- (ZShareMusic *)shareMusic
{
    ZShareMusic *shareInfo = [ZShareMusic new];
    shareInfo.desc = @"分享一首好听的音乐，真的很好听，试一试你就知道了";
    shareInfo.title = @"音乐分享测试";
    shareInfo.musicUrl = @"";
    shareInfo.musicDataUrl = @"";
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"xxx.jpeg"];
    shareInfo.thumbnailData = [NSData dataWithContentsOfFile:path];
    NSInteger limitSize = 32 * 1024;
    if (shareInfo.thumbnailData.length > limitSize) {
        shareInfo.thumbnailData = [NSData compressImageData:shareInfo.thumbnailData belowSize:limitSize];
    }

    return shareInfo;
}

- (ZShareVideo *)shareVideo
{
    ZShareVideo *shareInfo = [ZShareVideo new];
    shareInfo.desc = @"分享一个小黄片给你，你懂的！！";
    shareInfo.title = @"分享视频测试";
    shareInfo.videoUrl = @"http://music.163.com/#/video?from=singlemessage&id=8426C841B242421344894351484E8814&userid=496477158&isappinstalled=1";
    shareInfo.videoStreamUrl = @"http://vodkgeyttp8.vod.126.net/vodkgeyttp8/RII32aFx_20501837_hd.mp4?wsSecret=9850d168d925a3027fb8e70b53b69478&wsTime=1506587392";
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"xxx.jpeg"];
    shareInfo.thumbnailData = [NSData dataWithContentsOfFile:path];
    NSInteger limitSize = 32 * 1024;
    if (shareInfo.thumbnailData.length > limitSize) {
        shareInfo.thumbnailData = [NSData compressImageData:shareInfo.thumbnailData belowSize:limitSize];
    }
    
    return shareInfo;
}


//图片压缩
//压缩图片

@end
