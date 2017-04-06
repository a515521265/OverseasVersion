//
//  ReceiptViewController.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/8.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "ReceiptViewController.h"

#import <GoogleMaps/GoogleMaps.h>

#import "HXActivity.h"
#import <Social/Social.h>
#import "UIImage+QRImage.h"
@import SafariServices;
@import MessageUI;
@import Twitter;


@interface ReceiptViewController ()

@property (nonatomic,strong) JWScrollView * scrollView;

@property (nonatomic,strong) JWScrollviewCell * receiptCell;

@property (nonatomic,strong) GMSMapView * mapView;

@end

@implementation ReceiptViewController

-(GMSMapView *)mapView{
    
    if (!_mapView) {
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:-33.868
                                                                longitude:151.2086
                                                                     zoom:12];
        _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
        dispatch_async(dispatch_get_main_queue(), ^{
//            _mapView.myLocationEnabled = YES;
            _mapView.userInteractionEnabled = false;
        });
    }
    return _mapView;
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


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!self.recordModel) {
        self.recordModel = [TradingRecordModel yy_modelWithDictionary:self.transmitObject[@"data"]];
    }
    
    
    [self.scrollView setScrollviewSubViewsArr:@[self.receiptCell].mutableCopy];
    self.scrollView.contentSize = CGSizeMake(0, self.receiptCell.contentView.height+30);
    
    
    [self createImageBarButtonItemStyle:BtnRightType Image:@"share_01" TapEvent:^{
        [self shareBtnClicked];
    }];
    
}

-(JWScrollviewCell *)receiptCell{

    if (!_receiptCell) {
        _receiptCell = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        JWLabel * receiptLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, 0, kScreenWidth-40, 50)];
        receiptLab.textColor = commonBlackBtnColor;
        receiptLab.text = Internationalization(@"收据", @"Receipt");
        receiptLab.font = kMediumFont(25);
        receiptLab.textAlignment =1;
        [_receiptCell.contentView addSubview:receiptLab];
        
        JWLabel * received = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(receiptLab.frame), kScreenWidth-40, adaptY(20))];
        if (self.recordModel.type ==1 || self.recordModel.type ==72) {
            received.text = @"Received From:";
        }else{
            received.text = @"Paid To:";
        }
        
        received.font = kMediumFont(13);
        received.textColor = commonBlackBtnColor;
        [_receiptCell.contentView addSubview:received];
        
        JWLabel * receivedName = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(received.frame), kScreenWidth-40, adaptY(30))];
        receivedName.font = kLightFont(17);
        receivedName.textColor = commonBlackBtnColor;
        receivedName.text = self.recordModel.showName;
        [_receiptCell.contentView addSubview:receivedName];
    
        JWLabel * amount = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(receivedName.frame)+adaptY(5), kScreenWidth-40, adaptY(20))];
        amount.text = @"Amount:";
        amount.font = kMediumFont(13);
        amount.textColor = commonBlackBtnColor;
        [_receiptCell.contentView addSubview:amount];
        
        JWLabel * money = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(amount.frame), kScreenWidth-40, adaptY(30))];
        money.font = kLightFont(17);
        money.textColor = UIColorFromRGB(0x23b800);
        money.text = @"₱20.00";
        money.labelAnotherFont = kLightFont(12);
        money.text =[NSString formatSpecialMoneyString:self.recordModel.amount.doubleValue];
        money.adjustsFontSizeToFitWidth = true;
        if (self.recordModel.type ==1 || self.recordModel.type ==72) {
            money.textColor = UIColorFromRGB(0x23b800);
        }else{
            money.textColor = commonErrorColor;
        }
        [_receiptCell.contentView addSubview:money];
        
        
        JWLabel * Time = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(money.frame)+adaptY(5), kScreenWidth-40, adaptY(20))];
        Time.text = @"Time:";
        Time.font = kMediumFont(13);
        Time.textColor = commonBlackBtnColor;
        [_receiptCell.contentView addSubview:Time];
        
        JWLabel * time = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(Time.frame), kScreenWidth-40, adaptY(30))];
        time.font = kLightFont(17);
        time.textColor = commonBlackBtnColor;
        time.text = @"10:02:01 AM";
