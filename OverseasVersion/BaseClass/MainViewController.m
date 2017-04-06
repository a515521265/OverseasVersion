//
//  MainViewController.m
//  OverseasVersion
//
//  Created by 梁家文 on 17/2/6.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "MainViewController.h"

#import "JxbDebugTool.h"

#import "LoginViewController.h"

#import "JPUSHService.h"

#import "FaceBookLogInViewController.h"

#import "SDWebImageManager.h"

#import "NetworkState.h"

@interface MainViewController ()

@property (nonatomic, copy) dispatch_block_t tapleftBarButtonItemEvent;

@property (nonatomic, copy) dispatch_block_t taprightBarButtonItemEvent;

@property (nonatomic, copy) dispatch_block_t tapimageleftBarButtonItemEvent;

@property (nonatomic, copy) dispatch_block_t tapimagerightBarButtonItemEvent;

@property (nonatomic, strong) UITextField * altTextfield;

@property (nonatomic,strong) NSMutableArray <ResponseModel *>* responseObjectArr;

@property (nonatomic, copy) dispatch_semaphore_t semaphore;

@end

@implementation MainViewController

-(dispatch_semaphore_t)semaphore{
    
    if (!_semaphore) {
        _semaphore = dispatch_semaphore_create(0);
    }
    return _semaphore;
}

-(NSMutableArray<ResponseModel *> *)responseObjectArr{
    if (!_responseObjectArr) {
        _responseObjectArr = [NSMutableArray arrayWithCapacity:10];
    }
    return _responseObjectArr;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.defaultSetting = commonAppDelegate.defaultSetting;
    self.userInfoModel = commonAppDelegate.userInfoModel;
    [self addNavTitleView];
    
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
}

-(customHUD *)showHud{
    
    if (!_showHud) {
        _showHud = [[customHUD alloc]init];
        [_showHud showCustomHUDWithView:self.view];
    }
    return _showHud;
}

-(void)closeHud{
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.showHud hideCustomHUD];
        self.showHud  = nil;
    });
    
}
//总的navView
-(void)addNavTitleView{

    JWLabel * titleLabel = [[JWLabel alloc] init];
    titleLabel.text = @"PICA";
    titleLabel.font = kLightFont(24);
    titleLabel.isShadow = true;
    titleLabel.textAlignment = 1;
    [titleLabel sizeToFit];
    titleLabel.colors = @[(id)UIColorFromRGB(0x9164db).CGColor, (id)UIColorFromRGB(0x46bbe3).CGColor];
    titleLabel.center = CGPointMake(self.navigationItem.titleView.bounds.size.width * 0.5, self.navigationItem.titleView.bounds.size.height * 0.5);
    [titleLabel addSingleTapEvent:^{
       //开启debug。
        static NSInteger tap  = 0;
        tap ++;
        if (tap==10) {
            UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"debug模式" message:nil delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
            alert.alertViewStyle = UIAlertViewStylePlainTextInput;
            _altTextfield = [alert textFieldAtIndex:0];
            _altTextfield.placeholder=@"请输入密码";
            _altTextfield.secureTextEntry = true;
            [alert show];
            tap = 0;
        }
    }];
    self.navigationItem.titleView = titleLabel;
    
}


