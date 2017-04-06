//
//  AccountViewController.m
//  OverseasVersion
//
//  Created by 梁家文 on 17/2/6.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "AccountViewController.h"
#import "ShadowView.h"

#import "JPUSHService.h"

#import "ReceiptViewController.h"

#import "LoginViewController.h"
#import "MainNavController.h"
#import "VerificationCodeViewController.h"

//联系我们
#import "ContactUsViewController.h"
//关于我们
#import "AboutUsViewController.h"
#import "FAQViewController.h"


#import "SettingTouchIDViewController.h"
#import "SettingSecurityCodeViewController.h"
#import "CredentialsInfoViewController.h"

#import "HXSelectPicture.h"

#import "UIImage+QRImage.h"


#import <FBSDKCoreKit/FBSDKCoreKit.h>
//头像
#import "UIImageView+WebCache.h"

#import "ShowAlertViewController.h"

@interface AccountViewController ()<LGAlertViewDelegate>

@property (nonatomic,strong) JWScrollView * scrollView;

@property (nonatomic,strong) JWScrollviewCell * headCell; //头像

@property (nonatomic,strong) JWScrollviewCell * accountCell; //账户

@property (nonatomic,strong) JWScrollviewCell * levelItem;

@end

@implementation AccountViewController

-(JWScrollView *)scrollView{
    
    if (!_scrollView) {
        _scrollView = [[JWScrollView alloc]init];
        _scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-50);
        _scrollView.alwaysBounceVertical = true;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    HXWeak_self
    //账户信息
    [self getAccountInfosuccess:^(AccountInfo *accountInfo) {
        HXStrong_self
        ((JWLabel *)self.accountCell.getElementByTag(1991)).text =
        [NSString stringWithFormat:@"%@",[NSString formatSpecialMoneyString:accountInfo.availableAmount.doubleValue]];
        ((JWLabel *)self.accountCell.getElementByTag(1992)).text = accountInfo.availablePoints;
    } showHud:false];
    
    
    [self getUserInfosuccess:^(UserInfoModel *userInfo) {
        
        [((UIImageView *)self.accountCell.getElementByTag(1990)) sd_setImageWithURL:[NSURL URLWithString:userInfo.headPic] placeholderImage:[UIImage imageNamed:@"UserDefaultIcon.jpg"]];
        commonAppDelegate.userConfiguration.userIcon = ((UIImageView *)self.accountCell.getElementByTag(1990)).image;
        
        ((JWLabel *)self.levelItem.getElementByTag(1994)).text =
        [NSString stringWithFormat:@"LEVEL %@",userInfo.level];
        
    } showHud:false];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    UIImageView * backgroundImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 130)];
    backgroundImageView.image = [UIImage imageNamed:@"我的-图片"];
    [self.view addSubview:backgroundImageView];
    
    [self facebooksupplementaryInfo];
    
    HXWeak_self;
    //登录密码
    JWScrollviewCell * item1 = [self creatOtheritemwithTitle:Internationalization(@"重置密码", @"Reset password") subTitle:@""];
    item1.isGestureEnabled = true;
    item1.click = ^(){
        HXStrong_self
        [self getUserInfosuccess:^(UserInfoModel *userInfo) {
            VerificationCodeViewController * verificationCodeVC = [VerificationCodeViewController new];
            verificationCodeVC.skipStr = @"账户修改密码";
            verificationCodeVC.transmitObject = @{@"phone":userInfo.mobile,
                                                  @"area_code":userInfo.areaCode};
            verificationCodeVC.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:verificationCodeVC animated:true];
        } showHud:true];
    };
    
    JWScrollviewCell * item2 = [self creatOtheritemwithTitle:Internationalization(@"重置支付密码", @"Reset payment password") subTitle:@""];
    item2.isGestureEnabled = true;
    item2.click = ^(){
        HXStrong_self
        [self getUserInfosuccess:^(UserInfoModel *userInfo) {
            VerificationCodeViewController * verificationCodeVC = [VerificationCodeViewController new];
            verificationCodeVC.skipStr = @"账户修改交易密码";
            verificationCodeVC.transmitObject = @{@"phone":userInfo.mobile,
                                                  @"area_code":userInfo.areaCode};
            verificationCodeVC.hidesBottomBarWhenPushed = true;
            [self.navigationController pushViewController:verificationCodeVC animated:true];
        } showHud:true];
    };
    
    JWScrollviewCell * item3 = [self creatOtheritemwithTitle:Internationalization(@"联系我们", @"Chat With Us") subTitle:@""];
    item3.isGestureEnabled = true;
    item3.click = ^(){
        HXStrong_self
        ContactUsViewController * contactUsVC = [ContactUsViewController new];
        contactUsVC.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:contactUsVC animated:true];
    };
    
    self.levelItem = [self creatOtheritemwithTitle:Internationalization(@"帐户认证和限制", @"Account Certifications and Limits") subTitle:@"LEVEL 0"];
    self.levelItem.isGestureEnabled = true;
    self.levelItem.click = ^(){
        HXStrong_self
        CredentialsInfoViewController * credentialsInfoVC = [CredentialsInfoViewController new];
        credentialsInfoVC.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:credentialsInfoVC animated:true];
    };
    
    JWScrollviewCell * item5 = [self creatOtheritemwithTitle:Internationalization(@"常见问题", @"Frequently Asked Questions") subTitle:@""];
    item5.isGestureEnabled = true;
    item5.click = ^(){
        HXStrong_self
        FAQViewController * faqVC = [FAQViewController new];
        faqVC.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:faqVC animated:true];
    };
    
    JWScrollviewCell * item6 = [self creatOtheritemwithTitle:Internationalization(@"关于我们", @"About PICA") subTitle:@""];
    item6.isGestureEnabled = true;
    item6.click = ^(){
        HXStrong_self
        AboutUsViewController * aboutUsVC = [AboutUsViewController new];
        aboutUsVC.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:aboutUsVC animated:true];
    };
    
    JWScrollviewCell * item7 = [self creatOtheritemwithTitle:Internationalization(@"退出",@"Exit") subTitle:@""];
    item7.isGestureEnabled = true;
    item7.click = ^(){
        HXStrong_self
        LGAlertView *  alertView = [[LGAlertView alloc] initWithTitle:nil
                                                   message:@"Are you sure you want to quit?"
                                                     style:LGAlertViewStyleActionSheet
                                              buttonTitles:@[@"OK"]
                                         cancelButtonTitle:@"Cancel"
                                    destructiveButtonTitle:nil
                                                  delegate:self];
        alertView.buttonsTextAlignment = NSTextAlignmentCenter;
        alertView.buttonsBackgroundColorHighlighted  = commonGrayBtnColor;
        alertView.cancelButtonBackgroundColorHighlighted = commonGrayBtnColor;
        alertView.buttonsTitleColorHighlighted =
        alertView.cancelButtonTitleColorHighlighted = alertView.cancelButtonTitleColor;
        alertView.tag = 9988;
        [alertView showAnimated:YES completionHandler:nil];
        
    };
    [self.scrollView setScrollviewSubViewsArr:@[self.heardCell,self.accountCell,item1,item2,item3,self.levelItem,item5,item6,item7].mutableCopy];
}

