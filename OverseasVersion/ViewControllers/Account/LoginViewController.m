//
//  LoginViewController.m
//  OverseasVersion
//
//  Created by 梁家文 on 17/2/7.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "LoginViewController.h"

#import "ShadowView.h"

#import "ForgotPasswordViewController.h"

#import "VerificationCodeViewController.h"

#import "JPUSHService.h"

#import "OtherTool.h"

#import <FBSDKLoginKit/FBSDKLoginKit.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "FaceBookLogInViewController.h"

#import "HelperUtil.h"

@interface LoginViewController ()

@property (nonatomic,strong) JWScrollView * scrollView;
//通用cell
@property (nonatomic,strong) JWScrollviewCell * whiteCell;
//登录界面的cell
@property (nonatomic,strong) JWScrollviewCell * emailCell;
@property (nonatomic,strong) JWScrollviewCell * passwordCell;
@property (nonatomic,strong) JWScrollviewCell * errorCell;
//注册界面的cell
@property (nonatomic,strong) JWScrollviewCell * registerEmailCell;
@property (nonatomic,strong) JWScrollviewCell * registerPasswordCell;
@property (nonatomic,strong) JWScrollviewCell * accountTypeCell;
@property (nonatomic,strong) JWScrollviewCell * userNameCell;//注册填写
@property (nonatomic,strong) JWScrollviewCell * otherBtnsCell;
@property (nonatomic,strong) JWScrollviewCell * businessCell;

@property (nonatomic,strong) UIButton * selectBtn;
@property (nonatomic,strong) NSMutableArray * loginArr;
@property (nonatomic,strong) NSMutableArray * registerArr;

@property (nonatomic,strong) customHUD * faceBooklogInHUD;

@end

@implementation LoginViewController

-(customHUD *)faceBooklogInHUD{
    if (!_faceBooklogInHUD) {
        _faceBooklogInHUD = [[customHUD alloc]init];
    }
    return _faceBooklogInHUD;
}

-(NSMutableArray *)loginArr{

    if (!_loginArr) {
        _loginArr = [NSMutableArray arrayWithCapacity:10];
    }
    return _loginArr;
}

-(NSMutableArray *)registerArr{
    if (!_registerArr) {
        _registerArr = [NSMutableArray arrayWithCapacity:10];
    }
    return _registerArr;
}

-(JWScrollviewCell *)businessCell{

    if (!_businessCell) {
        _businessCell = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 140)];
        JWLabel * tiplab = [[JWLabel alloc]initWithFrame:CGRectMake(20, 10, kScreenWidth-40, adaptY(60))];
        tiplab.text =
        Internationalization(@"企业注册请下载App Store“PICA业务”的应用程序并进行登记有。谢谢您.", @"For Business registrations please download the “PICA Business” app from the App Store and proceed with the registration there. Thank you.");
        tiplab.font = kMediumFont(12);
        tiplab.textColor = commonBlackBtnColor;
        tiplab.numberOfLines = 0;
        [_businessCell.contentView addSubview:tiplab];
        
        
        UIImageView * image1 = [[UIImageView alloc]initWithFrame:CGRectMake(adaptX(70), CGRectGetMaxY(tiplab.frame), 813/10, 813/10)];
        image1.image = [UIImage imageNamed:@"picaLogo"];
        [_businessCell.contentView addSubview:image1];
        
        JWLabel * tiplab2 = [[JWLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image1.frame)+20, image1.y, 150, adaptY(30))];
        tiplab2.text = Internationalization( @"PICA 商户", @"PICA Business");
        tiplab2.font = kMediumFont(17);
        tiplab2.textColor = commonBlackBtnColor;
        [_businessCell.contentView addSubview:tiplab2];
        
        UIImageView * image2 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(image1.frame)+20, CGRectGetMaxY(tiplab2.frame), 956/10, 335/10)];
        image2.image = [UIImage imageNamed:@"下载"];
        HXWeak_self
        [image2 addSingleTapEvent:^{
            HXStrong_self
            [self skipAppStoreDownload];
        }];
        [_businessCell.contentView addSubview:image2];
        

        [_businessCell setUPSpacing:0 andDownSpacing:0];
    }
    return _businessCell;
    
}

//做头部 JWScrollviewCell bug
-(JWScrollviewCell *)whiteCell{
    if (!_whiteCell) {
        _whiteCell = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 1)];
        _whiteCell.backgroundColor = [UIColor whiteColor];
        [_whiteCell setUPSpacing:0 andDownSpacing:0];
    }
    return _whiteCell;
}

