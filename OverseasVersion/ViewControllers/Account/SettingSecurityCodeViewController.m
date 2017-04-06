//
//  SettingSecurityCodeViewController.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/15.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "SettingSecurityCodeViewController.h"

#import "OtherTool.h"

#import "ShadowView.h"

#import "XLNotificationTransfer.h"

#import "HXTouchID.h"

#import "LSStatusBarHUD.h"

@interface SettingSecurityCodeViewController ()

@property (nonatomic,strong) NSMutableArray * textFieldArr;

@property (nonatomic,strong) JWScrollviewCell * verificationCodeCell;

@property (nonatomic,strong) NSString * backStr;

@property (nonatomic,strong) NSString * firstPassword;


@end

@implementation SettingSecurityCodeViewController


-(NSMutableArray *)textFieldArr{
    if (!_textFieldArr) {
        _textFieldArr =[NSMutableArray arrayWithCapacity:10];
    }
    return _textFieldArr;
}

-(JWScrollviewCell *)verificationCodeCell{
    
    if (!_verificationCodeCell) {
        _verificationCodeCell = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        [self.view addSubview:_verificationCodeCell];
        
        JWLabel * messlab = [[JWLabel alloc]initWithFrame:CGRectMake(30, 64, kScreenWidth-60, 30)];
        messlab.numberOfLines = 0;
        NSString *message = Internationalization(@"请创建个人识别码（PIN）",  @"Please create a Personal Identification Number (PIN)");
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
            self.backStr = backStr;
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
            textField.textAlignment = 1;
            textField.userInteractionEnabled =false;
            //            textField.secureTextEntry = true;
            textField.font = kMediumFont(18);
            NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"—" attributes:@{NSFontAttributeName : kMediumFont(18), NSForegroundColorAttributeName : commonBlackBtnColor}];
            textField.attributedPlaceholder = str;
            [_verificationCodeCell.contentView addSubview:textField];
            [self.textFieldArr addObject:textField];
        }
        
        JWLabel * warningL = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(texttfeld.frame), kScreenWidth-40, 60)];
        warningL.textAlignment = 1;
        warningL.textColor = commonErrorColor;
        warningL.font = kItalicFont(11);
        warningL.tag = 1992;
        warningL.hidden = false;
        warningL.numberOfLines = 0;
        [_verificationCodeCell.contentView addSubview:warningL];
        
        
        JWLabel * noteLab = [[JWLabel alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(warningL.frame), kScreenWidth-80, 100)];
        noteLab.textColor = commonBlackBtnColor;
        noteLab.labelAnotherColor = UIColorFromRGB(0x949494);
        noteLab.font = kMediumFont(11);
        noteLab.labelAnotherFont = kLightFont(11);
        noteLab.textAlignment = 1;
        noteLab.numberOfLines = 0;
        noteLab.text =
        Internationalization(@"提示: [<这个PIN是你每次支付时都会输入的数字，请不要将此代码分享给任何人.>]",@"NOTE: [<This PIN is the number that you will enter everytime you make a payment. Please do not share this code to anyone.>]");
        
        [_verificationCodeCell.contentView addSubview:noteLab];
        

        ShadowView * nextBtn = [[ShadowView alloc] initWithFrame:
                                CGRectMake(20,CGRectGetMaxY(noteLab.frame)+40,kScreenWidth-40,ShadowViewHeight)];
        nextBtn.colors =commonColorS;
        [nextBtn addSingleTapEvent:^{
            NSLog(@"next");
            if (((JWTextField *)self.verificationCodeCell.getElementByTag(1991)).text.length >6 || !((JWTextField *)self.verificationCodeCell.getElementByTag(1991)).text.length) {
                NSLog(@"未输入完毕");
            }else{
                [self setting:self.backStr];
            }
        }];
        [_verificationCodeCell.contentView addSubview:nextBtn];
        JWLabel * nextLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, nextBtn.y, nextBtn.width, nextBtn.height)];
        nextLab.text = Internationalization(@"下一步",  @"Next");
        nextLab.textAlignment = 1;
        nextLab.textColor = [UIColor whiteColor];
        nextLab.tag = 1993;
        [_verificationCodeCell.contentView addSubview:nextLab];
        
        
        [_verificationCodeCell setUPSpacing:0 andDownSpacing:0];
        
    }
    return _verificationCodeCell;
    
}

