//
//  UserInfoSingleton.h
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/24.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "UserInfoModel.h"

#import "DefaultSetting.h"

#import "AccountInfo.h"

#import <UIKit/UIKit.h>

@interface UserInfoSingleton : NSObject

@property (nonatomic,strong) UserInfoModel * singletonUserInfo;

@property (nonatomic,strong) DefaultSetting * singletonDefaultSetting;

@property (nonatomic,strong) AccountInfo * accountInfo;

@property (nonatomic,strong) UIImage * userIcon;

+ (id)sharedSingleton;

@end
