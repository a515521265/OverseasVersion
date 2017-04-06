//
//  CredentialsInfoViewController.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/20.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "CredentialsInfoViewController.h"

#import "FirstLevelViewController.h"

#import "SecondLevelViewController.h"
#import "ThirdLevelViewController.h"

#import "ShowAlertViewController.h"
#import "LevelModel.h"

@interface CredentialsInfoViewController ()

@property (nonatomic,strong) JWScrollView * scrollView;


@property (nonatomic,strong) JWScrollviewCell * cell3;

@property (nonatomic,strong) JWScrollviewCell * cell4;

@property (nonatomic,strong) JWScrollviewCell * cell5;

@end

@implementation CredentialsInfoViewController

-(JWScrollView *)scrollView{
    
    if (!_scrollView) {
        _scrollView = [[JWScrollView alloc]init];
        _scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
        _scrollView.alwaysBounceVertical = true;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

-(void)viewDidLoad{

    [super viewDidLoad];
    
    JWScrollviewCell * cell1 = [self creatCell1];
    
    JWScrollviewCell * cell2 = [self creatCell2];
    
    JWScrollviewCell * cell3 = [self creatCell3:@{@"Level":@"Level 1 Certified",
                                                  @"CashIn":@"--",
                                                  @"CashOut":@"--",
                                                  @"type":@"1"}];
    self.cell3 = cell3;
    
    JWScrollviewCell * cell4 = [self creatCell3:@{@"Level":@"Level 2 Certified",
                                                  @"CashIn":@"--",
                                                  @"CashOut":@"--",
                                                  @"type":@"2"}];
    self.cell4 = cell4;
    
    JWScrollviewCell * cell5 = [self creatCell3:@{@"Level":@"Level 3 Certified",
                                                  @"CashIn":@"--",
                                                  @"CashOut":@"--",
                                                  @"type":@"3"}];
    self.cell5 = cell5;
    
    JWScrollviewCell * cell6 = [self creatheadCell];
    
    
    [self.scrollView setScrollviewSubViewsArr:@[cell1,cell2,cell6,cell3,cell4,cell5].mutableCopy];
    
    
    [self getUserInfosuccess:^(UserInfoModel *userInfo) {
        
        if (userInfo.level.integerValue>=1) {
            [((UIButton *)cell3.getElementByTag(1001)) setImage:[UIImage imageNamed:@"Check-1"] forState:UIControlStateNormal];
        }
        if (userInfo.level.integerValue>=2){
            [((UIButton *)cell4.getElementByTag(1001)) setImage:[UIImage imageNamed:@"Check-1"] forState:UIControlStateNormal];
        }
        if (userInfo.level.integerValue>=3){
            [((UIButton *)cell5.getElementByTag(1001)) setImage:[UIImage imageNamed:@"Check-1"] forState:UIControlStateNormal];
        }
        
    } showHud:true];
    
    
    [self getLevelList];
    
}

-(JWScrollviewCell *)creatCell1{

    JWScrollviewCell * item = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 52)];
    
    JWLabel * titleLab1 = [[JWLabel alloc]initWithFrame:CGRectMake(20, adaptY(20), kScreenWidth-60, adaptY(30))];
    titleLab1.text = @"Account";
    titleLab1.font = kMediumFont(22);
    titleLab1.isShadow = true;
    titleLab1.colors = commonColorS;
    [item addSubview:titleLab1];
    
    JWLabel * titleLab2 = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLab1.frame), kScreenWidth-60, adaptY(30))];
    titleLab2.text = @"Certifications and";
    titleLab2.font = kMediumFont(22);
    titleLab2.isShadow = true;
    titleLab2.colors = commonColorS;
    [item addSubview:titleLab2];
    
    JWLabel * titleLab3 = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLab2.frame), kScreenWidth-60, adaptY(30))];
    titleLab3.text = @"Limits      ";
    titleLab3.font = kMediumFont(22);
    titleLab3.isShadow = true;
    titleLab3.colors = commonColorS;
    [item addSubview:titleLab3];
    
    
    item.contentView.height = CGRectGetMaxY(titleLab3.frame);
    
    [item setUPSpacing:0 andDownSpacing:0];
    
    return item;

}