//        time.text = [NSString stringWithdateFrom1970:self.recordModel.createTime withFormat:@"HH:mm:ss a"];
        time.text =
        [NSString stringWithFormat:@"%@%@",[NSString stringWithdateFrom1970:self.recordModel.createTime withFormat:@"HH:mm:ss "],[NSString timeslot:[NSString stringWithdateFrom1970:self.recordModel.createTime withFormat:@"a"]]];
        
        [_receiptCell.contentView addSubview:time];
        
        JWLabel * Date = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(time.frame)+adaptY(5), kScreenWidth-40, adaptY(20))];
        Date.text = @"Date:";
        Date.font = kMediumFont(13);
        Date.textColor = commonBlackBtnColor;
        [_receiptCell.contentView addSubview:Date];
        
        JWLabel * date = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(Date.frame), kScreenWidth-40, adaptY(30))];
        date.font = kLightFont(17);
        date.textColor = commonBlackBtnColor;
        date.text = @"December 12, 2016";
        date.text = [NSString stringWithFormat:@"%@%@",[NSString getMonth:[NSString stringWithdateFrom1970:self.recordModel.createTime withFormat:@"MM"]],[NSString stringWithdateFrom1970:self.recordModel.createTime withFormat:@" dd,YYYY"]];
        [_receiptCell.contentView addSubview:date];
        
        self.mapView.frame = CGRectMake(20, CGRectGetMaxY(date.frame)+adaptY(5), kScreenWidth-40, adaptY(130));

        [_receiptCell.contentView addSubview:self.mapView];

        GMSMarker *sydneyMarker = [[GMSMarker alloc] init];
        sydneyMarker.title = self.recordModel.showName;
        sydneyMarker.icon = [UIImage imageNamed:@"地图钉"];
        sydneyMarker.position = CLLocationCoordinate2DMake(self.recordModel.lat.doubleValue, self.recordModel.lon.doubleValue);
        sydneyMarker.map = self.mapView;

        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.recordModel.lat.doubleValue
                                                                longitude:self.recordModel.lon.doubleValue
                                                                     zoom:12];
        self.mapView.camera = camera;
        
        
        JWLabel * Reward = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.mapView.frame)+adaptY(5), kScreenWidth-40, adaptY(20))];
        Reward.text = @"Reward Points:";
        Reward.font = kMediumFont(13);
        Reward.textColor = commonBlackBtnColor;
        [_receiptCell.contentView addSubview:Reward];
        
        JWLabel * Points = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(Reward.frame), kScreenWidth-40, adaptY(30))];
        Points.font = kLightFont(17);
        Points.textColor = commonBlackBtnColor;
        Points.text = self.recordModel.points;
        [_receiptCell.contentView addSubview:Points];
        
        
        JWLabel * Transaction = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(Points.frame)+adaptY(5), kScreenWidth-40, adaptY(20))];
        
        if (self.recordModel.points.doubleValue==0) {
            Transaction.y = CGRectGetMaxY(self.mapView.frame)+adaptY(5);
            Reward.hidden = Points.hidden = true;
        }
        
        Transaction.text = @"Transaction Number:";
        Transaction.font = kMediumFont(13);
        Transaction.textColor = commonBlackBtnColor;
        [_receiptCell.contentView addSubview:Transaction];
        
        
        JWLabel * Number = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(Transaction.frame), kScreenWidth-40, adaptY(30))];
        Number.font = kLightFont(17);
        Number.textColor = commonBlackBtnColor;
        Number.text = self.recordModel.code;
        [_receiptCell.contentView addSubview:Number];
        
        
        _receiptCell.contentView.height = CGRectGetMaxY(Number.frame);
        [_receiptCell setUPSpacing:0 andDownSpacing:0];

        
    }
    return _receiptCell;
}

- (void)shareBtnClicked{
    
    //要分享的内容，加在一个数组里边，初始化UIActivityViewController
    NSString *textToShare = @"PICA";
    UIImage *imageToShare = [UIImage imageWithScreenshot];
    NSArray *activityItems = @[textToShare,imageToShare];

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
    
    
    activityVC.completionWithItemsHandler = myBlock;
    [self presentViewController:activityVC animated:YES completion:nil];
    
    
    
}


