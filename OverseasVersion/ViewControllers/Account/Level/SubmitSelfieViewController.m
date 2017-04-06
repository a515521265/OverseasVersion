//
//  SubmitSelfieViewController.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/23.
//  Copyright © 2017年 梁家文. All rights reserved.
//

//上传自拍
#import "SubmitSelfieViewController.h"

#import "ShadowView.h"

#import "HXSelectPicture.h"

#import "SelfiePocessingViewController.h"

@interface SubmitSelfieViewController ()

@property (nonatomic,strong) JWScrollView * scrollView;

@property (nonatomic,strong) UIImageView * slefieImageView;

@property (nonatomic,strong) JWLabel * tipLab;

@property (nonatomic,strong) NSString * submitUrl;

@end

@implementation SubmitSelfieViewController

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
    
    JWScrollviewCell * cell3 = [self creatSubmitCell];
    
    [self.scrollView setScrollviewSubViewsArr:@[cell1,cell2,cell3].mutableCopy];
    
    
    HXWeak_self
    [self createTitleBarButtonItemStyle:BtnRightType title:@"Next" TapEvent:^{
        HXStrong_self
        [self submitGovernmentIDStr];
    }];
    
}

-(JWScrollviewCell *)creatCell2{
    
    JWScrollviewCell * item = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 52)];
    
    
    UIImageView * slefieImageView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth - adaptX(130))/2, 30, adaptX(130), adaptY(175.5))];
    
    slefieImageView.image = [UIImage imageNamed:@"default-2"];
    
    [item.contentView addSubview:slefieImageView];
    self.slefieImageView = slefieImageView;
    

    JWLabel * titleLab = [[JWLabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(slefieImageView.frame), kScreenWidth-60, 35)];
    titleLab.text = @"Example selfie";
    titleLab.font = kItalicFont(10);
    titleLab.textColor = commonGrayBtnColor;
    titleLab.textAlignment =1;
    [item.contentView addSubview:titleLab];
    self.tipLab = titleLab;
    
    item.contentView.height = CGRectGetMaxY(item.contentView.subviews.lastObject.frame)+20;
    
    [item setUPSpacing:0 andDownSpacing:0];
    
    return item;
    
}


-(JWScrollviewCell *)creatCell1{
    
    JWScrollviewCell * item = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 52)];
    
    JWLabel * titleLab1 = [[JWLabel alloc]initWithFrame:CGRectMake(20, adaptY(20), kScreenWidth-60, adaptY(30))];
    titleLab1.text = @"Selfie with";
    titleLab1.font = kMediumFont(25);
    titleLab1.isShadow = true;
    titleLab1.colors = commonColorS;
    [item.contentView addSubview:titleLab1];
    
    JWLabel * titleLab2 = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLab1.frame), kScreenWidth-60, adaptY(30))];
    titleLab2.text = @"Government ID";
    titleLab2.font = kMediumFont(25);
    titleLab2.isShadow = true;
    titleLab2.colors = commonColorS;
    [item.contentView addSubview:titleLab2];
    
    
    UIButton * imageViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageViewBtn.frame = CGRectMake(kScreenWidth - 80 -20-10, titleLab1.y, 80, 70);
    [imageViewBtn setImage:[UIImage imageNamed:@"wrong-2"] forState:UIControlStateNormal];
    imageViewBtn.userInteractionEnabled = false;
    [item.contentView addSubview:imageViewBtn];
    
    
    JWLabel * titleLab3 = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLab2.frame)+20, kScreenWidth-40, 35)];
    titleLab3.text = @"For faster processing please submit one (1) selfie following the format below:";
    titleLab3.font = kLightFont(14);
    titleLab3.textColor = commonBlackBtnColor;
    titleLab3.numberOfLines = 0;
    titleLab3.height = [titleLab3 getLabelSize:titleLab3].height;
    [item.contentView addSubview:titleLab3];
    
    
    item.contentView.height = CGRectGetMaxY(item.contentView.subviews.lastObject.frame);
    
    [item setUPSpacing:0 andDownSpacing:0];
    
    return item;
    
}

-(JWScrollviewCell *)creatSubmitCell{
    
    JWScrollviewCell * item = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    
    
    ShadowView * SubmitBtn = [[ShadowView alloc] initWithFrame:
                              CGRectMake(20,10,kScreenWidth-40,ShadowViewHeight)];
    SubmitBtn.colors =commonColorS;
    [SubmitBtn addSingleTapEvent:^{
        [self submitGovernmentIDImage];
    }];
    [item.contentView addSubview:SubmitBtn];
    
    JWLabel * SubmitBtnLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, SubmitBtn.y, SubmitBtn.width, SubmitBtn.height)];
    SubmitBtnLab.text = Internationalization(@"上传自拍", @"Submit Selfie");
    SubmitBtnLab.textAlignment = 1;
    SubmitBtnLab.textColor = [UIColor whiteColor];
    SubmitBtnLab.font = kMediumFont(14);
    [item.contentView addSubview:SubmitBtnLab];
    
    JWLabel * tipLab = [[JWLabel alloc]initWithFrame:CGRectMake(30, CGRectGetMaxY(SubmitBtn.frame)+20, kScreenWidth-60, 10)];
    tipLab.text = @"Click the button above to take a selfie holding your Government ID or upload one.";
    tipLab.textColor = commonGrayBtnColor;
    tipLab.numberOfLines = 0;
    tipLab.textAlignment = 1;
    tipLab.font = kMediumFont(12);
    tipLab.height = [tipLab getLabelSize:tipLab].height + 10;
    
    [item.contentView addSubview:tipLab];
    
    
    item.contentView.height = CGRectGetMaxY(item.contentView.subviews.lastObject.frame);
    
    [item setUPSpacing:0 andDownSpacing:0];
    
    return item;
    
}


-(void)submitGovernmentIDImage{
    
    HXWeak_self
    [HXSelectPicture showImagePickerFromViewController:self allowsEditing:false finishAction:^(UIImage *image) {
        HXStrong_self
        if (image) {
            HXWeak_self
            [self submitShareImage:image success:^(NSString *imageStr) {
                HXStrong_self
                self.tipLab.hidden = true;
                self.slefieImageView.image = image;
                self.submitUrl = imageStr;
            }];
        }
    }];
    
}

-(void)submitGovernmentIDStr{
    
    if (!self.submitUrl.length) {
        
        [self showTip:@"Please upload a picture"];
        
        return;
    }
    
    [self submintselfie];
}

-(void)submintselfie{

    customHUD * hud = [[customHUD alloc]init];
    [hud showCustomHUDWithView:self.view];
    
    [CommonService requestuploadSelfieGovernmentIdOfaccess_token:self.defaultSetting.access_token picUrl:self.submitUrl success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
            [self certificationViewControllerSPush:[SelfiePocessingViewController new]];
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
