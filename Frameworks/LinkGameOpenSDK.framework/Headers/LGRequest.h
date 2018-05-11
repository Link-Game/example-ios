//
//  LGRequest.h
//  LGOpenSDK
//
//  Created by 刘万林 on 2018/3/2.
//  Copyright © 2018年 刘万林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGOpenSDKEnum.h"
@class UIImage;
 
/**
 所有请求的基类,请不要使用这个类
 */
@interface LGBaseRequest:NSObject
@property (assign, nonatomic) LGRequestType requestType;
@property (copy, nonatomic,nullable) NSString * status;//用户自定义字段,原样返回,可用于区分多个不同的Request的返回结果
@end

#pragma mark - ● 授权

/**
 授权登录请求
 */
@interface LGAuthRequest:LGBaseRequest
+(instancetype)AuthRequest;
@end

#pragma mark - ● 分享

/**
 分享请求的基类,请不要使用这个类
 */
@interface  LGBaseShareRequest:LGBaseRequest
@end

#pragma mark 分享文字
/**
 分享文字的请求.
 */
@interface LGTextShareRequest:LGBaseShareRequest

/**
 初始化一个分享文字的请求

 @param text 要分享的文字
 @return 返回一个分享请求
 */
+(instancetype)RequestWithText:(nonnull NSString *)text;
@end



#pragma mark 分享图片
/**
 分享图片的请求
 */
@interface LGImageShareRequest:LGBaseShareRequest

/**
 初始化一个图片分享的请求

 @param image 要分享的图片
 @return 返回一个分享请求
 */
+(instancetype)RequestWithUIImage:(nonnull UIImage *)image;

/**
初始化一个图片分享的请求

 @param imageData 要分享的图片的NSData
 @return 返回一个分享请求
 */
+(instancetype)RequestWithImageData:(nonnull NSData *)imageData;
@end

#pragma mark 分享网页链接
/**
 分享网页链接的请求
 */
@interface LGWebPageShareRequest:LGBaseShareRequest

/**
 初始化一个网页链接分享的请求

 @param filePath 要分享的图片的文件路径(请确保图片小于32KB)
 @param title 分享的标题
 @param text 分享的内容摘要
 @param url 网页链接的URL地址
 @return 返回一个分享请求
 */
+(instancetype)RequestWithImageFilePath:(nullable NSString *)filePath
                                Title:(nullable NSString *)title
                                 Text:(nullable NSString *)text
                              linkUrl:(nullable NSURL *)url;


/**
 初始化一个网页链接分享的请求

 @param imageData 要分享的图片的NSData(请确保小于32KB)
 @param title 分享的标题
 @param text 分享的内容摘要
 @param url 网页链接的URL地址
 @return 返回一个分享请求
 */
+(instancetype)RequestWithImageData:(nullable NSData *)imageData
                           Title:(nullable NSString *)title
                            Text:(nullable NSString *)text
                         linkUrl:(nullable NSURL *)url;

/**
 初始化一个网页链接分享的请求

 @param webImageUrl  要分享的图片的Url链接(请使用HTTPS的链接,否则iOS可能无法正常显示)
 @param title 分享的标题
 @param text 分享的内容摘要
 @param url 网页链接的URL地址
 @return 返回一个分享请求
 */
+(instancetype)RequestWithWebImageUrl:(nullable NSString *)webImageUrl
                                Title:(nullable NSString *)title
                                 Text:(nullable NSString *)text
                              linkUrl:(nullable NSURL *)url;

@end
