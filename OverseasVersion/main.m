//
//  main.m
//  OverseasVersion
//
//  Created by 梁家文 on 17/2/6.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "projectHeader.h"

#import <JSPatchPlatform/JSPatch.h>

int main(int argc, char * argv[]) {
    @autoreleasepool {
        
        [JSPatch startWithAppKey:JSPatchKey];
        
        [JSPatch setupRSAPublicKey:@"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC/vKrYYpxsKpW6lm1HH/70d010\nFr4vFMW0yxihZiTKftIbCimbj38SlhvN1N2xMj7WDvld3xQzNha9vsmCEt/NCyqh\n9jZG9P0YG4HWYcgmCzxRQJ/iPFImmXutsq0ktyWtUCEZs0OTsQSg06R9eLmjePD1\n16PlYbF6C1s7EEw5twIDAQAB\n-----END PUBLIC KEY-----"];
#ifdef DEBUG
        [JSPatch setupDevelopment];
#endif
        [JSPatch sync];
        
//        测试本地js
//        [JSPatch testScriptInBundle];


      
        
        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
