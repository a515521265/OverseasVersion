//
//  SubmitAddressViewController.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/23.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "SubmitAddressViewController.h"

#import "SpinnerView.h"

#import "JWTextView.h"

#import "AddressSuccessViewController.h"

#import "CityModel.h"

@interface SubmitAddressViewController ()

@property (nonatomic,strong) JWScrollView * scrollView;

@property (nonatomic,strong) NSString * str1;
@property (nonatomic,strong) NSString * str2;
@property (nonatomic,strong) NSString * str3;
@property (nonatomic,strong) NSString * str4;
@property (nonatomic,strong) NSString * str5;

@property (nonatomic,strong) UIButton * cityBtn;
@property (nonatomic,strong) UIButton * provinceBtn;

@property (nonatomic,strong) JWScrollviewCell * unitCell;
@property (nonatomic,strong) JWScrollviewCell * barangayCell;
@property (nonatomic,strong) JWScrollviewCell * countryCell;
@property (nonatomic,strong) JWScrollviewCell * headCell;
@property (nonatomic,strong) NSMutableArray <CityModel *>* cityArr;

@property (nonatomic,strong) NSMutableArray *  provinceArr; //选中的省份数据

@end

@implementation SubmitAddressViewController


static NSString * cityBtnName = @"Please choose a city";

static NSString * provinceBtnName = @"Please choose a Province / Region / State";

-(NSMutableArray *)cityArr{

    if (!_cityArr) {
        _cityArr = [NSMutableArray arrayWithCapacity:10];
    }
    return _cityArr;
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
    // Do any additional setup after loading the view.
    
    [self addNotification];
    
    JWScrollviewCell * cell1 = [self creatCell1];
    [self.scrollView addSubview:cell1];
    self.headCell = cell1;
    
    JWScrollviewCell * cell2 = [self addAnswerCell:Internationalization(@"单位/数家街村", @"Unit / House Number, Street, Village Name")];
    cell2.y = CGRectGetMaxY(cell1.frame);
    [self.scrollView addSubview:cell2];
    self.unitCell = cell2;
    
    
    JWScrollviewCell * cell3 = [self addAnswerCell:Internationalization(@"镇的名字", @"Barangay Name")];
    cell3.y = CGRectGetMaxY(cell2.frame);
    [self.scrollView addSubview:cell3];
    self.barangayCell = cell3;
    
    
    JWLabel * cityLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(cell3.frame)+10, kScreenWidth-40, 30)];
    cityLab.text = @"City";
    cityLab.font = kMediumFont(12);
    cityLab.textColor = commonBlackBtnColor;
    [self.scrollView addSubview:cityLab];
    
    UIButton * btn1 = [self addspinnerBtnwithframe:CGRectMake(20, CGRectGetMaxY(cityLab.frame)+10,kScreenWidth-40, adaptY(30)) btnTitle:cityBtnName list:@[@"哈哈",@"呵呵",@"嘿嘿",@"嗷嗷",@"啊啊",@"--"].mutableCopy];
    btn1.tag = 1001;
    [self.scrollView addSubview:btn1];
    self.cityBtn = btn1;
    
    JWLabel * provinceLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(btn1.frame)+10, kScreenWidth-40, 30)];
    provinceLab.text = @"Province / Region / State";
    provinceLab.font = kMediumFont(12);
    provinceLab.textColor = commonBlackBtnColor;
    [self.scrollView addSubview:provinceLab];
    
    UIButton * btn2 = [self addspinnerBtnwithframe:CGRectMake(20, CGRectGetMaxY(provinceLab.frame)+10,kScreenWidth-40, adaptY(30)) btnTitle:provinceBtnName list:@[@"哈哈",@"呵呵",@"嘿嘿",@"嗷嗷",@"啊啊",@"--"].mutableCopy];
    btn2.tag = 1002;
    [self.scrollView addSubview:btn2];
    self.provinceBtn = btn2;
    
    
    JWScrollviewCell * cell4 = [self addPostCodecell];
    cell4.y = CGRectGetMaxY(btn2.frame)+10;
    [self.scrollView addSubview:cell4];
    self.countryCell = cell4;
    

    [self setScrollViewContenSize];
    
    HXWeak_self
    [self createTitleBarButtonItemStyle:BtnRightType title:@"Next" TapEvent:^{
        HXStrong_self
        [self verificationData];
    }];
    
    
    [self getCityList];
    
}

