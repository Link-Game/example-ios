//
//  AppDelegate.m
//  SDKTestApp
//
//  Created by 刘万林 on 2018/3/2.
//  Copyright © 2018年 刘万林. All rights reserved.
//

#import "AppDelegate.h"
#import <LinkGameOpenSDK/LGOpenSDK.h>
#import "ViewController.h"
#import "Utils.h"

#define APPID @"015678bdehlqstuvwy"

@interface AppDelegate ()<LGOpenSDKDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    self.window.backgroundColor = [UIColor whiteColor];
    [self.window makeKeyAndVisible];
    //初始化需要被管理的视图控制器
    ViewController *home = [[ViewController alloc]init];
    self.window.rootViewController = home;
    
    [[LGOpenSDK share] registerApp:APPID withDelegate:self];
    
    return YES;
}

//授权登录返回的回调
- (void)authOnResault:(LGSDKAuthResult *)resault {
    switch (resault.errorCode) {
        case LGRequestErrorCode_Success:
            NSLog(@"授权成功!!");
            [[NSNotificationCenter defaultCenter] postNotificationName:@"AuthSuccessNotification" object:self userInfo:@{@"code":resault.code}];
            break;
        case LGRequestErrorCode_ParameterError:
            NSLog(@"授权:参数错误");
            [Utils alertInfo:@"授权:参数错误" showOkButton:YES];
            break;
        case LGRequestErrorCode_ParameterIntegralityError:
            NSLog(@"授权:参数校验失败");
            [Utils alertInfo:@"授权:参数校验失败" showOkButton:YES];
            break;
        case LGRequestErrorCode_TypeNotSupport:
            NSLog(@"暂不支持的请求类型");
            [Utils alertInfo:@"暂不支持的请求类型" showOkButton:YES];
            break;
        case LGRequestErrorCode_NetworkError:
            NSLog(@"授权:网络错误");
            [Utils alertInfo:@"授权:网络错误" showOkButton:YES];
            break;
        case LGRequestErrorCode_AppNotFound:
            NSLog(@"AppId不存在");
            [Utils alertInfo:@"AppId不存在" showOkButton:YES];
            break;
        case LGRequestErrorCode_UserCanceled:
            NSLog(@"用户取消授权");
            [Utils alertInfo:@"用户取消授权" showOkButton:YES];
            break;
        case LGRequestErrorCode_Other:
            NSLog(@"授权:其他错误");
            [Utils alertInfo:@"授权:其他错误" showOkButton:YES];
            break;
        case LGRequestErrorCode_AppNotExist:
            NSLog(@"应用不存在");
            [Utils alertInfo:@"应用不存在" showOkButton:YES];
            break;
        case LGRequestErrorCode_AppNotApproved:
            NSLog(@"APP未通过审核");
            [Utils alertInfo:@"APP未通过审核" showOkButton:YES];
            break;
        case LGRequestErrorCode_ScopeError:
            NSLog(@"Scope作用域错误");
            [Utils alertInfo:@"Scope作用域错误" showOkButton:YES];
            break;
        default:
            NSLog(@"授权:未知错误，请于游戏互联联系");
            break;
    }
}

//分享的返回回调
- (void)shareOnResault:(LGSDKShareResult *)resault{
    switch (resault.errorCode) {
        case LGRequestErrorCode_Success:
            NSLog(@"分享成功!!");
            [Utils alertInfo:@"分享成功!!" showOkButton:YES];
            break;
        case LGRequestErrorCode_ParameterError:
            NSLog(@"分享:参数错误");
            [Utils alertInfo:@"分享:参数错误" showOkButton:YES];
            break;
        case LGRequestErrorCode_ParameterIntegralityError:
            NSLog(@"分享:参数校验失败");
            [Utils alertInfo:@"分享:参数校验失败" showOkButton:YES];
            break;
        case LGRequestErrorCode_TypeNotSupport:
            NSLog(@"分享:暂不支持的请求类型");
            [Utils alertInfo:@"分享:暂不支持的请求类型" showOkButton:YES];
            break;
        case LGRequestErrorCode_NetworkError:
            NSLog(@"分享:网络错误");
            [Utils alertInfo:@"分享:网络错误" showOkButton:YES];
            break;
        case LGRequestErrorCode_FileError:
            NSLog(@"分享:本地图片文件错误");
            [Utils alertInfo:@"分享:本地图片文件错误" showOkButton:YES];
            break;
        case LGRequestErrorCode_AppNotFound:
            NSLog(@"AppId不存在");
            [Utils alertInfo:@"AppId不存在" showOkButton:YES];
            break;
        case LGRequestErrorCode_UserCanceled:
            NSLog(@"用户取消分享");
            [Utils alertInfo:@"用户取消分享" showOkButton:YES];
            break;
        case LGRequestErrorCode_Other:
            NSLog(@"分享:其他错误");
            [Utils alertInfo:@"分享:其他错误" showOkButton:YES];
            break;
        case LGRequestErrorCode_AppNotExist:
            NSLog(@"应用不存在");
            [Utils alertInfo:@"应用不存在" showOkButton:YES];
            break;
        case LGRequestErrorCode_AppNotApproved:
            NSLog(@"APP未通过审核");
            [Utils alertInfo:@"APP未通过审核" showOkButton:YES];
            break;
        case LGRequestErrorCode_ScopeError:
            NSLog(@"Scope作用域错误");
            [Utils alertInfo:@"Scope作用域错误" showOkButton:YES];
            break;
        default:
            NSLog(@"分享:未知错误，请于游戏互联联系");
            break;
    }
}

//此方法必须实现
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
