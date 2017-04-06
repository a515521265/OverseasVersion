//
//  AppDelegate.h
//  OverseasVersion
//
//  Created by 梁家文 on 17/2/6.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DefaultSetting.h"
#import "UserInfoModel.h"
#import "UserInfoSingleton.h"
#import "HXSingleton.h"
#import "APPSetting.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (assign, nonatomic) float autoSizeScaleX;
@property (assign, nonatomic) float autoSizeScaleY;
@property (strong, nonatomic) DefaultSetting * defaultSetting;
@property (strong, nonatomic) UserInfoModel * userInfoModel;
@property (nonatomic,strong) UserInfoSingleton * userConfiguration;
@property (nonatomic,strong) HXSingleton * singleton;
@property (nonatomic,strong) APPSetting * appSetting;

@end

