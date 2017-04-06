//
//  DefaultSetting.h
//  GTriches
//
//  Created by devair on 14/12/28.
//  Copyright (c) 2014年 eric. All rights reserved.
//

#import <Foundation/Foundation.h>
#define DefaultSettingFile @"defaultSetting"

@interface DefaultSetting : NSObject

@property (assign, nonatomic) NSInteger uid;//保存最近登录用户uid
@property (strong, nonatomic) NSString *mobile;/**< 保存手机号 */
@property (assign, nonatomic) BOOL  isTouchID; //是否设置了指纹密码
@property (strong, nonatomic) NSString *access_token;//应用识别码
@property (assign, nonatomic) long long access_tokenTimeStamp;//应用识别码有效期
- (void)clearData;
+ (instancetype)defaultSettingWithFile;
+ (void)saveSetting:(DefaultSetting *)setting;
@end
