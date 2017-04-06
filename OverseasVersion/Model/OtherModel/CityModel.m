//
//  CityModel.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/3/13.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel

+ (NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"child" : [CityModel class]
             };
}


@end