-(void)viewDidLoad{

    [super viewDidLoad];
    
    [self addNotification];
    
    [self.view addSubview:self.verificationCodeCell];
    
    if ([self.skipStr isEqualToString:@"正常注册"]) {
        
        //去掉返回键
        [self createTitleBarButtonItemStyle:BtnLeftType title:@"" TapEvent:^{
            
        }];
        
    }else if ([self.skipStr isEqualToString:@"退出注册"]){

        //去掉返回键
        [self createTitleBarButtonItemStyle:BtnLeftType title:@"" TapEvent:^{
            
        }];
        
    }else if ([self.skipStr isEqualToString:@"验证密码"]){
        
        ((JWLabel *)self.verificationCodeCell.getElementByTag(1990)).text = Internationalization(@"输入保护密码", @"Input protection password"); //输入保护密码
        ((JWLabel *)self.verificationCodeCell.getElementByTag(1993)).text = Internationalization(@"验证",  @"Verification");
        
    }else if ([self.skipStr isEqualToString:@"重新设置密码"]){
        
    }

}

-(void)setting:(NSString *)str{
    
    if ([self.skipStr isEqualToString:@"正常注册"]) {
        
        if (!self.firstPassword.length) {
            self.firstPassword = str;
            ((JWLabel *)self.verificationCodeCell.getElementByTag(1990)).text = CCNotice(@"请确认您的号码（PIN）", @"Please confirm your Personal Identification Number (PIN)");
            [self resettingViewData];
            return;
        }else{
            if ([self.firstPassword isEqualToString:str]) {
                
                [self setNewpayPassword:self.firstPassword];
                
            }else{
                self.firstPassword = @"";
                [self resettingViewData];
                ((JWLabel *)self.verificationCodeCell.getElementByTag(1992)).text = CCNotice(@"请确保您输入的PIN与上次输入的PIN一致", @"The PIN you entered did not match the last one you entered. Please make sure it’s the same.");
            }
        }
    }else if ([self.skipStr isEqualToString:@"退出注册"]){

        if (!self.firstPassword.length) {
            self.firstPassword = str;
            ((JWLabel *)self.verificationCodeCell.getElementByTag(1990)).text = CCNotice(@"请确认您的号码（PIN）", @"Please confirm your Personal Identification Number (PIN)");
            [self resettingViewData];
            return;
        }else{
            if ([self.firstPassword isEqualToString:str]) {
                
                [self setNewpayPassword:self.firstPassword];
            }else{
                self.firstPassword = @"";
                [self resettingViewData];
                ((JWLabel *)self.verificationCodeCell.getElementByTag(1992)).text = CCNotice(@"请确保您输入的PIN与上次输入的PIN一致", @"The PIN you entered did not match the last one you entered. Please make sure it’s the same.");
            }
        }
        
    }else if ([self.skipStr isEqualToString:@"验证密码"]){
        
        NSString * rrotectStr =  [[NSUserDefaults standardUserDefaults] objectForKey:@"ProtectPassword"];
        if ([str isEqualToString:rrotectStr]) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            self.firstPassword = @"";
            [self resettingViewData];
            ((JWLabel *)self.verificationCodeCell.getElementByTag(1992)).text = CCNotice(@"请确保您输入的PIN与上次输入的PIN一致", @"The PIN you entered did not match the last one you entered. Please make sure it’s the same.");
        }
        
    }else if ([self.skipStr isEqualToString:@"重新设置密码"]){
        
        if (!self.firstPassword.length) {
            self.firstPassword = str;
            ((JWLabel *)self.verificationCodeCell.getElementByTag(1990)).text = CCNotice(@"请确认您的号码（PIN）", @"Please confirm your Personal Identification Number (PIN)");
            [self resettingViewData];
            return;
        }else{
            if ([self.firstPassword isEqualToString:str]) {
                
                [self setNewpayPassword:self.firstPassword];
            
            }else{
                self.firstPassword = @"";
                [self resettingViewData];
                ((JWLabel *)self.verificationCodeCell.getElementByTag(1992)).text = CCNotice(@"请确保您输入的PIN与上次输入的PIN一致", @"The PIN you entered did not match the last one you entered. Please make sure it’s the same.");
            }
        }
        
    }
    
}