-(JWScrollviewCell *)heardCell{

    if (!_headCell) {
        _headCell = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 130)];
        _headCell.backgroundColor =
        _headCell.contentView.backgroundColor = [UIColor clearColor];
        
        HXWeak_self
        UIView * clearView = [[UIView alloc]initWithFrame:CGRectMake((kScreenWidth-adaptX(70))/2, _headCell.contentView.height-adaptX(50), adaptX(70), adaptX(50))];
        [clearView addSingleTapEvent:^{
            HXStrong_self
            [self replaceUserIcon];
        }];
        [clearView addlongTapEvent:^{
             [self showUsericon];
        }];
        [_headCell.contentView addSubview:clearView];
        
        [_headCell setUPSpacing:0 andDownSpacing:0];
    }
    return _headCell;
}

-(JWScrollviewCell *)accountCell{

    if (!_accountCell) {
        _accountCell = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 110)];
        _accountCell.backgroundColor =
        _accountCell.contentView.backgroundColor = [UIColor whiteColor];
        
        
        UIImageView * userIconiamgeV = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-adaptX(70))/2,adaptX(-50),adaptX(70) , adaptX(70) )];
        userIconiamgeV.layer.cornerRadius =userIconiamgeV.width/2;
        userIconiamgeV.layer.masksToBounds =true;
        commonAppDelegate.userConfiguration.userIcon =
        userIconiamgeV.image = [UIImage imageNamed:@"UserDefaultIcon.jpg"];
        userIconiamgeV.backgroundColor = [UIColor whiteColor];
        userIconiamgeV.layer.borderWidth = 2;
        userIconiamgeV.layer.borderColor = [UIColor whiteColor].CGColor;
        HXWeak_self
        [userIconiamgeV addSingleTapEvent:^{
            HXStrong_self
            [self replaceUserIcon];
        }];
        
        [userIconiamgeV addlongTapEvent:^{
            [self showUsericon];
        }];
        
        userIconiamgeV.tag = 1990;
        [_accountCell.contentView addSubview:userIconiamgeV];
        [userIconiamgeV makeDraggable];
        
        
        CGFloat width1 = kScreenWidth/2;
    
        JWLabel * balance = [[JWLabel alloc]initWithFrame:CGRectMake(20, adaptY(10), width1/1.5,adaptY(30) )];
        balance.textAlignment = 1;
        balance.text = Internationalization(@"收支",@"Balance");
        balance.textColor = commonVioletColor;
        balance.font = kMediumFont(12);
        [_accountCell.contentView addSubview:balance];
        
        JWLabel * reward = [[JWLabel alloc]initWithFrame:CGRectMake(kScreenWidth-20 -width1/1.5, adaptY(10), width1/1.5, adaptY(30))];
        reward.textAlignment = 1;
        reward.text = Internationalization(@"积分", @"Reward Points");
        reward.textColor = commonGreenColor;
        reward.font = kMediumFont(12);
        [_accountCell.contentView addSubview:reward];
        
        JWLabel * leftLine = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(balance.frame), width1/1.5, 1)];
        leftLine.backgroundColor = balance.textColor;
        [_accountCell.contentView addSubview:leftLine];
        
        JWLabel * rightLine = [[JWLabel alloc]initWithFrame:CGRectMake(kScreenWidth-20 -width1/1.5 , CGRectGetMaxY(reward.frame), width1/1.5, 1)];
        rightLine.backgroundColor = reward.textColor;
        
        [_accountCell.contentView addSubview:rightLine];
        
        JWLabel * moneyLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(leftLine.frame), width1/1.5, adaptY(30))];
        moneyLab.font = kMediumFont(17);
        moneyLab.textColor = commonVioletColor;
        moneyLab.labelAnotherFont = kMediumFont(12);
        moneyLab.text = @"₱0.00";
        moneyLab.tag = 1991;
        moneyLab.textAlignment = 1;
        [_accountCell.contentView addSubview:moneyLab];
                
        JWLabel * integralLab = [[JWLabel alloc]initWithFrame:CGRectMake(kScreenWidth-20 -width1/1.5, CGRectGetMaxY(rightLine.frame), width1/1.5, adaptY(30))];
        integralLab.font = kMediumFont(17);
        integralLab.textAlignment= 1;
        integralLab.labelAnotherFont = kMediumFont(12);
        integralLab.textColor = commonGreenColor;
        integralLab.text = @"0.00";
        integralLab.tag = 1992;
        [_accountCell.contentView addSubview:integralLab];
        
        
        _accountCell.contentView.height = CGRectGetMaxY(_accountCell.contentView.subviews.lastObject.frame);
        
        [_accountCell setUPSpacing:0 andDownSpacing:0];
    }
    return _accountCell;
}

