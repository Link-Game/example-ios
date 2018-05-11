//
//  LGOpenSDKEnum.h
//  游戏互联
//
//  Created by 刘万林 on 2018/3/30.
//  Copyright © 2018年 刘万林. All rights reserved.
//
#import <Foundation/Foundation.h>

#ifndef LGOpenSDKEnum_h
#define LGOpenSDKEnum_h

//SDK返回的错误码
typedef NS_ENUM(NSUInteger, LGOpenSDKErrorCode) {
    LGOpenSDKErrorCodeNoError         = 20000,//没有错误
    LGOpenSDKErrorCodeUserCancel      = 20001,//用户取消
    LGOpenSDKErrorCodeUserRefused     = 20002,//用户拒绝
    LGOpenSDKErrorCodeParematersError = 20003,//参数错误
    LGOpenSDKErrorCodeTimeOut         = 20004,//超时,仅在授权登录时会出现,分享时不会出现该错误
    LGOpenSDKErrorCodeOtherError      = 20005,//其他错误
};

//发起的请求类型
typedef NS_ENUM(NSUInteger, LGRequestType ) {
    LGRequestTypeAuthorize = 0,      //授权登录
    LGRequestTypeShare               //分享
};

//分享的类型
typedef NS_ENUM(NSUInteger, LGShareType) {
    LGShareTypeImage = 0,           //图片分享,可携带网页链接
    LGShareTypeText,                //文字分享
    LGShareTypeWebPage              //网页分享,包含标题,文字,缩略图,和网页链接,其中缩略图可以不传
};


#endif /* LGOpenSDKEnum_h */
