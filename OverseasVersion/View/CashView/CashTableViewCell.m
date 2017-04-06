//
//  CashTableViewCell.m
//  OverseasVersion
//
//  Created by 梁家文 on 17/2/7.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "CashTableViewCell.h"
#import "JWLabel.h"
#import "projectHeader.h"
#import "UIView+Extension.h"

@interface CashTableViewCell ()

@property (nonatomic,strong) JWLabel * numberLab;

@property (nonatomic,strong) JWLabel * shopLab;

@property (nonatomic,strong) JWLabel * distanceLab;

@property (nonatomic,strong) UIImageView * iconImageView;

@end

@implementation CashTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.numberLab = [[JWLabel alloc]initWithFrame:CGRectMake(0, 15, 20, adaptY(30))];
        self.numberLab.text = @"1";
        self.numberLab.font = kMediumFont(12);
        self.numberLab.textColor = commonVioletColor;
        [self addSubview:self.numberLab];
        
        self.shopLab = [[JWLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.numberLab.frame), 10, kScreenWidth/1.5, adaptY(20))];
        self.shopLab.text = @"Jack’s Coffee and Bakery Shop";
        self.shopLab.font = kLightFont(12);
        self.shopLab.adjustsFontSizeToFitWidth = true;
        [self addSubview:self.shopLab];
        
        self.distanceLab = [[JWLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.numberLab.frame), CGRectGetMaxY(self.shopLab.frame), kScreenWidth/2, adaptY(20))];
        self.distanceLab.text = @"300 m";
        self.distanceLab.textColor = commonGrayColor;
        self.distanceLab.font = kItalicFont(11);
        [self addSubview:self.distanceLab];
        
        self.iconImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth-44-20, (adaptY(60) -18.5)/2,24, 18.5)];
        self.iconImageView.image = [UIImage imageNamed:@"高跟鞋"];
        [self addSubview:self.iconImageView];
        
        
        UIButton * button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, 0, kScreenWidth, adaptY(60));
        [button addTarget:self action:@selector(tapCell) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:button];
        
    }
    return self;
}

-(void)setIndex:(NSInteger)index{

    _index = index;
    
    self.numberLab.text = [NSString stringWithFormat:@"%ld",(long)_index];
    
}

-(void)tapCell{

    !_cellClick ? : _cellClick(self.cellModel);
    
}


-(void)setCellModel:(ShopModel *)cellModel{

    _cellModel = cellModel;
    
    
    self.shopLab.text = cellModel.name;
    self.distanceLab.text = [NSString stringWithFormat:@"%ld m",(long)cellModel.dict] ;
}


@end
