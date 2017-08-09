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

@property (nonatomic) NSString *title;
@property (nonatomic) NSString *desc;

//内容缩略图
@property (nonatomic) NSData *thumbnailData;
//内容原图
@property (nonatomic) NSData *originalImageData;

@end


@interface ZShareWebPage : ZShareMedia

@property (nonatomic, copy) NSString *url;

@end


@interface ZShareImage : ZShareMedia

@property (nonatomic) UIImage *image;

@end


#pragma mark --授权信息
@interface ZSAuthInfo : NSObject

@property (nonatomic, copy) NSString *channelKey;
@property (nonatomic, copy) NSString *openId;
@property (nonatomic, copy) NSString *token;
@property (nonatomic) long long expire;
@property (nonatomic) NSDictionary *otherInfo;

@end