-(JWScrollviewCell *)creatOtheritemwithTitle:(NSString *)title{
    
    JWScrollviewCell * item = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 52)];
    JWLabel * titleLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, 10, kScreenWidth-60, 40)];
    titleLab.text = title;
    [item addSubview:titleLab];
    
    
    UIImageView * rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-13-20, CGRectGetMidY(titleLab.frame)-17/2, 13, 17)];
    rightImageView.image = [UIImage imageNamed:@"箭头"];
    
    [item addSubview:rightImageView];
    
    if ([title isEqualToString:Internationalization(@"退出",@"Exit")]) {
        titleLab.textAlignment = 1;
        [rightImageView removeFromSuperview];
    }
    
    JWLabel * lineL = [JWLabel addLineLabel:CGRectMake(20, CGRectGetMaxY(titleLab.frame), kScreenWidth-40, 1)];
    [item addSubview:lineL];
    
    [item setUPSpacing:0 andDownSpacing:0];
    
    return item;
}



-(JWScrollviewCell *)creatOtheritemwithTitle:(NSString *)title subTitle:(NSString *)subtitle{

    JWScrollviewCell * item = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 20)];
    item.tapAnimation = true;
    item.tintColor = [UIColor colorWithRed:217/255 green:217/255 blue:217/255 alpha:0.2];;
    JWLabel * titleLab = [[JWLabel alloc]initWithFrame:CGRectMake(20,adaptY(15), kScreenWidth-60, adaptY(20))];
    titleLab.text = title;
    titleLab.font = kMediumFont(11);
    titleLab.textColor = commonBlackBtnColor;
    [item.contentView addSubview:titleLab];
    
    UIImageView * rightImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-adaptY(7)-20, CGRectGetMidY(titleLab.frame)-adaptY(9)/2 -adaptY(2), adaptY(7), adaptY(9))];
    rightImageView.image = [UIImage imageNamed:@"箭头"];
    [item.contentView addSubview:rightImageView];
    
    JWLabel * subTitleLab = [[JWLabel alloc]initWithFrame:CGRectMake(CGRectGetMinX(rightImageView.frame)-adaptX(70)-5, titleLab.y,adaptX(70),adaptY(15))];
    subTitleLab.text = subtitle;
    subTitleLab.font = kLightFont(7);
    subTitleLab.textAlignment = 1;
    subTitleLab.layer.borderWidth = 1;
    subTitleLab.layer.borderColor = UIColorFromRGB(0x30aa17).CGColor;
    subTitleLab.layer.cornerRadius =3;
    subTitleLab.layer.masksToBounds =true;
    subTitleLab.textColor = UIColorFromRGB(0x30aa17);
    subTitleLab.tag = 1994;
    if (subtitle.length) {
        [item.contentView addSubview:subTitleLab];
    }

    if ([title isEqualToString:Internationalization(@"退出",@"Exit")]) {
        titleLab.textAlignment = 1;
        [rightImageView removeFromSuperview];
    }
    
    JWLabel * lineL = [JWLabel addLineLabel:CGRectMake(20, CGRectGetMaxY(titleLab.frame), kScreenWidth-40, 1)];
    lineL.backgroundColor = UIColorFromRGB(0xe4e4e4);
    [item.contentView addSubview:lineL];
    
    item.contentView.height = CGRectGetMaxY(item.contentView.subviews.lastObject.frame);
    
    [item setUPSpacing:0 andDownSpacing:0];
    
    return item;
}



