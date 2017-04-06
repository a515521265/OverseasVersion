//
//  SubmitSecurityDetailsViewController.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/23.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "SubmitSecurityDetailsViewController.h"

#import "SpinnerView.h"

#import "JWTextView.h"

#import "SecurityDetailsSuccessController.h"

#import "OtherTool.h"

#import "QuestionModel.h"

@interface SubmitSecurityDetailsViewController ()

@property (nonatomic,strong) JWScrollView * scrollView;

@property (nonatomic,strong) NSMutableArray * monthArr;

@property (nonatomic,strong) NSMutableArray * dateArr;

@property (nonatomic,strong) NSMutableArray * yearArr;

@property (nonatomic,strong) NSMutableArray * security_QuestionArr1;

@property (nonatomic,strong) NSMutableArray * security_QuestionArr2;

@property (nonatomic,strong) UIButton * monthBtn;
@property (nonatomic,strong) UIButton * dateBtn;
@property (nonatomic,strong) UIButton * yearBtn;
@property (nonatomic,strong) UIButton * questionBtn1;
@property (nonatomic,strong) UIButton * questionBtn2;

@property (nonatomic,strong) JWScrollviewCell * answerCell1;
@property (nonatomic,strong) JWScrollviewCell * answerCell2;
@property (nonatomic,strong) JWScrollviewCell * headCell;

@property (nonatomic,strong) NSString * str1;
@property (nonatomic,strong) NSString * str2;
@property (nonatomic,strong) NSString * str3;
@property (nonatomic,strong) NSString * str4;
@property (nonatomic,strong) NSString * str5;
@property (nonatomic,strong) NSString * str6;
@property (nonatomic,strong) NSString * str7;

@property (nonatomic,strong) NSString * selectSex;

@end

@implementation SubmitSecurityDetailsViewController

static NSString * monthBtnTitle = @"Month";

static NSString * dateBtnTitle = @"Date";

static NSString * yearBtnTitle = @"Year";

static NSString * questionBtnTitle1 = @"Please choose a question";

static NSString * questionBtnTitle2 = @"Please choose a question ";

-(NSMutableArray *)security_QuestionArr1{
    
    if (!_security_QuestionArr1) {
        _security_QuestionArr1 = @[@"What is the first name of your best friend in high school?",
                                   @"What was the name of your first pet?",
                                   @"What was the first thing you learned to cook?"].mutableCopy;
        
    }
    return _security_QuestionArr1;
}

-(NSMutableArray *)security_QuestionArr2{
    
    if (!_security_QuestionArr2) {
        _security_QuestionArr2 = @[@"What is you dream job?",
                                   @"What is you favorite children's book?",
                                   @"What was the model of you first car?"].mutableCopy;
        
    }
    return _security_QuestionArr2;
}


-(NSMutableArray *)monthArr{

    if (!_monthArr) {
        _monthArr = [NSMutableArray arrayWithCapacity:10];
        
        for (int i =1; i< 13; i++) {
            NSString * monthStr = [NSString stringWithFormat:@"%d",i];
            [_monthArr addObject:monthStr];
        }
    }
    return _monthArr;
}

-(NSMutableArray *)dateArr{
    
    if (!_dateArr) {
        _dateArr = [NSMutableArray arrayWithCapacity:10];
        for (int i =1; i< 32; i++) {
            NSString * monthStr = [NSString stringWithFormat:@"%d",i];
            [_dateArr addObject:monthStr];
        }
    }
    return _dateArr;
}

