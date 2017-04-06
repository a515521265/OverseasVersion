//
//  CustomTabBarItem.h
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/9.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CustomTabBarItem : UIView

@property (nonatomic,assign) BOOL  selectstatus;

@property (nonatomic,strong) NSString * selectImage;

@property (nonatomic,strong) NSString * defaultImage;

@property (nonatomic,strong) NSString * title;


@end
