//
//  FriendModel.h
//  OverseasVersion
//
//  Created by 梁家文 on 17/2/19.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FriendModel : NSObject

@property (nonatomic,strong) NSString *headPic;
@property (nonatomic,strong) NSString *pinyin;//拼音
@property (nonatomic,strong) NSString * address;
@property (nonatomic,strong) NSString * email;
@property (nonatomic,strong) NSString * firstName;
@property (nonatomic,strong) NSString * lastName;
@property (nonatomic,strong) NSString * mobile;
@property (nonatomic,strong) NSString * qrCode;
@property (nonatomic,strong) NSString * status;

@property (nonatomic,strong) NSString * shopName;

@property (nonatomic,assign) NSInteger  level;

@end
