//
//  ZSThirdKitManager.h
//  ZSThirdKit
//
//  Created by zhaosheng on 2017/8/7.
//  Copyright © 2017年 zs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ZSChannelBase.h"

@interface ZSThirdKitManager : NSObject

//三方登录的渠道，非三方登录，则为nil
@property (nonatomic) ZSChannelBase *loginedChannel;
//当前操作的渠道，操作结束之后，会置为nil
@property (nonatomic) ZSChannelBase *currentChannel;


+ (instancetype)sharedManager;


//接住外部openurl回调
- (BOOL)handleOpenURL:(NSURL *)url;

@end
