//
//  HXSingleton.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/10.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "HXSingleton.h"

static HXSingleton * _singleton;

@implementation HXSingleton

+ (id)sharedSingleton
{
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        
        if (_singleton == nil) {
            _singleton = [[HXSingleton alloc] init];
        }
    });
    return _singleton;
}

@end