-(JWScrollviewCell *)accountTypeCell{

    if (!_accountTypeCell) {
        _accountTypeCell = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 95)];
        
        JWLabel * tipLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, 20, kScreenWidth, 30)];
        tipLab.textColor = commonBlackBtnColor;
        tipLab.text = Internationalization(@"账户类型", @"Type of Account");
        tipLab.tag = 3001;
        tipLab.font = kMediumFont(15);
        [_accountTypeCell.contentView addSubview:tipLab];
        
        UIButton * individualBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        individualBtn.frame = CGRectMake(20, CGRectGetMaxY(tipLab.frame)+15, 15.1, 15.1);
        [individualBtn setBackgroundImage:[UIImage imageNamed:@"单选新"] forState:UIControlStateNormal];
        [individualBtn setBackgroundImage:[UIImage imageNamed:@"选中新"] forState:UIControlStateSelected];
        individualBtn.tag = 4001;
        [_accountTypeCell.contentView addSubview:individualBtn];
        JWLabel * individualLab = [[JWLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(individualBtn.frame)+4, individualBtn.y-3, 80, 20)];
        individualLab.text = Internationalization(@"个人", @"Individual");
        individualBtn.selected = true;
        individualLab.textColor = commonVioletColor;
        individualLab.font = kMediumFont(12);
        [_accountTypeCell.contentView addSubview:individualLab];
        
        UIButton * businessBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        businessBtn.frame = CGRectMake(CGRectGetMaxX(individualLab.frame)+15, CGRectGetMaxY(tipLab.frame)+15, 15.1, 15.1);
        [businessBtn setBackgroundImage:[UIImage imageNamed:@"单选新"] forState:UIControlStateNormal];
        [businessBtn setBackgroundImage:[UIImage imageNamed:@"选中新"] forState:UIControlStateSelected];
        businessBtn.tag = 4002;
        [_accountTypeCell.contentView addSubview:businessBtn];
        
        JWLabel * businessLab = [[JWLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(businessBtn.frame)+4, businessBtn.y-3, 80, 20)];
        businessLab.text = Internationalization(@"企业", @"Business");
        businessLab.textColor = commonGrayBtnColor;
        businessLab.font = kMediumFont(12);
        [_accountTypeCell.contentView addSubview:businessLab];
        
        
        HXWeak_(individualBtn)
        HXWeak_(individualLab)
        HXWeak_(businessBtn)
        HXWeak_(businessLab)
        
        [individualBtn addSingleTapEvent:^{
            HXStrong_(individualBtn)
            HXStrong_(individualLab)
            HXStrong_(businessBtn)
            HXStrong_(businessLab)
            individualBtn.selected = true;
            businessBtn.selected = false;
            individualLab.textColor = commonVioletColor;
            businessLab.textColor = commonGrayBtnColor;
            [self reloadScrollview:individualBtn];
        }];
        
        [individualLab addSingleTapEvent:^{
            HXStrong_(individualBtn)
            HXStrong_(individualLab)
            HXStrong_(businessBtn)
            HXStrong_(businessLab)
            individualBtn.selected = true;
            businessBtn.selected = false;
            individualLab.textColor = commonVioletColor;
            businessLab.textColor = commonGrayBtnColor;
            [self reloadScrollview:individualBtn];
        }];
        

        [businessBtn addSingleTapEvent:^{
            HXStrong_(individualBtn)
            HXStrong_(individualLab)
            HXStrong_(businessBtn)
            HXStrong_(businessLab)
            individualBtn.selected = false;
            businessBtn.selected = true;
            individualLab.textColor = commonGrayBtnColor;
            businessLab.textColor = commonVioletColor;
            [self reloadScrollview:businessBtn];
        }];
        
        [businessLab addSingleTapEvent:^{
            HXStrong_(individualBtn)
            HXStrong_(individualLab)
            HXStrong_(businessBtn)
            HXStrong_(businessLab)
            individualBtn.selected = false;
            businessBtn.selected = true;
            individualLab.textColor = commonGrayBtnColor;
            businessLab.textColor = commonVioletColor;
            [self reloadScrollview:businessBtn];
        }];
        
        [_accountTypeCell setUPSpacing:0 andDownSpacing:0];
    }
    return _accountTypeCell;
    
}

-(void)reloadScrollview:(UIButton *)btn{

    if (btn.tag == 4001) {
        
        [self.scrollView removeAllSubViews];
        self.registerArr = @[self.whiteCell,self.accountTypeCell,self.userNameCell,self.registerEmailCell,self.registerPasswordCell,self.otherBtnsCell].mutableCopy;
        [self.scrollView setScrollviewSubViewsArr:self.registerArr];
        ((JWLabel *)self.otherBtnsCell.getElementByTag(1994)).hidden = true;
        
    }else if (btn.tag == 4002){
        
        [self.scrollView removeAllSubViews];
        self.registerArr = @[self.whiteCell,self.accountTypeCell,self.businessCell].mutableCopy;
        [self.scrollView setScrollviewSubViewsArr:self.registerArr];
        ((JWLabel *)self.otherBtnsCell.getElementByTag(1994)).hidden = true;
        
    }
    
}

