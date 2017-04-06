//
//  BillingStatementProcessingController.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/24.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "BillingStatementProcessingController.h"

@interface BillingStatementProcessingController ()
@property (nonatomic,strong) JWScrollView * scrollView;
@end

@implementation BillingStatementProcessingController

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
    
    JWScrollviewCell * cell1 = [self creatCell1];
    
    JWScrollviewCell * cell2 = [self creatCell2];
    
    JWScrollviewCell * cell3 = [self creatTipCell];
    
    [self.scrollView setScrollviewSubViewsArr:@[cell1,cell2,cell3].mutableCopy];
 
    
}

-(JWScrollviewCell *)creatCell1{
    
    JWScrollviewCell * item = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 52)];
    
    JWLabel * titleLab1 = [[JWLabel alloc]initWithFrame:CGRectMake(20, adaptY(20), kScreenWidth-60, adaptY(30))];
    titleLab1.text = @"Billing";
    titleLab1.font = kMediumFont(25);
    titleLab1.isShadow = true;
    titleLab1.colors = commonColorS;
    [item.contentView addSubview:titleLab1];
    
    JWLabel * titleLab2 = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLab1.frame), kScreenWidth-60, adaptY(30))];
    titleLab2.text = @"Statement";
    titleLab2.font = kMediumFont(25);
    titleLab2.isShadow = true;
    titleLab2.colors = commonColorS;
    [item.contentView addSubview:titleLab2];
    
    
    UIButton * imageViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageViewBtn.frame = CGRectMake(kScreenWidth - 80 -20-10, titleLab1.y, 80, 70);
    [imageViewBtn setImage:[UIImage imageNamed:@"Intreatment-1"] forState:UIControlStateNormal];
    imageViewBtn.userInteractionEnabled = false;
    [item.contentView addSubview:imageViewBtn];
    
    
    JWLabel * titleLab3 = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLab2.frame)+20, kScreenWidth-40, 35)];
    titleLab3.text = @"We are processing your submission and we will notify you once it’s finished or contact you if we have any questions. Thanks!";
    titleLab3.font = kMediumFont(14);
    titleLab3.textColor = commonBlackBtnColor;
    titleLab3.numberOfLines = 0;
    titleLab3.height = [titleLab3 getLabelSize:titleLab3].height;
    [item.contentView addSubview:titleLab3];
    
    
    item.contentView.height = CGRectGetMaxY(item.contentView.subviews.lastObject.frame);
    
    [item setUPSpacing:0 andDownSpacing:0];
    
    return item;
}


-(JWScrollviewCell *)creatCell2{
    
    JWScrollviewCell * item = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 52)];
    
    
    UIImageView * imageView= [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth -301/2)/2, 30, 301/2, 392/2)];
    imageView.image = [UIImage imageNamed:@"default-1"];
    [item.contentView addSubview:imageView];
    
    item.contentView.height = CGRectGetMaxY(item.contentView.subviews.lastObject.frame)+30;
    
    [item setUPSpacing:0 andDownSpacing:0];
    
    return item;
    
}

-(JWScrollviewCell *)creatTipCell{
    
    JWScrollviewCell * item = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 52)];
    
    JWLabel * titleLab3 = [[JWLabel alloc]initWithFrame:CGRectMake(20, 10, kScreenWidth-40, 35)];
    titleLab3.font = kMediumFont(10);
    titleLab3.textColor = commonGrayBtnColor;
    titleLab3.labelAnotherFont = kLightFont(10);
    titleLab3.text = @"Note: [Processing time may take up to 3 days. We will notify or contact you as we process your documents. Thank you! :)]";
    titleLab3.numberOfLines = 0;
    titleLab3.height = [titleLab3 getLabelSize:titleLab3].height;
    [item.contentView addSubview:titleLab3];
    
    item.contentView.height = CGRectGetMaxY(item.contentView.subviews.lastObject.frame);
    
    [item setUPSpacing:0 andDownSpacing:0];
    
    return item;
    
}

@end
