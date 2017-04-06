//
//  TransactionsCell.m
//  OverseasVersion
//
//  Created by 梁家文 on 17/2/7.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "TransactionsCell.h"
#import "JWLabel.h"
#import "projectHeader.h"
#import "UIView+Extension.h"
#import "NSString+CustomString.h"

@interface TransactionsCell ()

@property (nonatomic,strong) JWLabel * nameLab;

@property (nonatomic,strong) JWLabel * timeLab;

@property (nonatomic,strong) JWLabel * timeTwoLab;

@property (nonatomic,strong) JWLabel * moneyLab;

@end

@implementation TransactionsCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.nameLab = [[JWLabel alloc]initWithFrame:CGRectMake(20,adaptY(7.5), kScreenWidth/2, adaptY(20))];
//        self.nameLab.text = @"Joshua Gardner";
        self.nameLab.font = kMediumFont(12);
        self.nameLab.textColor = UIColorFromRGB(0x444444);
        self.nameLab.adjustsFontSizeToFitWidth = true;
        [self addSubview:self.nameLab];
        
        self.timeLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.nameLab.frame), kScreenWidth/1.5, adaptY(15))];
//        self.timeLab.text = @"December 12,2016";
        self.timeLab.textColor = UIColorFromRGB(0x4e5052);
        self.timeLab.font = kLightFont(11);
        [self addSubview:self.timeLab];
        
        self.timeTwoLab = [[JWLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.timeLab.frame)+10, self.timeLab.y, kScreenWidth/4, 30)];
//        self.timeTwoLab.text = @"10:02 AM";
        self.timeTwoLab.textColor = commonGrayColor;
        self.timeTwoLab.font = kLightFont(9);
//        [self addSubview:self.timeTwoLab];
        
        
        self.moneyLab = [[JWLabel alloc]initWithFrame:CGRectMake(kScreenWidth-20-kScreenWidth/2.5, adaptY(10), kScreenWidth/2.5, adaptY(30))];
        self.moneyLab.text = @"₱0.00";
        self.moneyLab.textColor = UIColorFromRGB(0x23b800);
        self.moneyLab.font = kLightFont(20);
        self.moneyLab.labelAnotherFont = kLightFont(13);
        self.moneyLab.textAlignment = 2;
        self.moneyLab.adjustsFontSizeToFitWidth = true;
        [self addSubview:self.moneyLab];
        
        
        
        JWLabel * lineLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, adaptY(50)-1, kScreenWidth-40, 1)];
        lineLab.backgroundColor = UIColorFromRGB(0xe8e8e8);
        [self addSubview:lineLab];
        
        
    }
    return self;
}

-(void)setModel:(TradingRecordModel *)model{
    _model = model;
    self.nameLab.text = model.showName;
    self.moneyLab.text =[NSString formatSpecialMoneyString:model.amount.doubleValue];
    if (model.type ==1 || model.type ==72) {
        self.moneyLab.textColor = UIColorFromRGB(0x2fb000);
    }else{
        self.moneyLab.textColor = UIColorFromRGB(0xeb0b00);
    }
    self.timeLab.text = [NSString getpicaTime:model.createTime];
}

@end
