//
//  AppDelegate.m
//  TouchIDDemo
//
//  Created by 陈博文 on 16/9/9.
//  Copyright © 2016年 陈博文. All rights reserved.
//

#import "AppDelegate.h"
#import <LocalAuthentication/LocalAuthentication.h>

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {

    NSLog(@"%s",__func__);
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    
    
     NSLog(@"%s",__func__);
   /*
    LAContext *context = [[LAContext alloc]init];//使用 new 不会给一些属性初始化赋值
    NSError *error;
    BOOL value = [context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        
        if (value)
        {
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            NSData *oldDate = [defaults objectForKey:@"123"];
            NSData *newData = context.evaluatedPolicyDomainState;
            NSLog(@"oldDate-------%@",oldDate);
            NSLog(@"newData-------%@",newData);
            if ([newData isEqualToData:oldDate])
            {
                NSLog(@"指纹没有变");
            }
            else
            {
                NSLog(@"指纹有改变!!!!!!!!!!!!!");
                //指纹有改变之后就需要提醒用户去重新输入密码;
                
            }
        }
        else
        {
            
        }
    });
    
   */
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
