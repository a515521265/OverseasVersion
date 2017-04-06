//
//  FriendDetailViewController.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/3/9.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "FriendDetailViewController.h"
#import "UIImageView+WebCache.h"

@interface FriendDetailViewController ()

@end

@implementation FriendDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    UIImageView * userIconiamgeV = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-adaptX(80))/2,adaptY(50),adaptX(80) , adaptX(80) )];
    userIconiamgeV.layer.cornerRadius =userIconiamgeV.width/2;
    userIconiamgeV.layer.masksToBounds =true;
    userIconiamgeV.backgroundColor = [UIColor whiteColor];
    userIconiamgeV.layer.borderWidth = 2;
    userIconiamgeV.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:userIconiamgeV];
    [userIconiamgeV sd_setImageWithURL:[NSURL URLWithString:self.model.headPic] placeholderImage:[UIImage imageNamed:@"UserDefaultIcon.jpg"]];
    
    
    JWLabel * levelLab = [[JWLabel alloc]initWithFrame:CGRectMake((kScreenWidth - adaptY(60))/2, CGRectGetMaxY(userIconiamgeV.frame)+adaptY(10), adaptY(60),adaptY(15))];
    levelLab.text = [NSString stringWithFormat:@"LEVEL : %ld",(long)_model.level];
    levelLab.font = kLightFont(10);
    levelLab.textAlignment = 1;
    levelLab.layer.borderWidth = 1;
    levelLab.layer.borderColor = UIColorFromRGB(0x30aa17).CGColor;
    levelLab.layer.cornerRadius =3;
    levelLab.layer.masksToBounds =true;
    levelLab.textColor = UIColorFromRGB(0x30aa17);
    [self.view addSubview:levelLab];
    
    
    
    JWLabel * nameLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(levelLab.frame)+adaptY(15), kScreenWidth-40,adaptY(20))];
    nameLab.font = kMediumFont(15);
    nameLab.textAlignment = 0;
    nameLab.textColor = commonBlackBtnColor;
    nameLab.text = [NSString stringWithFormat:@"UserName :  %@ %@",_model.firstName,_model.lastName];
    [self.view addSubview:nameLab];
    
    

    
    
    
    
}


@end
