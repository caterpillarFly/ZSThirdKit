//
//  ZSChannelPYQ.m
//  ZSThirdKit
//
//  Created by zhaosheng on 2017/8/10.
//  Copyright © 2017年 zs. All rights reserved.
//

#import "ZSChannelPYQ.h"

@implementation ZSChannelPYQ

- (instancetype)init
{
    if (self = [super init]) {
        self.channelName = @"朋友圈";
    }
    return self;
}

- (enum WXScene)scene
{
    return WXSceneTimeline;
}

@end
