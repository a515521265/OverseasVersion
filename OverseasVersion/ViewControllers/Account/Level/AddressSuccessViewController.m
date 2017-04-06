//
//  AddressSuccessViewController.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/24.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "AddressSuccessViewController.h"

#import "AttestationModel.h"

@interface AddressSuccessViewController ()

@property (nonatomic,strong) JWScrollView * scrollView;

@property (nonatomic,strong) NSMutableArray * list;

@property (nonatomic,strong) NSMutableArray * viewUIArr;

@property (nonatomic,strong) AttestationModel * serviceModel;

@end

@implementation AddressSuccessViewController

-(NSMutableArray *)viewUIArr{
    
    if (!_viewUIArr) {
        _viewUIArr = [NSMutableArray arrayWithCapacity:10];
    }
    return _viewUIArr;
}


-(NSMutableArray *)list{
    
    if (!_list) {
        _list = @[@{@"title":@"Unit / House Number, Street, Village Name",
                    @"subTitle":@"*******************"},
                  
                  
                  @{@"title":@"Barangay Name",
                    @"subTitle":@"************"},
                  
                  
                  @{@"title":@"City",
                    @"subTitle":@"***"},
                  
                  
                  @{@"title":@"Province / Region / State",
                    @"subTitle":@"***"}
                  
                  
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
    titleLab1.text = @"Residential";
    titleLab1.font = kMediumFont(25);
    titleLab1.isShadow = true;
    titleLab1.colors = commonColorS;
    [item.contentView addSubview:titleLab1];
    
    
    UIButton * imageViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageViewBtn.frame = CGRectMake(kScreenWidth - 80 -20-10, titleLab1.y, 80, 70);
    
    if (self.success) {
        [imageViewBtn setImage:[UIImage imageNamed:@"Check-2"] forState:UIControlStateNormal];
    }else{
        [imageViewBtn setImage:[UIImage imageNamed:@"Intreatment-1"] forState:UIControlStateNormal];
    }
    imageViewBtn.userInteractionEnabled = false;
    [item.contentView addSubview:imageViewBtn];
    

    
    JWLabel * titleLab2 = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLab1.frame), kScreenWidth-60, adaptY(30))];
    titleLab2.text = @"Address";
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
    
    
    JWLabel * Countrylab = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(tipLab1.frame), tipLab1.width, 30)];
    Countrylab.text = @"PHILIPPINES";
    Countrylab.font = kLightFont(14);
    Countrylab.textColor = commonBlackBtnColor;
    [item.contentView addSubview:Countrylab];
    
    
    JWTextField * textfield = [[JWTextField alloc]initWithFrame:CGRectMake(CGRectGetMaxX(Countrylab.frame), Countrylab.y, Countrylab.width, 30)];
    textfield.font = kLightFont(14);
    textfield.text = @"****";
    textfield.tag = 1888;
    textfield.textColor = commonBlackBtnColor;
    [item.contentView addSubview:textfield];
    
    
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
    [CommonService requestmyAddressaccess_token:self.defaultSetting.access_token success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HXStrong_self
        if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {

            AttestationModel * mode = [AttestationModel yy_modelWithDictionary:responseObject[@"data"]];
            
            self.serviceModel = mode;
            
            [self.list removeAllObjects];
            
            
            self.list = @[@{@"title":@"Unit / House Number, Street, Village Name",
                            @"subTitle":mode.address ? mode.address:@""},
                          
                          @{@"title":@"Barangay Name",
                            @"subTitle":mode.barangay? mode.barangay:@""},
                          
                          @{@"title":@"City",
                            @"subTitle":mode.city? mode.city:@""},
                          
                          @{@"title":@"Province / Region / State",
                            @"subTitle":mode.province? mode.province:@""},
                          
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
    
    JWScrollviewCell * postCodecell = [self addPostCodecell];
    [self.viewUIArr addObject:postCodecell];
    ((JWTextField *)postCodecell.getElementByTag(1888)).text = self.serviceModel.postCode;
    
    JWScrollviewCell * tipCell = [self creatTipCell];
    [self.viewUIArr addObject:tipCell];
    
    [self.scrollView setScrollviewSubViewsArr:self.viewUIArr];
    
}


@end
