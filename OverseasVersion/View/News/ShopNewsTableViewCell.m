//
//  ShopNewsTableViewCell.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/23.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "ShopNewsTableViewCell.h"
#import "JWLabel.h"
#import "projectHeader.h"
#import "NSString+CustomString.h"
#import "NerdyUI.h"

@interface ShopNewsTableViewCell ()

@property (nonatomic,strong) JWLabel * nameLab;

@property (nonatomic,strong) JWLabel * descriptionLab;

@property (nonatomic,strong) JWLabel * timeLab;

@property (nonatomic,strong) JWLabel * timeTwoLab;

@property (nonatomic,strong) JWLabel * moneyLab;


@end

@implementation ShopNewsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        
        self.nameLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, adaptY(10), kScreenWidth/2.2,adaptY(15))];
        self.nameLab.text = @"Happy Students Day!!!";
        self.nameLab.font = kMediumFont(11);
        self.nameLab.textColor = commonBlackFontColor;
        self.nameLab.adjustsFontSizeToFitWidth = true;
        [self addSubview:self.nameLab];
        
        self.descriptionLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.nameLab.frame)+5, kScreenWidth-40, adaptY(15))];
        self.descriptionLab.text = @"It’s Happy Students Day today! Go to your favorite local Starbucks ...";
        self.descriptionLab.textColor = commonBlackFontColor;
        self.descriptionLab.font = kLightFont(10);
        [self addSubview:self.descriptionLab];
        
        
        self.timeTwoLab = [[JWLabel alloc]initWithFrame:CGRectMake(kScreenWidth - kScreenWidth/6 - 20, adaptY(10), kScreenWidth/6, adaptY(15))];
        self.timeTwoLab.text = @"10:02 AM";
        self.timeTwoLab.textColor = commonBlackFontColor;
        self.timeTwoLab.textAlignment = 2;
        self.timeTwoLab.font = kLightFont(10);
        [self addSubview:self.timeTwoLab];
        
        JWLabel * lineLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, adaptY(50)-1, kScreenWidth-40, 1)];
        lineLab.backgroundColor = UIColorFromRGB(0xe8e8e8);
        [self addSubview:lineLab];

        
    }
    return self;
}

-(void)setCellModel:(NewsModel *)cellModel{
    
    _cellModel = cellModel;
    
    self.nameLab.text = cellModel.title;
    
    self.descriptionLab.text = cellModel.newsDesc;
    
    self.timeTwoLab.text = [NSString stringWithdateFrom1970:cellModel.publicTime withFormat:@"HH:mm "].
    a([NSString timeslot:[NSString stringWithdateFrom1970:cellModel.publicTime withFormat:@"a"]]);
    
}

@end
