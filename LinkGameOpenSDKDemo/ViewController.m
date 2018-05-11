//
//  ViewController.m
//  SDKTestApp
//
//  Created by 刘万林 on 2018/3/2.
//  Copyright © 2018年 刘万林. All rights reserved.
//

#import "ViewController.h"
#import <LinkGameOpenSDK/LGOpenSDK.h>
#import "BSKImagePreView.h"
#import "Utils.h"

@interface ViewController ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;
@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *shareTextTextView;
@property (weak, nonatomic) IBOutlet BSKImagePreView *ImageView;
@property (weak, nonatomic) IBOutlet UIButton *AuthorizeButton;

@property (copy, nonatomic) NSString * refreshToken;
@property (copy, nonatomic) NSString * app_id;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(AuthSuccessNotification:) name:@"AuthSuccessNotification" object:nil];
    self.ImageView.image = [UIImage imageNamed:@"miku"];
}

-(void)AuthSuccessNotification:(NSNotification *)notify{
    self.refreshToken = notify.userInfo[@"RefreshToken"];
    self.app_id = notify.userInfo[@"APPID"];
    [self setUserInfo];
    self.AuthorizeButton.selected = YES;
}


- (IBAction)refreshUserInfo:(UIButton * )sender {
    [UIView animateWithDuration:0.25 animations:^{
        sender.transform = CGAffineTransformMakeRotation(M_PI);
    } completion:^(BOOL finished) {
        sender.transform = CGAffineTransformMakeRotation(0);
    }];
    [self setUserInfo];
}

- (IBAction)selecteImageAction:(id)sender {
    UIImagePickerController * imagePickVc = [[UIImagePickerController alloc] init];
    imagePickVc.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickVc.allowsEditing = NO;
    imagePickVc.delegate = self;
    [self presentViewController:imagePickVc animated:YES completion:nil];
}


- (IBAction)AuthorizeAction:(UIButton *)sender {
    if (self.AuthorizeButton.selected) {
        self.app_id = nil;
        self.refreshToken = nil;
        self.AuthorizeButton.selected = NO;
        self.userNameLabel.text = @"未登录";
        self.headerImageView.image = [UIImage imageNamed:@"user"];
        return;
    }
    LGAuthRequest * request = [LGAuthRequest new];
    [[LGOpenSDK share] sendRequest:request];
}
- (IBAction)shareTextAction:(id)sender {
    LGTextShareRequest * request = [LGTextShareRequest RequestWithText:self.shareTextTextView.text];
    request.status = @"TestStatus";
    [[LGOpenSDK share] sendRequest:request];
}
- (IBAction)shareImageAction:(id)sender {
    
    LGImageShareRequest * request = [LGImageShareRequest RequestWithUIImage:self.ImageView.image];
    [[LGOpenSDK share] sendRequest:request];
}
- (IBAction)ShareLinkWebImageAction:(id)sender {
    LGWebPageShareRequest * request = [LGWebPageShareRequest RequestWithWebImageUrl:@"http://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1521007876938&di=15d5969e0709ba94710501c29cbcab6a&imgtype=0&src=http%3A%2F%2Fimg3.duitang.com%2Fuploads%2Fitem%2F201608%2F16%2F20160816183822_hwBM2.jpeg" Title:@"Web图片" Text:@"这是一个测试!!" linkUrl: [NSURL URLWithString:@"http://www.zhuanxinyu.com/"]];
    [[LGOpenSDK share] sendRequest:request];
}
- (IBAction)ShareLinkLocalImageAction:(id)sender {
    NSString * path = [[NSBundle mainBundle]pathForResource:@"flower" ofType:@"jpg"];
    LGWebPageShareRequest * request = [LGWebPageShareRequest RequestWithImageFilePath:path Title:@"本地图片" Text:@"这是一个测试!!" linkUrl: [NSURL URLWithString:@"http://www.zhuanxinyu.com"]];
    [[LGOpenSDK share] sendRequest:request];
}

-(void)setUserInfo{
    if (!(self.refreshToken&&self.app_id)) {
        [Utils alertInfo:@"请先登录" showOkButton:YES];
        return;
    }
    UIAlertController * alertVC = [Utils alertInfo:@"正在获取用户信息..." showOkButton:NO];
    NSMutableURLRequest * UserInfoRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString: @"http://api.zhuanxinyu.com/v1/user/get-info"]];
    UserInfoRequest.HTTPMethod = @"post";
    NSData * body = [[NSString stringWithFormat:@"&refresh_token=%@&app_id=%@",self.refreshToken,self.app_id] dataUsingEncoding:NSUTF8StringEncoding];
    [UserInfoRequest setHTTPBody:body];
    NSURLSessionTask * task = [[NSURLSession sharedSession] dataTaskWithRequest:UserInfoRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        NSDictionary * dic = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        if (dic&&[dic[@"code"] integerValue]==200) {

            NSMutableURLRequest * imageRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:dic[@"data"][@"face"]]];
            NSURLSessionDataTask * imageTask =  [[NSURLSession sharedSession] dataTaskWithRequest:imageRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                if (data&&!error) {
                    UIImage * img = [UIImage imageWithData:data];
                    runOnMainThread(^{
                        self.headerImageView.image = img;
                        self.userNameLabel.text = dic[@"data"][@"nickname"];
                        [alertVC dismissViewControllerAnimated:YES completion:nil];
                    });
                }else{
                    runOnMainThread(^{
                        [alertVC dismissViewControllerAnimated:YES completion:nil];
                    });
                }
            }];

            [imageTask resume];
        }else{
            runOnMainThread(^{
                [alertVC dismissViewControllerAnimated:YES completion:nil];
            });
        }
    }];
    [task resume];

}


-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [super touchesBegan:touches withEvent:event];
    [self.view endEditing:YES];
}


#pragma mark - ● Delegate

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    self.ImageView.image = info[UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AuthSuccessNotification" object:nil];
}

@end
