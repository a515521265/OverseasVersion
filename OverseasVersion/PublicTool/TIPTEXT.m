//
//  TIPTEXT.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/10.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "TIPTEXT.h"
#import "projectHeader.h"

@implementation TIPTEXT

+(NSString *)sendVerificationCode{
    //验证码发送成功
    return Internationalization(@"验证码已成功发送", @"Verification code has been sent successfully");

}

+(NSString *)noNetwork{
    //检查网络设置
    return Internationalization(@"请检查网络设置", @"Please check the network settings");
    
}

+(NSString *)errorCamera{

    return Internationalization(@"当前相机不可用，请在系统设置中打开相机权限", @"The current camera is not available, please open the camera permissions in the system settings");
}

+(NSString *)QRcodefail{

    return Internationalization(@"扫描失败", @"QR code fail");

}

+(NSString *)TransactionPassword{

    return Internationalization(@"请设置交易密码", @"Please set the transaction password");
}

+(NSString *)ServerFault{

    return Internationalization(@"服务器出现故障，我们正在全力抢修中", @"The server is out of order, we are doing our best to repair it");
}

+(NSString *)NetworkError{

    return Internationalization(@"请检查您的网络情况", @"Please check your network situation");
}

@end
