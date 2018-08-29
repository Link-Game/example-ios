//
//  WHNetworkrRequest+SDK.m
//  linkGameOpenSDKTextApp
//
//  Created by xingcheng on 2018/8/24.
//  Copyright © 2018年 xingcheng. All rights reserved.
//

#import "WHNetworkrRequest+SDK.h"
#import "WHURLs.h"

@implementation WHNetworkrRequest (SDK)

//通过code获取access_token
- (void)getAccess_tokenWithSdk_app_id:(NSString *)sdk_app_id secret:(NSString *)secret code:(NSString *)code complertionHandler:(RequestCompletion) callback{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if(sdk_app_id != nil) {
        [parameters setObject:sdk_app_id forKey:@"sdk_app_id"];
    }
    if(secret != nil) {
        [parameters setObject:secret forKey:@"secret"];
    }
    if(code != nil) {
        [parameters setObject:code forKey:@"code"];
    }
    NSString * requestUrlString = [BASE_URL stringByAppendingString:kGetAccess_token];
    [WHNetworkrRequest postRequestUrl:requestUrlString params:parameters callBlock:^(WHResponds *responds) {
        if(responds.isSuccess) {
            NSLog(@"%@",responds.resultObject);
        }
        if(callback != nil) {
            callback(responds);
        }
    }];
}

//通过access_token获取用户信息
- (void)getUserinfoWithAccess_token:(NSString *)access_token sdk_app_id:(NSString *)sdk_app_id complertionHandler:(RequestCompletion) callback{
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    if(access_token != nil) {
        [parameters setObject:access_token forKey:@"access_token"];
    }
    if(sdk_app_id != nil) {
        [parameters setObject:sdk_app_id forKey:@"sdk_app_id"];
    }
    NSString * requestUrlString = [BASE_URL stringByAppendingString:kGetUserinfo];
    [WHNetworkrRequest postRequestUrl:requestUrlString params:parameters callBlock:^(WHResponds *responds) {
        if(responds.isSuccess) {
            NSLog(@"%@",responds.resultObject);
        }
        if(callback != nil) {
            callback(responds);
        }
    }];
}



@end
