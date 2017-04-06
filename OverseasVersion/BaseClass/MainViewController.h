//
//  MainViewController.h
//  OverseasVersion
//
//  Created by 梁家文 on 17/2/6.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JWLabel.h"
#import "projectHeader.h"
#import "JWScrollView.h"
#import "JWScrollviewCell.h"
#import "JWTextField.h"
#import "JWAlertView.h"
#import "UIView+Extension.h"
#import "UIViewController+KeyboardCorver.h"
#import "CommonService.h"
#import "MainTabBarViewController.h"
#import "YYModel.h"
#import "GWTipView.h"
#import "customHUD.h"
#import "NSString+CustomString.h"
#import "AccountInfo.h"
#import "TooltipView.h" //提示层
#import "HXMapLocationManager.h" //地址管理
#import "TIPTEXT.h"//提示文字管理
#import "HXSingleton.h"
#import "MainNavController.h"

#import "UIImage+QRImage.h"
#import "NerdyUI.h"
#import "Masonry.h"
#import "ResponseModel.h"
#import "LGAlertView.h"

typedef NS_ENUM(NSInteger, BtnTypeStyle) {
    BtnRightType,
    BtnLeftType
};


@interface MainViewController : UIViewController


@property (strong, nonatomic) DefaultSetting * defaultSetting;
@property (strong, nonatomic) UserInfoModel * userInfoModel;

@property (nonatomic, strong) customHUD * showHud;
-(void)closeHud;


@property (nonatomic, strong) id transmitObject; /**< 所有控制器共有的参数 */

#pragma mark  - 失败处理
- (void)errorDispose:(NSInteger)errorCode judgeMent:(NSString *)judgement;
#pragma mark  - 无网络的统一处理
- (void)errorRemind:(NSString *)judgement;

- (void)createTitleBarButtonItemStyle:(BtnTypeStyle)btnStyle title:(NSString *)title TapEvent:(void(^)(void))event;

- (void)createImageBarButtonItemStyle:(BtnTypeStyle)btnStyle Image:(NSString *)image TapEvent:(void(^)(void))event;


-(void)publicPush:(NSString * )viewControllerClass andTransmitObject:(id)object Animated:(BOOL)animated;

-(void)publicPopViewControllerIndex:(NSInteger)index Animated:(BOOL)animated;

-(void)showTip:(NSString *)tipStr;

-(void)setRootViewController:(UIViewController *)viewController;

-(void)showWindowTip:(NSString *)messge;

/**
 *  获取用户信息
 */
- (void)getUserInfosuccess:(void (^)(UserInfoModel *userInfo))success showHud:(BOOL)showHud;
/**
 *  账户信息信息
 */
- (void)getAccountInfosuccess:(void (^)(AccountInfo *accountInfo))success showHud:(BOOL)showHud;


-(void)facebooksupplementaryInfo;

-(void)submitShareImage:(UIImage *)image success:(void (^)(NSString * imageStr))success;

-(BOOL)isVersion9;

-(void)addTipView;

-(void)certificationViewControllerSPush:(UIViewController *)viewController;



/**
 *  请求队列
 */
-(void)requestQueueWithURL:(NSArray<NSString *> *)URLQueue withDict:(NSArray<NSDictionary *> *)dict success:(void(^)(NSMutableArray <ResponseModel *> * responseArr))success;

@end
