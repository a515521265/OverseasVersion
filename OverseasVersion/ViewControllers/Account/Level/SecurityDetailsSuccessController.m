//
//  SecurityDetailsSuccessController.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/24.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "SecurityDetailsSuccessController.h"

#import "AttestationModel.h"

@interface SecurityDetailsSuccessController ()

@property (nonatomic,strong) JWScrollView * scrollView;

@property (nonatomic,strong) NSMutableArray * list;

@property (nonatomic,strong) NSMutableArray * viewUIArr;


@end

@implementation SecurityDetailsSuccessController

-(NSMutableArray *)viewUIArr{

    if (!_viewUIArr) {
        _viewUIArr = [NSMutableArray arrayWithCapacity:10];
    }
    return _viewUIArr;
}


-(NSMutableArray *)list{
    
    if (!_list) {
        _list = @[@{@"title":@"Birthday",
                    @"subTitle":@"****** **, ****"},
                  
                  
                  @{@"title":@"Sex",
                    @"subTitle":@"**"},
                  
                  
                  @{@"title":@"Security Question 1",
                    @"subTitle":@"******"},
                  
                  
                  @{@"title":@"Answer 1",
                    @"subTitle":@"******"},
                  
                  
                  @{@"title":@"Security Question 2",
                    @"subTitle":@"******"},
                  
                  
                  @{@"title":@"Answer 2",
                    @"subTitle":@"******"}
                  

                  
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
    
    [self.viewUIArr addObject:cell1];
    
    [self getUserSecurityDetails];
    
}

-(JWScrollviewCell *)creatCell1{
    
    JWScrollviewCell * item = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 52)];
    
    JWLabel * titleLab1 = [[JWLabel alloc]initWithFrame:CGRectMake(20, adaptY(20), kScreenWidth-60, adaptY(30))];
    titleLab1.text = @"Security";
    titleLab1.font = kMediumFont(25);
    titleLab1.isShadow = true;
    titleLab1.colors = commonColorS;
    [item.contentView addSubview:titleLab1];
    
    
    UIButton * imageViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageViewBtn.frame = CGRectMake(kScreenWidth - 80 -20-10, titleLab1.y, 80, 70);
//    [imageViewBtn setImage:[UIImage imageNamed:@"Intreatment-1"] forState:UIControlStateNormal];
    if (self.success) {
        [imageViewBtn setImage:[UIImage imageNamed:@"Check-2"] forState:UIControlStateNormal];
    }else{
        [imageViewBtn setImage:[UIImage imageNamed:@"Intreatment-1"] forState:UIControlStateNormal];
    }
    imageViewBtn.userInteractionEnabled = false;
    [item.contentView addSubview:imageViewBtn];
    
    JWLabel * titleLab2 = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLab1.frame), kScreenWidth-60, adaptY(30))];
    titleLab2.text = @"Details";
    titleLab2.font = kMediumFont(25);
    titleLab2.isShadow = true;
    titleLab2.colors = commonColorS;
    [item.contentView addSubview:titleLab2];
    
    
    item.contentView.height = CGRectGetMaxY(item.contentView.subviews.lastObject.frame);
    
    [item setUPSpacing:0 andDownSpacing:0];
    
    return item;
    
}

-(JWScrollviewCell *)creatCell2:(NSDictionary *)dict{
    
    JWScrollviewCell * item = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 52)];
    
    JWLabel * titleLab1 = [[JWLabel alloc]initWithFrame:CGRectMake(20, 20, kScreenWidth-40, 30)];
    titleLab1.text = dict[@"title"];
    titleLab1.font = kMediumFont(13);
    titleLab1.textColor = commonBlackBtnColor;
    titleLab1.numberOfLines = 0;
    titleLab1.height = [titleLab1 getLabelSize:titleLab1].height;
    [item.contentView addSubview:titleLab1];
    
    
    JWLabel * titleLab2 = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLab1.frame)+5, kScreenWidth-40, 25)];
    titleLab2.text = dict[@"subTitle"];
    titleLab2.font = kLightFont(12);
    titleLab2.numberOfLines = 0;
    titleLab2.textColor = commonBlackBtnColor;
    titleLab2.height = [titleLab2 getLabelSize:titleLab2].height+10;
    [item.contentView addSubview:titleLab2];
    
    item.contentView.height = CGRectGetMaxY(item.contentView.subviews.lastObject.frame);
    
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


-(void)getUserSecurityDetails{

    HXWeak_self
    [self showHud];
    [CommonService requestuserSecurityDetailsaccess_token:self.defaultSetting.access_token success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HXStrong_self
        if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
//            [self certificationViewControllerSPush:[BillingStatementProcessingController new]];
            AttestationModel * mode = [AttestationModel yy_modelWithDictionary:responseObject[@"data"]];
            
            [self.list removeAllObjects];
            
            NSString * birth = [NSString stringWithFormat:@"%@ **, ****",[NSString getMonth:[NSString stringWithdateFrom1970:mode.birthDay.longLongValue withFormat:@"MM"]]];
            
            
            self.list = @[@{@"title":@"Birthday",
                        @"subTitle":birth},
                      
                      @{@"title":@"Sex",
                        @"subTitle":mode.sex ? mode.sex:@""},
                      
                      @{@"title":@"Security Question 1",
                        @"subTitle":mode.question1? mode.question1:@""},
                      
                      @{@"title":@"Answer 1",
                        @"subTitle":mode.answer1? mode.answer1:@""},
                      
                      @{@"title":@"Security Question 2",
                        @"subTitle":mode.question2? mode.question2:@""},
                      
                      @{@"title":@"Answer 2",
                        @"subTitle":mode.answer2? mode.answer2:@""}
                      
                      ].mutableCopy;
            
            [self reloadViewdata];

        }else{
            
            [self showTip:[responseObject objectForKey:@"errorMessage"]];
            [self reloadViewdata];
        }
        [self closeHud];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HXStrong_self
        [self closeHud];
        [self errorDispose:[[operation response] statusCode] judgeMent:nil];
        [self reloadViewdata];
    }];
    
}

-(void)reloadViewdata{
    for (int i = 0; i< self.list.count; i++) {
        JWScrollviewCell * cell  = [self creatCell2:self.list[i]];
        [self.viewUIArr addObject:cell];
    }
    JWScrollviewCell * tipCell = [self creatTipCell];
    [self.viewUIArr addObject:tipCell];
    [self.scrollView setScrollviewSubViewsArr:self.viewUIArr];
}

@end
