//
//  MainNavController.m
//  handheldCredit
//
//  Created by boruijie on 15/9/1.
//  Copyright (c) 2015年 liguiwen. All rights reserved.
//

#import "MainNavController.h"
#import "AppDelegate.h"
#import "projectHeader.h"
#import "JWLabel.h"
@interface MainNavController ()

@end

@implementation MainNavController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self){
    }
    return self;
}


- (void)viewDidLoad{
    [super viewDidLoad];
    //返回箭头的颜色
    self.navigationBar.tintColor = BaseTitleTextColor;
    self.navigationBar.translucent = NO;
    //开启滑动返回
    self.interactivePopGestureRecognizer.delegate = (id<UIGestureRecognizerDelegate>)self;
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated{
    [super pushViewController:viewController animated:animated];
    if (viewController.navigationItem.leftBarButtonItem == nil && [self.viewControllers count] > 1)
    {
        viewController.navigationItem.leftBarButtonItem =[self createBackButton];
    }
}

-(void)setViewControllers:(NSArray<UIViewController *> *)viewControllers animated:(BOOL)animated{

    [super setViewControllers:viewControllers animated:animated];

    if (viewControllers.lastObject.navigationItem.leftBarButtonItem == nil && [self.viewControllers count] > 1)
    {
        viewControllers.lastObject.navigationItem.leftBarButtonItem =[self createBackButton];
    }
}

#pragma mark 重写barbutton
-(UIBarButtonItem *)createBackButton
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundImage:[UIImage imageNamed:@"返回"]
                      forState:UIControlStateNormal];
    [button addTarget:self action:@selector(popself)
     forControlEvents:UIControlEventTouchUpInside];
    button.frame = resetRectWH2(16, (44 -18 *commonAppDelegate.autoSizeScaleY) /2, 18, 18);
    UIBarButtonItem *menuButton = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = menuButton;

    return menuButton;
}


-(void)popself{
    [self popViewControllerAnimated:YES];
}



@end
