//
//  AppDelegate.m
//  OverseasVersion
//
//  Created by 梁家文 on 17/2/6.
//  Copyright © 2017年 梁家文. All rights reserved.
//



/*
 *          .,:,,,                                        .::,,,::.
 *        .::::,,;;,                                  .,;;:,,....:i:
 *        :i,.::::,;i:.      ....,,:::::::::,....   .;i:,.  ......;i.
 *        :;..:::;::::i;,,:::;:,,,,,,,,,,..,.,,:::iri:. .,:irsr:,.;i.
 *        ;;..,::::;;;;ri,,,.                    ..,,:;s1s1ssrr;,.;r,
 *        :;. ,::;ii;:,     . ...................     .;iirri;;;,,;i,
 *        ,i. .;ri:.   ... ............................  .,,:;:,,,;i:
 *        :s,.;r:... ....................................... .::;::s;
 *        ,1r::. .............,,,.,,:,,........................,;iir;
 *        ,s;...........     ..::.,;:,,.          ...............,;1s
 *       :i,..,.              .,:,,::,.          .......... .......;1,
 *      ir,....:rrssr;:,       ,,.,::.     .r5S9989398G95hr;. ....,.:s,
 *     ;r,..,s9855513XHAG3i   .,,,,,,,.  ,S931,.,,.;s;s&BHHA8s.,..,..:r:
 *    :r;..rGGh,  :SAG;;G@BS:.,,,,,,,,,.r83:      hHH1sXMBHHHM3..,,,,.ir.
 *   ,si,.1GS,   sBMAAX&MBMB5,,,,,,:,,.:&8       3@HXHBMBHBBH#X,.,,,,,,rr
 *   ;1:,,SH:   .A@&&B#&8H#BS,,,,,,,,,.,5XS,     3@MHABM&59M#As..,,,,:,is,
 *  .rr,,,;9&1   hBHHBB&8AMGr,,,,,,,,,,,:h&&9s;   r9&BMHBHMB9:  . .,,,,;ri.
 *  :1:....:5&XSi;r8BMBHHA9r:,......,,,,:ii19GG88899XHHH&GSr.      ...,:rs.
 *  ;s.     .:sS8G8GG889hi.        ....,,:;:,.:irssrriii:,.        ...,,i1,
 *  ;1,         ..,....,,isssi;,        .,,.                      ....,.i1,
 *  ;h:               i9HHBMBBHAX9:         .                     ...,,,rs,
 *  ,1i..            :A#MBBBBMHB##s                             ....,,,;si.
 *  .r1,..        ,..;3BMBBBHBB#Bh.     ..                    ....,,,,,i1;
 *   :h;..       .,..;,1XBMMMMBXs,.,, .. :: ,.               ....,,,,,,ss.
 *    ih: ..    .;;;, ;;:s58A3i,..    ,. ,.:,,.             ...,,,,,:,s1,
 *    .s1,....   .,;sh,  ,iSAXs;.    ,.  ,,.i85            ...,,,,,,:i1;
 *     .rh: ...     rXG9XBBM#M#MHAX3hss13&&HHXr         .....,,,,,,,ih;
 *      .s5: .....    i598X&&A&AAAAAA&XG851r:       ........,,,,:,,sh;
 *      . ihr, ...  .         ..                    ........,,,,,;11:.
 *         ,s1i. ...  ..,,,..,,,.,,.,,.,..       ........,,.,,.;s5i.
 *          .:s1r,......................       ..............;shs,
 *          . .:shr:.  ....                 ..............,ishs.
 *              .,issr;,... ...........................,is1s;.
 *                 .,is1si;:,....................,:;ir1sr;,
 *                    ..:isssssrrii;::::::;;iirsssssr;:..
 *                         .,::iiirsssssssssrri;;:.
 */


#import "AppDelegate.h"
#import "UIWindow+CustomWindow.h"
#import "projectHeader.h"
#import "MainNavController.h"
#import "LoginViewController.h"
#import "CommonService.h"
#import "CheckCrossBorder.h"

#import "SettingSecurityCodeViewController.h"

//Google地图
#import <GoogleMaps/GoogleMaps.h>

#import <FBSDKCoreKit/FBSDKCoreKit.h>

#import "GuideViewController.h"

#import <Bugtags/Bugtags.h>
// iOS10注册APNs所需头文件
#import "JPUSHService.h"
#import <UserNotifications/UserNotifications.h>
#import "NoticeNewsViewController.h"

