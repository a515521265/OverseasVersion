//
//  ResponseModel.h
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 2017/3/31.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ResponseModel : NSObject

@property (nonatomic,strong) id responseObject;

@property (nonatomic,assign) NSInteger status; //0请求中 1请求成功 2请求失败

@property (nonatomic,strong) NSError * error;

@property (nonatomic,assign) NSInteger number; //请求编号

@property (nonatomic,strong) NSString * requestURL;

@property (nonatomic,strong) NSDictionary * requestDict;

@end
