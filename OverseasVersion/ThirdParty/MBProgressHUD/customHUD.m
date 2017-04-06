//
//  customHUD.m
//  handheldCredit
//
//  Created by devair on 15/8/11.
//  Copyright (c) 2015年 liguiwen. All rights reserved.
//

#import "customHUD.h"
#import "MBProgressHUD.h"
#import "AppDelegate.h"
#import "projectHeader.h"
#import "UIView+Extension.h"
@interface customHUD (){
    double add;
    CATextLayer *textL;
}

@property (strong, nonatomic) MBProgressHUD * mbProgressHUD;
@property (strong, nonatomic) UIImageView *animationImageView;
@property (nonatomic, strong) CAGradientLayer *gradientLayer;
@property (nonatomic, strong) NSTimer *timer;
@property (nonatomic, strong) CAShapeLayer *shapeLayer;


@property (nonatomic,strong) UIView * superView;

@end

@implementation customHUD

- (void)showCustomHUDWithView:(UIView *)view{
//#warning 
//    self.mbProgressHUD = [[MBProgressHUD alloc] initWithView:view];
//    NSMutableArray * imageArr = [NSMutableArray array];
//    for (int i = 0; i < 10; i++) {
//        NSString * imageName = [NSString stringWithFormat:@"common-hud%d.png",i+1];
//        UIImage * image = [UIImage imageNamed:imageName];
//        [imageArr addObject:image];
//    }
//    self.animationImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 65, 65)];
//    self.animationImageView.image = [UIImage imageNamed:@"common-hud1.png"];
//    self.animationImageView.animationImages = imageArr;
//    self.animationImageView.animationDuration = 0.7;
//    [self.animationImageView startAnimating];
//    self.mbProgressHUD.customView = self.animationImageView;
//    self.mbProgressHUD.mode = MBProgressHUDModeCustomView;
//    self.mbProgressHUD.labelText = @"加载中";
//    self.mbProgressHUD.labelFont = kLightFont(11.0);
//    self.mbProgressHUD.labelColor = commonWhiteColor;
//    [self.mbProgressHUD show:YES];
//    [view addSubview:self.mbProgressHUD];
    
    [self addloadingAnimation:view];
    
    
}
- (void)hideCustomHUD{
//    [self.mbProgressHUD removeFromSuperview];
    self.superView.userInteractionEnabled = true;
    [self removeFromSuperview];
}

-(void)addloadingAnimation:(UIView *)addView{

    self.frame             = CGRectMake(0, -100, kScreenWidth, kScreenHeight+100);
    self.backgroundColor = [UIColor whiteColor];
    self.gradientLayer     = [CAGradientLayer layer];
//    self.userInteractionEnabled = false;
    _gradientLayer.frame   = self.frame;
    [_gradientLayer setColors:commonColorS];
    [_gradientLayer setStartPoint:CGPointMake(0, 0)];
    [_gradientLayer setEndPoint:CGPointMake(1, 1)];
    _gradientLayer.type    = kCAGradientLayerAxial;
    UIBezierPath *be       = [UIBezierPath bezierPath];
    [be addArcWithCenter:CGPointMake(50, 50) radius:100 startAngle:0 endAngle:2 * M_PI clockwise:NO];
    _shapeLayer             = [CAShapeLayer layer];
    _shapeLayer.path        = be.CGPath;
    _shapeLayer.fillColor   = [UIColor clearColor].CGColor;
    _shapeLayer.strokeColor = [UIColor orangeColor].CGColor;
    _shapeLayer.strokeEnd   = 0.92f;
    _shapeLayer.strokeStart = 0.f;
    _shapeLayer.lineWidth   = 4;
    _shapeLayer.bounds = CGRectMake(0, 0, 100, 100);
    _shapeLayer.position         = CGPointMake(50, 15);
    
    textL                  = [CATextLayer layer];
    textL.contentsScale    = [UIScreen mainScreen].scale;
    textL.position         = CGPointMake(self.center.x, self.center.y+100);
    textL.bounds           = CGRectMake(0, 0, 100, 100);
    textL.fontSize         = 20;
    textL.alignmentMode    = kCAAlignmentCenter;
    [textL addSublayer:_shapeLayer];
    [_gradientLayer setMask:textL];
    [self.layer addSublayer:_gradientLayer];
    
    
    CABasicAnimation *anim;
    anim=[CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    anim.duration = 1;
    anim.autoreverses=NO;
    anim.repeatCount= 10000;
    anim.fromValue=[NSNumber numberWithFloat:0];
    anim.toValue=[NSNumber numberWithFloat:2 * M_PI];
    anim.removedOnCompletion = NO;
    [_shapeLayer addAnimation:anim forKey:@"layer1Rotation"];
    self.center = addView.center;
    [addView addSubview:self];
    
    self.superView = addView;
    
    self.superView.userInteractionEnabled = false;

}


@end