-(JWScrollView *)scrollView{
    if (!_scrollView) {
        _scrollView = [[JWScrollView alloc]init];
        _scrollView.frame = CGRectMake(0, 51, kScreenWidth, kScreenHeight-51);
        _scrollView.alwaysBounceVertical = true;
        _scrollView.paddingHeight = 20;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

-(JWScrollviewCell *)errorCell{

    if (!_errorCell) {
        _errorCell = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
        JWLabel * warningLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, 0, kScreenWidth-40, 60)];
        warningLab.tag = 1991;
        warningLab.textAlignment = 0;
        warningLab.numberOfLines = 0;
        warningLab.font = kMediumFont(12);
        warningLab.textColor = commonErrorColor;
        [_errorCell.contentView addSubview:warningLab];
        [_errorCell setUPSpacing:0 andDownSpacing:0];
    }
    return _errorCell;
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    
    [self getAccountToken];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNotification];
    
    [self addBtnsView];
    
    self.emailCell = [self creatCell:Internationalization(@"邮箱", @"Email") describe:Internationalization(@"输入您的邮箱", @"type in your email here") isShowEye:false];
    self.passwordCell = [self creatCell:Internationalization(@"密码", @"Password") describe:Internationalization(@"输入您的密码", @"type in your password here") isShowEye:true];
    self.userNameCell = [self creatUserNameCell];
    
    self.registerEmailCell = [self creatCell:Internationalization(@"邮箱", @"Email") describe:Internationalization(@"输入您的邮箱", @"type in your email here") isShowEye:false];
    self.registerPasswordCell = [self creatCell:Internationalization(@"密码", @"Password") describe:Internationalization(@"输入您的密码", @"type in your password here") isShowEye:true];
    
    //登录界面view数据
    
    UIView * white1view =[[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth,adaptY(20))];
    
    self.loginArr = @[self.whiteCell,white1view,self.emailCell,self.passwordCell,self.otherBtnsCell].mutableCopy;
    //注册界面view数据
    self.registerArr = @[self.whiteCell,self.accountTypeCell,self.userNameCell,self.registerEmailCell,self.registerPasswordCell,self.otherBtnsCell].mutableCopy;
    //添加默认数据
    if (self.guide) {
        [self.scrollView setScrollviewSubViewsArr:self.registerArr];
    }else{
        [self.scrollView setScrollviewSubViewsArr:self.loginArr];
    }
    
    ((JWTextField *)self.emailCell.getElementByTag(2002)).keyboardType = UIKeyboardTypeEmailAddress;
    ((JWTextField *)self.passwordCell.getElementByTag(2002)).secureTextEntry = true;
    
    ((JWTextField *)self.registerEmailCell.getElementByTag(2002)).keyboardType = UIKeyboardTypeEmailAddress;
    ((JWTextField *)self.registerPasswordCell.getElementByTag(2002)).secureTextEntry = true;
    
//    [self getAccountToken];
    [self addfaceBookNotification];
}

-(void)addBtnsView{

    UIView * btnsView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 51)];
    btnsView.backgroundColor = [UIColor whiteColor];
    
    UIButton * leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    leftbutton.titleLabel.font = kMediumFont(16);
    [leftbutton setTitle:Internationalization(@"注册", @"Register") forState:UIControlStateNormal];

    leftbutton.frame = CGRectMake(0, 0, kScreenWidth/2, 50);
    leftbutton.selected = false;
    leftbutton.tag = 888;
    [leftbutton setTitleColor:commonGrayBtnColor forState:UIControlStateNormal];
    [leftbutton setTitleColor:commonBlackBtnColor forState:UIControlStateSelected];
    [btnsView addSubview:leftbutton];
    
    UIButton * rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    rightbutton.titleLabel.font = kMediumFont(16);
    [rightbutton setTitle:Internationalization(@"登录", @"Log In") forState:UIControlStateNormal];
    rightbutton.frame = CGRectMake( kScreenWidth/2, 0, kScreenWidth/2, 50);
    rightbutton.selected = true;
    self.selectBtn = rightbutton;
    [rightbutton setTitleColor:commonGrayBtnColor forState:UIControlStateNormal];
    [rightbutton setTitleColor:commonBlackBtnColor forState:UIControlStateSelected];
    rightbutton.tag = 999;
    
    JWLabel * leftLine = [[JWLabel alloc]initWithFrame:CGRectMake((leftbutton.width-leftbutton.width/1.5)/2, CGRectGetMaxY(leftbutton.frame), leftbutton.width/1.5, 1)];
    leftLine.backgroundColor = commonBlackBtnColor;
    leftLine.hidden = true;
    [btnsView addSubview:leftLine];
    CGRect leftFrame = leftLine.frame;
    
    JWLabel * rightLine = [[JWLabel alloc]initWithFrame:CGRectMake((rightbutton.width-rightbutton.width/1.5)/2 + CGRectGetMaxX(leftbutton.frame), CGRectGetMaxY(rightbutton.frame), rightbutton.width/1.5, 1)];
    rightLine.backgroundColor = commonBlackBtnColor;
    [btnsView addSubview:rightLine];
    CGRect rightFrame = rightLine.frame;

    if (self.guide) {
        leftbutton.selected = true;
        rightbutton.selected = false;
        self.selectBtn = leftbutton;
        [UIView animateWithDuration:0.3 animations:^{
            rightLine.frame = leftFrame;
        } completion:nil];
    }
    
    HXWeak_(rightbutton)
    HXWeak_(leftbutton)
    HXWeak_self
    [rightbutton addSingleTapEvent:^{
        HXStrong_(rightbutton)
        HXStrong_(leftbutton)
        HXStrong_self
        rightbutton.selected = true;
        leftbutton.selected = false;
        ((JWLabel *)self.otherBtnsCell.getElementByTag(1992)).text = Internationalization(@"登录", @"Log In");
        ((JWLabel *)self.otherBtnsCell.getElementByTag(1993)).text = @"Log In with faceBook";
        self.selectBtn = rightbutton;
        [self reloadUIdata:rightbutton];
        
        [UIView animateWithDuration:0.3 animations:^{
            rightLine.frame = rightFrame;
        } completion:nil];
        
    }];
    
    [leftbutton addSingleTapEvent:^{
        HXStrong_(rightbutton)
        HXStrong_(leftbutton)
        HXStrong_self
        rightbutton.selected = false;
        leftbutton.selected = true;
        ((JWLabel *)self.otherBtnsCell.getElementByTag(1992)).text = Internationalization(@"注册", @"Register");
        ((JWLabel *)self.otherBtnsCell.getElementByTag(1993)).text = @"Register with faceBook";
        self.selectBtn = leftbutton;
        [self reloadUIdata:leftbutton];
        
        [UIView animateWithDuration:0.3 animations:^{
            rightLine.frame = leftFrame;
        } completion:nil];
        
    }];
    
    [btnsView addSubview:rightbutton];
    
    [self.view addSubview:btnsView];
    
}

