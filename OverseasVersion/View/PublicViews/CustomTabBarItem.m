//
//  CustomTabBarItem.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/9.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "CustomTabBarItem.h"
#import "JWLabel.h"
#import "UIView+Extension.h"
#import "projectHeader.h"
#import "Masonry.h"

@interface CustomTabBarItem ()

@property (nonatomic,strong) UIImageView * imageView;

@property (nonatomic,strong) JWLabel * titleLab1;

@property (nonatomic,strong) JWLabel * titleLab2;

@end

@implementation CustomTabBarItem

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        
        
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.width - 22)/2, (self.height - 22)/2 -5, 22, 22)];
        [self addSubview:self.imageView];
    
        self.titleLab1 = [[JWLabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageView.frame), self.width, 20)];
        self.titleLab1.font = kLightFont(10);
        self.titleLab1.textAlignment = 1;
        self.titleLab1.hidden = true;
        self.titleLab1.isShadow = true;
        self.titleLab1.colors = commonColorS;
        self.titleLab1.textAlignment = 1;
        [self addSubview:self.titleLab1];
        
        
        self.titleLab2 = [[JWLabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.imageView.frame), self.width, 20)];
        self.titleLab2.font = kLightFont(10);
        self.titleLab2.textAlignment = 1;
        self.titleLab2.textColor = commonGrayColor;
        [self addSubview:self.titleLab2];
        
        
    }
    return self;
    
}

-(void)layoutSubviews{

    [super layoutSubviews];
    
    self.imageView.frame = CGRectMake((self.width - 22)/2, (self.height - 22)/2 -5, 22, 22);
    self.titleLab1.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame), self.width, 20);
    [self.titleLab1 sizeToFit];
    self.titleLab1.center = CGPointMake(self.bounds.size.width * 0.5, 40);
    self.titleLab2.frame = CGRectMake(0, CGRectGetMaxY(self.imageView.frame), self.width, 20);
    
}

-(void)setSelectstatus:(BOOL)selectstatus{
    
    _selectstatus = selectstatus;
    if (selectstatus) {
        self.imageView.image = [UIImage imageNamed:self.selectImage];
        self.titleLab1.hidden = false;
        self.titleLab2.hidden = true;
    }else{
        self.titleLab1.hidden = true;
        self.titleLab2.hidden = false;
        self.imageView.image = [UIImage imageNamed:self.defaultImage];
    }
}

-(void)setDefaultImage:(NSString *)defaultImage{
    
    _defaultImage = defaultImage;
    
    self.imageView.image = [UIImage imageNamed:_defaultImage];
}

-(void)setTitle:(NSString *)title{
    _title = title;
    self.titleLab1.text = _title;
    self.titleLab2.text = _title;
    [self.titleLab1 sizeToFit];
    self.titleLab1.center = CGPointMake(self.bounds.size.width * 0.5, 40);
}



@end
