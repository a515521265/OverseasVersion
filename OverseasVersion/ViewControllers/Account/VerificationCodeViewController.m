//
//  VerificationCodeViewController.m
//  OverseasVersion
//
//  Created by 梁家文 on 17/2/7.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "VerificationCodeViewController.h"

#import "NSObject+Extension.h"

#import "JPUSHService.h"
//设置新的密码
#import "SettingNewPasswordViewController.h"
//设置支付密码
#import "SettingPayPasswordViewController.h"

#import "ShadowView.h"

#import "SettingTouchIDViewController.h"

#import <LocalAuthentication/LocalAuthentication.h>

#import "SettingSecurityCodeViewController.h"

@interface VerificationCodeViewController ()

@property (nonatomic,strong) NSMutableArray * textFieldArr;

@property (nonatomic,strong) JWScrollviewCell * verificationCodeCell;

@property (nonatomic,strong) NSString * verificationCodeStr;

@end

@implementation VerificationCodeViewController

-(NSMutableArray *)textFieldArr{
    if (!_textFieldArr) {
        _textFieldArr =[NSMutableArray arrayWithCapacity:10];
    }
    return _textFieldArr;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.verificationCodeStr = @"";
    
    [self verificationCodeCell];
    
    if ([self.skipStr isEqualToString:@"注册"] || [self.skipStr isEqualToString:@"忘记密码"]) {
        
    }else{
        [self judgeSkipStr];
    }

}


-(void)judgeSkipStr{
    
    if ([self.skipStr isEqualToString:@"忘记密码"]) {
        [self getForgetPasswordVerificationCode];
    }else if ([self.skipStr isEqualToString:@"账户修改密码"]){
        [self getForgetPasswordVerificationCode];
    }else if ([self.skipStr isEqualToString:@"账户修改交易密码"]){
        [self getResetPayPwdVerificationCode];
    }else{
        [self getVerificationCode];
    }
}


