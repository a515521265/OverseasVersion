//
//  ShopNewsHeadTableViewCell.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/23.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "ShopNewsHeadTableViewCell.h"
#import "JWLabel.h"
#import "projectHeader.h"
#import "UIView+Extension.h"
#import "NSString+CustomString.h"
#import "UIImageView+WebCache.h"

@interface ShopNewsHeadTableViewCell ()

@property (nonatomic,strong) UIImageView * userIconiamgeV;

@end

@implementation ShopNewsHeadTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.userIconiamgeV = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-adaptX(40))/2,adaptY(15),adaptX(40), adaptX(40))];
        self.userIconiamgeV.layer.cornerRadius =self.userIconiamgeV.width/2;
        self.userIconiamgeV.layer.masksToBounds =true;
//        self.userIconiamgeV.image = [UIImage imageNamed:@"IMG_3005.PNG"];
        self.userIconiamgeV.backgroundColor = [UIColor whiteColor];
        HXWeak_self
        [self.userIconiamgeV addSingleTapEvent:^{
            HXStrong_self
            !self.tapImageView ? : self.tapImageView(self.userIconiamgeV);
        }];
        [self addSubview:self.userIconiamgeV];
        
    }
    return self;
}

-(void)setIconImage:(NSString *)iconImage{

    _iconImage = iconImage;
    
    if ([iconImage isKindOfClass:[NSNull class]]) {
        
    }else{
//        [self.userIconiamgeV sd_setImageWithURL:[NSURL URLWithString:iconImage]];
        
        [self.userIconiamgeV sd_setImageWithURL:[NSURL URLWithString:iconImage] placeholderImage:[UIImage imageNamed:@"UserDefaultIcon.jpg"]];
        
    }
    
    
    
}

@end
