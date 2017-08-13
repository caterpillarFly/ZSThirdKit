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

@interface ZShareText : ZShareInfo

@property (nonatomic, copy) NSString *text;

@end

@interface ZShareMedia : ZShareInfo

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *desc;

//内容缩略图，一般<32k，如果超过，会导致接口调用失败
@property (nonatomic) NSData *thumbnailData;
//内容原图
@property (nonatomic) NSData *originalImageData;

@end

@interface ZShareImage : ZShareMedia

@property (nonatomic) UIImage *image;

@end

@interface ZShareWebPage : ZShareMedia

@property (nonatomic, copy) NSString *url;

@end

@interface ZShareMusic : ZShareMedia

@property (nonatomic, copy) NSString *musicUrl;
@property (nonatomic, copy) NSString *musicLowBandUrl;
@property (nonatomic, copy) NSString *musicDataUrl;
@property (nonatomic, copy) NSString *musicLowBandDataUrl;

@end


#pragma mark --登录用户信息

typedef NS_ENUM(NSInteger, ZSUserSexType){
    ZSUserSexUnknown = 0,
    ZSUserSexMale,
    ZSUserSexFemale
};

@interface ZSUserInfo : NSObject

@property (nonatomic) ZSUserSexType sex;
@property (nonatomic, copy) NSString *channelKey;
@property (nonatomic, copy) NSString *nickname;
@property (nonatomic, copy) NSString *profile;
@property (nonatomic, copy) NSString *province;
@property (nonatomic, copy) NSString *city;

@end


#pragma mark --授权信息
@interface ZSAuthInfo : NSObject

@property (nonatomic, copy) NSString *channelKey;
@property (nonatomic, copy) NSString *openId;
@property (nonatomic, copy) NSString *unionId;      //微信独有
@property (nonatomic, copy) NSString *token;
@property (nonatomic) long long expire;

@property (nonatomic) ZSUserInfo *userInfo;     //用户信息，可选

@end