-(JWScrollviewCell *)creatCell2{
    
    JWScrollviewCell * item = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 52)];
    
    JWLabel * titleLab1 = [[JWLabel alloc]initWithFrame:CGRectMake(20, 10, kScreenWidth-40, 45)];
    titleLab1.text = @"Being certified allows you to have higher Cash Out limits and the ability to earn reward points.";
    titleLab1.font = kLightFont(12);
    titleLab1.numberOfLines = 0;
    titleLab1.height = [titleLab1 getLabelSize:titleLab1].height;
    [item addSubview:titleLab1];
    
    JWLabel * titleLab2 = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLab1.frame)+adaptY(15) , kScreenWidth-40, 45)];
    titleLab2.text = @"We are asking you to provide details about yourself because we have to follow government rules. As well as to deliver highly rewarding and safe services.";
    titleLab2.font = kLightFont(12);
    titleLab2.numberOfLines = 0;
    titleLab2.height = [titleLab2 getLabelSize:titleLab2].height;
    [item addSubview:titleLab2];
    
    
    JWLabel * titleLab3 = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLab2.frame)+adaptY(15), kScreenWidth/1.6, 30)];
    titleLab3.text = @"Fore more information, please click";
    titleLab3.font = kLightFont(12);
//    titleLab3.height = [titleLab3 getLabelSize:titleLab3].height;
    [item addSubview:titleLab3];
    
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(CGRectGetMaxX(titleLab3.frame), titleLab3.y, 30, 30);
    [button setImage:[UIImage imageNamed:@"help-1"] forState:UIControlStateNormal];
    button.userInteractionEnabled = false;
//    [button addSingleTapEvent:^{
//       
//        ShowAlertViewController * aletrVC = [[ShowAlertViewController alloc] init];
//        aletrVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//        aletrVC.modalPresentationStyle = UIModalPresentationCustom;
//        [self presentViewController:aletrVC animated:YES completion:nil];
//        
//    
//        
//        
//    }];
    [item addSubview:button];
    
    item.contentView.height = CGRectGetMaxY(titleLab3.frame);
    
    [item setUPSpacing:0 andDownSpacing:0];
    
    return item;
    
}


-(JWScrollviewCell *)creatCell3:(NSDictionary *)model{

    
    JWScrollviewCell * item = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    

    UIButton * levelbutton = [UIButton buttonWithType:UIButtonTypeCustom];
    levelbutton.frame = CGRectMake(20, adaptY(10), 30, 30);
    [levelbutton setImage:[UIImage imageNamed:@"wrong-1"] forState:UIControlStateNormal];
    levelbutton.userInteractionEnabled = false;
    levelbutton.tag = 1001;
    [item.contentView addSubview:levelbutton];
    
    
    JWLabel * levelLab = [[JWLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(levelbutton.frame), adaptY(10),adaptX(90) , 30)];
    levelLab.text = model[@"Level"];
    levelLab.font = kMediumFont(10);
    levelLab.textAlignment = 1;
    [item.contentView addSubview:levelLab];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(CGRectGetMaxX(levelLab.frame), adaptY(10), 30, 30);
    [button setImage:[UIImage imageNamed:@"help-1"] forState:UIControlStateNormal];
    HXWeak_self
    [button addSingleTapEvent:^{
        HXStrong_self
        if ([model[@"type"] isEqualToString:@"1"]) {
            [self.navigationController pushViewController:[FirstLevelViewController new] animated:true];
        }else if ([model[@"type"] isEqualToString:@"2"]){
            [self.navigationController pushViewController:[SecondLevelViewController new] animated:true];
        }else if ([model[@"type"] isEqualToString:@"3"]){
            [self.navigationController pushViewController:[ThirdLevelViewController new] animated:true];
        }
        
    }];
    [item.contentView addSubview:button];
    
    JWLabel * tipLab1 = [[JWLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button.frame)+adaptX(5), adaptY(10), adaptX(70), 30)];
    tipLab1.text = model[@"CashIn"];
    tipLab1.textAlignment = 1;
    tipLab1.font = kLightFont(10);
    tipLab1.tag = 1222;
    [item.contentView addSubview:tipLab1];
    
    
    JWLabel * tipLab2 = [[JWLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tipLab1.frame), adaptY(10), adaptX(70), 30)];
    tipLab2.text = model[@"CashOut"];
    tipLab2.textAlignment = 1;
    tipLab2.font = kLightFont(10);
    tipLab2.tag = 1223;
    [item.contentView addSubview:tipLab2];
    
    item.contentView.height = CGRectGetMaxY(item.contentView.subviews.lastObject.frame)+adaptY(10);
    
    [item setUPSpacing:0 andDownSpacing:0];
    
    return item;
    
}