-(void)userExit{

    self.defaultSetting.uid = 0;
    self.defaultSetting.mobile = @"";
    self.defaultSetting.isTouchID = false;
    //FacebooklogOut
    [FBSDKAccessToken setCurrentAccessToken:nil];
    [FBSDKProfile setCurrentProfile:nil];
    
    HXWeak_self
    [CommonService requestAccesstokensuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        HXStrong_self
        if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
            self.defaultSetting.access_token = [responseObject objectForKey:@"data"];
        }
        [DefaultSetting saveSetting:self.defaultSetting];
        [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
        
        [self modalLogin];
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HXStrong_self
        [DefaultSetting saveSetting:self.defaultSetting];
        [JPUSHService setAlias:@"" callbackSelector:nil object:nil];
        [self modalLogin];
    }];
}


-(void)modalLogin{
    
    
//    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me"
//                                       parameters:nil
//                                       HTTPMethod:@"DELETE"]
//     startWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
//         // ...
//     }];
    
    LoginViewController *loginVC =[LoginViewController new];
    loginVC.skipStr = @"present";
    MainNavController *navi =[[MainNavController alloc] initWithRootViewController:loginVC];
    [self presentViewController:navi animated:YES completion:nil];
    
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"ProtectPassword"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    commonAppDelegate.singleton.isAccount = true;
    commonAppDelegate.singleton.mainTabBarVC = self.tabBarController;
}

