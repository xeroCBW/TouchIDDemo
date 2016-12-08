//
//  ViewController.m
//  TouchIDDemo
//
//  Created by 陈博文 on 16/9/9.
//  Copyright © 2016年 陈博文. All rights reserved.
//

#import "ViewController.h"
#import <SVProgressHUD.h>
#import <LocalAuthentication/LocalAuthentication.h>
#import <LocalAuthentication/LAError.h>
#import "NSString+QDTouchID.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}
#pragma mark - 支付宝
- (IBAction)authrizeAction:(id)sender {

    
    //这个 demo 是以目前的支付宝为例子写的
    
    if ([NSString judueIPhonePlatformSupportTouchID])
    {
        [self startTouchIDWithPolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics];

    }
    else
    {
        NSLog(@"您的设置硬件暂时不支持指纹识别");
    }
    
}

- (void)startTouchIDWithPolicy:(LAPolicy )policy{
    
    
    [SVProgressHUD show];
    [SVProgressHUD setDefaultStyle:SVProgressHUDStyleDark];
    LAContext *context = [[LAContext alloc]init];//使用 new 不会给一些属性初始化赋值
    
    context.localizedFallbackTitle = @"输入密码";//@""可以不让 feedBack 按钮显示
    //LAPolicyDeviceOwnerAuthenticationWithBiometrics
    [context evaluatePolicy:policy localizedReason:@"请验证已有指纹" reply:^(BOOL success, NSError * _Nullable error) {
        
        [SVProgressHUD dismiss];
        //SVProgressHUD dismiss 需要 0.15才会消失;所以dismiss 后进行下一步操作;但是0.3是适当延长时间;留点余量
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (success)
            {
                NSLog(@"指纹识别成功");
                // 指纹识别成功，回主线程更新UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    //成功操作--马上调用纯指纹验证方法
                    
                    if (policy == LAPolicyDeviceOwnerAuthentication)
                    {
                        [self startTouchIDWithPolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics];
                    }
                    else
                    {
 
                    }
                    
                });
            }
            
            if (error) {
                //指纹识别失败，回主线程更新UI
                NSLog(@"指纹识别成功");
                dispatch_async(dispatch_get_main_queue(), ^{
                    //失败操作
                    [self handelWithError:error];
                    
                });
            }
        });
    }];

}



/**
 处理错误数据

 @param error 错误信息
 */
- (void)handelWithError:(NSError *)error{

    if (error) {
        
        NSLog(@"%@",error.domain);
        NSLog(@"%zd",error.code);
        NSLog(@"%@",error.userInfo[@"NSLocalizedDescription"]);
        
        LAError errorCode = error.code;
        switch (errorCode) {
                
            case LAErrorTouchIDLockout: {
                //touchID 被锁定--ios9才可以
                
                [self handleLockOutTypeAliPay];
                
                
                break;
            }
        }
    }
}



/**
 支付宝处理锁定
 */
- (void)handleLockOutTypeAliPay{
    
    //开启验证--调用非全指纹指纹验证
    [self startTouchIDWithPolicy:LAPolicyDeviceOwnerAuthentication];
    
}


#pragma mark - 最基本使用的 Demo

- (IBAction)authrizeAction1:(id)sender {
    
    if([NSString judueIPhonePlatformSupportTouchID]){
        
        [self BaseDemo];
        
    }else{
        
        NSLog(@"您的设置硬件不支持指纹识别");
    }
    
    
}

- (void)BaseDemo{
    
    
    [SVProgressHUD show];
    
    LAContext *context = [[LAContext alloc]init];//使用 new 不会给一些属性初始化赋值
    
    context.localizedFallbackTitle = @"输入密码";//@""可以不让 feedBack 按钮显示
    //LAPolicyDeviceOwnerAuthenticationWithBiometrics
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:@"请验证已有指纹" reply:^(BOOL success, NSError * _Nullable error) {
        
        [SVProgressHUD dismiss];
        //SVProgressHUD dismiss 需要 0.15才会消失;所以dismiss 后进行下一步操作;但是0.3是适当延长时间;留点余量
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3* NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            if (success)
            {
                NSLog(@"指纹识别成功");
                // 指纹识别成功，回主线程更新UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    //成功操作
                });
            }
            
            if (error) {
                //指纹识别失败，回主线程更新UI
                dispatch_async(dispatch_get_main_queue(), ^{
                    //失败操作
                    LAError errorCode = error.code;
                    switch (errorCode) {
                       
                        case LAErrorAuthenticationFailed:
                        {
                            NSLog(@"授权失败"); // -1 连续三次指纹识别错误
                        }
                            break;
                        case LAErrorUserCancel: // Authentication was canceled by user (e.g. tapped Cancel button)
                        {
                            NSLog(@"用户取消验证Touch ID"); // -2 在TouchID对话框中点击了取消按钮
                        }
                            break;
                        case LAErrorUserFallback: // Authentication was canceled, because the user tapped the fallback button (Enter Password)
                        {
                            NSLog(@"用户选择输入密码，切换主线程处理"); // -3 在TouchID对话框中点击了输入密码按钮
                        }
                            break;
                        case LAErrorSystemCancel: // Authentication was canceled by system (e.g. another application went to foreground)
                        {
                            NSLog(@"取消授权，如其他应用切入"); // -4 TouchID对话框被系统取消，例如按下Home或者电源键
                        }
                            break;
                        case LAErrorPasscodeNotSet: // Authentication could not start, because passcode is not set on the device.
                            
                        {
                            NSLog(@"设备系统未设置密码"); // -5
                        }
                            break;
                        case LAErrorTouchIDNotAvailable: // Authentication could not start, because Touch ID is not available on the device
                        {
                            NSLog(@"设备未设置Touch ID"); // -6
                        }
                            break;
                        case LAErrorTouchIDNotEnrolled: // Authentication could not start, because Touch ID has no enrolled fingers
                        {
                            NSLog(@"用户未录入指纹"); // -7
                        }
                            break;
                        case LAErrorTouchIDLockout: //Authentication was not successful, because there were too many failed Touch ID attempts and Touch ID is now locked. Passcode is required to unlock Touch ID, e.g. evaluating LAPolicyDeviceOwnerAuthenticationWithBiometrics will ask for passcode as a prerequisite 用户连续多次进行Touch ID验证失败，Touch ID被锁，需要用户输入密码解锁，先Touch ID验证密码
                        {
                            NSLog(@"Touch ID被锁，需要用户输入密码解锁"); // -8 连续五次指纹识别错误，TouchID功能被锁定，下一次需要输入系统密码
                        }
                            break;
                        case LAErrorAppCancel: // Authentication was canceled by application (e.g. invalidate was called while authentication was in progress) 如突然来了电话，电话应用进入前台，APP被挂起啦");
                        {
                            NSLog(@"用户不能控制情况下APP被挂起"); // -9
                        }
                            break;
                        case LAErrorInvalidContext: // LAContext passed to this call has been previously invalidated.
                        {
                            NSLog(@"LAContext传递给这个调用之前已经失效"); // -10
                        }
                            break;
                    }

                });
            }
        });
    }];
    

}

@end
