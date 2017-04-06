//
//  FriendsTableViewCell.h
//  OverseasVersion
//
//  Created by 梁家文 on 17/2/19.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "projectHeader.h"
#import "JWLabel.h"
#import "FriendModel.h"
#import "NewsModel.h"

@interface FriendsTableViewCell : UITableViewCell

@property (nonatomic,strong) FriendModel * cellModel;

@property (nonatomic,strong) NewsModel * newsModel;

@property (nonatomic, copy) void(^backCellModel)(FriendModel *);

@end
