//
//  FriendsTableViewCell.m
//  OverseasVersion
//
//  Created by 梁家文 on 17/2/19.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "FriendsTableViewCell.h"
#import "UIView+Extension.h"
#import "ShadowView.h"

#import "UIImageView+WebCache.h"


#import "NewsModel.h"

@interface FriendsTableViewCell ()

@property (nonatomic,strong) UIImageView *headImageView;//头像
@property (nonatomic,strong) JWLabel * nameLabel;//姓名
@property (nonatomic,strong) ShadowView * payBtn;

@end

@implementation FriendsTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        //布局View
        [self setUpView];
    }
    return self;
}

#pragma mark - setUpView
- (void)setUpView{
    //头像
    [self.contentView addSubview:self.headImageView];
    //姓名
    [self.contentView addSubview:self.nameLabel];
    
    JWLabel * lineLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, 60-1, kScreenWidth-40, 1)];
    lineLab.backgroundColor = UIColorFromRGB(0x7c7c7c);
    [self.contentView addSubview:lineLab];
    
    
    ShadowView * payBtn = [[ShadowView alloc] initWithFrame:
                              CGRectMake(kScreenWidth-90,18,50,24)];
    payBtn.colors =commonColorS;
    HXWeak_self
    [payBtn addSingleTapEvent:^{
        HXStrong_self
//        NSLog(@"pay");
        !_backCellModel ? : _backCellModel(self.cellModel);
    }];
    payBtn.layer.cornerRadius =payBtn.width/8;
    payBtn.layer.masksToBounds =true;
    [self.contentView addSubview:payBtn];
    
    JWLabel * payLab = [[JWLabel alloc]initWithFrame:CGRectMake(0, 0, payBtn.width, payBtn.height)];
    payLab.text = Internationalization(@"支付", @"PAY");
    payLab.textAlignment = 1;
    payLab.textColor = [UIColor whiteColor];
    payLab.font = kMediumFont(9);
    [payBtn addSubview:payLab];
    self.payBtn = payBtn;
    
}
- (UIImageView *)headImageView{
    if (!_headImageView) {
        _headImageView=[[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 40.0, 40.0)];
        _headImageView.backgroundColor = [UIColor whiteColor];
        _headImageView.layer.cornerRadius =_headImageView.width/2;
        _headImageView.layer.masksToBounds =true;
        _headImageView.layer.borderWidth = 1;
//        _headImageView.image = [UIImage imageNamed:@"IMG_3005.PNG"];
        _headImageView.layer.borderColor = commonBlackBtnColor.CGColor;
        [_headImageView setContentMode:UIViewContentModeScaleAspectFill];
    }
    return _headImageView;
}
- (JWLabel *)nameLabel{
    if (!_nameLabel) {
        _nameLabel=[[JWLabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.headImageView.frame)+10, 10, kScreenWidth-60.0, 40.0)];
        _nameLabel.font = kMediumFont(14);
        _nameLabel.textColor = commonBlackBtnColor;
        _nameLabel.labelAnotherFont = kLightFont(14);
    }
    return _nameLabel;
}

-(void)setCellModel:(FriendModel *)cellModel{

    _cellModel = cellModel;
    self.payBtn.hidden = false;
    self.nameLabel.text = [NSString stringWithFormat:@"%@ [%@]",cellModel.firstName,cellModel.lastName];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:cellModel.headPic]];
    
}

-(void)setNewsModel:(NewsModel *)newsModel{

    _newsModel = newsModel;
    self.payBtn.hidden = true;
    
    if (newsModel.shopName.length) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@",newsModel.shopName];
    }else{
        self.nameLabel.text = [NSString stringWithFormat:@""];
    }
    
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:newsModel.headPic]];
    
}

@end
