//
//  ZShareInfo.h
//  ZSharekit
//
//  Created by zhaosheng on 2017/8/2.
//  Copyright © 2017年 zs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface ZShareInfo : NSObject

@end


@interface ZShareWebPage : ZShareInfo

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;
@property (nonatomic, copy) NSString *url;

@end


@interface ZShareText : ZShareInfo

@property (nonatomic, copy) NSString *text;

@end


@interface ZShareImage : ZShareInfo

@property (nonatomic) UIImage *image;
@property (nonatomic) NSURL *imageFileURL;

@end


#pragma mark --授权信息
@interface ZSAuthInfo : NSObject

@property (nonatomic, copy) NSString *channelKey;
@property (nonatomic, copy) NSString *userId;
@property (nonatomic, copy) NSString *token;
@property (nonatomic) long long expire;
@property (nonatomic) NSDictionary *otherInfo;

@end
