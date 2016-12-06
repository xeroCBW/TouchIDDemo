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


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (IBAction)authrizeAction:(id)sender {

    
    //这个 demo 是以目前的支付宝为例子写的
    [self startTouchIDWithPolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics];

}

#pragma mark - 支付宝

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
                    
                    if (policy == LAPolicyDeviceOwnerAuthentication) {
                        
                        [self startTouchIDWithPolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics];
                        
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

@end
