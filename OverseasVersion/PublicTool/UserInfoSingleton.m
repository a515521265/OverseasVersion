//
//  UserInfoSingleton.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/24.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "UserInfoSingleton.h"

static UserInfoSingleton * _singleton;

@implementation UserInfoSingleton

+ (id)sharedSingleton
{
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        
        if (_singleton == nil) {
            _singleton = [[UserInfoSingleton alloc] init];
        }
    });
    return _singleton;
}

@end
