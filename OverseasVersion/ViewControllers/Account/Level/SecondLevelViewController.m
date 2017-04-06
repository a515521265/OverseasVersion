//
//  SecondLevelViewController.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/22.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "SecondLevelViewController.h"

#import "SubmitGovernmentIDViewController.h"

#import "SubmitSelfieViewController.h"

#import "SubmitSecurityDetailsViewController.h"

#import "OtherTool.h"

#import "LevelModel.h"



#import "SelfiePocessingViewController.h"
#import "GovernmentIDProcessingController.h"
#import "SecurityDetailsSuccessController.h"


#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface SecondLevelViewController ()<FBSDKSharingDelegate>


@property (nonatomic,strong) JWScrollView * scrollView;

@property (nonatomic,strong) JWScrollviewCell * cell1;

@property (nonatomic,strong) JWScrollviewCell * cell2;

@property (nonatomic,strong) JWScrollviewCell * cell3;

@property (nonatomic,strong) JWScrollviewCell * cell4;

@property (nonatomic,strong) NSMutableArray * modelArr;

@property (nonatomic,strong) JWLabel * tipLab;

@end

@implementation SecondLevelViewController

-(NSMutableArray *)modelArr{

    if (!_modelArr) {
        _modelArr = [NSMutableArray arrayWithCapacity:10];
    }
    
    return _modelArr;
    
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

static NSInteger integer = 0 ;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    integer = 0;
    
    JWScrollviewCell * cell1 = [self creatCell1];
    
    self.cell1 = cell1;
    
    
    UIView * whiteView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    
    
    JWScrollviewCell * cell2 = [self creatCell2:@{@"title":@"Government ID",
                                                  @"subTitle":@"Please click here to submit one (1) Government ID.",
                                                  @"type":@"1"}];
    self.cell2 = cell2;
    
    JWScrollviewCell * cell3 = [self creatCell2:@{@"title":@"Selfie with government ID",
                                                  @"subTitle":@"Please click here to take a photo or uload a photo of yourself holding a Government ID.",
                                                  @"type":@"2"}];
    self.cell3 = cell3;
    
    JWScrollviewCell * cell4 = [self creatCell2:@{@"title":@"Security Details",
                                                  @"subTitle":@"Please click here to complete our security details form.",
                                                  @"type":@"3"}];
    self.cell4 = cell4;
    
    JWScrollviewCell * cell5 = [self creatFacebookCell];
    
    [self.scrollView setScrollviewSubViewsArr:@[cell1,whiteView,cell2,cell3,cell4,cell5].mutableCopy];
    
    [self addtipLabel];
    
    [self getlevel];
    
}



-(JWScrollviewCell *)creatCell1{
    
    JWScrollviewCell * item = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 52)];
    
    JWLabel * titleLab1 = [[JWLabel alloc]initWithFrame:CGRectMake(20, adaptY(20), kScreenWidth-60, adaptY(30))];
    titleLab1.text = @"Level 2";
    titleLab1.font = kMediumFont(25);
    titleLab1.isShadow = true;
    titleLab1.colors = commonColorS;
    [item.contentView addSubview:titleLab1];
    
    JWLabel * titleLab2 = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLab1.frame), kScreenWidth-60, adaptY(30))];
    titleLab2.text = @"Certified";
    titleLab2.font = kMediumFont(25);
    titleLab2.isShadow = true;
    titleLab2.colors = commonColorS;
    [item.contentView addSubview:titleLab2];
    
    
    UIButton * imageViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageViewBtn.frame = CGRectMake(kScreenWidth - 80 -20-10, titleLab1.y, 80, 70);
    [imageViewBtn setImage:[UIImage imageNamed:@"wrong-2"] forState:UIControlStateNormal];
    imageViewBtn.userInteractionEnabled = false;
    imageViewBtn.tag = 1777;
    [item.contentView addSubview:imageViewBtn];
    
    
    JWLabel * titleLab3 = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLab2.frame)+20, kScreenWidth-40, 35)];
    titleLab3.text = @"To be a “Level 2 Certified” PICA user, please submit the missing documents";
    titleLab3.font = kLightFont(13);
    titleLab3.numberOfLines = 0 ;
    titleLab3.height = [titleLab3 getLabelSize:titleLab3].height;
    titleLab3.tag = 1888;
    [item.contentView addSubview:titleLab3];
    
    
    item.contentView.height = CGRectGetMaxY(item.contentView.subviews.lastObject.frame);
    
    [item setUPSpacing:0 andDownSpacing:0];
    
    return item;
    
}