-(JWScrollviewCell *)verificationCodeCell{

    if (!_verificationCodeCell) {
        _verificationCodeCell = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [self.view addSubview:_verificationCodeCell];
        
        JWLabel * messlab = [[JWLabel alloc]initWithFrame:CGRectMake(30, 64, kScreenWidth-60, 30)];
        messlab.numberOfLines = 0;
        NSString *message = Internationalization(@"请输入6位代码", @"Please enter the 6-digit code");
        messlab.text = message;
        messlab.font = kMediumFont(15);
        messlab.textColor = commonBlackBtnColor;
        CGSize tipLabelsize = [message boundingRectWithSize:CGSizeMake((kScreenWidth - 60), 0)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName : messlab.font}
                                                    context:nil].size;
        messlab.frame = CGRectMake(30, 64, (kScreenWidth - 60), tipLabelsize.height);
        messlab.tag = 1990;
        messlab.textAlignment = 1;
        [_verificationCodeCell.contentView addSubview:messlab];

        
        JWTextField * texttfeld = [[JWTextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(messlab.frame)+20, kScreenWidth-40, 50)];
        texttfeld.textAlignment = 1;
        texttfeld.tintColor =[UIColor clearColor];
        texttfeld.textColor = [UIColor clearColor];
        texttfeld.keyboardType = UIKeyboardTypeNumberPad;
        texttfeld.tag = 1991;
        HXWeak_self
        HXWeak_(texttfeld)
        texttfeld.importBackString = ^(NSString * backStr){
            HXStrong_self
            HXStrong_(texttfeld)
            NSLog(@"----%@",backStr);
            
            self.verificationCodeStr = backStr;
            
            if (backStr.length == self.textFieldArr.count)
                [texttfeld resignFirstResponder];// 输入完毕
            for (NSInteger i = 0; i < self.textFieldArr.count; i++)
            {
                UITextField *textField = self.textFieldArr[i];
                NSString *passwordChar;
                if (i < backStr.length)
                    passwordChar = [backStr substringWithRange:NSMakeRange(i, 1)];
                textField.text = passwordChar;
            }
            if (backStr.length == 6)
            {
//                [self tapNextwithCode:backStr];
            }
        };
        [_verificationCodeCell.contentView addSubview:texttfeld];
        
        for (int i =0; i<6; i++) {
            UITextField * textField =[[UITextField alloc]initWithFrame:CGRectMake(((_verificationCodeCell.contentView.width-174)/2) + 29 * i, CGRectGetMaxY(messlab.frame)+20, 30, 30)];
            textField.placeholder = @"";
//            textField.borderStyle = UITextBorderStyleLine;
            textField.textAlignment = 1;
            textField.userInteractionEnabled =false;
//            textField.secureTextEntry = true;
            textField.font = kMediumFont(18);
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"—" attributes:@{NSFontAttributeName : kMediumFont(18), NSForegroundColorAttributeName : commonBlackBtnColor}];
            textField.attributedPlaceholder = str;
            //            textField.layer.borderColor = [[UIColor grayColor] CGColor];
            //            textField.layer.borderWidth = 0.5;
             [_verificationCodeCell.contentView addSubview:textField];
            [self.textFieldArr addObject:textField];
        }
        
        JWLabel * warningL = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(texttfeld.frame), kScreenWidth-40, 30)];
        warningL.textAlignment = 1;
        warningL.textColor = commonErrorColor;
        warningL.text = Internationalization(@"错误代码，请再试一次。", @"Wrong code, please try again.");
        warningL.font = kItalicFont(11);
        warningL.tag = 1992;
        warningL.hidden = true;
        [_verificationCodeCell.contentView addSubview:warningL];
        
        JWLabel * anewLab = [[JWLabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth-60, 30)];
        anewLab.numberOfLines = 0;
        anewLab.textAlignment = 1;
        NSString *message1 = @"Did not receive the code? \n Click here and we’ll send it again.";
        anewLab.text = message1;
        anewLab.font = kLightFont(12);
        anewLab.textColor = commonGrayColor;
        CGSize tipLabelsize1 = [message1 boundingRectWithSize:CGSizeMake((kScreenWidth - 60), 0)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName : anewLab.font}
                                                    context:nil].size;
        anewLab.frame = CGRectMake(30, CGRectGetMaxY(warningL.frame)+50, (kScreenWidth - 60), tipLabelsize1.height);
        
        NSRange contentRange = {anewLab.text.length-35,10};
        
        [self addUnderlineLabel:anewLab labText:message1 range:contentRange];
        
        [anewLab addSingleTapEvent:^{
            HXStrong_self
            NSLog(@"再次发送");
            [self judgeSkipStr];
        }];
        [_verificationCodeCell.contentView addSubview:anewLab];
        
        
        ShadowView * nextBtn = [[ShadowView alloc] initWithFrame:
                                 CGRectMake(20,CGRectGetMaxY(anewLab.frame)+40,kScreenWidth-40,ShadowViewHeight)];
        nextBtn.colors =commonColorS;
        [nextBtn addSingleTapEvent:^{
            NSLog(@"next");
            if (((JWTextField *)self.verificationCodeCell.getElementByTag(1991)).text.length >6 || !((JWTextField *)self.verificationCodeCell.getElementByTag(1991)).text.length) {
                NSLog(@"未输入完毕");
            }else{
                [self requestUserCheckCode:self.verificationCodeStr];
            }
        }];
        [_verificationCodeCell.contentView addSubview:nextBtn];
        JWLabel * nextLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, nextBtn.y, nextBtn.width, nextBtn.height)];
        nextLab.text = Internationalization(@"下一步", @"Next");
        nextLab.textAlignment = 1;
        nextLab.textColor = [UIColor whiteColor];
        nextLab.tag = 1992;
        [_verificationCodeCell.contentView addSubview:nextLab];
        
        
        [_verificationCodeCell setUPSpacing:0 andDownSpacing:0];
        
    }
    return _verificationCodeCell;
    
}

