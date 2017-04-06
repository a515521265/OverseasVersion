//
//  FaceBookLogInViewController.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/3/5.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "FaceBookLogInViewController.h"

#import "ShadowView.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "HelperUtil.h"

#import "LoginViewController.h"

@interface FaceBookLogInViewController ()

@property (nonatomic,strong) JWScrollView * scrollView;

@property (nonatomic,strong) JWScrollviewCell * registerEmailCell;
@property (nonatomic,strong) JWScrollviewCell * registerPasswordCell;
@property (nonatomic,strong) JWScrollviewCell * nextCell;
@property (nonatomic,strong) JWScrollviewCell * errorCell;

@property (nonatomic,strong) NSMutableArray * registerArr;

@end

@implementation FaceBookLogInViewController

-(NSMutableArray *)registerArr{

    if (!_registerArr) {
        _registerArr = [NSMutableArray arrayWithCapacity:10];
    }
    return _registerArr;
    
}

-(JWScrollView *)scrollView{
    
    if (!_scrollView) {
        _scrollView = [[JWScrollView alloc]init];
        _scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addNotification];
    
    [self createTitleBarButtonItemStyle:BtnLeftType title:@"" TapEvent:^{
        
    }];
    
    JWLabel * tipLab = [[JWLabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 50)];
    tipLab.text = @"Perfect information";
    tipLab.textColor = commonBlackBtnColor;
    tipLab.textAlignment = 1;
    tipLab.font = kMediumFont(20);
    
    self.registerEmailCell = [self creatCell:Internationalization(@"邮箱", @"Email") describe:Internationalization(@"输入您的邮箱", @"type in your email here") isShowEye:false];
    
    self.registerPasswordCell = [self creatCell:Internationalization(@"密码", @"Password") describe:Internationalization(@"输入您的密码", @"type in your password here") isShowEye:true];
    
    ((JWTextField *)self.registerEmailCell.getElementByTag(2002)).keyboardType = UIKeyboardTypeEmailAddress;
    
    ((JWTextField *)self.registerPasswordCell.getElementByTag(2002)).secureTextEntry = true;
    
    self.registerArr = @[tipLab,self.registerEmailCell,self.registerPasswordCell,self.nextCell].mutableCopy;
    
    [self.scrollView setScrollviewSubViewsArr:self.registerArr];

    
    JWLabel * logOutLab = [[JWLabel alloc]initWithFrame:CGRectMake(0, kScreenHeight-50-64, kScreenWidth, 30)];
    logOutLab.text = @"Logout";
    logOutLab.textAlignment = 1;
    logOutLab.textColor = commonGrayBtnColor;
    HXWeak_self
    [logOutLab addSingleTapEvent:^{
        HXStrong_self
        NSLog(@"logout");
        if (self.presentingViewController) {
            [self dismissViewControllerAnimated:YES completion:nil];
            
            self.defaultSetting.uid = 0;
            self.defaultSetting.mobile = @"";
            self.defaultSetting.isTouchID = false;
            [DefaultSetting saveSetting:self.defaultSetting];
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                LoginViewController *loginVC =[LoginViewController new];
                loginVC.skipStr = @"present";
                MainNavController *navi =[[MainNavController alloc] initWithRootViewController:loginVC];
                [commonAppDelegate.singleton.mainTabBarVC presentViewController:navi animated:YES completion:nil];
                commonAppDelegate.singleton.isAccount = true;
            });
        } else {
            [self.navigationController popViewControllerAnimated:YES];
        }
    }];
    [self.view addSubview:logOutLab];
    
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

