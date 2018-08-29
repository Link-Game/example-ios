//
//  ViewController.m
//  linkGameOpenSDKTextApp
//
//  Created by xingcheng on 2018/8/16.
//  Copyright © 2018年 xingcheng. All rights reserved.
//

#import "ViewController.h"
#import <LinkGameOpenSDK/LGOpenSDK.h>
#import "Utils.h"
#import "WHNetworkrRequest+SDK.h"

#define APPID @"015678bdehlqstuvwy"
#define SECRET @"c144cd9d3af75dbc73a15f7e76d60944"


@interface ViewController ()
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UIButton *AuthorizeButton;

@property (copy, nonatomic) NSString * code;
@property (copy ,nonatomic) NSString *access_token;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.headerImageView.layer.masksToBounds = YES;
    self.headerImageView.layer.cornerRadius = 40;
    
    self.view.backgroundColor = [UIColor whiteColor];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AuthSuccessNotification:) name:@"AuthSuccessNotification" object:nil];
}

-(void)AuthSuccessNotification:(NSNotification *)notify{
    self.code = notify.userInfo[@"code"];
    [self setUserInfo];
    self.AuthorizeButton.selected = YES;
}


- (IBAction)AuthorizeAction:(id)sender {
    if (self.AuthorizeButton.selected) {
        self.code = nil;
        self.AuthorizeButton.selected = NO;
        self.userNameLabel.text = @"未登录";
        self.headerImageView.image = [UIImage imageNamed:@"user"];
        return;
    }
    LGSDKAuthRequest * request = [LGSDKAuthRequest AuthRequest];
    request.flag = @"authorization";
    [[LGOpenSDK share] sendRequest:request];
}

- (IBAction)refreshUserInfo:(id)sender {
    UIButton *butt = (UIButton *)sender;
    [UIView animateWithDuration:0.25 animations:^{
        butt.transform = CGAffineTransformMakeRotation(M_PI);
    } completion:^(BOOL finished) {
        butt.transform = CGAffineTransformMakeRotation(0);
    }];
    [self refreshUserInfo];
}

//分享文字
- (IBAction)shareTextAction:(id)sender {
    if ([self.textView.text isEqualToString:@""]) {
        [Utils alertInfo:@"请输入你要分享的文字内容!" showOkButton:YES];
        return;
    }
    LGSDKShareTextRequest *request = [LGSDKShareTextRequest RequestWithText:self.textView.text];
    request.flag = @"shareText";
    [[LGOpenSDK share] sendRequest:request];
}

//分享图文（图片为NSData）
- (IBAction)shareTextAndPictureAction:(id)sender {
    if ([self.textView.text isEqualToString:@""]) {
        [Utils alertInfo:@"请输入你要分享的图片文字描述!" showOkButton:YES];
        return;
    }
    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"cesi"]);
    LGSDKShareTextPictureRequest *request = [LGSDKShareTextPictureRequest RequestWithImageData:imageData text:self.textView.text];
    request.flag = @"shareTextAndPicture";
    [[LGOpenSDK share] sendRequest:request];
}

//分享图文（图片为URL地址）
- (IBAction)shareTextAndPictureURLAction:(id)sender {
    if ([self.textView.text isEqualToString:@""]) {
        [Utils alertInfo:@"请输入你要分享的图片文字描述!" showOkButton:YES];
        return;
    }
    NSString *imageURL = @"http://pic.58pic.com/58pic/11/39/65/71A58PICY4d.jpg";
    LGSDKShareTextPictureRequest *request = [LGSDKShareTextPictureRequest RequestWithImageURL:imageURL text:self.textView.text];
    request.flag = @"shareTextAndPicture";
    [[LGOpenSDK share] sendRequest:request];
}

//分享网页链接(图片为NSDate)
- (IBAction)shareWbUrlAction:(id)sender {
    NSData *imageData = UIImagePNGRepresentation([UIImage imageNamed:@"game"]);
    LGSDKShareWebLinkRequest *request = [LGSDKShareWebLinkRequest RequestWithImageData:imageData Title:@"一款很好玩的游戏——王者荣耀" Text:@"本游戏是类dota手游，游戏中的玩法以竞技对战为主，玩家之间进行1V1、3V3、5V5等多种方式的PVP对战，还可以参加游戏的冒险模式，进行PVE的闯关模式，在满足条件后可以参加游戏排位赛等。" linkUrl:@"http://www.zhuanxinyu.com"];
    request.flag = @"shareWebLink";
    [[LGOpenSDK share] sendRequest:request];
}

//分享网页链接(图片为URL地址)
- (IBAction)shareWbWithPictureUrlAction:(id)sender {
    NSString *imageURL = @"http://pic.58pic.com/58pic/11/39/65/71A58PICY4d.jpg";
    LGSDKShareWebLinkRequest *request = [LGSDKShareWebLinkRequest RequestWithWebImageUrl:imageURL Title:@"一款让人舍不得卸载的游戏——绝地求生：刺激战场" Text:@"《绝地求生：刺激战场》是腾讯旗下光子工作室群与韩国蓝洞共同推出的正版绝地求生IP手游。还原了《绝地求生》端游的大部分大地图，建模和游戏场景，也还原端游的经典风格" linkUrl:@"http://www.zhuanxinyu.com"];
    request.flag = @"shareWebLink";
    [[LGOpenSDK share] sendRequest:request];
}

//这里只做了最基本的操作，至于access_token失效通过refresh_token刷新 refresh_token失效重新授权等需要结合本身的app自行处理
-(void)setUserInfo{
    if (!self.code) {
        [Utils alertInfo:@"请先登录" showOkButton:YES];
        return;
    }
    UIAlertController * alertVC = [Utils alertInfo:@"正在获取用户信息..." showOkButton:NO];
    [[WHNetworkrRequest new] getAccess_tokenWithSdk_app_id:APPID secret:SECRET code:self.code complertionHandler:^(WHResponds *responds) {
        if (responds.isSuccess) {
            self.access_token = responds.resultObject[@"access_token"];
            [[WHNetworkrRequest new] getUserinfoWithAccess_token:self.access_token sdk_app_id:APPID complertionHandler:^(WHResponds *responds) {
                [alertVC dismissViewControllerAnimated:YES completion:nil];
                if (responds.isSuccess) {
                    self.headerImageView.image = [UIImage imageWithData:[NSData
                                                                         dataWithContentsOfURL:[NSURL URLWithString:responds.resultObject[@"avatar_url"]]]];
                    self.userNameLabel.text = responds.resultObject[@"nickname"];
                } else {
                    [Utils alertInfo:responds.resultDesc showOkButton:YES];
                }
            }];
        } else {
            [alertVC dismissViewControllerAnimated:YES completion:nil];
            [Utils alertInfo:responds.resultDesc showOkButton:YES];
        }
    }];
}

-(void)refreshUserInfo{
    if (!self.access_token) {
        [Utils alertInfo:@"请先登录" showOkButton:YES];
        return;
    }
    UIAlertController * alertVC = [Utils alertInfo:@"正在获取用户信息..." showOkButton:NO];
    [[WHNetworkrRequest new] getUserinfoWithAccess_token:self.access_token sdk_app_id:APPID complertionHandler:^(WHResponds *responds) {
        [alertVC dismissViewControllerAnimated:YES completion:nil];
        if (responds.isSuccess) {
            self.headerImageView.image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:responds.resultObject[@"avatar_url"]]]];
            self.userNameLabel.text = responds.resultObject[@"nickname"];
        } else {
            [Utils alertInfo:responds.resultDesc showOkButton:YES];
        }
    }];
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AuthSuccessNotification" object:nil];
}

@end