-(JWScrollviewCell *)creatCell:(NSString *)title describe:(NSString *)describe isShowEye:(BOOL)eye{
    
    JWScrollviewCell * cell = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 85)];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    JWLabel * tipLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, 10, 100, 30)];
    tipLab.textColor = commonBlackBtnColor;
    tipLab.text = title;
    tipLab.tag = 2001;
    tipLab.font = kMediumFont(15);
    [cell.contentView addSubview:tipLab];
    
    JWTextField  * textField = [[JWTextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(tipLab.frame), kScreenWidth-40, 30)];
    textField.tag = 2002;
//    NSAttributedString *str = [[NSAttributedString alloc] initWithString:describe attributes:@{NSFontAttributeName : kItalicFont(14), NSForegroundColorAttributeName : commonPlaceholderColor}];
//    textField.attributedPlaceholder = str;
    textField.font = kLightFont(15);
    [cell.contentView addSubview:textField];
    
    if (eye) {
        UIButton * eyesBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        eyesBtn.frame = CGRectMake(kScreenWidth-40-26, CGRectGetMaxY(textField.frame)-18-6, 26, 18);
        textField.width = kScreenWidth-40-26;
        [eyesBtn setBackgroundImage:[[UIImage imageNamed:@"隐藏-开"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateSelected];
        [eyesBtn setBackgroundImage:[[UIImage imageNamed:@"隐藏-关"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        HXWeak_(eyesBtn)
        [eyesBtn addSingleTapEvent:^{
            HXStrong_(eyesBtn)
            eyesBtn.selected = !eyesBtn.selected;
            textField.secureTextEntry = !textField.secureTextEntry;
        }];
        [cell.contentView addSubview:eyesBtn];
    }
    
    JWLabel * lineLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(textField.frame), kScreenWidth-40, 1)];
    lineLab.backgroundColor = commonGrayBtnColor;
    lineLab.tag = 2003;
    [cell.contentView addSubview:lineLab];
    [cell setUPSpacing:0 andDownSpacing:0];
    return cell;
}


-(JWScrollviewCell *)otherBtnsCell{

    if (!_otherBtnsCell) {
        
        HXWeak_self
        _otherBtnsCell = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 270)];
        _otherBtnsCell.backgroundColor = [UIColor whiteColor];
        
        JWLabel * forgotLab = [[JWLabel alloc]initWithFrame:CGRectMake(40, 0, kScreenWidth-80, 30)];
        forgotLab.textColor = commonGrayColor;
        forgotLab.text = @"Forgot password? Click here.";
        forgotLab.textAlignment = 1;
        forgotLab.font = kItalicFont(10);
        forgotLab.tag = 1994;
        NSRange contentRange = {forgotLab.text.length-11,11};
        [OtherTool addUnderlineLabel:forgotLab labText:@"Forgot password? Click here." range:contentRange];
        
        [forgotLab addSingleTapEvent:^{
            HXStrong_self
            ForgotPasswordViewController * forgotPasswordVC = [ForgotPasswordViewController new];
            forgotPasswordVC.skipStr = @"忘记密码";
            [self.navigationController pushViewController:forgotPasswordVC animated:true];
        }];
        [_otherBtnsCell.contentView addSubview:forgotLab];
        
        ShadowView * loginBtn = [[ShadowView alloc] initWithFrame:
                                 CGRectMake(20,CGRectGetMaxY(forgotLab.frame)+20,kScreenWidth-40,ShadowViewHeight)];
        loginBtn.colors =@[(id)UIColorFromRGB(0x9164db).CGColor, (id)UIColorFromRGB(0x46bbe3).CGColor];
        [loginBtn addSingleTapEvent:^{
            NSLog(@"login");
            [self VerificationLogin];
        }];
        [_otherBtnsCell.contentView addSubview:loginBtn];
        JWLabel * loginLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, loginBtn.y, loginBtn.width, loginBtn.height)];
        loginLab.text = Internationalization(@"登录", @"Log In");
        loginLab.textAlignment = 1;
        loginLab.textColor = [UIColor whiteColor];
        loginLab.tag = 1992;
        loginLab.font = kMediumFont(13);
        [_otherBtnsCell.contentView addSubview:loginLab];
        
        JWLabel * orlab = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(loginBtn.frame), kScreenWidth-40, 60)];
        orlab.textColor = commonGrayColor;
        orlab.text = @"or";
        orlab.font = kMediumFont(13);
        orlab.textAlignment = 1;
        
        [orlab addSingleTapEvent:^{
            NSLog(@"测试Facebook登录");
//            [self testFacebookLogin];
        }];
        
        [_otherBtnsCell.contentView addSubview:orlab];
        
        ShadowView * faceBookBtn = [[ShadowView alloc] initWithFrame:
                                    CGRectMake(20,CGRectGetMaxY(orlab.frame),kScreenWidth-40,ShadowViewHeight)];
        faceBookBtn.backgroundColor = [UIColor whiteColor];
        [faceBookBtn addSingleTapEvent:^{
//            NSLog(@"faceBookBtn");
            [self tapfaceBook];
            
        }];
        [_otherBtnsCell.contentView addSubview:faceBookBtn];
        
        JWLabel * faceBookLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, faceBookBtn.y, faceBookBtn.width, faceBookBtn.height)];
        faceBookLab.text = @"Log In with FaceBook";
        faceBookLab.textAlignment = 1;
        faceBookLab.font = kMediumFont(13);
        faceBookLab.textColor = UIColorFromRGB(0x7aadfd);
        [_otherBtnsCell.contentView addSubview:faceBookLab];
        faceBookLab.tag = 1993;
        faceBookLab.layer.borderWidth = 1;
        faceBookLab.layer.borderColor = [UIColorFromRGB(0x7aadfd) CGColor];
        
        [_otherBtnsCell setUPSpacing:0 andDownSpacing:0];
    }
    return _otherBtnsCell;
}