@interface AppDelegate ()<JPUSHRegisterDelegate,UNUserNotificationCenterDelegate>{
    id services_;
}

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    
    //启动页延迟1s
    //    [NSThread sleepForTimeInterval:1.0];
    [CheckCrossBorder setXcodeSafetyLog:YES];
    //推送数据初始化
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    //
    [self initGoogleMap];
    //
    [self inituserInfo];
    //
    [self setAppResolution];
    //
    [self setAppRootViewController];
    //
    [self addShortcuts];
    //
    [self initfaceBook:application launchOptions:launchOptions];
    
    [self initBugTages];
    
    [self initJpush:launchOptions];
    
    return YES;
}

-(void)initJpush:(NSDictionary *)launchOptions{
    
    //JPush 推送
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 10.0) {
        JPUSHRegisterEntity * entity = [[JPUSHRegisterEntity alloc] init];
        entity.types = UNAuthorizationOptionAlert | UNAuthorizationOptionBadge | UNAuthorizationOptionSound;
        [JPUSHService registerForRemoteNotificationConfig:entity delegate:self];
    }
    else if ([[UIDevice currentDevice].systemVersion floatValue] >= 8.0) {
        //可以添加自定义categories
        [JPUSHService registerForRemoteNotificationTypes:(UIUserNotificationTypeBadge |
                                                          UIUserNotificationTypeSound |
                                                          UIUserNotificationTypeAlert)
                                              categories:nil];
    }
    else {
        //categories 必须为nil
        [JPUSHService registerForRemoteNotificationTypes:(UIRemoteNotificationTypeBadge |
                                                          UIRemoteNotificationTypeSound |
                                                          UIRemoteNotificationTypeAlert)
                                              categories:nil];
    }

    [JPUSHService setupWithOption:launchOptions
                           appKey:KJPushAppKey
                          channel:KJPushChannel
                 apsForProduction:TRUE
            advertisingIdentifier:nil];
    
    
}

-(void)initBugTages{
    
    BugtagsOptions *options = [[BugtagsOptions alloc] init];
#if DEBUG
    [Bugtags startWithAppKey:BugTagsKey invocationEvent:BTGInvocationEventShake options:options];
#else
    [Bugtags startWithAppKey:BugTagsKey invocationEvent:BTGInvocationEventNone options:options];
#endif
    
    
    
}