-(void)tapNextwithCode:(NSString *)code{

    if ([self.skipStr isEqualToString:@"忘记密码"]) {
        SettingNewPasswordViewController *  SettingNewPasswordVC = [SettingNewPasswordViewController new];
        SettingNewPasswordVC.transmitObject = self.transmitObject;
        SettingNewPasswordVC.verification_Code = code;
        [self.navigationController pushViewController:SettingNewPasswordVC animated:true];
    }else if ([self.skipStr isEqualToString:@"账户修改密码"]){
        SettingNewPasswordViewController *  SettingNewPasswordVC = [SettingNewPasswordViewController new];
        SettingNewPasswordVC.transmitObject = self.transmitObject;
        SettingNewPasswordVC.verification_Code = code;
        SettingNewPasswordVC.skipStr = @"账户修改密码";
        [self.navigationController pushViewController:SettingNewPasswordVC animated:true];
        
    }else if ([self.skipStr isEqualToString:@"账户修改交易密码"]){
        
        SettingSecurityCodeViewController *  SettingNewPasswordVC = [SettingSecurityCodeViewController new];
        SettingNewPasswordVC.transmitObject = self.transmitObject;
        SettingNewPasswordVC.verification_Code = code;
        SettingNewPasswordVC.skipStr = @"重新设置密码";
        [self.navigationController pushViewController:SettingNewPasswordVC animated:true];
        
//        重新设置密码
        
        
        
    }else{
        [self requestUserRegister:code];
    }
    //输入完毕重置数据
    [self resettingViewData];
}

//校验验证码
-(void)requestVerificationCodeSuccess:(BOOL)success{

    if (success) {
        [self requestUserLogin];
    }else{
        ((JWLabel *)self.verificationCodeCell.getElementByTag(1990)).textColor = commonErrorColor;
        self.verificationCodeStr = ((JWTextField *)self.verificationCodeCell.getElementByTag(1991)).text = @"";
        ((JWLabel *)self.verificationCodeCell.getElementByTag(1992)).hidden = false;
        
        for (NSInteger i = 0; i < self.textFieldArr.count; i++)
        {
            UITextField *textField = self.textFieldArr[i];
            textField.text = @"";
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"—" attributes:@{NSFontAttributeName : kMediumFont(18), NSForegroundColorAttributeName : commonErrorColor}];
            textField.attributedPlaceholder = str;
            
        }
    }
}

-(void)resettingViewData{

    self.verificationCodeStr = ((JWTextField *)self.verificationCodeCell.getElementByTag(1991)).text = @"";
    
    for (NSInteger i = 0; i < self.textFieldArr.count; i++)
    {
        UITextField *textField = self.textFieldArr[i];
        textField.text = @"";
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"—" attributes:@{NSFontAttributeName : kMediumFont(18), NSForegroundColorAttributeName : commonBlackBtnColor}];
        textField.attributedPlaceholder = str;
        
    }
}

//获取验证码
-(void)getVerificationCode{

    [self showHud];
    HXWeak_self
    [CommonService getVerifyCodeWithMobile:self.transmitObject[@"phone"]
                              accountToken:self.defaultSetting.access_token
                                 area_code:self.transmitObject[@"area_code"]
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HXStrong_self
        if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
            [self showTip:[TIPTEXT sendVerificationCode]];
        }else{
            [self showTip:[responseObject objectForKey:@"errorMessage"]];
        }
        [self closeHud];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self closeHud];
        [self errorDispose:[[operation response] statusCode] judgeMent:nil];
    }];
    
}

