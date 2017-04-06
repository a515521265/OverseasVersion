//
//  SettingNewPasswordViewController.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/9.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "SettingNewPasswordViewController.h"
#import "CommonService.h"
#import "ShadowView.h"
#import "LSStatusBarHUD.h"
#import "HelperUtil.h"
@interface SettingNewPasswordViewController ()

@property (nonatomic,strong) JWScrollviewCell * passwordCell;

@property (nonatomic,strong) JWScrollView * scrollView;

@end

@implementation SettingNewPasswordViewController

-(JWScrollView *)scrollView{
    
    if (!_scrollView) {
        _scrollView = [[JWScrollView alloc]init];
        _scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
        _scrollView.alwaysBounceVertical = true;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.passwordCell = [self creatCell:Internationalization(@"密码", @"Password") describe:Internationalization(@"输入密码", @"type in your password here")];
    
    UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    whiteView.backgroundColor = [UIColor whiteColor];
    
    ShadowView * setNewPasswordBtn = [[ShadowView alloc] initWithFrame:
                             CGRectMake(20,20,kScreenWidth-40,ShadowViewHeight)];
    setNewPasswordBtn.colors =@[(id)UIColorFromRGB(0x9164db).CGColor, (id)UIColorFromRGB(0x46bbe3).CGColor];
    [setNewPasswordBtn addSingleTapEvent:^{
        [self setnewPassword];
    }];
    [whiteView addSubview:setNewPasswordBtn];
    JWLabel * loginLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, setNewPasswordBtn.y, setNewPasswordBtn.width, setNewPasswordBtn.height)];
    loginLab.text = @"Reset";
    loginLab.textAlignment = 1;
    loginLab.textColor = [UIColor whiteColor];
    [whiteView addSubview:loginLab];
    
    
    [self.scrollView setScrollviewSubViewsArr:@[self.passwordCell,whiteView].mutableCopy];
    
}

-(JWScrollviewCell *)creatCell:(NSString *)title describe:(NSString *)describe{
    JWScrollviewCell * cell = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    JWLabel * tipLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, 30, 100, 30)];
    tipLab.textColor = commonGreenColor;
    tipLab.text = title;
    tipLab.tag = 2001;
    [cell.contentView addSubview:tipLab];
    JWTextField  * textField = [[JWTextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(tipLab.frame), kScreenWidth-40, 30)];
    textField.placeholder = describe;
    textField.tag = 2002;
    textField.secureTextEntry = true;
    [cell.contentView addSubview:textField];
    JWLabel * lineLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(textField.frame), kScreenWidth-40, 1)];
    lineLab.backgroundColor = commonGreenColor;
    lineLab.tag = 2003;
    [cell.contentView addSubview:lineLab];
    [cell setUPSpacing:0 andDownSpacing:0];
    return cell;
}

-(void)setnewPassword{

    if (![HelperUtil checkPassword:((JWTextField *)self.passwordCell.getElementByTag(2002)).text]) {
        [self showTip:@"Password should be 6-18 digit and letter combination"];
        return;
    }
    
    [self.view endEditing:true];
    
    [self showHud];
    HXWeak_self
    [CommonService requestForgetPasswordOfaccess_token:self.defaultSetting.access_token mobile:self.transmitObject[@"phone"] code:self.verification_Code newpassword:((JWTextField *)self.passwordCell.getElementByTag(2002)).text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HXStrong_self
        if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
            
            NSMutableAttributedString *a= [LSStatusBarHUD createAttributedText:@"Set success" color:[UIColor whiteColor] font:kMediumFont(13)];
            [LSStatusBarHUD showMessage:a backgroundColor:UIColorFromRGB(0x2fb000)];
            
            [self publicPopViewControllerIndex:0 Animated:true];
            
        }else{
            [self showTip:[responseObject objectForKey:@"errorMessage"]];
        }
        [self closeHud];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HXStrong_self
        [self closeHud];
        [self errorDispose:[[operation response] statusCode] judgeMent:nil];
    }];
    
}


@end
