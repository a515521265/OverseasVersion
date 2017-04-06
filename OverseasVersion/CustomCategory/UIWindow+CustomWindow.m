//
//  UIWindow+CustomWindow.m
//  songShuFinance
//
//  Created by 梁家文 on 15/9/16.
//  Copyright (c) 2015年 李贵文. All rights reserved.
//

#import "UIWindow+CustomWindow.h"
#import "MainTabBarViewController.h"
#import "MainNavController.h"
//#import "NewfeatureViewController.h"
#import "LoginViewController.h"

@implementation UIWindow (CustomWindow)
- (void)switchRootViewController
{
    NSString *key = @"CFBundleVersion";
    // 上一次的使用版本（存储在沙盒中的版本号）
    NSString *lastVersion = [[NSUserDefaults standardUserDefaults] objectForKey:key];
    // 当前软件的版本号（从Info.plist中获得）
    NSString *currentVersion = [NSBundle mainBundle].infoDictionary[key];
    
    if ([currentVersion isEqualToString:lastVersion]) { // 版本号相同：这次打开和上次打开的是同一个版本
//        self.rootViewController = [[MainTabBarViewController alloc] init];
        
        LoginViewController * login = [[LoginViewController alloc]init];
        MainNavController * nav = [[MainNavController alloc]initWithRootViewController:login];
        self.rootViewController = nav;
        
    } else { // 这次打开的版本和上一次不一样，显示新特性
//        self.rootViewController = [[NewfeatureViewController alloc] init];
        self.rootViewController = [[MainTabBarViewController alloc] init];
        // 将当前的版本号存进沙盒
        [[NSUserDefaults standardUserDefaults] setObject:currentVersion forKey:key];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}
@end
