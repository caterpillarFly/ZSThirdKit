//
//  ZSThirdHeaderFile.h
//  ZSThirdKit
//
//  Created by zhaosheng on 2017/8/7.
//  Copyright © 2017年 zs. All rights reserved.
//

#ifndef ZSChannelHeaderFile_h
#define ZSChannelHeaderFile_h

@class ZSChannelBase;
@class ZSAuthInfo;

typedef void (^ZSNotSupportBlock)(ZSChannelBase *channel);
typedef void (^ZSOpSuccessBlock)(ZSChannelBase *channel, id data);
typedef void (^ZSOpFailBlock)(ZSChannelBase *channel, NSError *error);
typedef void (^ZSOpCancelBlock)(ZSChannelBase *channel);
typedef void (^ZSSimpleCallBack)(id sender);

typedef NS_ENUM(NSInteger, ZSChannelErrorCode){
    ZSChannelErrorCodeCancel,
    ZSChannelErrorCodeFail,
    ZSChannelErrorCodeDataError,
    ZSChannelErrorCodeAuthDeny,
    ZSChannelErrorCodeUnsupport,
    ZSChannelErrorCodeUnknown
};


typedef NS_ENUM(NSInteger, ZSChannelType){
    ZSChannelTypeQQ,        //QQ好友
    ZSChannelTypeQQZone,    //QQ空间
    ZSChannelTypeWX,        //微信
    ZSChannelTypePYQ,       //朋友圈
    ZSChannelTypeSinaWB     //新浪微博
};


#define ZSChannelError(theCode, desc)\
({\
    NSDictionary *userInfo = nil;\
    userInfo = @{NSLocalizedDescriptionKey:desc};\
    NSString *domain = [NSString stringWithFormat:@"%s", __FILE__];\
    [NSError errorWithDomain:domain code:theCode userInfo:userInfo];\
});


#ifndef weakify
#define weakify(object) try{} @finally{} {} __weak __typeof__(object) weak##_##object = object;
#endif

#ifndef strongify
#define strongify(object) try{} @finally{} __typeof__(object) object = weak##_##object;
#endif



#endif /* ZSThirdHeaderFile_h */