-(NSMutableArray *)yearArr{
    
    if (!_yearArr) {
        _yearArr = [NSMutableArray arrayWithCapacity:10];
        for (int i =1970; i< 2017; i++) {
            NSString * monthStr = [NSString stringWithFormat:@"%d",i];
            [_yearArr addObject:monthStr];
        }
    }
    return _yearArr;
}

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
    
    [self addNotification];
    
    JWScrollviewCell * cell1 = [self creatCell1];
    [self.scrollView addSubview:cell1];
    self.headCell = cell1;
    
    JWLabel * titleLab3 = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(cell1.frame), kScreenWidth-40, 35)];
    titleLab3.text = @"Birthday";
    titleLab3.font = kMediumFont(15);
    titleLab3.textColor = commonBlackBtnColor;
    titleLab3.numberOfLines = 0;
    [self.scrollView addSubview:titleLab3];
    
    UIButton * btn1 = [self addspinnerBtnwithframe:CGRectMake(20, CGRectGetMaxY(titleLab3.frame)+10,adaptX(100), adaptY(30)) btnTitle:monthBtnTitle list:self.monthArr];
    [self.scrollView addSubview:btn1];
    self.monthBtn = btn1;
    
    UIButton * btn2 = [self addspinnerBtnwithframe:CGRectMake(CGRectGetMaxX(btn1.frame)+ adaptX(30), btn1.y,adaptX(60), adaptY(30)) btnTitle:dateBtnTitle list:self.dateArr];
    [self.scrollView addSubview:btn2];
    self.dateBtn = btn2;
    
    UIButton * btn3 = [self addspinnerBtnwithframe:CGRectMake(kScreenWidth - adaptX(80) -20, btn1.y,adaptX(80), adaptY(30)) btnTitle:yearBtnTitle list:self.yearArr];
    [self.scrollView addSubview:btn3];
    self.yearBtn = btn3;
    
    
    JWScrollviewCell * cell2 = [self addSexCell];
    cell2.y = CGRectGetMaxY(btn3.frame);
    [self.scrollView addSubview:cell2];
    
    
    JWLabel * security1 = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(cell2.frame), kScreenWidth, 30)];
    security1.text = Internationalization(@"安全问题1", @"Security Question 1");
    security1.font = kMediumFont(15);
    security1.textColor = commonBlackBtnColor;
    [self.scrollView addSubview:security1];
    
    UIButton * btn4 = [self addspinnerBtnwithframe:CGRectMake(20, CGRectGetMaxY(security1.frame)+10,kScreenWidth-40, adaptY(30)) btnTitle:questionBtnTitle1 list:self.security_QuestionArr1];
    [self.scrollView addSubview:btn4];
    self.questionBtn1 = btn4;
    

    JWScrollviewCell * cell3 = [self addAnswerCell:Internationalization(@"答案1", @"answer1")];
    cell3.y = CGRectGetMaxY(btn4.frame);
    cell3.tag = 1000;
    [self.scrollView addSubview:cell3];
    self.answerCell1 = cell3;
    
    
    JWLabel * security2 = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(cell3.frame)+10, kScreenWidth, 30)];
    security2.text = Internationalization(@"安全问题2", @"Security Question 2");
    security2.font = kMediumFont(15);
    security2.textColor = commonBlackBtnColor;
    security2.tag = 1001;
    [self.scrollView addSubview:security2];
    
    
    UIButton * btn5 = [self addspinnerBtnwithframe:CGRectMake(20, CGRectGetMaxY(security2.frame)+10,kScreenWidth-40, adaptY(30)) btnTitle:questionBtnTitle2 list:self.security_QuestionArr2];
    btn5.tag = 1002;
    [self.scrollView addSubview:btn5];
    self.questionBtn2 = btn5;
    
    
    JWScrollviewCell * cell4 = [self addAnswerCell:Internationalization(@"答案2", @"answer2")];
    cell4.y = CGRectGetMaxY(btn5.frame);
    cell4.tag = 1003;
    [self.scrollView addSubview:cell4];
    self.answerCell2 = cell4;
    
    [self setScrollViewContenSize];
    
    HXWeak_self;
    [self createTitleBarButtonItemStyle:BtnRightType title:@"Next" TapEvent:^{
        HXStrong_self;
        [self verificationData];
    }];
    
    [self requestsecurityQue];
}

-(void)setScrollViewContenSize{
    self.scrollView.contentSize = CGSizeMake(0, self.scrollView.subviews.lastObject.y + self.scrollView.subviews.lastObject.height+64);
}


-(JWScrollviewCell *)addAnswerCell:(NSString *)title{

    JWScrollviewCell * item = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 52)];
    
    JWLabel * answer1 = [[JWLabel alloc]initWithFrame:CGRectMake(20, 10, kScreenWidth, 30)];
    answer1.text = title;
    answer1.font = kMediumFont(15);
    answer1.textColor = commonBlackBtnColor;
    [item.contentView addSubview:answer1];
    
    JWTextField * textfield = [[JWTextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(answer1.frame), kScreenWidth-40, 35)];
    textfield.importStyle = TextViewImportStyleChina;
    textfield.font = kLightFont(15);
    textfield.maxLength = 1000;
    textfield.importBackString = ^(NSString * backStr){
    
        if ([title isEqualToString:@"answer1"]) {
            self.str5 = backStr;
        }else if ([title isEqualToString:@"answer2"]){
            self.str7 = backStr;
        }
        
    };
    [item.contentView addSubview:textfield];
    
    JWLabel * line = [JWLabel addLineLabel:CGRectMake(20, CGRectGetMaxY(textfield.frame)+1, kScreenWidth-40, 1)];
    [item.contentView addSubview:line];
    line.tag = 1992;
    item.contentView.height = CGRectGetMaxY(item.contentView.subviews.lastObject.frame);
    
    [item setUPSpacing:0 andDownSpacing:0];

    
    return item;
}


