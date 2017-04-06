//
//  AccountInfo.h
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/9.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccountInfo : NSObject

@property (nonatomic,strong) NSString * availableAmount;//余额

@property (nonatomic,strong) NSString * availablePoints;//积分

@property (nonatomic,assign) NSInteger   freeCashNum; //可免费提现次数

@end
