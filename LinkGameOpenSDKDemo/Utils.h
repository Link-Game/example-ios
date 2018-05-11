//
//  Utils.h
//  SDKTestApp
//
//  Created by 刘万林 on 2018/3/30.
//  Copyright © 2018年 刘万林. All rights reserved.
//

#import <UIKit/UIKit.h>

extern void runOnMainThread(void(^block)(void) );

@interface Utils : NSObject
+(UIAlertController *)alertInfo:(NSString *)info showOkButton:(BOOL)showButton;
@end