-(JWScrollviewCell *)addSexCell{

    JWScrollviewCell * item = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 52)];
    
    JWLabel * tipLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, 10, kScreenWidth, 30)];
    tipLab.text = Internationalization(@"性别", @"Sex");
    tipLab.tag = 3001;
    tipLab.font = kMediumFont(15);
    tipLab.textColor = commonBlackBtnColor;
    [item.contentView addSubview:tipLab];
    
    UIButton * individualBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    individualBtn.frame = CGRectMake(20, CGRectGetMaxY(tipLab.frame)+10, 15.1, 15.1);
    [individualBtn setBackgroundImage:[UIImage imageNamed:@"单选新"] forState:UIControlStateNormal];
    [individualBtn setBackgroundImage:[UIImage imageNamed:@"选中新"] forState:UIControlStateSelected];
    individualBtn.tag = 4001;
    [item.contentView addSubview:individualBtn];
    JWLabel * individualLab = [[JWLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(individualBtn.frame)+10, individualBtn.y-3, 80, 20)];
    self.selectSex = individualLab.text = Internationalization(@"男", @"Male");
    individualBtn.selected = true;
    individualLab.textColor = commonVioletColor;
    individualLab.font = kMediumFont(12);
    [item.contentView addSubview:individualLab];
    
    UIButton * businessBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    businessBtn.frame = CGRectMake(CGRectGetMaxX(individualLab.frame)+20, CGRectGetMaxY(tipLab.frame)+10, 15.1, 15.1);
    [businessBtn setBackgroundImage:[UIImage imageNamed:@"单选新"] forState:UIControlStateNormal];
    [businessBtn setBackgroundImage:[UIImage imageNamed:@"选中新"] forState:UIControlStateSelected];
    businessBtn.tag = 4002;
    [item.contentView addSubview:businessBtn];
    
    JWLabel * businessLab = [[JWLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(businessBtn.frame)+10, businessBtn.y-3, 80, 20)];
    businessLab.text = Internationalization(@"女", @"Female");
    businessLab.textColor = commonGrayBtnColor;
    businessLab.font = kMediumFont(12);
    [item.contentView addSubview:businessLab];
    
    
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
        self.selectSex = individualLab.text;
        businessBtn.selected = false;
        individualLab.textColor = commonVioletColor;
        businessLab.textColor = commonGrayBtnColor;
    }];
    
    [individualLab addSingleTapEvent:^{
        HXStrong_(individualBtn)
        HXStrong_(individualLab)
        HXStrong_(businessBtn)
        HXStrong_(businessLab)
        individualBtn.selected = true;
        self.selectSex = individualLab.text;
        businessBtn.selected = false;
        individualLab.textColor = commonVioletColor;
        businessLab.textColor = commonGrayBtnColor;
    }];
    
    
    [businessBtn addSingleTapEvent:^{
        HXStrong_(individualBtn)
        HXStrong_(individualLab)
        HXStrong_(businessBtn)
        HXStrong_(businessLab)
        individualBtn.selected = false;
        businessBtn.selected = true;
        self.selectSex = businessLab.text;
        individualLab.textColor = commonGrayBtnColor;
        businessLab.textColor = commonVioletColor;
    }];
    
    [businessLab addSingleTapEvent:^{
        HXStrong_(individualBtn)
        HXStrong_(individualLab)
        HXStrong_(businessBtn)
        HXStrong_(businessLab)
        individualBtn.selected = false;
        businessBtn.selected = true;
        self.selectSex = businessLab.text;
        individualLab.textColor = commonGrayBtnColor;
        businessLab.textColor = commonVioletColor;
    }];

    
    item.contentView.height = CGRectGetMaxY(item.contentView.subviews.lastObject.frame)+10;
    
    [item setUPSpacing:0 andDownSpacing:0];
    
    return item;
}


