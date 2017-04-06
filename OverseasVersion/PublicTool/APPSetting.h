//
//  APPSetting.h
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/3/28.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
    app配置
 */

@interface APPSetting : NSObject

@property (nonatomic,strong) NSString * firstInstall; //第一次安装

@property (nonatomic,assign) BOOL  openDebug;

+ (id)sharedSingleton;

@end
