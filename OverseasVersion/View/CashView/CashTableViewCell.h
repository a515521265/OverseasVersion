//
//  CashTableViewCell.h
//  OverseasVersion
//
//  Created by 梁家文 on 17/2/7.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ShopModel.h"

@interface CashTableViewCell : UITableViewCell

@property (nonatomic,assign) NSInteger  index;

@property (nonatomic, copy) void(^cellClick)(ShopModel * model);

@property (nonatomic,strong) ShopModel * cellModel;

@end