-(void)initfaceBook:(UIApplication *)application launchOptions:(NSDictionary *)launchOptions{
    
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    
    [[FBSDKApplicationDelegate sharedInstance] application:application
                             didFinishLaunchingWithOptions:launchOptions];
    
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
            options:(nonnull NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options
{
    return [[FBSDKApplicationDelegate sharedInstance] application:application
                                                          openURL:url
                                                          options:options];
}
// Still need this for iOS8
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(nullable NSString *)sourceApplication
         annotation:(nonnull id)annotation
{
    [[FBSDKApplicationDelegate sharedInstance] application:application
                                                   openURL:url
                                         sourceApplication:sourceApplication
                                                annotation:annotation];
    return YES;
}


//分辨率
-(void)setAppResolution{
    //生成不同分辨率时的宽高放大比例
    AppDelegate *delegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if(kScreenHeight > 480){
        delegate.autoSizeScaleX = kScreenWidth/320;
        delegate.autoSizeScaleY = kScreenHeight/568;
    }else{
        delegate.autoSizeScaleX = 1.0;
        delegate.autoSizeScaleY = 1.0;
    }
}

-(void)setAppRootViewController{
    
    self.window = [[UIWindow alloc] init];
    self.window.frame = [UIScreen mainScreen].bounds;
    
    //只显示一次引导页
    if ([self.appSetting.firstInstall isEqualToString:@"first"]) {
        if (self.defaultSetting.uid==0) {
            LoginViewController * login = [[LoginViewController alloc]init];
            MainNavController * nav = [[MainNavController alloc]initWithRootViewController:login];
            self.window.rootViewController = nav;
        }else{
            self.window.rootViewController = [[MainTabBarViewController alloc] init];
            commonAppDelegate.singleton.mainTabBarVC = (MainTabBarViewController *)self.window.rootViewController;
        }
    }else{
        MainNavController * guideVC = [[MainNavController alloc]initWithRootViewController:[[GuideViewController alloc] init]];
        self.window.rootViewController = guideVC;
        self.appSetting.firstInstall = @"first";
    }
    [self.window makeKeyAndVisible];
    
}

//3dtouch
-(void)addShortcuts{
    
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    if (version >= 9.0) {
        if (self.window.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
            // 创建标签的ICON图标。
            UIApplicationShortcutIcon *icon = [UIApplicationShortcutIcon iconWithTemplateImageName:@"二维码"];
            // 创建一个标签，并配置相关属性。
            UIApplicationShortcutItem *item = [[UIApplicationShortcutItem alloc] initWithType:@"one" localizedTitle:@"My QR code" localizedSubtitle:nil icon:icon userInfo:nil];
            // 将标签添加进Application的shortcutItems中。
            [UIApplication sharedApplication].shortcutItems = @[item];
            
        } else {
            
        }
    }
}

- (void)application:(UIApplication *)application performActionForShortcutItem:(UIApplicationShortcutItem *)shortcutItem completionHandler:(void (^)(BOOL))completionHandler{
    
    if (self.defaultSetting.uid==0) {
        
    }else{
        MainTabBarViewController  * main = (MainTabBarViewController *)self.window.rootViewController;
        main.selectedIndex = 2;
    }
}

-(void)isProtectPassword{
    
    NSString * protectStr =  [[NSUserDefaults standardUserDefaults] objectForKey:@"ProtectPassword"];
    if (protectStr.length) {
        SettingSecurityCodeViewController *securityCodeVC =[SettingSecurityCodeViewController new];
        securityCodeVC.skipStr = @"验证密码";
        MainNavController *navi =[[MainNavController alloc] initWithRootViewController:securityCodeVC];
        [self.window.rootViewController presentViewController:navi animated:YES completion:nil];
    }
    
}

-(void)initGoogleMap{
    [GMSServices provideAPIKey:KGoogleMapsKey];
    //    services_ = [GMSServices sharedServices];
}

-(void)inituserInfo{
    
    // 初始化用户信息
    self.appSetting = [APPSetting sharedSingleton];
    self.defaultSetting = [DefaultSetting defaultSettingWithFile];
    self.userInfoModel = [[UserInfoModel alloc] init];
    self.userConfiguration = [UserInfoSingleton sharedSingleton];
    self.singleton = [HXSingleton sharedSingleton];
    
    if ([self.defaultSetting.access_token isEqualToString:@""]) {
        [CommonService requestAccesstokensuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
                self.defaultSetting.access_token = [responseObject objectForKey:@"data"];
                [DefaultSetting saveSetting:self.defaultSetting];
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@",error);
        }];
    }

}
#pragma mark- JPUSHRegisterDelegate
//注册唯一标识成功
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
    [JPUSHService registerDeviceToken:deviceToken];
}
//注册唯一标识失败
- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    NSLog(@"did Fail To Register For Remote Notifications With Error: %@", error);
}

//接收到推送通知（iOS7以前）
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo fetchCompletionHandler:(void (^)(UIBackgroundFetchResult))completionHandler {
    NSInteger badge = [UIApplication sharedApplication].applicationIconBadgeNumber;
    if ([JPUSHService setBadge:badge]) {
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    }
    [[UIApplication sharedApplication] cancelAllLocalNotifications];
    completionHandler(UIBackgroundFetchResultNewData);
    
    if ([UIApplication sharedApplication].applicationState == UIApplicationStateActive) {
        
    }else{
        [self receiveNotification:userInfo];
    }

}
// iOS 10 Support
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)())completionHandler {
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
    [JPUSHService resetBadge];
    completionHandler(UNNotificationPresentationOptionAlert);  // 系统要求执行这个方法
    // Required
    NSDictionary * userInfo = response.notification.request.content.userInfo;
    [self receiveNotification:userInfo];
}

//接收到推送通知（iOS7以前）//app运行状态
- (void)jpushNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(NSInteger))completionHandler {
    
    // Required
    NSDictionary * userInfo = notification.request.content.userInfo;
    [self receiveNotification:userInfo];
    
    if([notification.request.trigger isKindOfClass:[UNPushNotificationTrigger class]]) {
        [JPUSHService handleRemoteNotification:userInfo];
        [[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
        [[UIApplication sharedApplication] cancelAllLocalNotifications];
    }
    completionHandler(UNNotificationPresentationOptionAlert); // 需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型
}

//接收通知
-(void)receiveNotification:(NSDictionary *)dict{

    if ([dict[@"url"] length]) {
        NoticeNewsViewController *  noticeNewsVC = [NoticeNewsViewController new];
        noticeNewsVC.loadURL = dict[@"url"];
        MainNavController * nav = [[MainNavController alloc]initWithRootViewController:noticeNewsVC];
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:nav animated:YES completion:nil];
    }
}

@end
