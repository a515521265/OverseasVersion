//
//  AboutUsViewController.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/22.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()
@property (nonatomic,strong) JWScrollView * scrollView;

@property (nonatomic,strong) NSMutableArray * list;

@end

@implementation AboutUsViewController

-(NSMutableArray *)list{

    if (!_list) {
        _list = @[@{@"title":@"Where is PICA from?",
                    @"subTitle":@"PICA is a product of PICA Pinas Technologies Inc., a Filipino company incorporated in the Philippines."},
                  
                  
                  @{@"title":@"What is PICA?",
                    @"subTitle":@"PICA, is the best mobile payment solution in the Philippines. We allow users to make payments by scanning a QR code; receive money through the app; pay bills and buy prepaid load; and many more to come!"},
                  
                  
                  @{@"title":@"Our Mission",
                    @"subTitle":@"Our mission to you, our users, is to provide a seamless payment experience"},
                  
                  
                  @{@"title":@"Our Vision",
                    @"subTitle":@"Is to turn Philippines into a cash-less society. We see a bright future for the Philippines, and we believe that the country can be a cash-less society in 10 years. We know the positive impacts a digital economy brings, and we know how to get there. With your participation we can achieve this goal."}
                  
                  
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
    
    
    
//    [self requestQueueWithURL:@[[NSString stringWithFormat:@"%@/pica/userAccountInfo",BaseUrl],
//                                [NSString stringWithFormat:@"%@/pica/userInfo",BaseUrl],
//                                [NSString stringWithFormat:@"%@/pica/depositsList",BaseUrl]]
//                     withDict:@[@{@"access_token":self.defaultSetting.access_token},
//                                @{@"access_token":self.defaultSetting.access_token},
//                                @{@"access_token":self.defaultSetting.access_token}]
//                      success:^(NSMutableArray<ResponseModel *> *responseArr) {
//                          
//                          NSLog(@"请求结果-----%lu",(unsigned long)responseArr.count);
//
//                          for (int i = 0; i< responseArr.count; i++) {
//                              ResponseModel * mode = responseArr[i];
//                              if (mode.status==1) {
//                                  NSLog(@"数据%@ \n编号%ld",mode.responseObject,(long)mode.number);
//                              }else{
//                                  NSLog(@"错误%@  \n编号%ld",mode.error,(long)mode.number);
//                              }
//                              
//                          }
//                        
//                      }];
    
    
}

-(JWScrollviewCell *)creatCell1{
    
    JWScrollviewCell * item = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 52)];
    
    JWLabel * titleLab1 = [[JWLabel alloc]initWithFrame:CGRectMake(20, adaptY(20), kScreenWidth-60, adaptY(30))];
    titleLab1.text = @"About";
    titleLab1.font = kMediumFont(25);
    titleLab1.isShadow = true;
    titleLab1.colors = commonColorS;
    [item.contentView addSubview:titleLab1];
    
    JWLabel * titleLab2 = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLab1.frame), kScreenWidth-60, adaptY(30))];
    titleLab2.text = @"Us";
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
    titleLab1.font = kMediumFont(20);
    titleLab1.textColor = commonBlackBtnColor;
    [item.contentView addSubview:titleLab1];
    
    
    JWLabel * titleLab2 = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLab1.frame)+5, kScreenWidth-40, 25)];
    titleLab2.text = dict[@"subTitle"];
    titleLab2.font = kLightFont(13);
    titleLab2.numberOfLines = 0;
    titleLab2.textColor = commonBlackBtnColor;
    titleLab2.height = [titleLab2 getLabelSize:titleLab2].height+20;
    [item.contentView addSubview:titleLab2];
    
    item.contentView.height = CGRectGetMaxY(item.contentView.subviews.lastObject.frame);
    
    [item setUPSpacing:0 andDownSpacing:0];
    
    return item;
    
}


@end