-(JWScrollviewCell *)addPostCodecell{
    
    JWScrollviewCell * item = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 52)];
    
    JWLabel * tipLab1 = [[JWLabel alloc]initWithFrame:CGRectMake(20, 10, kScreenWidth/2-20, 30)];
    tipLab1.text = @"Country";
    tipLab1.font = kMediumFont(12);
    tipLab1.textColor = commonBlackBtnColor;
    [item.contentView addSubview:tipLab1];
    
    JWLabel * tipLab2 = [[JWLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tipLab1.frame), 10, kScreenWidth/2-20, 30)];
    tipLab2.text = @"Post Code";
    tipLab2.font = kMediumFont(12);
    tipLab2.textColor = commonBlackBtnColor;
    [item.contentView addSubview:tipLab2];
    
    
    JWLabel * Countrylab = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(tipLab1.frame)+10, tipLab1.width, 30)];
    Countrylab.text = @"PHILIPPINES";
    Countrylab.font = kLightFont(14);
    Countrylab.textColor = commonBlackBtnColor;
    [item.contentView addSubview:Countrylab];
    
    
    JWTextField * textfield = [[JWTextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(Countrylab.frame), Countrylab.y, Countrylab.width, 30)];
    textfield.font = kLightFont(14);
    textfield.maxLength = 1000;
    HXWeak_self
    textfield.importBackString = ^(NSString * backStr){
        HXStrong_self
        self.str5 = backStr;
    };
    [item.contentView addSubview:textfield];
    
    JWLabel * lineLab = [[JWLabel alloc]initWithFrame:CGRectMake(textfield.x, CGRectGetMaxY(textfield.frame), kScreenWidth/2-20, 1)];
    lineLab.backgroundColor = UIColorFromRGB(0x909090);
    lineLab.tag = 1992;
    [item.contentView addSubview:lineLab];
    
    item.contentView.height = CGRectGetMaxY(item.contentView.subviews.lastObject.frame);
    [item setUPSpacing:0 andDownSpacing:0];
    
    return item;

}

-(void)setScrollViewContenSize{
    self.scrollView.contentSize = CGSizeMake(0, self.scrollView.subviews.lastObject.y + self.scrollView.subviews.lastObject.height+64);
}


-(JWScrollviewCell *)addAnswerCell:(NSString *)title{
    
    JWScrollviewCell * item = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 52)];
    
    JWLabel * answer1 = [[JWLabel alloc]initWithFrame:CGRectMake(20, 10, kScreenWidth, 30)];
    answer1.text = title;
    answer1.font = kMediumFont(12);
    answer1.textColor = commonBlackBtnColor;
    [item.contentView addSubview:answer1];
    
    JWTextField * textfield = [[JWTextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(answer1.frame), kScreenWidth-40, 30)];
    textfield.importStyle = TextViewImportStyleNormal;
    textfield.maxLength = 1000;
    textfield.font = kLightFont(13);
    HXWeak_self
    textfield.importBackString = ^(NSString * backStr){
        HXStrong_self
        if ([title isEqualToString:Internationalization(@"单位/数家街村", @"Unit / House Number, Street, Village Name")]) {
            self.str1 = backStr;
        }else if ([title isEqualToString:Internationalization(@"镇的名字", @"Barangay Name")]){
            self.str2 = backStr;
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

-(UIButton *)addspinnerBtnwithframe:(CGRect)rect btnTitle:(NSString *)title list:(NSMutableArray *)list{
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = rect;
    [button setBackgroundColor:UIColorFromRGB(0xf4f4f4)];
    
    button.layer.cornerRadius =adaptX(5);
    button.layer.masksToBounds =true;
    
    button.layer.borderWidth = 1;
    button.layer.borderColor = UIColorFromRGB(0xcecece).CGColor;
    
    JWLabel * titleLab = [[JWLabel alloc]initWithFrame:CGRectMake(5, 0, button.width-5, button.height)];
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
        HXStrong_(button)
        HXStrong_self
        
        
        if ([title isEqualToString:provinceBtnName]){
            if (!self.provinceArr.count) {
                [self showTip:@"Please select the city"];
                return;
            }
        }
        
        
        SpinnerView * spinner = [[SpinnerView alloc]initShowSpinnerWithRelevanceView:button];
        spinner.isModelArr = true;
        if ([title isEqualToString:cityBtnName]) {
            spinner.modelArr = self.cityArr;
            
        }else if ([title isEqualToString:provinceBtnName]){
            spinner.modelArr = self.provinceArr;
        }
        
        spinner.isNavHeight = true;
        spinner.tapDisappear= true;
        [spinner ShowView];
        spinner.backModel = ^(id backStr){
            HXStrong_self
            NSString * str;
            if ([backStr isKindOfClass:[CityModel class]]) {
                str = [backStr cityName];
            }
            titleLab.text = str;
            if ([title isEqualToString:cityBtnName]) {
                self.str3 = str;
//                [self.provinceBtn setTitle:provinceBtnName forState:UIControlStateNormal];
                
                ((JWLabel *)self.provinceBtn.getElementByTag(1888)).text = provinceBtnName;
                self.str4 = @"";
            }else if ([title isEqualToString:provinceBtnName]){
                self.str4 = str;
            }
        };
        spinner.backindex = ^(NSIndexPath * index){
        HXStrong_self
            if ([title isEqualToString:cityBtnName]) {
                self.provinceArr =  self.cityArr[index.row].child.mutableCopy;
            }
        };
    }];
    
    return button;
    
}