-(JWScrollviewCell *)creatheadCell{
    
    
    JWScrollviewCell * item = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 60)];
    
    UIImageView * levelImage = [[UIImageView alloc]initWithFrame:CGRectMake(20,adaptY(17.5) , 25, 25)];
//    [item.contentView addSubview:levelImage];
    
    JWLabel * levelLab = [[JWLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(levelImage.frame), adaptY(15),adaptX(90) , 30)];
    levelLab.font = kMediumFont(10);
    levelLab.textAlignment = 1;
//    [item.contentView addSubview:levelLab];
    
    UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(CGRectGetMaxX(levelLab.frame), 15+10, 30, 30);
//    [item.contentView addSubview:button];
    
    JWLabel * tipLab1 = [[JWLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(button.frame)+adaptX(10), adaptY(10), adaptX(70), 30)];
    tipLab1.text = @"Cash In";
    tipLab1.textAlignment = 1;
    tipLab1.font = kMediumFont(10);
    [item.contentView addSubview:tipLab1];
    
    JWLabel * tipLab2 = [[JWLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(tipLab1.frame), adaptY(10), adaptX(70), 30)];
    tipLab2.text = @"Cash Out";
    tipLab2.textAlignment = 1;
    tipLab2.font = kMediumFont(10);
    [item.contentView addSubview:tipLab2];
    
    item.contentView.height = CGRectGetMaxY(item.contentView.subviews.lastObject.frame);
    
    [item setUPSpacing:0 andDownSpacing:0];
    
    
    
    return item;

}


-(void)getLevelList{

    customHUD * hud = [[customHUD alloc]init];
    [hud showCustomHUDWithView:self.view];
    [CommonService requestgetLevelListaccess_token:self.defaultSetting.access_token success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"errorCode"] integerValue] ==0) {

            NSMutableArray * modelArr  = [NSMutableArray arrayWithCapacity:10];
            for (NSDictionary *dict in responseObject[@"data"]) {
                
                LevelModelTwo *model = [LevelModelTwo yy_modelWithDictionary:dict];
                [modelArr addObject:model];
            }
            
            [self setviewlevellist:modelArr];
            
        }else{
            [self showTip:[responseObject objectForKey:@"errorMessage"]];
        }
        [hud hideCustomHUD];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hideCustomHUD];
        [self errorDispose:[[operation response] statusCode] judgeMent:nil];
    }];
    
}


-(void)setviewlevellist:(NSMutableArray *)list{
    
    for (int i =0; i<list.count ; i++) {
        
        LevelModelTwo *model = list[i];
        if (model.level ==1) {
            
            ((JWLabel *)self.cell3.getElementByTag(1222)).text = model.cashIn;
            ((JWLabel *)self.cell3.getElementByTag(1223)).text = model.cashOut;
            
        }else if (model.level ==2){
            
            ((JWLabel *)self.cell4.getElementByTag(1222)).text = model.cashIn;
            ((JWLabel *)self.cell4.getElementByTag(1223)).text = model.cashOut;
            
        }else if (model.level ==3){
            
            ((JWLabel *)self.cell5.getElementByTag(1222)).text = model.cashIn;
            ((JWLabel *)self.cell5.getElementByTag(1223)).text = model.cashOut;
            
        }
        
    }
    

}


@end
