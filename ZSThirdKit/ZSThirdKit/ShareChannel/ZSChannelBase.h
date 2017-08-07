//
//  ZSChannelBase.h
//  ZSharekit
//
//  Created by zhaosheng on 2017/8/2.
//  Copyright © 2017年 zs. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ZShareHeaderFile.h"
#import "ZShareInfo.h"

@interface ZSChannelBase : NSObject

@property (nonatomic) ZShareSuccessBlock successBlock;
@property (nonatomic) ZShareCancelBlock cancelBlock;
@property (nonatomic) ZShareFailBlock failBlock;
@property (nonatomic) ZSNotInstallBlock notInstallBlock;
@property (nonatomic) ZSAuthBlock authBlock;

//渠道名称
@property (nonatomic, copy) NSString *channelName;
//渠道icon
@property (nonatomic) UIImage *channelIcon;
//


/**
 *  是否支持分享该类型的信息
 *
 *  @param shareInfo 分享的数据
 *
 *  @return 是否支持
 */
- (BOOL)isSupportShareInfo:(ZShareInfo *)shareInfo;


//客户端是否支持分享到该渠道
- (BOOL)couldShare;


//设置额外的信息
- (void)setExternInfo:(NSDictionary *)externInfo;


//发起分享请求
- (void)shareInfo:(ZShareInfo *)shareInfo
          success:(ZShareSuccessBlock)success
             fail:(ZShareFailBlock)fail
           cancel:(ZShareCancelBlock)cancel;

@end
