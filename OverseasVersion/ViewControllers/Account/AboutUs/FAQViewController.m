//
//  FAQViewController.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/23.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "FAQViewController.h"

@interface FAQViewController ()

@property (nonatomic,strong) JWScrollView * scrollView;

@property (nonatomic,strong) NSMutableArray * list;

@end

@implementation FAQViewController

-(NSMutableArray *)list{
    
    if (!_list) {
        _list = @[@{@"title":@"What is PICA?",
                    @"subTitle":@"PICA is a mobile payments wallet. It allows you to pay merchants via QR code scanning and receive funds from merchants, friends, and family.\nYou can also buy prepaid load for Globe and Smart, and pay utility bills, telecom bills, etc..."},
                  
                  
                  @{@"title":@"Where can I use PICA?",
                    @"subTitle":@"You can use PICA to pay with our partnered merchants. We work hard everyday to convince merchants that PICA is good for them and for the community. Help us spread the word!"},
                  
                  
                  @{@"title":@"How do I put money in my PICA wallet?",
                    @"subTitle":@"Currently the only way to put money in your PICA wallet is through 7-11 stores by using their “Cliqq” system. However, we are working everyday to increase our Cash In network facility."}
                  
                  
                  
                  ].mutableCopy;
    }
    return _list;
    
}


-(JWScrollView *)scrollView{
    
    if (!_scrollView) {
        _scrollView = [[JWScrollView alloc]init];
        _scrollView.frame = CGRectMake(0, 0, kScreenWidth, kScreenHeight-64);
        _scrollView.alwaysBounceVertical = true;
        _scrollView.paddingHeight = 20;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    JWScrollviewCell * cell1 = [self creatCell1];
    
    NSMutableArray * uiArr = [NSMutableArray arrayWithCapacity:10];
    [uiArr addObject:cell1];
    
    for (int i = 0; i< self.list.count; i++) {
        JWScrollviewCell * cell  = [self creatCell2:self.list[i]];
        [uiArr addObject:cell];
    }
    
    [self.scrollView setScrollviewSubViewsArr:uiArr];
    
}

-(JWScrollviewCell *)creatCell1{
    
    JWScrollviewCell * item = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 52)];
    
    JWLabel * titleLab1 = [[JWLabel alloc]initWithFrame:CGRectMake(20, adaptY(20), kScreenWidth-60,adaptY(30))];
    titleLab1.text = @"Frequently";
    titleLab1.font = kMediumFont(25);
    titleLab1.isShadow = true;
    titleLab1.colors = commonColorS;
    [item.contentView addSubview:titleLab1];
    
    JWLabel * titleLab2 = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLab1.frame), kScreenWidth-60, adaptY(30))];
    titleLab2.text = @"Asked";
    titleLab2.font = kMediumFont(25);
    titleLab2.isShadow = true;
    titleLab2.colors = commonColorS;
    [item.contentView addSubview:titleLab2];
    
    
    JWLabel * titleLab3 = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLab2.frame), kScreenWidth-60, adaptY(30))];
    titleLab3.text = @"Questions";
    titleLab3.font = kMediumFont(25);
    titleLab3.isShadow = true;
    titleLab3.colors = commonColorS;
    [item.contentView addSubview:titleLab3];
    
    
    item.contentView.height = CGRectGetMaxY(item.contentView.subviews.lastObject.frame);
    
    [item setUPSpacing:0 andDownSpacing:0];
    
    return item;
    
}

-(JWScrollviewCell *)creatCell2:(NSDictionary *)dict{
    
    JWScrollviewCell * item = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 52)];
    
    JWLabel * titleLab1 = [[JWLabel alloc]initWithFrame:CGRectMake(20, 20, kScreenWidth-40, 30)];
    titleLab1.text = dict[@"title"];
    titleLab1.font = kMediumFont(20);
    titleLab1.textColor = commonBlackBtnColor;
    titleLab1.numberOfLines = 0;
    titleLab1.height = [titleLab1 getLabelSize:titleLab1].height;
    [item.contentView addSubview:titleLab1];
    
    
    JWLabel * titleLab2 = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLab1.frame)+5, kScreenWidth-40, 25)];
    titleLab2.text = dict[@"subTitle"];
    titleLab2.font = kLightFont(13);
    titleLab2.numberOfLines = 0;
    titleLab2.textColor = commonBlackBtnColor;
    titleLab2.height = [titleLab2 getLabelSize:titleLab2].height+10;
    [item.contentView addSubview:titleLab2];
    
    item.contentView.height = CGRectGetMaxY(item.contentView.subviews.lastObject.frame);
    
    [item setUPSpacing:0 andDownSpacing:0];
    
    return item;
    
}



@end