- (void)createTitleBarButtonItemStyle:(BtnTypeStyle)btnStyle title:(NSString *)title TapEvent:(void(^)(void))event{
    UIBarButtonItem *buttonItem;
    [buttonItem setTintColor:UIColorFromRGB(0x5682db)];
    if (btnStyle==BtnRightType) {
        buttonItem= [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(titleTapRightBar)];
        self.navigationItem.rightBarButtonItem = buttonItem;
        
         [self.navigationItem.rightBarButtonItem setTintColor:UIColorFromRGB(0x5682db)];
        
        self.taprightBarButtonItemEvent = event;
    }else if (btnStyle==BtnLeftType){
        buttonItem= [[UIBarButtonItem alloc]initWithTitle:title style:UIBarButtonItemStylePlain target:self action:@selector(titleTapLeftBar)];
        self.navigationItem.leftBarButtonItem = buttonItem;
        [self.navigationItem.leftBarButtonItem setTintColor:UIColorFromRGB(0x5682db)];
        self.tapleftBarButtonItemEvent = event;
    }
}
- (void)createImageBarButtonItemStyle:(BtnTypeStyle)btnStyle Image:(NSString *)image TapEvent:(void(^)(void))event{
    UIButton * settingButton = [UIButton buttonWithType:UIButtonTypeSystem];
    settingButton.frame = resetRectWH2(16, (44 -18 *commonAppDelegate.autoSizeScaleY) /2, 18, 18);
    [settingButton setBackgroundImage:[UIImage imageNamed:image] forState:UIControlStateNormal];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:settingButton];
    if (btnStyle==BtnRightType) {
        self.navigationItem.rightBarButtonItem = buttonItem;
        self.tapimagerightBarButtonItemEvent = event;
        [settingButton addTarget:self action:@selector(tapimagerightBar) forControlEvents:UIControlEventTouchUpInside];
    }else if (btnStyle==BtnLeftType){
        self.navigationItem.leftBarButtonItem = buttonItem;
        self.tapimageleftBarButtonItemEvent  = event;
        [settingButton addTarget:self action:@selector(tapimageleftBar) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)titleTapRightBar{!self.taprightBarButtonItemEvent ? nil:self.taprightBarButtonItemEvent();}
-(void)titleTapLeftBar{!self.tapleftBarButtonItemEvent ? nil:self.tapleftBarButtonItemEvent();}
-(void)tapimagerightBar{!self.tapimagerightBarButtonItemEvent ? nil:self.tapimagerightBarButtonItemEvent();}
-(void)tapimageleftBar{!self.tapimageleftBarButtonItemEvent ? nil:self.tapimageleftBarButtonItemEvent();}

//push传值
-(void)publicPush:(NSString * )viewControllerClass andTransmitObject:(id)object Animated:(BOOL)animated{
    
    if (![NSClassFromString(viewControllerClass) isSubclassOfClass: [UIViewController class]]) return;
    MainViewController * viewC = [NSClassFromString(viewControllerClass) new];
    if (object) {
        viewC.transmitObject = object;
    }
    viewC.hidesBottomBarWhenPushed=true;
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController pushViewController:viewC  animated:animated];
    });
}

//pop到哪个界面
-(void)publicPopViewControllerIndex:(NSInteger)index Animated:(BOOL)animated{
    UIViewController *popVC = self.navigationController.viewControllers[index];
    [self.navigationController popToViewController:popVC animated:animated];
}

#pragma mark  - 失败处理
- (void)errorDispose:(NSInteger)errorCode judgeMent:(NSString *)judgement{
    if (errorCode == 401) {
        [CommonService requestAccesstokensuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
                //请求新token
                self.defaultSetting.access_token = [responseObject objectForKey:@"data"];
                [DefaultSetting saveSetting:self.defaultSetting];
            
                [self jumpLogIn];
                
            }else{
                NSLog(@"获取唯一标示失败");
            }
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"获取唯一标示失败%@",error);
        }];
        //重置uid
        self.defaultSetting.uid = 0;
        self.defaultSetting.mobile = @"";
        self.defaultSetting.isTouchID = false;
        [DefaultSetting saveSetting:self.defaultSetting];

    }else if (errorCode >= 500 && errorCode <= 599) {
        GWTipView *tipView = [[GWTipView alloc] initWithTipViewOfMessage:[TIPTEXT ServerFault] LableFrame:CGRectMake(adaptX(5), adaptY(80), adaptX(300), adaptY(30))];
        [tipView show];
    }else{
        
    #if DEBUG
        GWTipView *tipView = [[GWTipView alloc] initWithTipViewOfMessage:[NSString stringWithFormat:@"error code%ld",(long)errorCode] LableFrame:CGRectMake(adaptX(5), adaptY(80), adaptX(300), adaptY(30))];
        [tipView show];
    #else
            
    #endif
    
    }
}
#pragma mark  - 无网络的统一处理
- (void)errorRemind:(NSString *)judgement{
    // judgement -> 防止产品汪要做的其他特殊处理。
    GWTipView *tipView = [[GWTipView alloc] initWithTipViewOfMessage:[TIPTEXT NetworkError] LableFrame:CGRectMake(adaptX(5), adaptY(80), adaptX(300), adaptY(30))];
    [tipView show];
    [[AFNetworkReachabilityManager sharedManager] stopMonitoring];
}

-(void)showTip:(NSString *)messge{

    [GWTipView createTooltipViewWithMarkedWords:messge view:self.view];
    
}


-(void)showWindowTip:(NSString *)messge{

    [TooltipView showWithText:messge];

}


//设置主控制器
-(void)setRootViewController:(UIViewController *)viewController{
    
    self.view.window.rootViewController = viewController;
}


/**
 *  获取用户信息
 */
