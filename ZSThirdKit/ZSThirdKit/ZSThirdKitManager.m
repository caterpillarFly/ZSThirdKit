//
//  ZSThirdKitManager.m
//  ZSThirdKit
//
//  Created by zhaosheng on 2017/8/7.
//  Copyright © 2017年 zs. All rights reserved.
//

#import "ZSThirdKitManager.h"

@implementation ZSThirdKitManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static ZSThirdKitManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [ZSThirdKitManager new];
    });
    return manager;
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    return [self.currentChannel handleOpenURL:url];
}

- (ZSChannelBase *)channelWithKey:(NSString *)key
{
    ZSChannelBase *channel;
    if (self.delegate && [self.delegate respondsToSelector:@selector(channelClassNameWithKey:)]) {
        NSString *className = [self.delegate channelClassNameWithKey:key];
        channel = [NSClassFromString(className) new];
        if ([self.delegate respondsToSelector:@selector(channelInfoWithKey:)]) {
            [channel setupWithInfo:[self.delegate channelInfoWithKey:key]];
        }
    }
    return channel;
}

- (NSArray<ZSChannelBase *> *)validChannels
{
    NSMutableArray<ZSChannelBase *> *channels;
    if (self.delegate && [self.delegate respondsToSelector:@selector(channelKeys)]) {
        NSArray<NSString *> *channelKeys = [self.delegate channelKeys];
        channels = [NSMutableArray array];
        for (NSString *key in channelKeys) {
            ZSChannelBase *channel = [self channelWithKey:key];
            if ([channel couldShare]) {
                [channels addObject:channel];
            }
        }
        if (channels.count) {
            channels = nil;
        }
    }
    return channels;
}

@end
