//
//  FirstLevelViewController.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/22.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "FirstLevelViewController.h"

#import <FBSDKShareKit/FBSDKShareKit.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKShareKit/FBSDKShareKit.h>

@interface FirstLevelViewController ()<FBSDKSharingDelegate>
@property (nonatomic,strong) JWScrollView * scrollView;
@end

@implementation FirstLevelViewController

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
    
    JWScrollviewCell * cell2 = [self creatCell2:@{@"title":@"Full Name",
                                                  @"subTitle":@"Zairo Herrero Ko"}];
    
    JWScrollviewCell * cell3 = [self creatCell2:@{@"title":@"Email",
                                                 @"subTitle":@"*****@picapinas.com"}];
    
    JWScrollviewCell * cell4 = [self creatCell2:@{@"title":@"Cell number",
                                                  @"subTitle":@"+** *** *** 7788"}];
    
    JWScrollviewCell * cell5 = [self creatFacebookCell];
    
    [self.scrollView setScrollviewSubViewsArr:@[cell1,cell2,cell3,cell4,cell5].mutableCopy];
    
    [self getUserInfosuccess:^(UserInfoModel *userInfo) {
        
        ((JWLabel *)cell2.getElementByTag(1003)).text = [NSString stringWithFormat:@"%@ %@",userInfo.firstName,userInfo.lastName];
        ((JWLabel *)cell3.getElementByTag(1003)).text = [self hiddenEmailNum:userInfo.email];
        ((JWLabel *)cell4.getElementByTag(1003)).text =
        [NSString stringWithFormat:@"%@ %@",userInfo.areaCode,[self hiddenMobileStr:userInfo.mobile]];
        
    } showHud:true];
    
    
}

-(JWScrollviewCell *)creatCell1{
    
    JWScrollviewCell * item = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 52)];
    
    JWLabel * titleLab1 = [[JWLabel alloc]initWithFrame:CGRectMake(20,adaptY(20), kScreenWidth-60, adaptY(30))];
    titleLab1.text = @"Level 1";
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
    [imageViewBtn setImage:[UIImage imageNamed:@"Check-2"] forState:UIControlStateNormal];
    imageViewBtn.userInteractionEnabled = false;
    [item.contentView addSubview:imageViewBtn];
    
    
    
    JWLabel * titleLab3 = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLab2.frame)+20, kScreenWidth-40, 35)];
    titleLab3.text = @"You are now a “Level 1 Certified” PICA user!";
    titleLab3.font = kLightFont(13);
    [item.contentView addSubview:titleLab3];
    
    
    
    item.contentView.height = CGRectGetMaxY(item.contentView.subviews.lastObject.frame);
    
    [item setUPSpacing:0 andDownSpacing:0];
    
    return item;
    
}


-(JWScrollviewCell *)creatCell2:(NSDictionary *)dict{
    
    JWScrollviewCell * item = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 52)];
    
    JWLabel * titleLab1 = [[JWLabel alloc]initWithFrame:CGRectMake(20, 10, kScreenWidth-40,adaptY(25))];
    titleLab1.text = dict[@"title"];
    titleLab1.font = kMediumFont(13);
    [item.contentView addSubview:titleLab1];
    
    
    UIButton * imageViewBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    imageViewBtn.frame = CGRectMake(kScreenWidth - adaptX(25) -20, titleLab1.y,adaptX(25) , adaptX(25));
    [imageViewBtn setImage:[UIImage imageNamed:@"Check-1"] forState:UIControlStateNormal];
    imageViewBtn.userInteractionEnabled = false;
    [item.contentView addSubview:imageViewBtn];
    
    
    JWLabel * titleLab2 = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLab1.frame), kScreenWidth-40, adaptY(25))];
    titleLab2.text = dict[@"subTitle"];
    titleLab2.font = kLightFont(12);
    titleLab2.tag = 1003;
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
    HXWeak_self
    [subTitleLab addSingleTapEvent:^{
        HXStrong_self
        [self facebookshare];
    }];
    
    [item addSubview:subTitleLab];
    
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
        content.contentTitle = @"Level 1";
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

- (NSString *)hiddenEmailNum:(NSString *)EmailStr
{
    
    NSString *symbolStr = @"******************";
    NSString * lastStr =@"@";//截取符
    NSRange rangeLenth = [EmailStr rangeOfString:lastStr];
    //开始
    NSRange rangeBegin = NSMakeRange(0, 0);
    NSString *beginStr = [EmailStr substringWithRange:rangeBegin];//隐藏部分
    NSRange rangeHidden = NSMakeRange(0, rangeLenth.location - 0);
    NSString * hiddenStr = [EmailStr substringWithRange:rangeHidden];//替换隐藏部分
    NSRange rangSymbol = NSMakeRange(0, hiddenStr.length);
    NSString *newHiddenStr = [symbolStr substringWithRange:rangSymbol];//结尾
    NSRange rangeEnd = NSMakeRange(rangeLenth.location - 0, EmailStr.length - rangeLenth.location + 0);
    NSString *endStr = [EmailStr substringWithRange:rangeEnd];NSString * newStr = [NSString stringWithFormat:@"%@%@%@",beginStr,newHiddenStr,endStr];return newStr;

}


-(NSString *)hiddenMobileStr:(NSString *)Str{

    NSString *originTel = Str;
    
    NSString *tel;
    
    if (originTel.length>=7) {
        
       tel = [originTel stringByReplacingCharactersInRange:NSMakeRange(0, 7) withString:@"*** *** "];
        
    }else{
        tel = [originTel stringByReplacingCharactersInRange:NSMakeRange(0, 3) withString:@"*** *** "];
    }
    
//    NSLog(@"tel:%@",tel);
    
    
    NSString * res = [NSString stringWithFormat:@"%@",tel];
    
    return res;

    
}



@end