- (void)getUserInfosuccess:(void (^)(UserInfoModel *userInfo))success showHud:(BOOL)showHud {
    
    
    
    if (showHud) {
        [self showHud];
    }
    HXWeak_self
    [CommonService requestUserInfoOfaccess_token:self.defaultSetting.access_token success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HXStrong_self
        if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
            
            NSDictionary *dict = [[responseObject objectForKey:@"data"] isEqual:[NSNull null]] ? nil : [responseObject objectForKey:@"data"];
            UserInfoModel *userIfno = [[UserInfoModel alloc] init];
            [userIfno yy_modelSetWithDictionary:dict];
            
            self.userInfoModel = [UserInfoModel yy_modelWithDictionary:dict];
            
            [self setCurrentUserInfo:self.userInfoModel];
            
            [JPUSHService setAlias:[NSString stringWithFormat:@"%ld",(long)userIfno.userId]
                  callbackSelector:nil
                            object:nil];
            success(self.userInfoModel);
        } else {
            [self showTip:[responseObject objectForKey:@"errorMessage"]];
            success(nil);
        }
        [self closeHud];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HXStrong_self
        success(nil);
        [self closeHud];
        [self errorDispose:[[operation response] statusCode] judgeMent:nil];
    }];
}

/**
 *  获取账户信息
 */
- (void)getAccountInfosuccess:(void (^)(AccountInfo *accountInfo))success showHud:(BOOL)showHud {
    
    
    customHUD * hud = [[customHUD alloc]init];
    if (showHud) {
        [hud showCustomHUDWithView:self.view];
    }
    HXWeak_self
    [CommonService requestUserAccountInfoOfaccess_token:self.defaultSetting.access_token success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HXStrong_self
        if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
            
            NSDictionary *dict = [[responseObject objectForKey:@"data"] isEqual:[NSNull null]] ? nil : [responseObject objectForKey:@"data"];
            AccountInfo *userIfno = [[AccountInfo alloc] init];
            [userIfno yy_modelSetWithDictionary:dict];
            commonAppDelegate.userConfiguration.accountInfo = userIfno;
            success(userIfno);
        } else {
            [self showTip:[responseObject objectForKey:@"errorMessage"]];
            success(nil);
        }
        [hud hideCustomHUD];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HXStrong_self
        success(nil);
        [hud hideCustomHUD];
        [self errorDispose:[[operation response] statusCode] judgeMent:nil];
    }];
}


#pragma mark - UIAlert delegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1){
        if ([_altTextfield.text isEqualToString:@"aaa123"]) {
            [[JxbDebugTool shareInstance] setMainColor:[UIColor redColor]];
            [[JxbDebugTool shareInstance] enableDebugMode];
        }
    }
}

- (void)dealloc {
    [self clearNotificationAndGesture];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


//跳转登录
-(void)jumpLogIn{

    if (![self.class isSubclassOfClass:[LoginViewController class]]) {
        
        LoginViewController *loginVC =[LoginViewController new];
        loginVC.skipStr = @"present";
        MainNavController *navi =[[MainNavController alloc] initWithRootViewController:loginVC];
        [self presentViewController:navi animated:YES completion:nil];
        commonAppDelegate.singleton.isAccount = true;
        
    }
    
}

//跳转完善信息
-(void)facebooksupplementaryInfo{

    [self getUserInfosuccess:^(UserInfoModel *userInfo) {
        
        self.userInfoModel = userInfo;
        
        if ([userInfo.level isEqualToString:@"0"]) {
            
            commonAppDelegate.singleton.isAccount = true;
            commonAppDelegate.singleton.mainTabBarVC = self.tabBarController;
            if (![self.class isSubclassOfClass:[FaceBookLogInViewController class]]){
                MainNavController *navi =[[MainNavController alloc] initWithRootViewController:[FaceBookLogInViewController new]];
                [self presentViewController:navi animated:YES completion:nil];
            }
        }
        
    } showHud:false];
    
}


//上传图片公共接口
-(void)submitShareImage:(UIImage *)image success:(void (^)(NSString * imageStr))success{
    
    UIImage * newImage  = [UIImage selectAndUniformScaleImageOfImage:image];
    NSData *selectImageData = UIImageJPEGRepresentation(newImage, 0.5);

    customHUD * hud = [[customHUD alloc]init];
    [hud showCustomHUDWithView:self.view];
    [CommonService uploadImgWithconstructingBodyWithBlock:^(id<AFMultipartFormData> formData) {

        [formData appendPartWithFileData:selectImageData name:@"image" fileName:@"picFront.jpg" mimeType:@"image/jpeg"];

    } access_token:self.defaultSetting.access_token success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"errorCode"] integerValue] ==0) {
            NSString * imageString = [NSString stringWithFormat:@"%@", [responseObject objectForKey:@"data"]];
            success(imageString);
        }else{
            [self showTip:[responseObject objectForKey:@"errorMessage"]];
        }
        [hud hideCustomHUD];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hideCustomHUD];
        [self errorDispose:[[operation response] statusCode] judgeMent:nil];
    }];

}