- (void)dealloc {
    [self clearNotificationAndGesture];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)reloadUIdata:(UIButton *)button{

    if (button.tag == 888) { //注册
        
        [self.scrollView removeAllSubViews];
        
        [self.scrollView setScrollviewSubViewsArr:self.registerArr];
        
        ((JWLabel *)self.otherBtnsCell.getElementByTag(1994)).hidden = true;
        
    }else if (button.tag == 999){ //登录
        
        [self.scrollView removeAllSubViews];
        
        [self.scrollView setScrollviewSubViewsArr:self.loginArr];
        
        ((JWLabel *)self.otherBtnsCell.getElementByTag(1994)).hidden = false;
    }
    
}

-(void)VerificationLogin{
    
    [self.view endEditing:true];
    
    if (self.selectBtn.tag ==888) {//注册
        
        if (((JWTextField *)self.registerEmailCell.getElementByTag(2002)).text.length && ((JWTextField *)self.registerPasswordCell.getElementByTag(2002)).text.length &&((JWTextField *)self.userNameCell.getElementByTag(2002)).text.length && ((JWTextField *)self.userNameCell.getElementByTag(2004)).text.length) {
            
            [self resettingColor];
            //邮箱是否合规
            if (![HelperUtil checkMailInput:((JWTextField *)self.registerEmailCell.getElementByTag(2002)).text]) {
                ((JWLabel *)self.errorCell.getElementByTag(1991)).text = @"Please enter the correct mailbox";
                ((JWLabel *)self.registerEmailCell.getElementByTag(2003)).backgroundColor = commonErrorColor;
                [self showErrorCell];
                return;
            }
            //密码是否合规
            if (![HelperUtil checkPassword:((JWTextField *)self.registerPasswordCell.getElementByTag(2002)).text]) {
                ((JWLabel *)self.errorCell.getElementByTag(1991)).text = @"Password should be 6-18 digit and letter combination";
                ((JWLabel *)self.registerPasswordCell.getElementByTag(2003)).backgroundColor = commonErrorColor;
                [self showErrorCell];
                return;
            }
            //验证邮箱
            [self requestCheckEmail];
            
            
        }else{
            
            [self showRegisterErrorMessage:Internationalization(@"请填写必填字段", @"Please fill in the required fields")];
            
        }
    }else if (self.selectBtn.tag == 999){ //登录
    
        if (((JWTextField *)self.emailCell.getElementByTag(2002)).text.length && ((JWTextField *)self.passwordCell.getElementByTag(2002)).text.length) {
            
            [self requestUserLogin];
            
        }else{
            [self verificationLogIn:false errorStr:Internationalization(@"请填写必填字段", @"Please fill in the required fields")];
        }
        
    }
}

