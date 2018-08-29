//
//  LGSDKPublicHeader.h
//  LinkGameOpenSDK
//
//  Created by 刘万林 on 2018/8/10.
//  Copyright © 2018年 ChaungMiKeJi. All rights reserved.
//

#import <Foundation/Foundation.h>

#ifndef LGSDKBasePublicHeader_h
#define LGSDKBasePublicHeader_h


typedef NS_ENUM(NSInteger, LGSDKRequestErrorCode) {
    LGRequestErrorCode_Success = 200,//成功

    LGRequestErrorCode_ParameterError = 2001,//参数错误
    LGRequestErrorCode_ParameterIntegralityError = 2002,//参数校验失败
    LGRequestErrorCode_TypeNotSupport = 2003,//暂不支持的请求类型
    LGRequestErrorCode_NetworkError = 2004,//网络错误
    LGRequestErrorCode_FileError = 2005,//文件错误
    LGRequestErrorCode_AppNotFound = 2006,//AppId不存在

    LGRequestErrorCode_UserCanceled = 3002,//用户取消
    
    LGRequestErrorCode_Other = 4001,//其他

    LGRequestErrorCode_AppNotExist = 70001,//应用不存在
    LGRequestErrorCode_AppNotApproved = 70002,//APP未通过审核
    LGRequestErrorCode_ScopeError = 70007,//Scope作用域错误
};


//基础请求类型,所有请求的基类,不要直接使用此类.
@interface LGSDKBaseRequest:NSObject
@property (copy, nonatomic,nullable )  NSString * flag;//SDK发起请求时的标志，用于区分每次的请求，会原样返回。可不填
@end

//分享文字的请求
@interface LGSDKShareTextRequest:LGSDKBaseRequest
/**
 初始化一个分享文字的请求
 
 @param text 要分享的文字
 @return 返回一个分享请求(可能为空)
 */
+(instancetype)RequestWithText:(nonnull NSString *)text;
@end

//分享图文的请求
@interface LGSDKShareTextPictureRequest:LGSDKBaseRequest
/**
 初始化一个图文分享的请求
 
 @param imageURL 要分享的图片的url
 @return 返回一个分享请求(可能为空)
 */
+(instancetype)RequestWithImageURL:(nonnull NSString *)imageURL text:(nonnull NSString *)text;

/**
 初始化一个图文分享的请求
 
 @param imageData 要分享的图片的NSData（请确保小于10M）
 @return 返回一个分享请求(可能为空)
 */
+(instancetype)RequestWithImageData:(nonnull NSData *)imageData text:(nonnull NSString *)text;
@end

//分享网页链接的请求
@interface LGSDKShareWebLinkRequest:LGSDKBaseRequest
/**
 初始化一个网页链接分享的请求
 
 @param imageData 要分享的图片的NSData(请确保小于32KB)
 @param title 分享的标题
 @param text 分享的内容摘要
 @param url 网页链接的URL地址
 @return 返回一个分享请求(可能为空)
 */
+(instancetype)RequestWithImageData:(nullable NSData *)imageData Title:(nonnull NSString *)title Text:(nonnull NSString *)text linkUrl:(nonnull NSString *)url;

/**
 初始化一个网页链接分享的请求
 
 @param webImageUrl  要分享的图片的Url链接(请使用HTTPS的链接,否则iOS可能无法正常显示)
 @param title 分享的标题
 @param text 分享的内容摘要
 @param url 网页链接的URL地址
 @return 返回一个分享请求(可能为空)
 */
+(instancetype)RequestWithWebImageUrl:(nullable NSString *)webImageUrl Title:(nonnull NSString *)title Text:(nonnull NSString *)text linkUrl:(nonnull NSString *)url;
@end

//授权的请求
@interface LGSDKAuthRequest:LGSDKBaseRequest
+(instancetype)AuthRequest;
@end


//==================================

//返回结果的基类
@interface LGSDKBaseResult:NSObject
@property (copy, nonatomic,nullable )  NSString * flag;//SDK发起请求时的标志，用于区分每次的请求，原样返回。
@property (assign, nonatomic) LGSDKRequestErrorCode errorCode;//错误码,LGRequestErrorCode_Success表示成功

@end

//分享返回结果
@interface LGSDKShareResult:LGSDKBaseResult

@end

//授权的返回结果
@interface LGSDKAuthResult:LGSDKBaseResult
@property (copy, nonatomic,nonnull ) NSString * code;//授权成功时得到的临时票据

@end


#endif /* LGSDKPublicHeader_h */
