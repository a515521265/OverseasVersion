//
//  SpinnerCell.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/24.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "SpinnerCell.h"
#import "JWLabel.h"
#import "projectHeader.h"
#import "UIView+Extension.h"
#import "CityModel.h"
#import "YYModel.h"

@interface SpinnerCell ()

@property (nonatomic,strong) JWLabel * titleLab;

@property (nonatomic,strong) JWLabel * lineLab;

@end

@implementation SpinnerCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.titleLab = [[JWLabel alloc]initWithFrame:CGRectMake(5, 0, kScreenWidth, adaptY(20))];
        self.titleLab.font = kLightFont(9);
        self.titleLab.textColor = UIColorFromRGB(0x989299);
        self.titleLab.numberOfLines = 0;
        [self.contentView addSubview:self.titleLab];
        
        self.lineLab = [JWLabel addLineLabel:CGRectMake(0, 0, kScreenWidth, 0.5)];
        [self addSubview:self.lineLab];
        
    }
    return self;
}


-(void)setTitleText:(NSString *)titleText{

    _titleText = titleText;
    
    self.titleLab.text = titleText;
    
    self.titleLab.y = (self.cellHeight - adaptY(20))/2;
    
    self.titleLab.width = self.cellW;
    
    
    CGSize tipLabelsize1 = [self.titleLab.text boundingRectWithSize:CGSizeMake(self.cellW, 0)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName : self.titleLab.font}
                                                    context:nil].size;
    
    self.titleLab.height = tipLabelsize1.height;
    
    self.titleLab.y = (self.cellHeight - tipLabelsize1.height)/2;
    
    self.lineLab.y = self.cellHeight - 0.5;
    
    
}

-(void)setModel:(id)model{

    _model = model;
    
    CityModel * mode = model;
    
    self.titleLab.text = mode.cityName;
    
    self.titleLab.y = (self.cellHeight - adaptY(20))/2;
    
    self.titleLab.width = self.cellW;
    
    CGSize tipLabelsize1 = [self.titleLab.text boundingRectWithSize:CGSizeMake(self.cellW, 0)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName : self.titleLab.font}
                                                            context:nil].size;
    self.titleLab.height = tipLabelsize1.height;
    
    self.titleLab.y = (self.cellHeight - tipLabelsize1.height)/2;
    
    self.lineLab.y = self.cellHeight - 0.5;

}


@end