-(JWScrollviewCell *)creatCell2:(NSDictionary *)dict{
    
    JWScrollviewCell * item = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 52)];
    
    JWLabel * titleLab1 = [[JWLabel alloc]initWithFrame:CGRectMake(20, 10, kScreenWidth-40, adaptY(25))];
    titleLab1.text = dict[@"title"];
    titleLab1.font = kMediumFont(13);
    [item.contentView addSubview:titleLab1];
    
    UIButton * imageViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageViewBtn.frame = CGRectMake(kScreenWidth - adaptX(25) -20, titleLab1.y, adaptX(25), adaptX(25));
    [imageViewBtn setImage:[UIImage imageNamed:@"wrong-1"] forState:UIControlStateNormal];
    imageViewBtn.userInteractionEnabled = false;
    imageViewBtn.tag = 1999;
    [item.contentView addSubview:imageViewBtn];
    
    
    JWLabel * titleLab2 = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLab1.frame), kScreenWidth-40, adaptY(25))];
    titleLab2.text = dict[@"subTitle"];
    
    if ([dict[@"type"] isEqualToString:@"1"]) {

        NSRange contentRange = {0,17};
        [OtherTool addUnderlineLabel:titleLab2 labText:titleLab2.text range:contentRange];
        
    }else if ([dict[@"type"] isEqualToString:@"2"]) {
        NSRange contentRange = {0,17};
        [OtherTool addUnderlineLabel:titleLab2 labText:titleLab2.text range:contentRange];
        
    }else if ([dict[@"type"] isEqualToString:@"3"]){
        
        NSRange contentRange = {0,17};
        [OtherTool addUnderlineLabel:titleLab2 labText:titleLab2.text range:contentRange];
    }
    
    titleLab2.font = kLightFont(12);
    titleLab2.numberOfLines = 0;
    titleLab2.tag = 2000;
    titleLab2.height = [titleLab2 getLabelSize:titleLab2].height;
    HXWeak_self
    [titleLab2 addSingleTapEvent:^{
       HXStrong_self

        
        
        if ([dict[@"type"] isEqualToString:@"1"]) {
            
            LevelModel * model = self.cell2.model;
            
            if (model.status==1) {
                
            }else if (model.status==2){
                
                [self.navigationController pushViewController:[GovernmentIDProcessingController new] animated:true];
            
            }else if (model.status==-1){
                SubmitGovernmentIDViewController * subVC = [SubmitGovernmentIDViewController new];
                [self.navigationController pushViewController:subVC animated:true];
            }else{
                SubmitGovernmentIDViewController * subVC = [SubmitGovernmentIDViewController new];
                [self.navigationController pushViewController:subVC animated:true];
            }
            

            
        }else if ([dict[@"type"] isEqualToString:@"2"]) {
        
            
            LevelModel * model = self.cell3.model;
            
            if (model.status==1) {
                
            }else if (model.status==2){
                
                [self.navigationController pushViewController:[SelfiePocessingViewController new] animated:true];
                
            }else if (model.status==-1){
                SubmitSelfieViewController * subselfie = [SubmitSelfieViewController new];
                [self.navigationController pushViewController:subselfie animated:true];
            }else{
                SubmitSelfieViewController * subselfie = [SubmitSelfieViewController new];
                [self.navigationController pushViewController:subselfie animated:true];
            }
            
        }else if ([dict[@"type"] isEqualToString:@"3"]){
        
            LevelModel * model = self.cell4.model;
            if (model.status==1) {
                SecurityDetailsSuccessController * detailsVC = [SecurityDetailsSuccessController new];
                detailsVC.success = true;
                [self.navigationController pushViewController:detailsVC animated:true];
            }else if (model.status==2){
                [self.navigationController pushViewController:[SecurityDetailsSuccessController new] animated:true];
            }else if (model.status==-1){
                SubmitSecurityDetailsViewController * securityVC = [SubmitSecurityDetailsViewController new];
                [self.navigationController pushViewController:securityVC animated:true];
            }else{
                SubmitSecurityDetailsViewController * securityVC = [SubmitSecurityDetailsViewController new];
                [self.navigationController pushViewController:securityVC animated:true];
            }
            
        }
        
    }];
    [item.contentView addSubview:titleLab2];
    
    
    item.contentView.height = CGRectGetMaxY(item.contentView.subviews.lastObject.frame)+10;
    
    [item setUPSpacing:0 andDownSpacing:0];
    
    return item;
    
}