//接口校验验证码
-(void)requestUserCheckCode:(NSString *)code{

    
    NSString * business;
    
    if ([self.skipStr isEqualToString:@"忘记密码"]) {
        business = @"forgetPassword";
    }else if ([self.skipStr isEqualToString:@"账户修改密码"]){
        business = @"forgetPassword";
    }else if ([self.skipStr isEqualToString:@"账户修改交易密码"]){
        business = @"resetPayPwd";
    }else{
        business = @"onLineRegister";
    }
    
    [self showHud];
    HXWeak_self
    [CommonService requestCheckCodeOfaccess_token:self.defaultSetting.access_token
                                         business:business
                                             code:code
                                           mobile:self.transmitObject[@"phone"]
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HXStrong_self
        if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
            [self tapNextwithCode:code];
        }else{
            [self showTip:[responseObject objectForKey:@"errorMessage"]];
            [self requestVerificationCodeSuccess:false];
        }
        [self closeHud];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HXStrong_self
        [self closeHud];
        [self errorDispose:[[operation response] statusCode] judgeMent:nil];
    }];
    
}


//注册接口
-(void)requestUserRegister:(NSString *)code{

//    [self showHud];
    customHUD * hud = [[customHUD alloc]init];
    [hud showCustomHUDWithView:self.view];
    HXWeak_self
    [CommonService requestUserRegisterOfaccess_token:self.defaultSetting.access_token
                                               email:self.transmitObject[@"Email"]
                                            password:self.transmitObject[@"Password"]
                                              mobile:self.transmitObject[@"phone"]
                                          verifycode:code
                                           firstname:self.transmitObject[@"firstname"] lastname:self.transmitObject[@"lastname"]
                                             success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HXStrong_self
        if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
            [self requestVerificationCodeSuccess:true];
        }else{
            [self showTip:[responseObject objectForKey:@"errorMessage"]];
            [self requestVerificationCodeSuccess:false];
        }
//        [self closeHud];
        [hud hideCustomHUD];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [self closeHud];
        [hud hideCustomHUD];
        [self errorDispose:[[operation response] statusCode] judgeMent:nil];
    }];
}


//登录
-(void)requestUserLogin{
//    [self showHud];
    
    customHUD * hud = [[customHUD alloc]init];
    [hud showCustomHUDWithView:self.view];
    HXWeak_self
    [CommonService requestUserLoginOfaccess_token:self.defaultSetting.access_token email:self.transmitObject[@"Email"] password:self.transmitObject[@"Password"] success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HXStrong_self
        if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
            [self requestUserInfo];
        }else{
            [self showTip:[responseObject objectForKey:@"errorMessage"]];
        }
//        [self closeHud];
        [hud hideCustomHUD];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HXStrong_self
//        [self closeHud];
        [hud hideCustomHUD];
        [self errorDispose:[[operation response] statusCode] judgeMent:nil];
    }];
}

//获取用户信息
-(void)requestUserInfo{

//    [self showHud];
    customHUD * hud = [[customHUD alloc]init];
    [hud showCustomHUDWithView:self.view];
    HXWeak_self
    [CommonService requestUserInfoOfaccess_token:self.defaultSetting.access_token success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HXStrong_self
        if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
            NSDictionary *dict = [[responseObject objectForKey:@"data"] isEqual:[NSNull null]] ? nil : [responseObject objectForKey:@"data"];
            UserInfoModel *user = [UserInfoModel yy_modelWithDictionary:dict];
            self.defaultSetting.uid = user.userId;
            [JPUSHService setAlias:[NSString stringWithFormat:@"%ld",(long)user.userId] callbackSelector:nil object:nil];
            self.userInfoModel = user;
            [DefaultSetting saveSetting:self.defaultSetting];
            
            [self isTouchID];
            
        }else{
            [self showTip:[responseObject objectForKey:@"errorMessage"]];
        }
//        [self closeHud];
        [hud hideCustomHUD];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HXStrong_self
//        [self closeHud];
        [hud hideCustomHUD];
        [self errorDispose:[[operation response] statusCode] judgeMent:nil];
    }];
    
}


