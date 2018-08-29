//
//  WHNetworkrRequest.h
//  management
//
//  Created by xingcheng on 2017/3/1.
//  Copyright © 2017年 xingcheng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WHResponds.h"
#define BASE_URL   @"http://api.youxihulian.com:8080/api/v1/"

typedef NS_ENUM(NSUInteger, NetworkStatus) {
    /** 未知网络*/
    NetworkStatusUnknown,
    /** 无网络*/
    NetworkStatusNotReachable,
    /** 手机网络*/
    NetworkStatusReachableViaWWAN,
    /** WIFI网络*/
    NetworkStatusReachableViaWiFi
};

/**  成功的回调 */
typedef void(^RequestCompletion)(WHResponds *responds);
typedef void(^RequestSuccess)(id  requestDic);
/**  失败的回调 */
typedef void(^RequestFail)(NSError *error);
/**  缓存的回调 */
typedef void(^RequestCache)(id requestCache);
/**  上传或者下载进度的回调 */
typedef void(^RequestProgress)(NSProgress *progress);
/**   网络状态回调 */
typedef void(^RequestNetWorkStatus)(NetworkStatus status);
/**  请求任务 */
typedef NSURLSessionTask URLSessionTask;

@interface WHNetworkrRequest : NSObject
/**
 *  监听网络,可在appdelegate设置全局监控
 */
+(void)MonitorNetwork;


/**
 *  get请求
 *
 *  @param url           请求路径
 *  @param params        参数
 *  @param callBlock  成功回调
 *
 *  @return 返回任务,可以取消
 */

+(URLSessionTask *)getRequestUrl:(NSString *)url params:(NSDictionary *)params callBlock:(RequestCompletion)callBlock;
/**
 *  post请求
 *
 *  @param url           请求路径
 *  @param params        参数
 *  @param callBlock  成功回调
 *
 *  @return 返回任务,可以取消
 */
+(URLSessionTask *)postRequestUrl:(NSString *)url params:(NSDictionary *)params callBlock:(RequestCompletion)callBlock;

/**
 *  配置请求头
 *
 *  @param httpHeader 请求头
 */
+ (void)configHttpHeader:(NSDictionary *)httpHeader;

/**
 *  取消GET请求
 */
+ (void)cancelRequestWithURL:(NSString *)url;

/**
 *  取消所有请求
 */
+ (void)cancleAllRequest;

/**
 *	设置超时时间
 *
 *  @param timeout 超时时间
 */
+ (void)setupTimeout:(NSTimeInterval)timeout;
@end
