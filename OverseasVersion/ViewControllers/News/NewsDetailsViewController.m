//
//  NewsDetailsViewController.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/23.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "NewsDetailsViewController.h"

#import "HXActivity.h"
#import <Social/Social.h>
#import "UIImage+QRImage.h"
#import "Cutter.h"
@import SafariServices;
@import MessageUI;
@import Twitter;

@interface NewsDetailsViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView *webView;

@property (nonatomic,strong) customHUD * webHud ;

@end

@implementation NewsDetailsViewController

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
    
    [self createImageBarButtonItemStyle:BtnRightType Image:@"share_01" TapEvent:^{
        [self shareBtnClicked];
    }];
    
    [self webHud];
}

//- (void)webViewDidFinishLoad:(UIWebView *)webView {
//    self.title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
//}

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
    
    //自定义Activity
//    HXActivity * activity = [[HXActivity alloc] initWithTitie:@"PICA" withActivityImage:[UIImage imageNamed:@"picaLogo"] withUrl:urlToShare withType:@"customActivity" withShareContext:activityItems];
//    NSArray *activities = @[activity];
    
    /**
     创建分享视图控制器
     
     ActivityItems  在执行activity中用到的数据对象数组。数组中的对象类型是可变的，并依赖于应用程序管理的数据。例如，数据可能是由一个或者多个字符串/图像对象，代表了当前选中的内容。
     Activities  是一个UIActivity对象的数组，代表了应用程序支持的自定义服务。这个参数可以是nil。
     
     */
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


//- (void)elseAPI{
//    
//    //复制链接功能
//    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//    pasteboard.string = @"需要复制的内容";
//    
//    //用safari打开网址
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/wslcmk"]];
//
//    //添加书签
//    NSURL *URL = [NSURL URLWithString:@"https://github.com/wslcmk"];
//    BOOL result = [[SSReadingList defaultReadingList] addReadingListItemWithURL:URL
//                                                                          title:@"WSL"
//                                                                    previewText:@"且行且珍惜_iOS"
//                                                                          error:nil];
//    if (result) {
//        NSLog(@"添加书签成功");
//    }
//    
//    //发送短信
//    MFMessageComposeViewController *messageComposeViewController = [[MFMessageComposeViewController alloc] init];
//    messageComposeViewController.recipients = @[@"recipients"];
//    messageComposeViewController.body = @"body";
//    messageComposeViewController.subject = @"subject";
//    
//    //发送邮件
//    MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
//    [mailComposeViewController setToRecipients:@[@"setToRecipients"]];
//    [mailComposeViewController setSubject:@"setSubject"];
//    [mailComposeViewController setMessageBody:@"setMessageBody"
//                                       isHTML:NO];
//    if([MFMailComposeViewController  canSendMail]){
//        [self presentViewController:mailComposeViewController animated:YES completion:nil];
//    };
//    
//}

//- (NSArray<id<UIPreviewActionItem>> *)previewActionItems {
//    // setup a list of preview actions
//    UIPreviewAction *action1 = [UIPreviewAction actionWithTitle:@"Share" style:UIPreviewActionStyleDefault handler:^(UIPreviewAction * _Nonnull action, UIViewController * _Nonnull previewViewController) {
////        NSLog(@"Aciton1");
//        [self shareBtnClicked];
//    }];
//    
//    NSArray *actions = @[action1];
//    
//    return actions;
//}

@end
