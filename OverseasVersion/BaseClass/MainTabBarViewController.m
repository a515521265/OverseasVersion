//
//  MainTabBarViewController.m
//  songShuFinance
//
//  Created by 梁家文 on 15/9/16.
//  Copyright (c) 2015年 李贵文. All rights reserved.
//

#import "MainTabBarViewController.h"
#import "ViewController.h"
#import "MainNavController.h"
#import "projectHeader.h"

#import "TransactionsViewController.h"
#import "FriendsViewController.h"
#import "ScanViewController.h"
#import "CashViewController.h"
#import "AccountViewController.h"

#import "CustomTabBarItem.h"

#import "NewsViewController.h"

@interface MainTabBarViewController ()<UITabBarControllerDelegate>

@property (nonatomic,strong) NSMutableArray <CustomTabBarItem *> * items;

@property (nonatomic,strong) NSMutableArray * titleS;

@property (nonatomic,strong) NSMutableArray * images;

@property (nonatomic,strong) NSMutableArray * selectimages;

@end

@implementation MainTabBarViewController


-(instancetype)init{

    if (self = [super init]) {
        
        [self images];
        [self selectimages];
        [self titleS];
        [self items];
        
    }
    
    return self;
    
}


-(NSMutableArray *)images{

    if (!_images) {
        _images = @[@"未选中-1",@"未选中-2",@"未选中-3",@"未选中-4",@"未选中-5"].mutableCopy;
    }
    return _images;
    
}

-(NSMutableArray *)selectimages{

    if (!_selectimages) {
        _selectimages = @[@"选中-1",@"选中-2",@"选中-3",@"选中-4",@"选中-5"].mutableCopy;
    }
    return _selectimages;
}

-(NSMutableArray *)titleS{

    if (!_titleS) {
        _titleS = @[Internationalization(@"交易", @"Transactions"),Internationalization(@"新闻", @"News"),Internationalization(@"扫一扫", @"Scan"),Internationalization(@"转入/转出", @"Cash In/Out"),Internationalization(@"账户", @"Account")].mutableCopy;
    }
    return _titleS;
}


-(NSMutableArray<CustomTabBarItem *> *)items{

    if (!_items) {
        _items = [NSMutableArray arrayWithCapacity:10];
    }
    return _items;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.delegate=self;
    // 1.初始化子控制器
    MainNavController *nav1 = [[MainNavController alloc] initWithRootViewController:[[TransactionsViewController alloc] init]];

//    MainNavController *nav2 = [[MainNavController alloc] initWithRootViewController:[[ViewController alloc]init]];
    MainNavController *nav2 = [[MainNavController alloc] initWithRootViewController:[[NewsViewController alloc]init]];

    MainNavController *nav3 = [[MainNavController alloc] initWithRootViewController:[[ScanViewController alloc] init]];

    MainNavController *nav4 = [[MainNavController alloc] initWithRootViewController:[[CashViewController alloc] init]];
    
    MainNavController *nav5 = [[MainNavController alloc] initWithRootViewController:[[AccountViewController alloc]init]];

    [self addChildViewController:nav1];
    [self addChildViewController:nav2];
    [self addChildViewController:nav3];
    [self addChildViewController:nav4];
    [self addChildViewController:nav5];
    
    NSInteger count = self.childViewControllers.count;
    for (int i = 0; i < count; i++) {
        CustomTabBarItem * item = [[CustomTabBarItem alloc]initWithFrame:CGRectMake(i * self.tabBar.frame.size.width / count, 0, self.tabBar.frame.size.width / count, self.tabBar.frame.size.height)];
        item.selectImage = self.selectimages[i];
        item.defaultImage = self.images[i];
        item.title = self.titleS[i];
        if (!i) {
            item.selectstatus = true;
        }
        [self.tabBar addSubview:item];
        
        [self.items addObject:item];
    }
}

-(void)viewDidLayoutSubviews{

    [super viewDidLayoutSubviews];
    
    for (int i =0; i< self.items.count; i++) {
        self.items[i].frame = CGRectMake(i * self.tabBar.frame.size.width / self.items.count, 0, self.tabBar.frame.size.width / self.items.count, self.tabBar.frame.size.height);
    }
    
}


- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController{
    for (int i =0; i< self.items.count; i++) {
        self.items[i].selectstatus = false;
    }
    self.items[self.selectedIndex].selectstatus = true;
}

-(void)setSelectedIndex:(NSUInteger)selectedIndex{
    
    [super setSelectedIndex:selectedIndex];
    
    for (int i =0; i< self.items.count; i++) {
        self.items[i].selectstatus = false;
    }
    self.items[selectedIndex].selectstatus = true;
}

@end