-(UIButton *)addspinnerBtnwithframe:(CGRect)rect btnTitle:(NSString *)title list:(NSMutableArray *)list{

    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = rect;
    [button setBackgroundColor:UIColorFromRGB(0xf4f4f4)];

    button.layer.cornerRadius =adaptX(5);
    button.layer.masksToBounds =true;
    button.layer.borderWidth = 1;
    button.layer.borderColor = UIColorFromRGB(0xcecece).CGColor;
    
    JWLabel * titleLab = [[JWLabel alloc]initWithFrame:CGRectMake(5, 0, button.width-5-10.5, button.height)];
    titleLab.font = kLightFont(9);
    titleLab.text = title;
    titleLab.textColor = UIColorFromRGB(0x989299);
    titleLab.tag = 1888;
    [button addSubview:titleLab];
    
    UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake(button.width-20,(button.height - 7.5)/2, 10.5, 7.5)];
    imageView.image = [UIImage imageNamed:@"triangle"];
    [button addSubview:imageView];
    
    [self.scrollView addSubview:button];
    
    HXWeak_(button)
    HXWeak_self
    [button addSingleTapEvent:^{
        HXStrong_self
        HXStrong_(button)
        
        if ([title isEqualToString:dateBtnTitle]) {
            if (![self judgeFormatDate]) {
                return;
            }
        }
        
//        if ([title isEqualToString:yearBtnTitle]) {
//            
//        }else if ([title isEqualToString:monthBtnTitle]){
//        
//        }else{
//            if ([title isEqualToString:questionBtnTitle1] || [title isEqualToString:questionBtnTitle2]) {
//                
//            }else{
//
//            }
//        }
        
        SpinnerView * spinner = [[SpinnerView alloc]initShowSpinnerWithRelevanceView:button];
        spinner.modelArr = list;
        spinner.isNavHeight = true;
        spinner.tapDisappear= true;
        [spinner ShowView];
        spinner.backModel = ^(NSString *backStr){
            HXStrong_self
            titleLab.text = backStr;
            if ([title isEqualToString:monthBtnTitle]) {
                self.str1 = backStr;
                [self cleardate];
            }else if ([title isEqualToString:dateBtnTitle]){
                self.str2 = backStr;
            }else if ([title isEqualToString:yearBtnTitle]){
                self.str3 = backStr;
                [self cleardate];
            }else if ([title isEqualToString:questionBtnTitle1]){
                self.str4 = backStr;
            }else if ([title isEqualToString:questionBtnTitle2]){
                self.str6 = backStr;
            }
        };
    }];
    return button;
    
}

-(void)cleardate{

    ((JWLabel *)self.dateBtn.getElementByTag(1888)).text = dateBtnTitle;
    self.str2 = @"";
    
}


-(BOOL)judgeFormatDate{
    if (!self.str3.length) {
        [self showTip:@"Please select year"];
         return false;
    }else if (!self.str1.length){
        [self showTip:@"Please select month"];
        return false;
    }else{
        [self.dateArr removeAllObjects];
        for (int i =0; i< [OtherTool howManyDaysInThisYear:self.str3.integerValue withMonth:self.str1.integerValue]; i++) {
            NSString * monthStr = [NSString stringWithFormat:@"%d",i+1];
            [self.dateArr addObject:monthStr];
        }
        return true;
    }
}



-(JWScrollviewCell *)creatCell1{
    
    JWScrollviewCell * item = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 52)];
    
    JWLabel * titleLab1 = [[JWLabel alloc]initWithFrame:CGRectMake(20, adaptY(20), kScreenWidth-60, adaptY(30))];
    titleLab1.text = @"Security";
    titleLab1.font = kMediumFont(25);
    titleLab1.isShadow = true;
    titleLab1.colors = commonColorS;
    [item.contentView addSubview:titleLab1];
    
    JWLabel * titleLab2 = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLab1.frame), kScreenWidth-60, adaptY(30))];
    titleLab2.text = @"Details";
    titleLab2.font = kMediumFont(25);
    titleLab2.isShadow = true;
    titleLab2.colors = commonColorS;
    [item.contentView addSubview:titleLab2];
    
    
    UIButton * imageViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageViewBtn.frame = CGRectMake(kScreenWidth - 80 -20-10, titleLab1.y, 80, 70);
    [imageViewBtn setImage:[UIImage imageNamed:@"wrong-2"] forState:UIControlStateNormal];
    imageViewBtn.userInteractionEnabled = false;
    [item.contentView addSubview:imageViewBtn];
    
    JWLabel * warningLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(imageViewBtn.frame)+20, kScreenWidth-40, 20)];
    warningLab.tag = 1991;
    warningLab.textAlignment = 0;
    warningLab.numberOfLines = 0;
    warningLab.font = kMediumFont(10);
    warningLab.textColor = commonErrorColor;
    warningLab.text = @"***Please fill in all required fields before proceeding.";
    warningLab.hidden = true;
    [item.contentView addSubview:warningLab];

    item.contentView.height = CGRectGetMaxY(item.contentView.subviews.lastObject.frame);
    
    [item setUPSpacing:0 andDownSpacing:0];
    
    return item;
    
}

