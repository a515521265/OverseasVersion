//
//  TradingRecordModel.h
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/13.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TradingRecordModel : NSObject

@property (nonatomic,strong) NSString * amount; //金额

@property (nonatomic,strong) NSString * code;

@property (nonatomic,assign) long long  createTime;

@property (nonatomic,strong) NSString * lat;

@property (nonatomic,strong) NSString * lon;

@property (nonatomic,strong) NSString * points;//积分

@property (nonatomic,strong) NSString * remark;

@property (nonatomic,strong) NSString * showName;

@property (nonatomic,assign) NSInteger  type;

/*
 * 交易类型 type
 * 1:充值
 * 69:提现
 * 73:支出
 * 72:收入
 */

@end
