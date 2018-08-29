//
//  WHNetworkrRequest+SDK.h
//  linkGameOpenSDKTextApp
//
//  Created by xingcheng on 2018/8/24.
//  Copyright © 2018年 xingcheng. All rights reserved.
//

#import "WHNetworkrRequest.h"

@interface WHNetworkrRequest (SDK)

//通过code获取access_token
- (void)getAccess_tokenWithSdk_app_id:(NSString *)sdk_app_id secret:(NSString *)secret code:(NSString *)code complertionHandler:(RequestCompletion) callback;

//通过access_token获取用户信息
- (void)getUserinfoWithAccess_token:(NSString *)access_token sdk_app_id:(NSString *)sdk_app_id complertionHandler:(RequestCompletion) callback;

@end