-(JWScrollviewCell *)nextCell{

    if (!_nextCell) {
        _nextCell = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, adaptY(100))];
        
        
        
        ShadowView * nextBtn = [[ShadowView alloc] initWithFrame:
                                  CGRectMake(20,(_nextCell.height -ShadowViewHeight)/2,kScreenWidth-40,ShadowViewHeight)];
        nextBtn.colors =commonColorS;
        HXWeak_self
        [nextBtn addSingleTapEvent:^{
            HXStrong_self
            [self faceBookRegister];
        }];
        [_nextCell.contentView addSubview:nextBtn];
        
        JWLabel * nextLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, nextBtn.y, nextBtn.width, nextBtn.height)];
        nextLab.text = Internationalization(@"下一步", @"Next");
        nextLab.textAlignment = 1;
        nextLab.textColor = [UIColor whiteColor];
        [_nextCell.contentView addSubview:nextLab];
        
        [_nextCell setUPSpacing:0 andDownSpacing:0];
        
    }
    return _nextCell;
}

-(void)faceBookRegister{

    if (((JWTextField *)self.registerEmailCell.getElementByTag(2002)).text.length && ((JWTextField *)self.registerPasswordCell.getElementByTag(2002)).text.length) {

        
        [self resettingColor];
        //邮箱是否合规
        if (![HelperUtil checkMailInput:((JWTextField *)self.registerEmailCell.getElementByTag(2002)).text]) {

            [self showRegisterErrorMessage: @"Please enter the correct mailbox"];
            ((JWLabel *)self.registerEmailCell.getElementByTag(2003)).backgroundColor = commonErrorColor;
            
            return;
        }
        //密码是否合规
        if (![HelperUtil checkPassword:((JWTextField *)self.registerPasswordCell.getElementByTag(2002)).text]) {
            
            [self showRegisterErrorMessage: @"Password should be 6-18 digit and letter combination"];
            ((JWLabel *)self.registerPasswordCell.getElementByTag(2003)).backgroundColor = commonErrorColor;
            
            
            return;
        }
        //验证邮箱
        [self requestCheckEmail];
        
        
    }else{
        [self showRegisterErrorMessage:Internationalization(@"请填写必填字段", @"Please fill in the required fields")];
    }
        
}


-(void)requestCheckEmail{
    
    [self showHud];
    HXWeak_self
    [CommonService requestCheckEmailOfaccess_token:self.defaultSetting.access_token email:((JWTextField *)self.registerEmailCell.getElementByTag(2002)).text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HXStrong_self
        if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
            
            
            [self clearErrormessage];
            
            [self publicPush:@"FaceBookVerificationMobileViewController" andTransmitObject:@{@"Email":((JWTextField *)self.registerEmailCell.getElementByTag(2002)).text,
                                                                                             @"Password":((JWTextField *)self.registerPasswordCell.getElementByTag(2002)).text
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
    ((JWLabel *)self.registerEmailCell.getElementByTag(2003)).backgroundColor = ((JWTextField *)self.registerEmailCell.getElementByTag(2002)).text.length ? commonGrayBtnColor : commonErrorColor;
    ((JWLabel *)self.registerPasswordCell.getElementByTag(2003)).backgroundColor = ((JWTextField *)self.registerPasswordCell.getElementByTag(2002)).text.length ? commonGrayBtnColor : commonErrorColor;
    
    if (self.registerArr[1] == self.errorCell) {
        return;
    }
    [self.registerArr insertObject:self.errorCell atIndex:1];
    self.scrollView.allSubviwes = self.registerArr;
    [UIView animateWithDuration:0.2 animations:^{
        [self.scrollView reloadViews];
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)resettingColor{

    ((JWLabel *)self.registerEmailCell.getElementByTag(2003)).backgroundColor =
    ((JWLabel *)self.registerPasswordCell.getElementByTag(2003)).backgroundColor = commonGrayBtnColor;
    
}

-(void)clearErrormessage{

    if (self.registerArr[1] == self.errorCell) {
        [self.registerArr removeObjectAtIndex:1];
        self.scrollView.allSubviwes = self.registerArr;
        [UIView animateWithDuration:0.2 animations:^{
            [self.scrollView reloadViews];
        } completion:^(BOOL finished) {
            
        }];
    }

    
}





@end
