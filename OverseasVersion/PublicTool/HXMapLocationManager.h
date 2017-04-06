//
//  HXMapLocationManager.h
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/10.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HXMapLocationManager : NSObject

{
    void (^saveGpsCallBack)(double lattitude,double longitude);
}
+ (void)getGps:(void(^)(double lattitude,double longitude))block;
+ (void)stop;

@end
