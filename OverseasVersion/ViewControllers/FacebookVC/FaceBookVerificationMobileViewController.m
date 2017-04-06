//
//  FaceBookVerificationMobileViewController.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/3/5.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "FaceBookVerificationMobileViewController.h"

#import "ShadowView.h"

#import "FaceBookVerificationCodeViewController.h"
#import "SpinnerView.h"
#import "QuestionModel.h"

@interface FaceBookVerificationMobileViewController ()

@property (nonatomic,strong) JWScrollviewCell * userNameCell;

@property (nonatomic,strong) NSMutableArray * areaList;



@end

@implementation FaceBookVerificationMobileViewController

-(NSMutableArray *)areaList{
    if (!_areaList) {
        _areaList = @[@"+63",@"+86"].mutableCopy;
    }
    return _areaList;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self userNameCell];
    
//    [self getArea_code];
    
}

-(JWScrollviewCell *)userNameCell{
    
    if (!_userNameCell) {
        _userNameCell = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/2)];
        
        JWLabel * messlab = [[JWLabel alloc]initWithFrame:CGRectMake(30, 64, kScreenWidth-60, 30)];
        messlab.numberOfLines = 0;
        NSString *message = Internationalization(@"输入您的手机号码接收确认码", @"Enter your cellphone number to receive confirmation code");
        messlab.text = message;
        messlab.font = kMediumFont(15);
        messlab.textColor = commonBlackBtnColor;
        CGSize tipLabelsize = [message boundingRectWithSize:CGSizeMake((kScreenWidth - 60), 0)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName : messlab.font}
                                                    context:nil].size;
        messlab.frame = CGRectMake(60, 64, (kScreenWidth - 60), tipLabelsize.height);
        messlab.tag = 1996;
        [_userNameCell.contentView addSubview:messlab];
        
        UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(messlab.frame)+30, 25, 25)];
        imageView.layer.cornerRadius =imageView.width/2;
        imageView.layer.masksToBounds =true;
        imageView.image = [UIImage imageNamed:@"国旗+63"];
        imageView.tag = 1997;
        [_userNameCell.contentView addSubview:imageView];
        
        JWLabel * numLab = [[JWLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame), imageView.y, 50, 25)];
        numLab.textColor = commonBlackBtnColor;
        numLab.font = kLightFont(13);
        numLab.text = @"+63";
        numLab.textAlignment = 1;
        numLab.tag = 1998;
        [_userNameCell.contentView addSubview:numLab];
        
        
        UIImageView * triangleimageView = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(numLab.frame),CGRectGetMinY(numLab.frame)+(numLab.height - 7.5)/2, 10.5, 7.5)];
        triangleimageView.image = [UIImage imageNamed:@"triangle"];
        [_userNameCell.contentView addSubview:triangleimageView];
        
        
        JWLabel * tapLab = [[JWLabel alloc]initWithFrame:CGRectMake(numLab.x, numLab.y-5+1, numLab.width, numLab.height+10)];
        HXWeak_(tapLab)
        HXWeak_self
        [tapLab addSingleTapEvent:^{
            HXStrong_(tapLab)
            HXStrong_self
            SpinnerView * spinner = [[SpinnerView alloc]initShowSpinnerWithRelevanceView:tapLab];
            spinner.modelArr = self.areaList;
            spinner.isNavHeight = true;
            spinner.tapDisappear= true;
            [spinner ShowView];
            spinner.backModel = ^(NSString *backStr){
                numLab.text = backStr;
                
                NSString * imgStr = [NSString stringWithFormat:@"国旗%@",backStr];
                ((UIImageView *)self.userNameCell.getElementByTag(1997)).image = [UIImage imageNamed:imgStr];
                
            };
        }];
        [_userNameCell.contentView addSubview:tapLab];
        
        
        JWLabel * line1 = [JWLabel addLineLabel:CGRectMake(CGRectGetMaxX(triangleimageView.frame)+5, imageView.y, 1, 25)];
        line1.backgroundColor = commonBlackBtnColor;
        line1.tag = 1999;
        [_userNameCell.contentView addSubview:line1];
        
        JWTextField * phoneTextField = [[JWTextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(line1.frame)+5, imageView.y, kScreenWidth/2, 25)];
        //        phoneTextField.placeholder = @"type in your number here";
        phoneTextField.font = kLightFont(14);
        phoneTextField.tag = 2000;
        
        NSAttributedString *str = [[NSAttributedString alloc] initWithString:Internationalization(@"在这里输入您的号码", @"type in your number here") attributes:@{NSFontAttributeName : kItalicFont(14), NSForegroundColorAttributeName : commonPlaceholderColor}];
