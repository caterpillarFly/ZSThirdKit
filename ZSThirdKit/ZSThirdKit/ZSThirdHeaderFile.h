//
//  ZSThirdHeaderFile.h
//  ZSThirdKit
//
//  Created by zhaosheng on 2017/8/7.
//  Copyright © 2017年 zs. All rights reserved.
//

#ifndef ZSThirdHeaderFile_h
#define ZSThirdHeaderFile_h

@class ZSChannelBase;
@class ZSAuthInfo;

typedef void (^ZSNotInstallBlock)(ZSChannelBase *channel);
typedef void (^ZSOpSuccessBlock)(ZSChannelBase *channel, id data);
typedef void (^ZSOpFailBlock)(ZSChannelBase *channel, NSError *error);
typedef void (^ZSOpCancelBlock)(ZSChannelBase *channel);
typedef void (^ZSAuthBlock)(ZSChannelBase *channel, ZSAuthInfo *authInfo);

typedef NS_ENUM(NSInteger, ZSThirdErrorCode){
    ZSThirdErrorCodeSuccess,
    ZSThirdErrorCodeCancel,
    ZSThirdErrorCodeFail,
    ZSThirdErrorCodeAuthDeny,
    ZSThirdErrorCodeUnsupport,
    ZSThirdErrorCodeUnknown
};

#define ZSThirdError(theCode, desc)\
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
