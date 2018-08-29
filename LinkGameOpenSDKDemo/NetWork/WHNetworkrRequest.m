//
//  WHNetworkrRequest.m
//  management
//
//  Created by xingcheng on 2017/3/1.
//  Copyright © 2017年 xingcheng. All rights reserved.
//

#import "WHNetworkrRequest.h"
#import "AFNetworking.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "Utils.h"
#import <CommonCrypto/CommonDigest.h>
#define XD_ERROR_IMFORMATION @"网络出现错误，请检查网络连接"

#define XD_ERROR [NSError errorWithDomain:@"com.caixindong.XDNetworking.ErrorDomain" code:-999 userInfo:@{ NSLocalizedDescriptionKey:XD_ERROR_IMFORMATION}]
@implementation WHNetworkrRequest
/**  超时时间 */
static NSTimeInterval   requestTimeout = 30.f;
/**  网络状态 */
static NetworkStatus   _netStatus;
/**  请求任务 */
static NSMutableArray   *requestTasks;

static NSDictionary     *headers;
#pragma mark - 初始化manager
+(AFHTTPSessionManager *)WHmanager
{
    //设置是否显示小菊花
    [AFNetworkActivityIndicatorManager sharedManager].enabled = YES;
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    //默认解析模式
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //配置请求序列化
    AFJSONResponseSerializer *serializer = [AFJSONResponseSerializer serializer];
    
    [serializer setRemovesKeysWithNullValues:YES];
    
    manager.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    
    manager.requestSerializer.timeoutInterval = requestTimeout;
    
    for (NSString *key in headers.allKeys) {
        if (headers[key] != nil) {
            [manager.requestSerializer setValue:headers[key] forHTTPHeaderField:key];
        }
    }
    
    //配置响应序列化
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithArray:@[@"application/json",
                                                                              @"text/html",
                                                                              @"text/json",
                                                                              @"text/plain",
                                                                              @"text/javascript",
                                                                              @"text/xml",
                                                                              @"image/*",
                                                                              @"application/octet-stream",
                                                                              @"application/zip"]];
    [self MonitorNetwork];
    return manager;
    
}

#pragma mark - 开始监听网络
+ (void)MonitorNetwork
{
    AFNetworkReachabilityManager *manager = [AFNetworkReachabilityManager sharedManager];
    
    [manager startMonitoring];
    
    [manager setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        switch (status)
        {
            case AFNetworkReachabilityStatusUnknown:
                _netStatus = NetworkStatusUnknown;
                
                break;
            case AFNetworkReachabilityStatusNotReachable:
                _netStatus = NetworkStatusNotReachable;
                break;
            case AFNetworkReachabilityStatusReachableViaWWAN:
                _netStatus = NetworkStatusReachableViaWWAN;
                
                break;
            case AFNetworkReachabilityStatusReachableViaWiFi:
                _netStatus = NetworkStatusReachableViaWiFi;
                
                break;
        }
    }];
    
    
}
#pragma mark
+ (NSMutableArray *)allTasks {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (requestTasks == nil) requestTasks = [NSMutableArray array];
    });
    return requestTasks;
}

+(URLSessionTask *)getRequestUrl:(NSString *)url params:(NSDictionary *)params callBlock:(RequestCompletion)callBlock{
    [WHNetworkrRequest cancleAllRequest];
    URLSessionTask *session = nil;
    AFHTTPSessionManager *manager = [self WHmanager];
    NSString *keyUrl = [[self alloc] urlDictToStringWithUrlStr:url WithDict:params];
    NSLog(@"地址为:\n         %@                  \n",keyUrl);
    //判断网络状态
    if (_netStatus == NetworkStatusNotReachable ) {
        [Utils alertInfo:XD_ERROR_IMFORMATION showOkButton:YES];
        return session;
    }
    session = [manager GET:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        WHResponds *responds = [[WHResponds alloc]init];
        NSInteger code = [responseObject[@"code"] integerValue];
        responds.code = code;
        if (code == 200) {
            responds.isSuccess = YES;
            responds.resultDesc = responseObject[@"msg"];
            responds.resultObject = responseObject[@"data"];
            //如果开启缓存 缓存数据
        }else{
            responds.isSuccess = NO;
            responds.resultObject = nil;
            responds.resultDesc = responseObject[@"msg"];
        }
        if (callBlock) {
            callBlock(responds);
        }
        //移除任务
        [[self allTasks] removeObject:session];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WHResponds *responds = [[WHResponds alloc]init];
        responds.isSuccess = NO;
        responds.resultObject = nil;
        responds.code = 0;
        responds.resultDesc = error.localizedDescription;
        if (error.code == NSURLErrorTimedOut) {
            responds.resultDesc = @"请求超时";
        } else if (error.code == NSURLErrorCancelled) {
            responds.resultDesc = @"取消请求";
        }
        if (callBlock != nil){
            callBlock(responds);
            [[self allTasks] removeObject:session];
        }
    }];
    //任务继续
    [session resume];
    if (session) {
        [[self allTasks] addObject:session];
    }
    return session;
}


