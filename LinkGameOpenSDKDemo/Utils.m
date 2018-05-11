//
//  Utils.m
//  SDKTestApp
//
//  Created by 刘万林 on 2018/3/30.
//  Copyright © 2018年 刘万林. All rights reserved.
//

#import "Utils.h"

void runOnMainThread(void(^block)(void) ){
    if([NSThread isMainThread]){
        block();
    }else{
        dispatch_sync(dispatch_get_main_queue(), block);
    }
}

@implementation Utils
+(UIAlertController *)alertInfo:(NSString *)info showOkButton:(BOOL)showButton{
    UIAlertController * alertController = [UIAlertController alertControllerWithTitle:@"提示" message:info preferredStyle:UIAlertControllerStyleAlert];
    if (showButton) {
        UIAlertAction * action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
        [alertController addAction:action];
    }
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alertController animated:YES completion:nil];
    return alertController;
}
@end
