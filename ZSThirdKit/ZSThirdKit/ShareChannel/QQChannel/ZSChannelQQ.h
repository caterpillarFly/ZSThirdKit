//
//  ZSChannelQQ.h
//  ZSharekit
//
//  Created by zhaosheng on 2017/8/2.
//  Copyright © 2017年 zs. All rights reserved.
//

#import "ZSChannelBase.h"
#import "ZSThirdKitManager.h"

typedef NS_ENUM(NSInteger, ZSChannelQQScene){
    ZSChannelQQSceneChat = 0,       //qq聊天界面
    ZSChannelQQSceneQQZone = 1      //qq空间
};

@interface ZSChannelQQ : ZSChannelBase

@property (nonatomic, readonly) ZSChannelQQScene scene;

@end
