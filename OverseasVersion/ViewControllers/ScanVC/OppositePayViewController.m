//
//  OppositePayViewController.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/8.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "OppositePayViewController.h"

#import "PasswordAlertView.h"

#import "ReceiptViewController.h"

#import "HXMapLocationManager.h"

#import "ShadowView.h"

#import "PayModel.h"

#import "WKTextFieldFormatter.h"

@interface OppositePayViewController ()

@property (nonatomic,strong) JWScrollviewCell * payCell; //搜索结果

@property (nonatomic,strong) PasswordAlertView * passwordalert;

@property (nonatomic,assign) double   longitude; //经度
@property (nonatomic,assign) double   lattitude; //纬度

@property (nonatomic,strong) NSString * qrCode;
@property (nonatomic,strong) NSString * showName;

@property (nonatomic,strong) WKTextFieldFormatter * formatter;

@end

@implementation OppositePayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self payCell];
    
    [self addNotification];
    
    [self setViewData];
    
    
    //判断是否可以支持指纹支付
    NSString * uidStr = [NSString stringWithFormat:@"%ld",(long)self.defaultSetting.uid];
    BOOL  isTouchID =  [[NSUserDefaults standardUserDefaults] boolForKey:uidStr];
    
    NSLog(@"%d",isTouchID);
}

-(void)setViewData{

    
    //好友列表进入
    if (self.friendModel) {
        
        NSString * showName;
        if (self.friendModel.shopName.length) {
            showName = self.friendModel.shopName;
        }else{
            showName = [NSString stringWithFormat:@"%@ %@",self.friendModel.firstName,self.friendModel.lastName];
        }
        ((JWLabel *)self.payCell.getElementByTag(1996)).text = showName;
        self.qrCode = self.friendModel.qrCode;
        self.showName = showName;
        
    }else{
    //扫码进入
        PayModel * payModel = [PayModel yy_modelWithDictionary:self.transmitObject[@"data"]];
        NSString * showName;
        if (payModel.shopName.length) {
            showName = payModel.shopName;
        }else{
            showName = [NSString stringWithFormat:@"%@ %@",payModel.firstName,payModel.lastName];
        }
        ((JWLabel *)self.payCell.getElementByTag(1996)).text = showName;
        self.qrCode = payModel.qrCode;
        self.showName = showName;
        
    }

}

-(JWScrollviewCell *)payCell{

    if (!_payCell) {
        _payCell = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    
        [self.view addSubview:_payCell];
        
        JWLabel *payLabel = [[JWLabel alloc] initWithFrame:CGRectMake(0, 40, kScreenWidth, 30)];
        payLabel.font = kMediumFont(20);
        payLabel.textColor = commonGrayColor;
        payLabel.textAlignment = NSTextAlignmentCenter;
        payLabel.numberOfLines = 0;
        payLabel.text = Internationalization( @"支付给", @"Pay");
        payLabel.tag = 1995;
        payLabel.textAlignment =1;
        [_payCell.contentView addSubview:payLabel];
        
        
        JWLabel *nameLabel = [[JWLabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(payLabel.frame), kScreenWidth, 30)];
        nameLabel.font = kLightFont(20);
        nameLabel.textColor = commonGrayColor;
        nameLabel.textAlignment = NSTextAlignmentCenter;
        nameLabel.tag = 1996;
        nameLabel.textAlignment =1;
        nameLabel.adjustsFontSizeToFitWidth = true;
        [_payCell.contentView addSubview:nameLabel];
        

        JWLabel * placeholderLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(nameLabel.frame)+adaptY(50), kScreenWidth-40, 50)];
        placeholderLab.isShadow = true;
        placeholderLab.font = kMediumFont(30);
        placeholderLab.labelAnotherFont = kMediumFont(20);
        placeholderLab.changeTextSize = true;
        placeholderLab.colors = commonColorS;
        placeholderLab.text = @"₱0.00";
        placeholderLab.textAlignment = 1;
        [placeholderLab sizeToFit];
        placeholderLab.center = CGPointMake(_payCell.bounds.size.width * 0.5, CGRectGetMaxY(nameLabel.frame)+adaptY(50));
        [_payCell.contentView addSubview:placeholderLab];
        
        JWTextField * textfield = [[JWTextField alloc]initWithFrame:CGRectMake(20, placeholderLab.y, kScreenWidth-40, placeholderLab.height)];
        textfield.textColor = [UIColor clearColor];
        textfield.tintColor =[UIColor clearColor];
        textfield.textAlignment = 1;
        textfield.tag = 1997;
        textfield.keyboardType = UIKeyboardTypeDecimalPad;
