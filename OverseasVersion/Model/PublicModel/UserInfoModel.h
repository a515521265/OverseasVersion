//
//  UserInfoModel.h
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/8.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserInfoModel : NSObject

@property (nonatomic, strong) NSString * address;
@property (nonatomic, strong) NSString * email;
@property (nonatomic, strong) NSString * mobile;
@property (nonatomic, strong) NSString * areaCode;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, assign) NSInteger userId;//userId
@property (nonatomic, assign) NSInteger status;
@property (nonatomic, strong) NSString * qrCode; //二维码
@property (nonatomic, assign) NSInteger  setPayPwd; //是否设置支付密码
@property (nonatomic, strong) NSString * headPic; //头像url

@property (nonatomic,strong) NSString * firstName;
@property (nonatomic,strong) NSString * lastName;

@property (nonatomic,strong) NSString *  level; // 0 1 2 3

@end