-(JWScrollviewCell *)creatCell1{
    
    JWScrollviewCell * item = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 52)];
    
    JWLabel * titleLab1 = [[JWLabel alloc]initWithFrame:CGRectMake(20, adaptY(20), kScreenWidth-60, adaptY(30))];
    titleLab1.text = @"Residential";
    titleLab1.font = kMediumFont(25);
    titleLab1.isShadow = true;
    titleLab1.colors = commonColorS;
    [item.contentView addSubview:titleLab1];
    
    JWLabel * titleLab2 = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLab1.frame), kScreenWidth-60, adaptY(30))];
    titleLab2.text = @"Address";
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

   ((JWLabel *)self.unitCell.getElementByTag(1992)).backgroundColor = self.str1.length ? UIColorFromRGB(0x909090) : commonErrorColor;
    ((JWLabel *)self.barangayCell.getElementByTag(1992)).backgroundColor = self.str2.length ? UIColorFromRGB(0x909090) : commonErrorColor;
    self.cityBtn.layer.borderColor  = self.str3.length ? UIColorFromRGB(0xcecece).CGColor : commonErrorColor.CGColor;
    self.provinceBtn.layer.borderColor  = self.str4.length ? UIColorFromRGB(0xcecece).CGColor : commonErrorColor.CGColor;
    ((JWLabel *)self.countryCell.getElementByTag(1992)).backgroundColor = self.str5.length ? UIColorFromRGB(0x909090) : commonErrorColor;


    if (self.str1.length && self.str2.length && self.str3.length && self.str4.length && self.str5.length) {
        [self submitAdderss];
    }else{
        self.headCell.getElementByTag(1991).hidden = false;
    }
}


-(void)submitAdderss{

    customHUD * hud = [[customHUD alloc]init];
    [hud showCustomHUDWithView:self.view];
    [CommonService requestuploadAddressOfaccess_token:self.defaultSetting.access_token
                                             province:self.str4
                                                 city:self.str3
                                             barangay:self.str2
                                              address:self.str1
                                             postCode:self.str5
                                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
                                                  
                                                  if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {

                                                      self.headCell.getElementByTag(1991).hidden = true;
                                                      
                                                      [self certificationViewControllerSPush:[AddressSuccessViewController new]];
                                                      
                                                  }else{
                                                      [self showTip:[responseObject objectForKey:@"errorMessage"]];
                                                  }
                                                  
                                                 [hud hideCustomHUD];
                                             } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                                                 [hud hideCustomHUD];
                                                [self errorDispose:[[operation response] statusCode] judgeMent:nil];
                                             }];
    
}


-(void)getCityList{

    customHUD * hud = [[customHUD alloc]init];
    [hud showCustomHUDWithView:self.view];
    [CommonService requestgetCityListOfaccess_token:self.defaultSetting.access_token success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
            
            [self.cityArr removeAllObjects];
            for (NSDictionary *dict in responseObject[@"data"]) {
                CityModel * model = [CityModel yy_modelWithDictionary:dict];
                [self.cityArr addObject:model];
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


@end
