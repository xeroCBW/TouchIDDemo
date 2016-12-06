# TouchIDDemo
模仿支付宝 TouchID 的一个 demo
- 1. 以下都是讲的是 ios9及以后; ios8 不存在锁定这么一说;错误5次后会自动弹出锁屏密码界面;
- 2. 支付宝在锁定的时候,会调用如下方法;成功验证锁屏密码后,会再次调用纯指纹验证方法;详细信息请看 demo 
- 3. 微信就在锁定后,就会默认关闭指纹密码;等成功验证锁屏密码后,便会开启;
- 4. 值得注意的是:微信不会主动弹出锁屏密码页面
- 5. 如果输入了锁屏密码,指纹解密锁定会默认解除
```obj-c
  LAContext *context = [[LAContext alloc]init];//使用 new 不会给一些属性初始化赋值
    
    context.localizedFallbackTitle = @"输入密码";//@""可以不让 feedBack 按钮显示
    //LAPolicyDeviceOwnerAuthenticationWithBiometrics
    [context evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"请验证已有指纹" reply:^(BOOL success, NSError * _Nullable error) {

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


```