//上传图片
-(void)replaceUserIcon{
    
    HXWeak_self
    [HXSelectPicture showImagePickerFromViewController:self allowsEditing:YES finishAction:^(UIImage *image) {
        HXStrong_self
        
        if (image) {
            
            UIImage * newImage  = [UIImage selectAndUniformScaleImageOfImage:image];
            NSData *selectImageData = UIImageJPEGRepresentation(newImage, 0.5);
            [self showHud];
            [CommonService uploadImgWithconstructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
                
                [formData appendPartWithFileData:selectImageData name:@"image" fileName:@"picFront.jpg" mimeType:@"image/jpeg"];

            } access_token:self.defaultSetting.access_token success:^(AFHTTPRequestOperation *operation, id responseObject) {
                
                if ([[responseObject objectForKey:@"errorCode"] integerValue] ==0) {
                NSString * userIconString = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"data"]];
                [self setuserIconwithStr:userIconString userIcon:image];
                }else{
                    [self showTip:[responseObject objectForKey:@"errorMessage"]];
                }
                [self closeHud];
            } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                [self closeHud];
                [self errorDispose:[[operation response] statusCode] judgeMent:nil];
                
            }];
        }
    }];
}

//设置头像接口
-(void)setuserIconwithStr:(NSString *)iconStr userIcon:(UIImage*)userIcon{

    customHUD * hud = [[customHUD alloc]init];
    [hud showCustomHUDWithView:self.view];
    [CommonService requestUPloadHeadPicOfaccess_token:self.defaultSetting.access_token picUrl:iconStr success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"errorCode"] integerValue] ==0) {
            commonAppDelegate.userConfiguration.userIcon = ((UIImageView *)self.accountCell.getElementByTag(1990)).image = userIcon;
        }else{
            [self showTip:[responseObject objectForKey:@"errorMessage"]];
        }
        [hud hideCustomHUD];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hideCustomHUD];
        [self errorDispose:[[operation response] statusCode] judgeMent:nil];
    }];

}

-(void)showUsericon{

    ShowAlertViewController * aletrVC = [[ShowAlertViewController alloc] init];
    aletrVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    aletrVC.modalPresentationStyle = UIModalPresentationCustom;
    aletrVC.showImageView = ((UIImageView *)self.accountCell.getElementByTag(1990));
    [self presentViewController:aletrVC animated:YES completion:nil];
    
}


- (void)alertView:(LGAlertView *)alertView buttonPressedWithTitle:(NSString *)title index:(NSUInteger)index {
    
    if (alertView.tag == 9988 && [title isEqualToString:@"OK"]) {
        
        [self userExit];
        
    }
    
}


@end
