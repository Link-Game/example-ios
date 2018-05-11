//
//  AppDelegate.m
//  SDKTestApp
//
//  Created by 刘万林 on 2018/3/2.
//  Copyright © 2018年 刘万林. All rights reserved.
//

#import "AppDelegate.h"

#import <LinkGameOpenSDK/LGOpenSDK.h>
#import "Utils.h"
#define APP_ID @"256abdejmnpstuvwyz"
#define APP_secret @"b03af2ec5e284502653f3b5b60d4c2a2"

@interface AppDelegate ()<LinkGameOpenSDKDelegate>

@end

@implementation AppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
//    初始化,注册回调
    [[LGOpenSDK share]RegisterAppID:APP_ID AppSecret:APP_secret Delegate:self];
    return YES;
}

-(void)didResponsed:(LGBaseResponse *)response{
    NSLog(@"收到回调Status: %@",response.status);
    NSLog(@"收到回调Errormessage: %@",response.Message);
    
    if (response.ResultRequestType == LGRequestTypeShare) {
        LGShareResponse * shareResponse = (LGShareResponse *)response;
            switch (shareResponse.ErrorCode) {
                case LGOpenSDKErrorCodeNoError:
                    NSLog(@"分享成功!!");
                    [Utils alertInfo:@"分享成功!!" showOkButton:YES];
                    break;
                case LGOpenSDKErrorCodeUserCancel:
                    NSLog(@"用户取消分享");
                    [Utils alertInfo:@"用户取消分享" showOkButton:YES];
                    break;
                case LGOpenSDKErrorCodeUserRefused:
                    NSLog(@"用户拒绝分享");
                    [Utils alertInfo:@"用户拒绝分享" showOkButton:YES];
                    break;
                case LGOpenSDKErrorCodeParematersError:
                    NSLog(@"分享参数错误");
                    [Utils alertInfo:@"分享参数错误" showOkButton:YES];
                    break;
                case LGOpenSDKErrorCodeTimeOut:
                    NSLog(@"分享超时");
                    [Utils alertInfo:@"分享超时" showOkButton:YES];
                    break;
                case LGOpenSDKErrorCodeOtherError:
                    NSLog(@"分享:其他错误");
                    [Utils alertInfo:@"分享:其他错误" showOkButton:YES];
                    break;
            }
    }
    if (response.ResultRequestType == LGRequestTypeAuthorize){
        LGAuthorizeResponse * authorizeResponse = (LGAuthorizeResponse *)response;
        switch (authorizeResponse.ErrorCode) {
            case LGOpenSDKErrorCodeNoError:
            {
                NSLog(@"授权成功!!");
                [[NSNotificationCenter defaultCenter] postNotificationName:@"AuthSuccessNotification" object:self userInfo:@{@"RefreshToken":authorizeResponse.RefreshToken,@"APPID":APP_ID}];
            }
                break;
            case LGOpenSDKErrorCodeUserCancel:
                NSLog(@"用户取消授权");
                [Utils alertInfo:@"用户取消授权" showOkButton:YES];
                break;
            case LGOpenSDKErrorCodeTimeOut:
                NSLog(@"用户长时间未点击授权");
                [Utils alertInfo:@"用户长时间未点击授权" showOkButton:YES];
                break;
            case LGOpenSDKErrorCodeOtherError:
                NSLog(@"其他错误");
                [Utils alertInfo:@"其他错误" showOkButton:YES];
                break;

            case LGOpenSDKErrorCodeUserRefused:
                NSLog(@"用户拒绝授权");
                [Utils alertInfo:@"用户拒绝授权" showOkButton:YES];
                break;
            case LGOpenSDKErrorCodeParematersError:
                NSLog(@"授权参数错误");
                [Utils alertInfo:@"授权参数错误" showOkButton:YES];
                break;
        }
    }
}

-(BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{

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
