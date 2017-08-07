//
//  ZSChannelBase.m
//  ZSharekit
//
//  Created by zhaosheng on 2017/8/2.
//  Copyright © 2017年 zs. All rights reserved.
//

#import "ZSChannelBase.h"

@implementation ZSChannelBase

- (instancetype)init
{
    if (self = [super init]) {
        
    }
    return self;
}

- (BOOL)isSupportShareInfo:(ZShareInfo *)shareInfo
{
    return NO;
}

- (BOOL)couldShare
{
    return NO;
}

- (void)shareInfo:(ZShareInfo *)shareInfo success:(ZShareSuccessBlock)success fail:(ZShareFailBlock)fail cancel:(ZShareCancelBlock)cancel
{
}


@end
