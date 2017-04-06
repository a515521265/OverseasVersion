//
//  NewsHeadTableViewCell.m
//  OverseasVersion
//
//  Created by 梁家文 on 17/2/19.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "NewsHeadTableViewCell.h"
#import "JWLabel.h"
#import "projectHeader.h"
#import "UIView+Extension.h"
#import "NSString+CustomString.h"
#import "Masonry.h"

@implementation NewsHeadTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        JWLabel * lab = [[JWLabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, adaptY(50))];
        lab.textAlignment = 1;
        lab.text =
        Internationalization(@"商户新闻", @"Merchant News");
        lab.font = kMediumFont(23);
        lab.textColor = commonBlackFontColor;
        [self addSubview:lab];
        
        [lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self);
        }];
        
        
    }
    return self;
}
@end
