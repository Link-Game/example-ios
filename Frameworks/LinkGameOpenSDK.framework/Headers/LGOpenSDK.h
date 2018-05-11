//
//  LGOpenSDK.h
//  LGOpenSDK
//
//  Created by 刘万林 on 2018/3/2.
//  Copyright © 2018年 刘万林. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <LinkGameOpenSDK/LGRequest.h>
#import <LinkGameOpenSDK/LGResponse.h>

//! Project version number for LGOpenSDK.
FOUNDATION_EXPORT double LinkGameOpenSDKVersionNumber;
//! Project version string for LGOpenSDK.
FOUNDATION_EXPORT const unsigned char LinkGameOpenSDKVersionString[];

@protocol LinkGameOpenSDKDelegate<NSObject>

-(void)didResponsed:(LGBaseResponse * )response;
@end

/**
 开放平台SDK
 */
@interface LGOpenSDK:NSObject

/**
 获得SDK单例
 */
+(instancetype)share;

/**
 注册App

 @param appID 开放平台提供的AppID
 @param appSecret 开放平台提供的AppSecret
 @param delegate 响应回调的delegate
 */
-(void)RegisterAppID:(NSString *)appID AppSecret:(NSString *)appSecret Delegate:(id<LinkGameOpenSDKDelegate>)delegate;

/**
 向游戏互联发送一个请求

 @param request 请求
 @return 是否成功
 */
-(BOOL)sendRequest:(LGBaseRequest *)request;

/**
 判断是否安装游戏互联
 需要将 linkgame 加入URLScheme白名单

 @return 是否安装游戏互联
 */
-(BOOL)isInstallLinkGame;
@end