//判断系统是否>=9
-(BOOL)isVersion9{
    
    double version = [[UIDevice currentDevice].systemVersion doubleValue];
    if (version >= 9.0) {
        return true;
    }else{
        return false;
    }
    
}

//底部审核提示
-(void)addTipView{
    
    JWLabel * lab = [[JWLabel alloc]initWithFrame:CGRectMake(20, kScreenHeight-110, kScreenWidth-40, 20)];
    lab.font = kMediumFont(10);
    lab.textColor = commonGrayBtnColor;
    lab.labelAnotherFont = kLightFont(10);
    lab.text = @"Note: [Processing time may take up to 3 days. We will notify or contact you as we process your documents. Thank you! :)]";
    lab.numberOfLines = 0;
    lab.height = [lab getLabelSize:lab].height;
    lab.frame = CGRectMake(20, kScreenHeight - 64 - lab.height-10, kScreenWidth-40, lab.height);
    [self.view addSubview:lab];
    
}

//公共的几个类跳转
-(void)certificationViewControllerSPush:(UIViewController *)viewController{
    NSArray *oldViewControllers = self.navigationController.viewControllers;
    NSMutableArray * newViewControllerArr = [NSMutableArray new];
    [newViewControllerArr addObjectsFromArray:oldViewControllers];
    [newViewControllerArr removeLastObject];
    [newViewControllerArr removeLastObject];
    [newViewControllerArr addObject:viewController];
    [self.navigationController setViewControllers:[newViewControllerArr copy] animated:YES];
}

//当前用户信息
-(void)setCurrentUserInfo:(UserInfoModel *)userinfo{

    SDWebImageManager *manager = [SDWebImageManager sharedManager];
    [manager downloadImageWithURL:[NSURL URLWithString:userinfo.headPic] options:SDWebImageRetryFailed progress:^(NSInteger receivedSize, NSInteger expectedSize) {
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished, NSURL *imageURL) {
        if (image) {
            commonAppDelegate.userConfiguration.userIcon = image;
        }else{
            commonAppDelegate.userConfiguration.userIcon = [UIImage imageNamed:@"UserDefaultIcon.jpg"];
        }
    }];
    commonAppDelegate.userConfiguration.singletonUserInfo = userinfo;
    
}


-(void)requestQueueWithURL:(NSArray<NSString *> *)URLQueue withDict:(NSArray<NSDictionary *> *)dict success:(void(^)(NSMutableArray <ResponseModel *> * responseArr))success{
    
    NETSTAT(
            [self.responseObjectArr removeAllObjects];
            customHUD * allhud = [[customHUD alloc]init];
            [allhud showCustomHUDWithView:self.view];
            __weak typeof(self) weakSelf = self;
            //    创建全局并行
            dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
            dispatch_group_t group = dispatch_group_create();
            NSInteger count = MIN(URLQueue.count, dict.count);
            for (int i = 0; i<count; i++) {
                
                ResponseModel * responseM = [[ResponseModel alloc]init];
                
                responseM.number = i;
                responseM.requestURL = URLQueue[i];
                responseM.requestDict = dict[i];
                
                dispatch_group_async(group, queue, ^{
                    
                    AFHTTPRequestOperationManager * manger = [AFHTTPRequestOperationManager manager];
                    
                    AFSecurityPolicy * securityPolicy = [AFSecurityPolicy defaultPolicy];
                    
                    securityPolicy.allowInvalidCertificates = YES;
                    
                    manger.securityPolicy = securityPolicy;
                    
                    [manger POST:URLQueue[i] parameters:dict[i] success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        
                        dispatch_semaphore_signal(weakSelf.semaphore);
                        
                        responseM.responseObject = responseObject;
                        
                        responseM.status = 1;
                        
                        [weakSelf.responseObjectArr addObject:responseM];
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        
                        dispatch_semaphore_signal(weakSelf.semaphore);
                        
                        responseM.error = error;
                        
                        responseM.status = 2;

                        [weakSelf.responseObjectArr addObject:responseM];
                        
                        [weakSelf errorDispose:[[operation response] statusCode] judgeMent:nil];
                    }];
                });
            }
            dispatch_group_notify(group, queue, ^{
        //请求的等待信号
        for (int i = 0; i<count; i++) {
            dispatch_semaphore_wait(weakSelf.semaphore, DISPATCH_TIME_FOREVER);
        }
        [allhud hideCustomHUD];
        !success ? : success(weakSelf.responseObjectArr);
        
    });
            
    )
}


@end
