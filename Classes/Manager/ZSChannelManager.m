//
//  ZSChannelManager.m
//  ZSThirdKit
//
//  Created by zhaosheng on 2017/8/14.
//  Copyright © 2017年 zs. All rights reserved.
//

#import "ZSChannelManager.h"
#import "ZSChannelQQZone.h"
#import "ZSChannelQQ.h"
#import "ZSChannelWX.h"
#import "ZSChannelPYQ.h"
#import "ZSChannelSinaWB.h"

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
    sourceApplication:(NSString *)sourceApplication
         requestBlock:(ZSOpSuccessBlock)requestBlock
{
    if ([sourceApplication isEqualToString:@"com.tencent.xin"]) {
        //来自微信的分享，需要特殊处理小程序的问题
        if (!self.currentChannel || self.currentChannel.channelType != ZSChannelTypeWX) {
            ZSChannelBase *channel = [self channelWithType:ZSChannelTypeWX];
            self.currentChannel = channel;
        }
        [self.currentChannel setRequestBlock:^(ZSChannelBase *channel, id data) {
            if (requestBlock) {
                WXMediaMessage *msg = (WXMediaMessage *)data;
                requestBlock(channel, msg.messageExt);
            }
        }];
    }
    return [self.currentChannel handleOpenURL:url];
}

- (ZSChannelBase *)channelWithType:(ZSChannelType)channelType notInstallBlock:(ZSNotSupportBlock)block
{
    ZSChannelBase *channel = [self channelWithType:channelType];
    channel.notSupportBlock = block;
    return channel;
}

- (ZSChannelBase *)channelWithType:(ZSChannelType)channelType
{
    ZSChannelBase *base;
    switch (channelType) {
        case ZSChannelTypeQQ:
            base = [ZSChannelQQ new];
            break;
        case ZSChannelTypeQQZone:
            base = [ZSChannelQQZone new];
            break;
        case ZSChannelTypeWX:
            base = [ZSChannelWX new];
            break;
        case ZSChannelTypePYQ:
            base = [ZSChannelPYQ new];
            break;
        case ZSChannelTypeSinaWB:
            base = [ZSChannelSinaWB new];
            break;
        default:
            break;
    }
    if (!base) {
#ifdef DEBUG
        NSAssert(NO, @"不支持的渠道类型");
#endif
    }
    if (base && [self.delegate respondsToSelector:@selector(channelInfoWithType:)]) {
        [base setupWithInfo:[self.delegate channelInfoWithType:channelType]];
    }
    return base;
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
    
    if (!channels.count) {
        channels = nil;
    }
    
    return channels;
}

- (void)clear
{
    self.currentChannel = nil;
}


@end