-(JWScrollviewCell *)creatFacebookCell{
    
    JWScrollviewCell * item = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 52)];
    
    JWLabel * titleLab1 = [[JWLabel alloc]initWithFrame:CGRectMake(20,adaptY(20), kScreenWidth-60, adaptY(25))];
    titleLab1.text = @"Facebook";
    titleLab1.font = kMediumFont(15);
    [item.contentView addSubview:titleLab1];
    
    JWLabel * subTitleLab = [[JWLabel alloc]initWithFrame:CGRectMake(kScreenWidth-adaptX(140)-20, titleLab1.y, adaptX(140) , adaptY(20))];
    subTitleLab.text = @"Connect with Facebook";
    subTitleLab.font = kLightFont(10);
    subTitleLab.layer.cornerRadius =2;
    subTitleLab.layer.masksToBounds =true;
    subTitleLab.textAlignment = 1;
    subTitleLab.layer.borderWidth = 1;
    subTitleLab.textColor = UIColorFromRGB(0x407edb);
    subTitleLab.layer.borderColor = UIColorFromRGB(0x407edb).CGColor;
    [item addSubview:subTitleLab];
    
    
    HXWeak_self
    [subTitleLab addSingleTapEvent:^{
        HXStrong_self
        [self facebookshare];
    }];
    
    
    JWLabel * titleLab2 = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLab1.frame), kScreenWidth-40, adaptY(25))];
    titleLab2.text = @"Connect your Facebook account now for more rewards!";
    titleLab2.font = kLightFont(12);
    titleLab2.numberOfLines = 0;
    titleLab2.height = [titleLab2 getLabelSize:titleLab2].height;
    [item.contentView addSubview:titleLab2];
    
    
    item.contentView.height = CGRectGetMaxY(item.contentView.subviews.lastObject.frame)+10;
    
    [item setUPSpacing:0 andDownSpacing:0];
    
    return item;
    
}


-(void)facebookshare{
    
    [self submitShareImage:[UIImage imageWithScreenshot] success:^(NSString *imageStr) {
        FBSDKShareLinkContent *content = [[FBSDKShareLinkContent alloc] init];
        content.contentURL = [NSURL URLWithString:imageStr];
        content.contentTitle = @"Level 2";
        [FBSDKShareDialog showFromViewController:self withContent:content delegate:self];
    }];
    
}

#pragma mark facebook delegate
- (void)sharer:(id<FBSDKSharing>)sharer didCompleteWithResults:(NSDictionary *)results{
    
    //    [FBSDKShareAPI shareWithContent:nil delegate:nil];
}

- (void)sharer:(id<FBSDKSharing>)sharer didFailWithError:(NSError *)error{
    
    //    [FBSDKShareAPI shareWithContent:nil delegate:nil];
}

- (void)sharerDidCancel:(id<FBSDKSharing>)sharer{
    //    [FBSDKShareAPI shareWithContent:nil delegate:nil];
}

-(void)addtipLabel{

    JWLabel * lab = [[JWLabel alloc]initWithFrame:CGRectMake(20, kScreenHeight-110, kScreenWidth-40, 20)];
    
    lab.font = kMediumFont(10);
    lab.textColor = commonGrayBtnColor;
    lab.labelAnotherFont = kLightFont(10);
    lab.text = @"Note: [Processing time may take up to 3 days. We will notify or contact you as we process your documents. Thank you! :)]";
    lab.numberOfLines = 0;
    lab.height = [lab getLabelSize:lab].height;
    lab.frame = CGRectMake(20, kScreenHeight - 64 - lab.height-10, kScreenWidth-40, lab.height);
    [self.view addSubview:lab];
    
    self.tipLab = lab;

}

-(void)getlevel{
    
    [self showHud];
    [CommonService requestgetUserInfoExtaccess_token:self.defaultSetting.access_token level:2 success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
            
            [self.modelArr removeAllObjects];
            
            for (NSDictionary *dict in responseObject[@"data"]) {
                LevelModel * model = [LevelModel yy_modelWithDictionary:dict];
                [self.modelArr addObject:model];
            }
            [self setViewdata];
        }else{
            [self showTip:[responseObject objectForKey:@"errorMessage"]];
        }
        [self closeHud];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self closeHud];
        [self errorDispose:[[operation response] statusCode] judgeMent:nil];
    }];
}


