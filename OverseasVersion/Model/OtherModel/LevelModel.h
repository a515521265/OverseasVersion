//
//  LevelModel.h
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/3/13.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LevelModel : NSObject

@property (nonatomic,strong) NSString * infoName;

@property (nonatomic,assign) NSInteger status;

@property (nonatomic,strong) NSString * type;


/*
审核成功1
审核中2
审核失败 -1
 */

@end

@interface LevelModelTwo : NSObject

@property (nonatomic,strong) NSString * cashIn;

@property (nonatomic,strong) NSString * cashOut;

@property (nonatomic,strong) NSString * freeCashNum;

@property (nonatomic,assign) NSInteger  level;

@end
