//
//  SettingTouchIDViewController.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/15.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "SettingTouchIDViewController.h"
#import "HXTouchID.h"
#import "SettingSecurityCodeViewController.h"

@interface SettingTouchIDViewController ()

@property (nonatomic,strong) JWScrollviewCell * touchIDCell;

@property (nonatomic,strong) HXSingleton * singleton;

@end

@implementation SettingTouchIDViewController

-(HXSingleton *)singleton{

    if (!_singleton) {
        _singleton = [HXSingleton sharedSingleton];
    }
    return _singleton;
}

-(JWScrollviewCell *)touchIDCell{

    if (!_touchIDCell) {
        _touchIDCell = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        JWLabel *tipLabel = [[JWLabel alloc] initWithFrame:CGRectMake(40, 40, kScreenWidth-80, 60)];
        tipLabel.font = kMediumFont(15);
        tipLabel.textColor = commonGrayColor;
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.numberOfLines = 0;
        tipLabel.text = Internationalization(@"请扫描您的手指使用快速和安全的付款", @"Please scan your finger to use for fast and secure payment");
        tipLabel.tag = 1999;
        [_touchIDCell.contentView addSubview:tipLabel];
        
        
        UIImageView * touchidImage = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth - 1039/4)/2, CGRectGetMaxY(tipLabel.frame)+40, 1039/4, 1120/4)];
        touchidImage.image = [UIImage imageNamed:@"指纹1"];
        touchidImage.tag = 2000;
        [touchidImage addSingleTapEvent:^{
            [self setTouchID];
        }];
        [_touchIDCell.contentView addSubview:touchidImage];
        
        JWLabel *tipLabel2 = [[JWLabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(touchidImage.frame)+40, kScreenWidth-40, 60)];
        tipLabel2.font = kItalicFont(12);
        tipLabel2.textColor = commonErrorColor;
        tipLabel2.textAlignment = NSTextAlignmentCenter;
        tipLabel2.numberOfLines = 0;
        tipLabel2.text = Internationalization(@"请清洁指纹扫描仪，然后再试一次。", @"Please clean the finger print scanner and try again.");
        tipLabel2.tag = 2001;
        tipLabel2.hidden = true;
        [_touchIDCell.contentView addSubview:tipLabel2];
        
        [_touchIDCell setUPSpacing:0 andDownSpacing:0];
    }
    return _touchIDCell;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.touchIDCell];
    

    if ([self.singleton.skipStr isEqualToString:@"正常进入注册"]) {
        
        [self createTitleBarButtonItemStyle:BtnRightType title:@"Skip" TapEvent:^{
            SettingSecurityCodeViewController * settingSecurityVC =  [SettingSecurityCodeViewController new];
            settingSecurityVC.skipStr = @"正常注册";
            [self.navigationController pushViewController:settingSecurityVC animated:true];
        }];
        
        //去掉返回键
        [self createTitleBarButtonItemStyle:BtnLeftType title:@"" TapEvent:^{
            
        }];
        
        
    }else if ([self.singleton.skipStr isEqualToString:@"退出注册新账号"]){
    
        [self createTitleBarButtonItemStyle:BtnRightType title:@"Skip" TapEvent:^{
            SettingSecurityCodeViewController * settingSecurityVC =  [SettingSecurityCodeViewController new];
            settingSecurityVC.skipStr = @"退出注册";
            [self.navigationController pushViewController:settingSecurityVC animated:true];
        }];
        //去掉返回键
        [self createTitleBarButtonItemStyle:BtnLeftType title:@"" TapEvent:^{
            
        }];
    }
}

-(void)setTouchID{
    
    [self validateTouchID];
    
}

-(void)pushettingSecurityVC{

    if ([self.singleton.skipStr isEqualToString:@"正常进入注册"]) {
        SettingSecurityCodeViewController * settingSecurityVC =  [SettingSecurityCodeViewController new];
        settingSecurityVC.skipStr = @"正常注册";
        [self.navigationController pushViewController:settingSecurityVC animated:true];
    }else if ([self.singleton.skipStr isEqualToString:@"退出注册新账号"]){
        SettingSecurityCodeViewController * settingSecurityVC =  [SettingSecurityCodeViewController new];
        settingSecurityVC.skipStr = @"退出注册";
        [self.navigationController pushViewController:settingSecurityVC animated:true];
    }
    
}


-(void)validateTouchID{

    
    // 判断系统是否是iOS8.0以上 8.0以上可用
    if (!([[UIDevice currentDevice]systemVersion].doubleValue >= 8.0)) {
        NSLog(@"系统不支持");
        return;
    }
    
    // 创建LAContext对象
    LAContext *authenticationContext = [[LAContext alloc]init];
    NSError *error = nil;
    authenticationContext.localizedFallbackTitle = @"";
    [authenticationContext canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error];
    if (error.code == LAErrorTouchIDLockout ) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [authenticationContext evaluatePolicy:LAPolicyDeviceOwnerAuthentication localizedReason:@"重新开启TouchID功能" reply:^(BOOL success, NSError * _Nullable error) {
                if (success) {
                    [self validateTouchID];
                }
            }];
        });
        return;
    }
    [authenticationContext evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:Internationalization(@"验证密码", @"Verify Password") reply:^(BOOL success, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{

            if (error) {
                switch (error.code) {
                    case LAErrorAuthenticationFailed:
                        ((JWLabel *)self.touchIDCell.getElementByTag(1999)).textColor = commonErrorColor;
                        ((JWLabel *)self.touchIDCell.getElementByTag(2001)).hidden = false;
                        ((UIImageView *)self.touchIDCell.getElementByTag(2000)).image = [UIImage imageNamed:@"指纹2"];
                        [self showWindowTip:CCNotice(@"TouchID验证失败", @"Authorize Failure")];
                        break;
                    case LAErrorUserCancel:
                        // 点击取消按钮

                        break;
                    case LAErrorUserFallback:
                        // 用户点击输入密码按钮

                        break;
                    case LAErrorPasscodeNotSet:
                        //没有在设备上设置密码
                        [self pushettingSecurityVC];
                        [self showWindowTip:CCNotice(@"设备没有录入TouchID,无法启用TouchID", @"Authorize Error TouchID Not Enrolled")];
                        break;
                    case LAErrorTouchIDNotAvailable:
                        //设备不支持TouchID
                        [self pushettingSecurityVC];
                        [self showWindowTip:CCNotice(@"该设备的TouchID无效", @"Authorize Error TouchID Not Available")];
                        break;
                    case LAErrorTouchIDNotEnrolled:
                        //设备没有注册TouchID
                        [self pushettingSecurityVC];
                        [self showWindowTip:CCNotice(@"该设备的TouchID无效", @"Authorize Error TouchID Not Available")];
                        break;
                    case LAErrorTouchIDLockout:
                        //重新验证
                        [self validateTouchID];
                        break;
                    default:
                        break;
                }
                return ;
            }
            // 说明验证成功,如果要刷新UI必须在这里回到主线程
            [self verificationSuccess];
        });
    }];
}

-(void)verificationSuccess{

    [self showWindowTip:CCNotice(@"TouchID验证成功", @"Authorize Success")];
    [self pushettingSecurityVC];
    //可以指纹支付
    self.defaultSetting.isTouchID = true;
    [DefaultSetting saveSetting:self.defaultSetting];
    
    //给当前用户开启指纹支付
    NSString * uidStr = [NSString stringWithFormat:@"%ld",(long)self.defaultSetting.uid];
    [[NSUserDefaults standardUserDefaults] setBool:true forKey:uidStr];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

@end