//        phoneTextField.attributedPlaceholder = str;
        phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
        [_userNameCell.contentView addSubview:phoneTextField];
        
        JWLabel * line2 = [JWLabel addLineLabel:CGRectMake(20, CGRectGetMaxY(phoneTextField.frame)+5, kScreenWidth-40, 1)];
        line2.backgroundColor = commonBlackBtnColor;
        line2.tag = 2001;
        [_userNameCell.contentView addSubview:line2];
        
        
        JWLabel * warningL = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(line2.frame)+10, kScreenWidth-40, 40)];
        warningL.text = Internationalization(@"请确保您输入了有效号码。", @"Please make sure you entered a valid number.");
        warningL.textColor = commonErrorColor;
        warningL.font = kItalicFont(13);
        warningL.textAlignment = 1;
        warningL.numberOfLines=0;
        warningL.hidden = true;
        warningL.tag = 2002;
        [_userNameCell.contentView addSubview:warningL];
        
        ShadowView * sendBtn = [[ShadowView alloc] initWithFrame:
                                CGRectMake(20,CGRectGetMaxY(warningL.frame)+40,kScreenWidth-40,ShadowViewHeight)];
        sendBtn.colors =commonColorS;

        [sendBtn addSingleTapEvent:^{
            HXStrong_self
                [self getVerificationCode];
        }];
        sendBtn.tag = 2003;
        [_userNameCell.contentView addSubview:sendBtn];
        JWLabel * loginLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, sendBtn.y, sendBtn.width, sendBtn.height)];
        loginLab.text = Internationalization(@"发送验证码", @"Send Code");
        loginLab.textAlignment = 1;
        loginLab.textColor = [UIColor whiteColor];
        loginLab.tag = 2004;
        loginLab.font = kMediumFont(14);
        [_userNameCell.contentView addSubview:loginLab];
        
        
        [_userNameCell setUPSpacing:0 andDownSpacing:0];
        [self.view addSubview:_userNameCell];
    }
    return _userNameCell;
    
}


-(void)pushVerificationCode{
    
    if (!((JWTextField *)self.userNameCell.getElementByTag(2000)).text.length) {
        ((JWLabel *)self.userNameCell.getElementByTag(2001)).backgroundColor = commonErrorColor;
        ((JWLabel *)self.userNameCell.getElementByTag(2002)).hidden = false;
        return;
    }else{
        ((JWLabel *)self.userNameCell.getElementByTag(2001)).backgroundColor = commonVioletColor;
        ((JWLabel *)self.userNameCell.getElementByTag(2002)).hidden = true;
    }
    
    NSDictionary * userdict1 = self.transmitObject;
    NSDictionary * userdict2 =@{@"phone":((JWTextField *)self.userNameCell.getElementByTag(2000)).text,
                                @"area_code":((JWLabel *)self.userNameCell.getElementByTag(1998)).text};
    NSMutableDictionary * dict =[NSMutableDictionary new];
    [dict addEntriesFromDictionary:userdict1];
    [dict addEntriesFromDictionary:userdict2];
    
//    if ([self.skipStr isEqualToString:@"忘记密码"]) {
//        VerificationCodeViewController * verificationCodeVC = [VerificationCodeViewController new];
//        verificationCodeVC.skipStr = @"忘记密码";
//        verificationCodeVC.transmitObject = dict;
//        [self.navigationController pushViewController:verificationCodeVC animated:true];
//    }else{
//        VerificationCodeViewController * verificationCodeVC = [VerificationCodeViewController new];
//        verificationCodeVC.skipStr = @"注册";
//        verificationCodeVC.transmitObject = dict;
//        [self.navigationController pushViewController:verificationCodeVC animated:true];
//    }
    
    
    FaceBookVerificationCodeViewController * verificationCodeVC = [FaceBookVerificationCodeViewController new];
    verificationCodeVC.transmitObject = dict;
    [self.navigationController pushViewController:verificationCodeVC animated:true];
    
}



//获取注册验证码
-(void)getVerificationCode{
    
    if (!((JWTextField *)self.userNameCell.getElementByTag(2000)).text.length) {
        [self showTip:@"Please enter the phone number"];
        return;
    }
    
    [self showHud];
    HXWeak_self
    [CommonService getVerifyCodeWithMobile:((JWTextField *)self.userNameCell.getElementByTag(2000)).text
                              accountToken:self.defaultSetting.access_token
                                 area_code:((JWLabel *)self.userNameCell.getElementByTag(1998)).text
                                   success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HXStrong_self
        if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
            //            [self showTip:[TIPTEXT sendVerificationCode]];
            [self pushVerificationCode];
        }else{
            [self showTip:[responseObject objectForKey:@"errorMessage"]];
            ((JWLabel *)self.userNameCell.getElementByTag(2001)).backgroundColor = commonErrorColor;
            ((JWLabel *)self.userNameCell.getElementByTag(2002)).hidden = false;
        }
        [self closeHud];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HXStrong_self
        [self closeHud];
        [self errorDispose:[[operation response] statusCode] judgeMent:nil];
    }];
    
}

//-(void)getArea_code{
//    
//    customHUD * hud = [[customHUD alloc]init];
//    [hud showCustomHUDWithView:self.view];
//    [CommonService requestsecurityQueOfaccess_token:self.defaultSetting.access_token success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
//            
//            [self.areaList removeAllObjects];
//            
//            for (NSDictionary *dict in responseObject[@"data"]) {
//                QuestionModel *model = [QuestionModel yy_modelWithDictionary:dict];
//                [self.areaList addObject:model.title];
//            }
//            
//            ((JWLabel *)self.userNameCell.getElementByTag(1998)).text =  [self.areaList.firstObject stringValue] ?[self.areaList.firstObject stringValue]:@"";
//            
//        }else{
//            [self showTip:[responseObject objectForKey:@"errorMessage"]];
//        }
//        [hud hideCustomHUD];
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        [hud hideCustomHUD];
//        [self errorDispose:[[operation response] statusCode] judgeMent:nil];
//    }];
//}




@end
