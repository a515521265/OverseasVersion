//
//  APPSetting.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/3/28.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "APPSetting.h"


static APPSetting * _singleton;

@implementation APPSetting

+ (id)sharedSingleton
{
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        
        if (_singleton == nil) {
            _singleton = [[APPSetting alloc] init];
            _singleton.firstInstall = [[NSUserDefaults standardUserDefaults] objectForKey:@"firstInstallApp"];
            _singleton.openDebug = [[[NSUserDefaults standardUserDefaults] objectForKey:@"picaDebug"] boolValue];
        }
    });
    return _singleton;
}

-(void)setFirstInstall:(NSString *)firstInstall{
    _firstInstall = firstInstall;
    [[NSUserDefaults standardUserDefaults] setObject:firstInstall forKey:@"firstInstallApp"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setOpenDebug:(BOOL)openDebug{
    
    _openDebug = openDebug;
    [[NSUserDefaults standardUserDefaults] setBool:openDebug forKey:@"picaDebug"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

@end
