//
//  HXMapLocationManager.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/10.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "HXMapLocationManager.h"
#import <CoreLocation/CoreLocation.h>
#import "TooltipView.h"

@interface HXMapLocationManager ()<CLLocationManagerDelegate>

@property (strong, nonatomic)CLLocationManager *locManager;

@end

@implementation HXMapLocationManager


+ (instancetype)sharedGpsManager
{
    static id mapLocation;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!mapLocation) {
            mapLocation = [[HXMapLocationManager alloc] init];
        }
    });
    return mapLocation;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self getCurrentLocation];
    }
    return self;
}

- (void)getCurrentLocation
{
    self.locManager = [[CLLocationManager alloc] init];
    self.locManager.delegate = self;
    self.locManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locManager.distanceFilter = 10.0;
    [self.locManager startUpdatingLocation];
}

- (void)getGps:(void (^)(double lat, double lng))gps
{
    if ([CLLocationManager locationServicesEnabled] == FALSE) {
        return;
    }
    saveGpsCallBack = [gps copy];
    [self.locManager stopUpdatingLocation];
    [self.locManager startUpdatingLocation];
}

+ (void)getGps:(void (^)(double, double))block
{
    [[HXMapLocationManager sharedGpsManager] getGps:block];
}

- (void)stop
{
    [self.locManager stopUpdatingLocation];
}

+ (void)stop
{
    [[HXMapLocationManager sharedGpsManager] stop];
}

#pragma mark - locationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"%f,%f",newLocation.coordinate.latitude,newLocation.coordinate.longitude);
    double latitude = newLocation.coordinate.latitude;
    double longitude = newLocation.coordinate.longitude;
    if (saveGpsCallBack) {
        saveGpsCallBack(latitude,longitude);
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    [TooltipView showWithText:@"Failed to get address"];
}

@end
