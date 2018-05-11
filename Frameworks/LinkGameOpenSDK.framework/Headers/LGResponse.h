//
//  LGResponse.h
//  LGOpenSDK
//
//  Created by 刘万林 on 2018/3/14.
//  Copyright © 2018年 刘万林. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGRequest.h"



/**
 SDK返回的数据的基类
 */
@interface LGBaseResponse : NSObject

@property (assign, nonatomic) LGRequestType ResultRequestType;//对应之前发出时的请求类型
@property (copy, nonatomic) NSString * AppID;//AppID
@property (assign, nonatomic) LGOpenSDKErrorCode ErrorCode;//错误码
@property (copy, nonatomic) NSString * Message;//错误消息
@property (copy, nonatomic) NSString * status;//用户自定义字段,原样返回,可用于区分多个不同的Request的返回结果
@end

/**
 分享的结果
 */
@interface LGShareResponse : LGBaseResponse
@property (assign, nonatomic) BOOL isSuccess;//是否分享成功
@end


/**
 授权登录的结果
 */
@interface LGAuthorizeResponse : LGBaseResponse
@property(nonatomic, copy) NSString * RefreshToken;//授权成功得到的用于获取用户信息的refreshToken
@end