-(void)setViewdata{

    for (int i=0; i<self.modelArr.count; i++) {
        
        LevelModel * model = self.modelArr[i];
        
        if ([model.type isEqualToString:@"1"]) {
            
            self.cell2.model = model;
            if (model.status == 1) {
                [((UIButton *) self.cell2.getElementByTag(1999)) setImage:[UIImage imageNamed:@"Check-1"] forState:UIControlStateNormal];
                integer ++;
                ((JWLabel *) self.cell2.getElementByTag(2000)).text = @"Data audit success";
            }else if (model.status == 2){
                [((UIButton *) self.cell2.getElementByTag(1999)) setImage:[UIImage imageNamed:@"Intreatment-1"] forState:UIControlStateNormal];
                ((JWLabel *) self.cell2.getElementByTag(2000)).text = @"Information is under review...";
            }else if (model.status == -1){
                [((UIButton *) self.cell2.getElementByTag(1999)) setImage:[UIImage imageNamed:@"wrong-1"] forState:UIControlStateNormal];
                ((JWLabel *) self.cell2.getElementByTag(2000)).text = @"Data review failed, please upload";
            }
            
        }else if ([model.type isEqualToString:@"2"]){
            self.cell3.model = model;
            if (model.status == 1) {
                [((UIButton *) self.cell3.getElementByTag(1999)) setImage:[UIImage imageNamed:@"Check-1"] forState:UIControlStateNormal];
                ((JWLabel *) self.cell3.getElementByTag(2000)).text = @"Data audit success";
                integer ++;
            }else if (model.status == 2){
                [((UIButton *) self.cell3.getElementByTag(1999)) setImage:[UIImage imageNamed:@"Intreatment-1"] forState:UIControlStateNormal];
                ((JWLabel *) self.cell3.getElementByTag(2000)).text = @"Information is under review...";
            }else if (model.status == -1){
                [((UIButton *) self.cell3.getElementByTag(1999)) setImage:[UIImage imageNamed:@"wrong-1"] forState:UIControlStateNormal];
                ((JWLabel *) self.cell3.getElementByTag(2000)).text = @"Data review failed, please upload";
            }
        }else if ([model.type isEqualToString:@"3"]){
            self.cell4.model = model;
            if (model.status == 1) {
                integer ++;
                [((UIButton *) self.cell4.getElementByTag(1999)) setImage:[UIImage imageNamed:@"Check-1"] forState:UIControlStateNormal];
                ((JWLabel *) self.cell4.getElementByTag(2000)).text = @"Data audit success";
            }else if (model.status == 2){
                [((UIButton *) self.cell4.getElementByTag(1999)) setImage:[UIImage imageNamed:@"Intreatment-1"] forState:UIControlStateNormal];
                ((JWLabel *) self.cell4.getElementByTag(2000)).text = @"Information is under review...";
            }else if (model.status == -1){
                [((UIButton *) self.cell4.getElementByTag(1999)) setImage:[UIImage imageNamed:@"wrong-1"] forState:UIControlStateNormal];
                ((JWLabel *) self.cell4.getElementByTag(2000)).text = @"Data review failed, please upload";
            }
        }
        
    }
    
    
    if (integer==3) {
        
         [((UIButton *)self.cell1.getElementByTag(1777)) setImage:[UIImage imageNamed:@"Check-2"] forState:UIControlStateNormal];
        ((JWLabel *)self.cell1.getElementByTag(1888)).text = @"You are now a “Level 2 Certified” PICA user!\nYou can now Cash Out a maximum amount of P10,000.00 per day through our Cash Out partners and through Bank Deposit.";
        ((JWLabel *)self.cell1.getElementByTag(1888)).height = [((JWLabel *)self.cell1.getElementByTag(1888)) getLabelSize:((JWLabel *)self.cell1.getElementByTag(1888))].height;
        self.cell1.contentView.height = CGRectGetMaxY(self.cell1.contentView.subviews.lastObject.frame);
        [self.cell1 refreshSubviews];
        [self.scrollView reloadViews];
        
        self.tipLab.hidden = true;
    }
    
}

@end
