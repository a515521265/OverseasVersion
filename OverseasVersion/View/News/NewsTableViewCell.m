//
//  NewsTableViewCell.m
//  OverseasVersion
//
//  Created by 梁家文 on 17/2/19.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "NewsTableViewCell.h"

#import "JWLabel.h"
#import "projectHeader.h"
#import "UIView+Extension.h"
#import "NSString+CustomString.h"

#import "UIImageView+WebCache.h"

#import "NerdyUI.h"

@interface NewsTableViewCell()

@property (nonatomic,strong) UIImageView * iconImage;

@property (nonatomic,strong) JWLabel * nameLab;

@property (nonatomic,strong) JWLabel * descriptionLab;

@property (nonatomic,strong) JWLabel * timeLab;

@property (nonatomic,strong) JWLabel * timeTwoLab;

@property (nonatomic,strong) JWLabel * lineLab;

@end

@implementation NewsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.iconImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, adaptY(10),adaptX(30) , adaptX(30))];
        self.iconImage.image = [UIImage imageNamed:@"IMG_3005.PNG"];
        [self addSubview:self.iconImage];
        
        self.nameLab = [[JWLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImage.frame)+5, adaptY(10), kScreenWidth/2.2,adaptY(15))];
                self.nameLab.text = @"Hugo Boss";
        self.nameLab.font = kMediumFont(11);
        self.nameLab.textColor = commonBlackFontColor;
        self.nameLab.adjustsFontSizeToFitWidth = true;
        [self addSubview:self.nameLab];
        
        self.descriptionLab = [[JWLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.iconImage.frame)+5, CGRectGetMaxY(self.nameLab.frame), kScreenWidth/2.2, adaptY(15))];
        self.descriptionLab.text = @"20% discount on all listed...";
        self.descriptionLab.textColor = commonBlackFontColor;
        self.descriptionLab.font = kMediumFont(10);
        [self addSubview:self.descriptionLab];
        
        self.timeLab = [[JWLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.descriptionLab.frame)+10, self.descriptionLab.y, kScreenWidth/7, adaptY(15))];
        self.timeLab.text = @"";
        self.timeLab.textColor = commonBlackFontColor;
        self.timeLab.font = kMediumFont(10);
        self.timeLab.adjustsFontSizeToFitWidth = true;
        [self addSubview:self.timeLab];
        
        self.timeTwoLab = [[JWLabel alloc]initWithFrame:CGRectMake(kScreenWidth - kScreenWidth/6 - 10, self.descriptionLab.y, kScreenWidth/6, adaptY(15))];
        self.timeTwoLab.text = @"";
        self.timeTwoLab.textColor = commonBlackFontColor;
        self.timeTwoLab.textAlignment = 2;
        self.timeTwoLab.font = kMediumFont(10);
        self.timeTwoLab.adjustsFontSizeToFitWidth = true;
        [self addSubview:self.timeTwoLab];
        
        JWLabel * lineLab = [[JWLabel alloc]initWithFrame:CGRectMake(10, adaptY(50)-1, kScreenWidth-20, 1)];
        lineLab.backgroundColor = UIColorFromRGB(0xe8e8e8);
        [self addSubview:lineLab];
        self.lineLab = lineLab;

    }
    return self;
}

-(void)layoutSubviews{

    [super layoutSubviews];
    self.iconImage.frame = CGRectMake(10, adaptY(10),adaptX(30) , adaptX(30));
    self.nameLab.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame)+5, adaptY(10), kScreenWidth/2.2,adaptY(15));
    self.descriptionLab.frame = CGRectMake(CGRectGetMaxX(self.iconImage.frame)+5, CGRectGetMaxY(self.nameLab.frame), kScreenWidth/2.2, adaptY(15));
    self.timeLab.frame = CGRectMake(CGRectGetMaxX(self.descriptionLab.frame)+10, self.descriptionLab.y, kScreenWidth/7, adaptY(15));
    self.timeTwoLab.frame = CGRectMake(kScreenWidth - kScreenWidth/6 - 10, self.descriptionLab.y, kScreenWidth/6, adaptY(15));
    self.lineLab.frame = CGRectMake(10, adaptY(50)-1, kScreenWidth-20, 1);
}

-(void)setCellModel:(NewsModel *)cellModel{

    _cellModel = cellModel;
    
    self.nameLab.text = cellModel.shopName;
    
    self.descriptionLab.text = cellModel.title;
    
    [self.iconImage sd_setImageWithURL:[NSURL URLWithString:cellModel.headPic]];
    
//    self.timeLab.text = [NSString stringWithFormat:@"%@",[NSString stringWithdateFrom1970:cellModel.publicTime withFormat:@"MM/dd"]];
    
    self.timeTwoLab.text = [NSString stringWithdateFrom1970:cellModel.publicTime withFormat:@"HH:mm "].a([NSString timeslot:[NSString stringWithdateFrom1970:cellModel.publicTime withFormat:@"a"]]);
    
    ;
    
    NSDate *dateInfo = [NSDate dateWithTimeIntervalSince1970:cellModel.publicTime/1000];
   self.timeLab.text = [self compareDate:dateInfo];
    
}

-(NSString *)compareDate:(NSDate *)date{
    
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *today = [[NSDate alloc] init];
    NSDate *tomorrow, *yesterday;
    
    tomorrow = [today dateByAddingTimeInterval: secondsPerDay];
    yesterday = [today dateByAddingTimeInterval: -secondsPerDay];
    
    // 10 first characters of description is the calendar date:
    NSString * todayString = [[today description] substringToIndex:10];
    NSString * yesterdayString = [[yesterday description] substringToIndex:10];
    NSString * tomorrowString = [[tomorrow description] substringToIndex:10];
    
    NSString * dateString = [[date description] substringToIndex:10];
    
    
    
    
    NSDateFormatter * formatter = [[NSDateFormatter alloc] init];
    //    formatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
    //    [formatter setTimeZone:[NSTimeZone timeZoneForSecondsFromGMT:8]];
    [formatter setDateFormat:@"MM/dd"];
    NSString * date_String = [formatter stringFromDate:date];
    
    if ([dateString isEqualToString:todayString])
    {
        return @"today";
    } else if ([dateString isEqualToString:yesterdayString])
    {
        return @"yesterday";
    }else if ([dateString isEqualToString:tomorrowString])
    {
//        return @"明天";
        return date_String;
    }
    else
    {
        return date_String;
    }
}



@end