-(void)showAlertView{
    
//    JWAlertView * jwalert1 = [[JWAlertView alloc]initJWAlertViewWithTitle:Internationalization(@"注册成功！", @"Registration successful!") message:Internationalization(@"加钱到你的钱包去最近的现金设备，这样你就可以开始使用PICA和获得奖励一天！", @"Add money to your wallet by going to the nearest Cash In facility so you can start using PICA and earn rewards to day!") delegate:self cancelButtonTitle:Internationalization(@"好的", @"OK") otherButtonTitles:nil];
//    [jwalert1 alertShow];
    
    UIAlertView * aletView = [[UIAlertView alloc]initWithTitle:@"Registration successful!" message:@"Add money to your wallet by going to the nearest Cash In facility so you can start using PICA and earn rewards to day!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
    [aletView show];
    
}


-(void)resettingViewData{
    
    self.backStr = ((JWTextField *)self.verificationCodeCell.getElementByTag(1991)).text = @"";
    
    for (NSInteger i = 0; i < self.textFieldArr.count; i++)
    {
        UITextField *textField = self.textFieldArr[i];
        textField.text = @"";
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:@"—" attributes:@{NSFontAttributeName : kMediumFont(18), NSForegroundColorAttributeName : commonBlackBtnColor}];
        textField.attributedPlaceholder = str;
    }
    
}

- (void)dealloc {
    [self clearNotificationAndGesture];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//设置支付密码
-(void)setNewpayPassword:(NSString *)password{
    
    [self.view endEditing:true];
    
    NSString * code = self.verification_Code;
    
    if (!self.verification_Code.length) {
        code = @"";
    }
    
    [self showHud];
    HXWeak_self
    [CommonService requestResetPayPwdOfaccess_token:self.defaultSetting.access_token payPassword:password code:code success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HXStrong_self
        if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
            
            if ([self.skipStr isEqualToString:@"退出注册"]) {
                commonAppDelegate.singleton.mainTabBarVC.selectedIndex = 3;
                [self dismissViewControllerAnimated:true completion:nil];
                [self showAlertView];
            }else if ([self.skipStr isEqualToString:@"正常注册"]){
                MainTabBarViewController * mainTabBar = [[MainTabBarViewController alloc]init];
                mainTabBar.selectedIndex = 3;
                self.view.window.rootViewController = mainTabBar;
                [self showAlertView];
            }else if ([self.skipStr isEqualToString:@"重新设置密码"]){
                
                NSMutableAttributedString *a= [LSStatusBarHUD createAttributedText:@"Set success" color:[UIColor whiteColor] font:kMediumFont(13)];
                [LSStatusBarHUD showMessage:a backgroundColor:UIColorFromRGB(0x2fb000)];
                
                [self publicPopViewControllerIndex:0 Animated:true];
            }

        }else{
            [self showTip:[responseObject objectForKey:@"errorMessage"]];
            
            self.firstPassword = @"";
            [self resettingViewData];
            
        }
        [self closeHud];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HXStrong_self
        [self closeHud];
        [self errorDispose:[[operation response] statusCode] judgeMent:nil];
    }];
    
}





@end