//        textfield.importStyle = TextFieldImportStyleRightfulMoney;
        
        self.formatter = [[WKTextFieldFormatter alloc] initWithTextField:textfield];
        self.formatter.formatterType = WKFormatterTypeDecimal;
        self.formatter.decimalPlace = 2;
        HXWeak_(placeholderLab)
        self.formatter.backStr = ^(NSString * backS){
//            placeholderLab.text = [NSString formatSpecialMoneyString:backS.doubleValue];
            HXStrong_(placeholderLab)
            placeholderLab.text = [NSString stringWithFormat:@"₱%.2f",backS.doubleValue];
            [placeholderLab sizeToFit];
            placeholderLab.center  = CGPointMake(_payCell.bounds.size.width * 0.5, CGRectGetMaxY(nameLabel.frame)+adaptY(50));
        };
        
//        textfield.importBackString = ^(NSString * importStr){
//            HXStrong_(placeholderLab)
//            placeholderLab.text = [NSString stringWithFormat:@"₱%.2f",importStr.doubleValue];
//            [placeholderLab sizeToFit];
//            placeholderLab.center  = CGPointMake(_payCell.bounds.size.width * 0.5, CGRectGetMaxY(nameLabel.frame)+adaptY(50));
//        };
        [_payCell.contentView addSubview:textfield];
        
        
        
        JWLabel * line = [JWLabel addLineLabel:CGRectMake(40, CGRectGetMaxY(textfield.frame)+adaptY(5), kScreenWidth-80, 1)];
        line.backgroundColor = commonGrayBtnColor;
        [_payCell.contentView addSubview:line];
        
        
        JWLabel * transactionLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(line.frame)+10, kScreenWidth-40, 30)];
        transactionLab.text = Internationalization(@"输入金额", @"Enter amount");
        transactionLab.textAlignment = 1;
        transactionLab.textColor = commonGrayBtnColor;
        transactionLab.font = kLightFont(12);
        [_payCell.contentView addSubview:transactionLab];
        
    
        ShadowView * nextBtn = [[ShadowView alloc] initWithFrame:
                                  CGRectMake(20,CGRectGetMaxY(transactionLab.frame)+70,kScreenWidth-40,ShadowViewHeight)];
        nextBtn.colors =commonColorS;
        HXWeak_self
        [nextBtn addSingleTapEvent:^{
            HXStrong_self
            [self requestPay];
        }];
        [_payCell.contentView addSubview:nextBtn];
        
        JWLabel * nextLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, nextBtn.y, nextBtn.width, nextBtn.height)];
        nextLab.text = Internationalization(@"下一步", @"Next");
        nextLab.textAlignment = 1;
        nextLab.textColor = [UIColor whiteColor];
        nextLab.font = kMediumFont(14);
        [_payCell.contentView addSubview:nextLab];
        [_payCell setUPSpacing:0 andDownSpacing:0];
        
    }
    
    return _payCell;
}

-(void)requestPay{

    if (!((JWTextField *)self.payCell.getElementByTag(1997)).text.doubleValue) {
        
        [self showTip:@"Please enter the correct amount"];
        
        return;
    }
    
    
    [self.view endEditing:true];
    

    self.passwordalert = [[PasswordAlertView alloc]init];
    self.passwordalert.permanentShow = true;
    [self.passwordalert jwAlertViewWithPaymentAmount:self.showName remainingBalance:[NSString stringWithFormat:@"%@",[NSString formatMoneyString:((JWTextField *)self.payCell.getElementByTag(1997)).text.doubleValue]] singleTapEvent:^(NSString *userPassword) {
        [self OppositePay:userPassword];
    }];
    
    HXWeak_self
    [HXMapLocationManager getGps:^(double lattitude, double longitude) {
        HXStrong_self
        self.longitude = longitude;
        self.lattitude = lattitude;
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(10 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [HXMapLocationManager stop];
    });
}

-(void)OppositePay:(NSString *)payPassword{
    
    HXWeak_self
    [self getUserInfosuccess:^(UserInfoModel *userInfo) {
        HXStrong_self
        [self showHud];
        [CommonService requestUserPaymentOfaccess_token:self.defaultSetting.access_token qrContent:self.qrCode amount:((JWTextField *)self.payCell.getElementByTag(1997)).text payPassword:payPassword longitude:self.longitude latitude:self.lattitude success:^(AFHTTPRequestOperation *operation, id responseObject) {
            HXStrong_self
            if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
                
                [self.passwordalert removeFromSuperview];
                
                ReceiptViewController * receiptVC = [ReceiptViewController new];
                receiptVC.hidesBottomBarWhenPushed = true;
                receiptVC.transmitObject = responseObject;
                [self.navigationController pushViewController:receiptVC animated:true];
                
            }else{
                
                [self showWindowTip:[responseObject objectForKey:@"errorMessage"]];
                
                self.passwordalert.errorMessage = [responseObject objectForKey:@"errorMessage"];
                
            }
            [self closeHud];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            HXStrong_self
            [self closeHud];
            [self.passwordalert removeFromSuperview];
            [self errorDispose:[[operation response] statusCode] judgeMent:nil];
        }];
    } showHud:false];
    
}



@end
