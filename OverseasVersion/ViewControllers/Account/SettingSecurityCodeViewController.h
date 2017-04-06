//
//  SettingSecurityCodeViewController.h
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/15.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "MainViewController.h"

@interface SettingSecurityCodeViewController : MainViewController

@property (nonatomic,strong) NSString * skipStr;

@property (nonatomic,strong) NSString * verification_Code;//验证码

@end


/*
 
 if ([self.skipStr isEqualToString:@"正常注册"]) {

 }else if ([self.skipStr isEqualToString:@"退出注册"]){

 }else if ([self.skipStr isEqualToString:@"验证密码"]){
 
 }else if ([self.skipStr isEqualToString:@"重新设置密码"]){
 
 }

 
 */
