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
