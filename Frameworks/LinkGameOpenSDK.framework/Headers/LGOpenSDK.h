//
//  LGOpenSDK.h
//  LinkGameOpenSDK
//
//  Created by 刘万林 on 2018/8/15.
//  Copyright © 2018年 ChaungMiKeJi. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LGSDKBasePublicHeader.h"

@protocol LGOpenSDKDelegate<NSObject>

@optional
/**
 授权登录收到游戏互联的返回结果
 @param resault 返回结果
 */
-(void)authOnResault:(LGSDKAuthResult *)resault;

/**
 分享收到游戏互联的返回结果
 @param resault 返回结果
 */
-(void)shareOnResault:(LGSDKShareResult *)resault;

@end

@interface LGOpenSDK : NSObject


/**
 获取游戏互联SDK单例

 @return 游戏互联SDK单例
 */
+(LGOpenSDK *)share;


/**
 注册appid 并设置回调代理

 @param appid 游戏互联平台Appid
 @param delegate 回调代理
 @return 是否成功
 */
-(BOOL)registerApp:(NSString *)appid withDelegate:(id<LGOpenSDKDelegate>)delegate;

/**
 向游戏互联发起请求

 @param request 请求
 @return 是否成功
 */
-(BOOL)sendRequest:(LGSDKBaseRequest *)request;

/**
 获取SDK版本

 @return 版本信息
 */
-(NSString * )getSDKVersion;

/**
 打开游戏互联.

 @return 是否打开成功
 */
-(BOOL)openLinkGame;


/**
 检查游戏互联是否安装,需要将 linkgame 加入scheme白名单

 @return 是否安装
 */
-(BOOL)isLinkGameInstall;
@end

