//
//  NoticeNewsViewController.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/3/27.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "NoticeNewsViewController.h"
#import "HXActivity.h"
#import <Social/Social.h>
#import "UIImage+QRImage.h"
#import "Cutter.h"

@import SafariServices;
@import MessageUI;
@import Twitter;

@interface NoticeNewsViewController ()<UIWebViewDelegate>
@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic,strong) customHUD * webHud ;

@end

@implementation NoticeNewsViewController

-(customHUD *)webHud{

    if (!_webHud) {
        _webHud = [[customHUD alloc]init];
        [_webHud showCustomHUDWithView:self.view];
    }
    return _webHud;
    
}

- (UIWebView *)webView {
    if (!_webView) {
        _webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
        _webView.scalesPageToFit = YES;
        _webView.delegate = self;
        [self.view addSubview:_webView];
    }
    return _webView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@?access_token=%@", self.loadURL,self.defaultSetting.access_token]]]];
    
    //    NSLog(@"loadurl--%@",[NSString stringWithFormat:@"%@?access_token=%@", self.loadURL,self.defaultSetting.access_token]);
    HXWeak_self
    [self createImageBarButtonItemStyle:BtnRightType Image:@"share_01" TapEvent:^{
        HXStrong_self
        [self shareBtnClicked];
    }];

    
    [self createImageBarButtonItemStyle:BtnLeftType Image:@"返回" TapEvent:^{
        HXStrong_self
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
    
    [self webHud];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    
    return true;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView{

    if (!webView.isLoading) {
        [self webViewDidFinishLoadCompletely];
    }
    
}

-(void)webViewDidFinishLoadCompletely{

    [self.webHud hideCustomHUD];
    
}

- (void)shareBtnClicked{
    
    //要分享的内容，加在一个数组里边，初始化UIActivityViewController
    NSString *textToShare = @"PICA";
    UIImage *imageToShare =
//    [UIImage imageWithScreenshot];
    [self.webView.scrollView scrollViewCutter];
    
    NSURL *urlToShare = [NSURL URLWithString:self.loadURL];
    NSArray *activityItems = @[urlToShare,textToShare,imageToShare];
    
    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:@[]];
    activityVC.excludedActivityTypes = @[UIActivityTypePostToFacebook];
    //初始化回调方法
    UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError)
    {
        NSLog(@"activityType :%@", activityType);
        if (completed)
        {
            NSLog(@"completed");
        }
        else
        {
            NSLog(@"cancel");
        }
    };
    // 初始化completionHandler，当post结束之后（无论是done还是cancell）该blog都会被调用
    activityVC.completionWithItemsHandler = myBlock;
    [self presentViewController:activityVC animated:YES completion:nil];
}





@end