//获取忘记密码的验证码
-(void)getForgetPasswordVerificationCode{
    
    [self showHud];
    HXWeak_self
    [CommonService getForgetPasswordVerifyCodeWithMobile:self.transmitObject[@"phone"]
                                            accountToken:self.defaultSetting.access_token
                                               area_code:self.transmitObject[@"area_code"]
                                                 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HXStrong_self
        if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
            [self showTip:[TIPTEXT sendVerificationCode]];
        }else{
            [self showTip:[responseObject objectForKey:@"errorMessage"]];
        }
        [self closeHud];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self closeHud];
        [self errorDispose:[[operation response] statusCode] judgeMent:nil];
    }];
    
}


//获取设置支付密码的验证码
-(void)getResetPayPwdVerificationCode{
    
    [self showHud];
    HXWeak_self
    [CommonService getResetPayPwdVerifyCodeWithMobile:self.transmitObject[@"phone"]
                                         accountToken:self.defaultSetting.access_token
                                            area_code:self.transmitObject[@"area_code"]
                                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HXStrong_self
        if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
            [self showTip:[TIPTEXT sendVerificationCode]];
        }else{
            [self showTip:[responseObject objectForKey:@"errorMessage"]];
        }
        [self closeHud];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self closeHud];
        [self errorDispose:[[operation response] statusCode] judgeMent:nil];
    }];
}

-(void)addUnderlineLabel:(UILabel *)lab labText:(NSString *)text range:(NSRange)range{
    
    NSMutableAttributedString *content = [[NSMutableAttributedString alloc]initWithString:text];
    NSRange contentRange = range;
    [content addAttribute:NSUnderlineStyleAttributeName value:[NSNumber numberWithInteger:NSUnderlineStyleSingle] range:contentRange];
    lab.attributedText = content;
    
}

//判断是否支持指纹
-(void)isTouchID{

    

    
    LAContext *laContext = [[LAContext alloc] init];
    NSError *error;

    //支持去设置指纹
    if ([laContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        
        HXSingleton * singleton =  [HXSingleton sharedSingleton];
        if (singleton.isAccount) {
            //                [self dismissViewControllerAnimated:YES completion:nil];
            singleton.skipStr = @"退出注册新账号";
            
            [self.navigationController pushViewController:[SettingTouchIDViewController new] animated:true];
        }else{
            //设置根控制器
            //                [self setRootViewController:[[MainTabBarViewController alloc] init]];
            singleton.skipStr = @"正常进入注册";
            [self.navigationController pushViewController:[SettingTouchIDViewController new] animated:true];
        }
        
    }
    else {

        if (error.code == LAErrorTouchIDLockout) {
            
            HXSingleton * singleton =  [HXSingleton sharedSingleton];
            if (singleton.isAccount) {
                singleton.skipStr = @"退出注册新账号";
                [self.navigationController pushViewController:[SettingTouchIDViewController new] animated:true];
            }else{
                singleton.skipStr = @"正常进入注册";
                [self.navigationController pushViewController:[SettingTouchIDViewController new] animated:true];
            }
            
        }else{
            HXSingleton * singleton =  [HXSingleton sharedSingleton];
            if (singleton.isAccount) {
                singleton.skipStr = @"退出注册新账号";
                SettingSecurityCodeViewController * settingSecurity = [SettingSecurityCodeViewController new];
                settingSecurity.skipStr = @"退出注册";
                [self.navigationController pushViewController:settingSecurity animated:true];
            }else{
                //设置根控制器
                singleton.skipStr = @"正常进入注册";
                SettingSecurityCodeViewController * settingSecurity = [SettingSecurityCodeViewController new];
                settingSecurity.skipStr = @"正常注册";
                [self.navigationController pushViewController:settingSecurity animated:true];
            }
        }
        

        
    }
    
}



@end
