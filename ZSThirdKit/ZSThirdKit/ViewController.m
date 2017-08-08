//
//  ViewController.m
//  ZSThirdKit
//
//  Created by zhaosheng on 2017/8/7.
//  Copyright © 2017年 zs. All rights reserved.
//

#import "ViewController.h"
#import "ZSChannelQQ.h"
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
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)qqlogin
{
    ZSChannelQQ *qq = [ZSChannelQQ new];
    qq.appKey = @"1105787459";
    [qq login:^(ZSChannelBase *channel, ZSAuthInfo *authInfo) {
        NSLog(@"登录成功了吗？？");
    }];
}

- (void)qqShareImage
{
    ZShareImage *imageInfo = [ZShareImage new];
    NSString *path = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"img.jpg"];
    imageInfo.image = [UIImage imageWithContentsOfFile:path];
    
    ZSChannelQQ *qq = [ZSChannelQQ new];
    qq.appKey = @"1105787459";
    
    //@weakify(self)
    [qq shareInfo:imageInfo success:^(ZSChannelBase *channel, id data) {
        //@strongify(self)
        NSLog(@"分享成功..........");
    } fail:^(ZSChannelBase *channel, NSError *error) {
        //@strongify(self)
        NSLog(@"分享失败：%@..........", [error description]);
    } cancel:^(ZSChannelBase *channel) {
        //@strongify(self)
        NSLog(@"分享取消..........");
    }];
}

- (void)qqShareText
{
    
}

- (void)qqShareWebPage
{
    
}


@end
