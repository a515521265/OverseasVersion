//
//  LevelModel.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/3/13.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "LevelModel.h"

@implementation LevelModel

-(void)setInfoName:(NSString *)infoName{

    _infoName = infoName;
    
    if ([infoName isEqualToString:@"governmentId"] || [infoName isEqualToString:@"address"]) {
        _type = @"1";
    }else if ([infoName isEqualToString:@"selgovernmentId"] || [infoName isEqualToString:@"bill"]){
        _type = @"2";
    }else if ([infoName isEqualToString:@"security"]){
        _type = @"3";
    }
    
}

@end


@implementation LevelModelTwo

@end