//- (void)shareBtnClicked{
//    
//    //要分享的内容，加在一个数组里边，初始化UIActivityViewController
//    NSString *textToShare = @"PICA";
//    UIImage *imageToShare = [UIImage imageNamed:@"地图钉"];
//    NSURL *urlToShare = [NSURL URLWithString:@"https://www.baidu.com"];
//    NSArray *activityItems = @[urlToShare,textToShare,imageToShare];
//    
//    //自定义Activity
//    HXActivity * activity = [[HXActivity alloc] initWithTitie:@"PICA" withActivityImage:[UIImage imageNamed:@"地图钉"] withUrl:urlToShare withType:@"customActivity" withShareContext:activityItems];
//    NSArray *activities = @[activity];
//    
//    /**
//     创建分享视图控制器
//     
//     ActivityItems  在执行activity中用到的数据对象数组。数组中的对象类型是可变的，并依赖于应用程序管理的数据。例如，数据可能是由一个或者多个字符串/图像对象，代表了当前选中的内容。
//     Activities  是一个UIActivity对象的数组，代表了应用程序支持的自定义服务。这个参数可以是nil。
//     
//     */
//    UIActivityViewController *activityVC = [[UIActivityViewController alloc]initWithActivityItems:activityItems applicationActivities:activities];
//    //初始化回调方法
//    UIActivityViewControllerCompletionWithItemsHandler myBlock = ^(NSString *activityType,BOOL completed,NSArray *returnedItems,NSError *activityError)
//    {
//        NSLog(@"activityType :%@", activityType);
//        if (completed)
//        {
//            NSLog(@"completed");
//        }
//        else
//        {
//            NSLog(@"cancel");
//        }
//        
//    };
//    // 初始化completionHandler，当post结束之后（无论是done还是cancell）该blog都会被调用
//    activityVC.completionWithItemsHandler = myBlock;
//    activityVC.excludedActivityTypes = @[];
//    [self presentViewController:activityVC animated:YES completion:nil];
//    
//}
//
//
//- (void)elseAPI{
//    
//    //复制链接功能
//    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
//    pasteboard.string = @"需要复制的内容";
//    
//    //用safari打开网址
//    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://github.com/wslcmk"]];
//    
//    //保存图片到相册
//    UIImage *image = [UIImage imageNamed:@"wang"];
//    id completionTarget = self;
//    SEL completionSelector = @selector(didWriteToSavedPhotosAlbum);
//    void *contextInfo = NULL;
//    UIImageWriteToSavedPhotosAlbum(image, completionTarget, completionSelector, contextInfo);
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
//    messageComposeViewController.recipients = @[@"且行且珍惜_iOS"];
//    //messageComposeViewController.delegate = self;
//    messageComposeViewController.body = @"你好，我是且行且珍惜_iOS，请多指教！";
//    messageComposeViewController.subject = @"且行且珍惜_iOS";
//    
//    //发送邮件
//    MFMailComposeViewController *mailComposeViewController = [[MFMailComposeViewController alloc] init];
//    [mailComposeViewController setToRecipients:@[@"mattt@nshipster•com"]];
//    [mailComposeViewController setSubject:@"WSL"];
//    [mailComposeViewController setMessageBody:@"Lorem ipsum dolor sit amet"
//                                       isHTML:NO];
//    if([MFMailComposeViewController  canSendMail]){
//        [self presentViewController:mailComposeViewController animated:YES completion:nil];
//    };
//    
//    //发送推文
//    TWTweetComposeViewController *tweetComposeViewController =
//    [[TWTweetComposeViewController alloc] init];
//    [tweetComposeViewController setInitialText:@"梦想还是要有的,万一实现了呢!-----且行且珍惜_iOS"];
//    [tweetComposeViewController addURL:[NSURL URLWithString:@"https://github.com/wslcmk"]];
//    [tweetComposeViewController addImage:[UIImage imageNamed:@"wang"]];
//    if ([TWTweetComposeViewController canSendTweet]) {
//        [self presentViewController:tweetComposeViewController animated:YES completion:nil];
//    }
//    
//}
//
////苹果自带的分享界面
//- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    
//    //[SLComposeViewController isAvailableForServiceType: @"com.tencent.xin.sharetimeline"];微信
//    
//    
//    //1.判断平台是否可用(系统没有集成,用户设置新浪账号)
//    if (![SLComposeViewController isAvailableForServiceType:SLServiceTypeSinaWeibo]) {
//        NSLog(@"到设置界面去设置自己的新浪账号");
//        return;
//    }
//    
//    // 2.创建分享控制器
//    SLComposeViewController *composeVc = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeSinaWeibo];
//    
//    // 2.1.添加分享的文字
//    [composeVc setInitialText:@"梦想还是要有的,万一实现了呢!-----且行且珍惜_iOS"];
//    
//    // 2.2.添加分享的图片
//    [composeVc addImage:[UIImage imageNamed:@"wang.png"]];
//    
//    // 2.3 添加分享的URL
//    [composeVc addURL:[NSURL URLWithString:@"https://github.com/wslcmk"]];
//    
//    // 3.弹出控制器进行分享
//    [self presentViewController:composeVc animated:YES completion:nil];
//    
//    // 4.设置监听发送结果
//    composeVc.completionHandler = ^(SLComposeViewControllerResult reulst) {
//        if (reulst == SLComposeViewControllerResultDone) {
//            NSLog(@"用户发送成功");
//        } else {
//            NSLog(@"用户发送失败");
//        }
//    };
//    
//}

@end
