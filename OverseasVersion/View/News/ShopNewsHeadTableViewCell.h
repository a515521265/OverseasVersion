//
//  ShopNewsHeadTableViewCell.h
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/23.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShopNewsHeadTableViewCell : UITableViewCell

@property (nonatomic,strong) NSString * iconImage;

@property (nonatomic, copy) void(^tapImageView)(UIImageView *);

@end
