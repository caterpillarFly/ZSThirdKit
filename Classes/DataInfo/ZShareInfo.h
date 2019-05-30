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

//音乐网页url地址
@property (nonatomic, copy) NSString *musicUrl;
//音乐数据流url
@property (nonatomic, copy) NSString *musicDataUrl;
//音乐lowband网页url地址
@property (nonatomic, copy) NSString *musicLowBandUrl;
//音乐lowband数据流url
@property (nonatomic, copy) NSString *musicLowBandDataUrl;

@end


@interface ZShareVideo : ZShareMedia

//视频网页的url，不能为空且长度不能超过255
@property (nonatomic, strong) NSString *videoUrl;
// 视频数据流url，长度有限制，不能超过255，否则直接分享失败
@property (nonatomic, strong) NSString *videoStreamUrl;
//视频lowband网页的url
@property (nonatomic, strong) NSString *videoLowBandUrl;
//视频lowband数据流url
@property (nonatomic, strong) NSString *videoLowBandStreamUrl;

@end

@interface ZShareMiniProgram : ZShareMedia

//分享链接
@property (nonatomic, strong) NSString *shareUrl;
//迷你小程序固定id
@property (nonatomic, strong) NSString *userName;
//路径，需要根据分享内容拼接（目前支持歌单，歌曲）
@property (nonatomic, strong) NSString *path;

@end