-(void)showErrorCell{
    if (self.registerArr[2] == self.errorCell) {
        return;
    }
    [self.registerArr insertObject:self.errorCell atIndex:2];
    self.scrollView.allSubviwes = self.registerArr;
    [UIView animateWithDuration:0.2 animations:^{
        [self.scrollView reloadViews];
    } completion:^(BOOL finished) {
        
    }];
}

//验证注册
-(void)verificationRegister{

    
    
}

//验证登录
-(void)verificationLogIn:(BOOL)success errorStr:(NSString *)errorStr{
    
    if (success) {
        
    }else{
        ((JWLabel *)self.errorCell.getElementByTag(1991)).text = errorStr;
        ((JWLabel *)self.emailCell.getElementByTag(2003)).backgroundColor = ((JWTextField *)self.emailCell.getElementByTag(2002)).text.length ? commonGrayBtnColor : commonErrorColor;
        ((JWLabel *)self.passwordCell.getElementByTag(2003)).backgroundColor = ((JWTextField *)self.passwordCell.getElementByTag(2002)).text.length ? commonGrayBtnColor : commonErrorColor;
        
        if (self.loginArr[2] == self.errorCell) {
            return;
        }
        [self.loginArr insertObject:self.errorCell atIndex:2];
        self.scrollView.allSubviwes = self.loginArr;
        [UIView animateWithDuration:0.2 animations:^{
            [self.scrollView reloadViews];
        } completion:^(BOOL finished) {
            
        }];
    }
    
}

//登录
-(void)requestUserLogin{
    [self showHud];
    HXWeak_self
    [CommonService requestUserLoginOfaccess_token:self.defaultSetting.access_token email:((JWTextField *)self.emailCell.getElementByTag(2002)).text password:((JWTextField *)self.passwordCell.getElementByTag(2002)).text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HXStrong_self
        if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
            [self requestUserInfo];
        }else{
            [self verificationLogIn:false errorStr:[responseObject objectForKey:@"errorMessage"]];
        }
        [self closeHud];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HXStrong_self
        [self closeHud];
        [self errorDispose:[[operation response] statusCode] judgeMent:nil];
    }];
}

//获取用户信息
-(void)requestUserInfo{
    
    [self showHud];
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
            
            if ([self.skipStr isEqualToString:@"present"]) {
                [self dismissViewControllerAnimated:YES completion:nil];
            }else{
                //设置根控制器
                [self setRootViewController:[[MainTabBarViewController alloc] init]];
            }
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


-(void)getAccountToken{
    // 初始化用户信息
    [CommonService requestAccesstokensuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
            self.defaultSetting.uid = 0;
            self.defaultSetting.access_token = [responseObject objectForKey:@"data"];
            [DefaultSetting saveSetting:self.defaultSetting];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //            NSLog(@"%@",error);
        [self getAccountToken];
    }];
    
}


-(JWScrollviewCell *)creatUserNameCell{

    
    JWScrollviewCell * cell = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 90)];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    JWLabel * tipLab1 = [[JWLabel alloc]initWithFrame:CGRectMake(20, 10, 100, 30)];
    tipLab1.textColor = commonBlackBtnColor;
    tipLab1.text = @"First Name";
    tipLab1.tag = 2001;
    tipLab1.font = kMediumFont(15);
    [cell.contentView addSubview:tipLab1];
    
    JWTextField  * textField1 = [[JWTextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(tipLab1.frame), kScreenWidth-40, 30)];
    textField1.tag = 2002;
    textField1.font = kLightFont(15);
    [cell.contentView addSubview:textField1];
    
    
    JWLabel * tipLab2 = [[JWLabel alloc]initWithFrame:CGRectMake(kScreenWidth/2, 10, 100, 30)];
    tipLab2.textColor = commonBlackBtnColor;
    tipLab2.text = @"Last Name";
    tipLab2.tag = 2003;
    tipLab2.font = kMediumFont(15);
    [cell.contentView addSubview:tipLab2];
    
    JWTextField  * textField2 = [[JWTextField alloc]initWithFrame:CGRectMake(kScreenWidth/2, CGRectGetMaxY(tipLab1.frame), kScreenWidth-40, 30)];
    textField2.tag = 2004;
    textField2.font = kLightFont(15);
    [cell.contentView addSubview:textField2];
    
    JWLabel * lineLab1 = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(textField1.frame), kScreenWidth/2-40, 1)];
    lineLab1.backgroundColor = commonGrayBtnColor;
    lineLab1.tag = 2005;
    [cell.contentView addSubview:lineLab1];
    
    JWLabel * lineLab2 = [[JWLabel alloc]initWithFrame:CGRectMake(kScreenWidth/2, CGRectGetMaxY(textField1.frame), kScreenWidth/2-20, 1)];
    lineLab2.backgroundColor = commonGrayBtnColor;
    lineLab2.tag = 2006;
    [cell.contentView addSubview:lineLab2];
    
    [cell setUPSpacing:0 andDownSpacing:0];
    return cell;

}

