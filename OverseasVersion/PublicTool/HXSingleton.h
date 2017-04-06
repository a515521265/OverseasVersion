//
//  HXSingleton.h
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/10.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>

@interface HXSingleton : NSObject

@property (nonatomic,assign) BOOL  isAccount; //账户退出

@property (nonatomic,strong) NSString * skipStr; //账户退出

@property (nonatomic,strong) UITabBarController *  mainTabBarVC;

+ (id)sharedSingleton;

@end
