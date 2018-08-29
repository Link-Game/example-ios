//
//  WHResponds.h
//  management
//
//  Created by xingcheng on 2017/2/24.
//  Copyright © 2017年 xingcheng. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WHResponds : NSObject
@property(nonatomic,assign) BOOL isSuccess;     /** 请求是否成功*/
@property(nonatomic,strong) id resultObject;    /** 请求结果*/
@property(nonatomic,copy) NSString *resultDesc; /** 请求结果的描述*/
@property(nonatomic,assign) NSInteger code;     /** 判断是否是缓存*/
@end