-(void)tapfaceBook{

    //清除数据
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [FBSDKProfile setCurrentProfile:nil];
    if (self.selectBtn.tag == 888) {
        
    }else if (self.selectBtn.tag == 999){

    }
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    [login logOut];
    [login logInWithReadPermissions:@[@"public_profile",
                                      @"email"]
                 fromViewController:self
                            handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                //失败或者取消
                                if (error || result.isCancelled) {
                                    
                                }else{
                                    [self.faceBooklogInHUD showCustomHUDWithView:self.view];
                                }
                            }];
}


-(void)addfaceBookNotification{

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(accessTokenChanged:)
                                                 name:FBSDKAccessTokenDidChangeNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(currentProfileChanged:)
                                                 name:FBSDKProfileDidChangeNotification
                                               object:nil];
    
}

- (void)accessTokenChanged:(NSNotification *)notification
{
    FBSDKAccessToken *token = notification.userInfo[FBSDKAccessTokenChangeNewKey];
    
    if (token) {
        [self facebookLogin:[FBSDKAccessToken currentAccessToken] profile:[FBSDKProfile currentProfile]];
    }
}

- (void)currentProfileChanged:(NSNotification *)notification
{
    FBSDKProfile *profile = notification.userInfo[FBSDKProfileChangeNewKey];
    
    if (profile) {
        [self facebookLogin:[FBSDKAccessToken currentAccessToken] profile:[FBSDKProfile currentProfile]];
    }
    
}

-(void)requestCheckEmail{
    
    [self resettingColor];
    
    [self showHud];
    HXWeak_self
    [CommonService requestCheckEmailOfaccess_token:self.defaultSetting.access_token email:((JWTextField *)self.registerEmailCell.getElementByTag(2002)).text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HXStrong_self
        if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {

            [self publicPush:@"ForgotPasswordViewController" andTransmitObject:@{@"Email":((JWTextField *)self.registerEmailCell.getElementByTag(2002)).text,
                                                                                 @"Password":((JWTextField *)self.registerPasswordCell.getElementByTag(2002)).text,
                                                                                 @"firstname":((JWTextField *)self.userNameCell.getElementByTag(2002)).text
                                                                                 ,
                                                                                 @"lastname":((JWTextField *)self.userNameCell.getElementByTag(2004)).text
                                                                                 
                                                                                 } Animated:true];
            
        }else{
            [self showRegisterErrorMessage:[responseObject objectForKey:@"errorMessage"]];
        }
        [self closeHud];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HXStrong_self
        [self closeHud];
        [self errorDispose:[[operation response] statusCode] judgeMent:nil];
    }];
    
}


-(void)showRegisterErrorMessage:(NSString *)errorStr{

    ((JWLabel *)self.errorCell.getElementByTag(1991)).text = errorStr;
    
    ((JWLabel *)self.registerEmailCell.getElementByTag(2003)).backgroundColor = ((JWTextField *)self.registerEmailCell.getElementByTag(2002)).text.length ?commonGrayBtnColor:commonErrorColor;
    
    ((JWLabel *)self.userNameCell.getElementByTag(2005)).backgroundColor = ((JWTextField *)self.userNameCell.getElementByTag(2002)).text.length ?commonGrayBtnColor:commonErrorColor;
    
    ((JWLabel *)self.userNameCell.getElementByTag(2006)).backgroundColor = ((JWTextField *)self.userNameCell.getElementByTag(2004)).text.length ?commonGrayBtnColor:commonErrorColor;
    
    ((JWLabel *)self.registerPasswordCell.getElementByTag(2003)).backgroundColor = ((JWTextField *)self.registerPasswordCell.getElementByTag(2002)).text.length ?commonGrayBtnColor:commonErrorColor;
    
    
    
    if (self.registerArr[2] == self.errorCell) {
        return;
    }
    [self.registerArr insertObject:self.errorCell atIndex:2];
    self.scrollView.allSubviwes = self.registerArr;
    [UIView animateWithDuration:0.2 animations:^{
        [self.scrollView reloadViews];
    } completion:^(BOOL finished) {
        
    }];
    
}