+(URLSessionTask *)postRequestUrl:(NSString *)url params:(NSDictionary *)params callBlock:(RequestCompletion)callBlock{
    [WHNetworkrRequest cancleAllRequest];
    URLSessionTask *session = nil;
    AFHTTPSessionManager *manager = [self WHmanager];
    NSString *keyUrl = [[self alloc] urlDictToStringWithUrlStr:url WithDict:params];
    NSLog(@"地址为:\n         %@                  \n",keyUrl);
    //判断网络状态
    if (_netStatus == NetworkStatusNotReachable ) {
        [Utils alertInfo:XD_ERROR_IMFORMATION showOkButton:YES];
        return session;
    }
    session = [manager POST:url parameters:params progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        WHResponds *responds = [[WHResponds alloc]init];
        NSInteger code = [responseObject[@"code"] integerValue];
        responds.code = code;
        if (code == 200) {
            responds.isSuccess = YES;
            responds.resultDesc = responseObject[@"msg"];
            responds.resultObject = responseObject[@"data"];
        }else{
            responds.isSuccess = NO;
            responds.resultObject = nil;
            responds.resultDesc = responseObject[@"msg"];
        }
        if (callBlock) {
            callBlock(responds);
        }
        //移除任务
        [[self allTasks] removeObject:session];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        WHResponds *responds = [[WHResponds alloc]init];
        responds.isSuccess = NO;
        responds.resultObject = nil;
        responds.code = 0;
        responds.resultDesc = error.localizedDescription;
        if (error.code == NSURLErrorTimedOut) {
            responds.resultDesc = @"请求超时";
        } else if (error.code == NSURLErrorCancelled) {
            responds.resultDesc = @"取消请求";
        }
        if (callBlock != nil) {
            callBlock(responds);
        }
        [[self allTasks] removeObject:session];
    }];
    //任务继续
    [session resume];
    if (session) {
        [[self allTasks] addObject:session];
    }
    return session;
}

/**
 *  拼接基础网址和参数
 *
 *  @param urlStr     基础网址
 *  @param parameters 参数
 *
 *  @return 拼接完成的网址
 */
-(NSString *)urlDictToStringWithUrlStr:(NSString *)urlStr WithDict:(NSDictionary *)parameters
{
    if (!parameters) {
        return urlStr;
    }
    
    
    NSMutableArray *parts = [NSMutableArray array];
    
    [parameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
        //接收key
        NSString *finalKey = [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        //接收值
        //NSString *finalValue = [obj stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        
        
        NSString *part =[NSString stringWithFormat:@"%@=%@",finalKey,obj];
        
        [parts addObject:part];
        
    }];
    
    NSString *queryString = [parts componentsJoinedByString:@"&"];
    
    queryString = queryString ? [NSString stringWithFormat:@"?%@",queryString] : @"";
    
    NSString *pathStr = [NSString stringWithFormat:@"%@%@",urlStr,queryString];
    
    return pathStr;
    
    
    
}
#pragma mark - other method
+ (void)setupTimeout:(NSTimeInterval)timeout {
    requestTimeout = timeout;
}

+ (void)cancleAllRequest {
    @synchronized (self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(URLSessionTask  *_Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[URLSessionTask class]]) {
                [obj cancel];
            }
        }];
        [[self allTasks] removeAllObjects];
    }
}

+ (void)cancelRequestWithURL:(NSString *)url {
    if (!url) return;
    @synchronized (self) {
        [[self allTasks] enumerateObjectsUsingBlock:^(URLSessionTask * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([obj isKindOfClass:[URLSessionTask class]]) {
                if ([obj.currentRequest.URL.absoluteString hasSuffix:url]) {
                    [obj cancel];
                    *stop = YES;
                }
            }
        }];
    }
}

+ (void)configHttpHeader:(NSDictionary *)httpHeader {
    headers = httpHeader;
}


#pragma mark - 散列值
+ (NSString *)md5:(NSString *)string {
    if (string == nil || string.length == 0) {
        return nil;
    }
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH],i;
    
    CC_MD5([string UTF8String],(int)[string lengthOfBytesUsingEncoding:NSUTF8StringEncoding],digest);
    
    NSMutableString *ms = [NSMutableString string];
    
    for (i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [ms appendFormat:@"%02x",(int)(digest[i])];
    }
    
    return [ms copy];
}

@end
