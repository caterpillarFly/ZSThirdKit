//
//  ZSChannelManager.m
//  ZSThirdKit
//
//  Created by zhaosheng on 2017/8/14.
//  Copyright © 2017年 zs. All rights reserved.
//

#import "ZSChannelManager.h"

@implementation ZSChannelManager

+ (instancetype)sharedManager
{
    static dispatch_once_t onceToken;
    static ZSChannelManager *manager;
    dispatch_once(&onceToken, ^{
        manager = [ZSChannelManager new];
    });
    return manager;
}

- (BOOL)handleOpenURL:(NSURL *)url
{
    return [self.currentChannel handleOpenURL:url];
}

- (ZSChannelBase *)channelWithType:(ZSChannelType)channelType
{
    return [self channelWithType:channelType notInstallBlock:nil];
}

- (ZSChannelBase *)channelWithType:(ZSChannelType)channelType notInstallBlock:(ZSNotSupportBlock)block
{
    ZSChannelBase *channel = [ZSChannelBase channelWithType:channelType];
    channel.notSupportBlock = block;
    if ([self.delegate respondsToSelector:@selector(channelInfoWithType:)]) {
        [channel setupWithInfo:[self.delegate channelInfoWithType:channelType]];
    }
    return channel;
}

- (NSArray<ZSChannelBase *> *)validChannels
{
    NSArray *channelTypes = @[@(ZSChannelTypeWX),
                              @(ZSChannelTypePYQ),
                              @(ZSChannelTypeSinaWB),
                              @(ZSChannelTypeQQZone),
                              @(ZSChannelTypeQQ)];
    
    NSMutableArray<ZSChannelBase *> *channels = [NSMutableArray array];
    
    for (NSInteger index = 0; index < channelTypes.count; ++index) {
        ZSChannelType type = [channelTypes[index] integerValue];
        ZSChannelBase *channel = [self channelWithType:type];
        if ([channel couldShare]) {
            [channels addObject:channel];
        }
    }
    
    if (channels.count) {
        channels = nil;
    }
    
    return channels;
}

- (void)clear
{
    self.currentChannel = nil;
}


@end