-(void)verificationData{
    
    self.monthBtn.layer.borderColor  = self.str1.length ? UIColorFromRGB(0xcecece).CGColor : commonErrorColor.CGColor;
    self.dateBtn.layer.borderColor  = self.str2.length ? UIColorFromRGB(0xcecece).CGColor : commonErrorColor.CGColor;
    self.yearBtn.layer.borderColor  = self.str3.length ? UIColorFromRGB(0xcecece).CGColor : commonErrorColor.CGColor;
    self.questionBtn1.layer.borderColor  = self.str4.length ? UIColorFromRGB(0xcecece).CGColor : commonErrorColor.CGColor;
    self.questionBtn2.layer.borderColor  = self.str6.length ? UIColorFromRGB(0xcecece).CGColor : commonErrorColor.CGColor;
    
    ((JWLabel *)self.answerCell1.getElementByTag(1992)).backgroundColor = self.str5.length ? UIColorFromRGB(0x909090) : commonErrorColor;
    ((JWLabel *)self.answerCell2.getElementByTag(1992)).backgroundColor = self.str7.length ? UIColorFromRGB(0x909090) : commonErrorColor;
    
    if (self.str1.length && self.str2.length && self.str3.length && self.str4.length &&self.str5.length&&self.str6.length&&self.str7.length) {
        [self submituploadSecurityDetails];
    }else{
        self.headCell.getElementByTag(1991).hidden = false;
    }
}

-(void)requestsecurityQue{
    customHUD * hud = [[customHUD alloc]init];
    [hud showCustomHUDWithView:self.view];
    [CommonService requestsecurityQueOfaccess_token:self.defaultSetting.access_token success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
            
            [self.security_QuestionArr1 removeAllObjects];
            [self.security_QuestionArr2 removeAllObjects];
            
            for (NSDictionary *dict in responseObject[@"data"]) {
                
                QuestionModel *model = [QuestionModel yy_modelWithDictionary:dict];
                if (model.type==1) {
                    [self.security_QuestionArr1 addObject:model.title];
                }else{
                    [self.security_QuestionArr2 addObject:model.title];
                }
            }
            
        }else{
            [self showTip:[responseObject objectForKey:@"errorMessage"]];
        }
        [hud hideCustomHUD];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hideCustomHUD];
        [self errorDispose:[[operation response] statusCode] judgeMent:nil];
    }];
    
}

-(void)submituploadSecurityDetails{

    NSString * birthdayStr =  [NSString getTimestamp:[NSString stringWithFormat:@"%@-%@-%@00:00:00",self.str3,self.str1,self.str2]];
    
    customHUD * hud = [[customHUD alloc]init];
    [hud showCustomHUDWithView:self.view];
    [CommonService requestuploadSecurityDetailsOfaccess_token:self.defaultSetting.access_token
                                                          sex:self.selectSex
                                                     birthDay:birthdayStr
                                                    question1:self.str4
                                                      answer1:self.str5
                                                    question2:self.str6
                                                      answer2:self.str7
                                                      success:^(AFHTTPRequestOperation *operation, id responseObject) {
      if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
          self.headCell.getElementByTag(1991).hidden = true;
          [self certificationViewControllerSPush:[SecurityDetailsSuccessController new]];
      }else{
          [self showTip:[responseObject objectForKey:@"errorMessage"]];
      }
      [hud hideCustomHUD];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hideCustomHUD];
        [self errorDispose:[[operation response] statusCode] judgeMent:nil];
    }];

}


@end