//facebook注册或者登陆调用
-(void)facebookLogin:(FBSDKAccessToken *)token profile:(FBSDKProfile *)profile{

    FBSDKAccessToken * fbAccess_token = token;
    
    FBSDKProfile * fbProfile = profile;
    
    if (fbAccess_token && fbProfile){

        //调用接口判断是否需要完善信息
        HXWeak_self
        [CommonService requestFacebookLoginOfaccess_token:self.defaultSetting.access_token firstName:fbProfile.firstName lastName:fbProfile.lastName password:fbAccess_token.userID facebookId:fbAccess_token.userID userType:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
            HXStrong_self
            if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
                
                [self faceBookRequestUserInfo];
                
            }else{
                [self showRegisterErrorMessage:[responseObject objectForKey:@"errorMessage"]];
            }
            [self.faceBooklogInHUD hideCustomHUD];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            HXStrong_self
            [self.faceBooklogInHUD hideCustomHUD];
            [self errorDispose:[[operation response] statusCode] judgeMent:nil];
        }];
    }
}

//获取用户信息
-(void)faceBookRequestUserInfo{
    
    [self showHud];
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
            
            if ([user.level isEqualToString:@"0"]) {
                [self.navigationController pushViewController:[FaceBookLogInViewController new] animated:true];
            }else{
                if ([self.skipStr isEqualToString:@"present"]) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }else{
                    //设置根控制器
                    [self setRootViewController:[[MainTabBarViewController alloc] init]];
                }
            }
            
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

//facebook注册或者登陆调用
-(void)testFacebookLogin{
    
    long num = (arc4random() % 10000000000);
    NSString * randomNumber = [NSString stringWithFormat:@"%.10ld", num];
//    NSLog(@"%@", randomNumber);
//    NSLog(@"first%@",[self shuffledAlphabet]);
//    NSLog(@"last%@",[self shuffledAlphabet]);
    NSString * firstName = [NSString stringWithFormat:@"first%@",[self shuffledAlphabet]];
    NSString * lastName = [NSString stringWithFormat:@"last%@",[self shuffledAlphabet]];
        HXWeak_self
    [CommonService requestFacebookLoginOfaccess_token:self.defaultSetting.access_token firstName:firstName lastName:lastName password:randomNumber facebookId:randomNumber userType:1 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HXStrong_self
        if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
            
            [self faceBookRequestUserInfo];
            
        }else{
            [self showRegisterErrorMessage:[responseObject objectForKey:@"errorMessage"]];
        }
        [self.faceBooklogInHUD hideCustomHUD];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HXStrong_self
        [self.faceBooklogInHUD hideCustomHUD];
        [self errorDispose:[[operation response] statusCode] judgeMent:nil];
    }];
    
}

- (NSString *)shuffledAlphabet {
    NSString *alphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    // Get the characters into a C array for efficient shuffling
    NSUInteger numberOfCharacters = [alphabet length];
    unichar *characters = calloc(numberOfCharacters, sizeof(unichar));
    [alphabet getCharacters:characters range:NSMakeRange(0, numberOfCharacters)];
    
    // Perform a Fisher-Yates shuffle
    for (NSUInteger i = 0; i < numberOfCharacters; ++i) {
        NSUInteger j = (arc4random_uniform(numberOfCharacters - i) + i);
        unichar c = characters[i];
        characters[i] = characters[j];
        characters[j] = c;
    }
    
    // Turn the result back into a string
    NSString *result = [NSString stringWithCharacters:characters length:numberOfCharacters];
    free(characters);
    
    //截取前5位
    NSString * str3 = [result substringWithRange:NSMakeRange(0, 5)];
    
    return str3;
    
}

//appstore下载
-(void)skipAppStoreDownload{

    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://itunes.apple.com/cn/app/shan-shan-pen-di-fu-nu-jian/id1177924186?mt=8"]];
    
}
//重置颜色
-(void)resettingColor{
    
    ((JWLabel *)self.registerEmailCell.getElementByTag(2003)).backgroundColor = ((JWTextField *)self.registerEmailCell.getElementByTag(2002)).text.length ?commonGrayBtnColor:commonErrorColor;
    
    ((JWLabel *)self.userNameCell.getElementByTag(2005)).backgroundColor = ((JWTextField *)self.userNameCell.getElementByTag(2002)).text.length ?commonGrayBtnColor:commonErrorColor;
    
    ((JWLabel *)self.userNameCell.getElementByTag(2006)).backgroundColor = ((JWTextField *)self.userNameCell.getElementByTag(2004)).text.length ?commonGrayBtnColor:commonErrorColor;
    
    ((JWLabel *)self.registerPasswordCell.getElementByTag(2003)).backgroundColor = ((JWTextField *)self.registerPasswordCell.getElementByTag(2002)).text.length ?commonGrayBtnColor:commonErrorColor;
    

    if (self.registerArr[2] == self.errorCell) {
        
        [self.registerArr removeObjectAtIndex:2];
        self.scrollView.allSubviwes = self.registerArr;
        [UIView animateWithDuration:0.2 animations:^{
            [self.scrollView reloadViews];
        } completion:^(BOOL finished) {
            
        }];
        
    }


}

@end
