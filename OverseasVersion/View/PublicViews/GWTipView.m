//
//  GWTipView.m
//  coreEnterpriseDW
//
//  Created by 李贵文 on 16/5/27.
//  Copyright © 2016年 Nathaniel. All rights reserved.
//

#import "GWTipView.h"
#import "ProjectHeader.h"

@interface GWTipView ()

@property (assign, nonatomic) CGRect lableFrame;

@end

@implementation GWTipView

- (id)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

+ (void)createTooltipViewWithMarkedWords:(NSString *)markWord view:(UIView *)showView{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setTitle:markWord forState:UIControlStateNormal];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:15];
    button.titleLabel.numberOfLines = 0;
    CGSize selfSize = [markWord boundingRectWithSize:CGSizeMake(showView.frame.size.width * 0.8, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:button.titleLabel.font} context:nil].size;
    button.frame = (CGRect){0,0,{selfSize.width,selfSize.height}};
    button.center = CGPointMake(showView.center.x, showView.center.y * 0.75);
    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    
    UIView *backView = [[UIView alloc] init];
    backView.frame = CGRectMake(0, 0, button.frame.size.width + 20, button.frame.size.height + 20);
    backView.center = CGPointMake(showView.center.x, showView.center.y * 0.75);
    backView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.5];
    backView.layer.cornerRadius = 5;
    backView.layer.masksToBounds = YES;
    
    [showView addSubview:backView];
    [showView addSubview:button];
    
    [self removeAllSubviews:button backView:backView];
}

+ (void)removeAllSubviews:(UIButton *)button backView:(UIView *)backView{
    [UIView animateWithDuration:5.0f animations:^{
        button.alpha = 0;
        backView.alpha = 0;
    } completion:^(BOOL finished) {
        [button removeFromSuperview];
        [backView removeFromSuperview];
    }];
}

+ (GWTipView *)createTipViewWithFrame:(CGRect)frame markedWords:(NSString *)markWords view:(UIView *)view{
    
    GWTipView * gtTooltipView =[[GWTipView alloc] initWithTipViewOfMessage:markWords LableFrame:frame];
    [view addSubview:gtTooltipView];
    [UIView animateWithDuration:5.0f animations:^{
        gtTooltipView.alpha = 0;
    } completion:^(BOOL finished) {
        [gtTooltipView removeFromSuperview];
    }];
    return gtTooltipView;
}

// 固定高度
+ (GWTipView *)createTipMultipleViewWithFrame:(CGRect)frame markedWords:(NSString *)markWords view:(UIView *)view {
    GWTipView * gtTooltipView =[[GWTipView alloc] initWithTipMultipleViewOfMessage:markWords LableFrame:frame];
    [view addSubview:gtTooltipView];
    [UIView animateWithDuration:5.0f animations:^{
        gtTooltipView.alpha = 0;
    } completion:^(BOOL finished) {
        [gtTooltipView removeFromSuperview];
    }];
    return gtTooltipView;
}
// 固定高度
- (id)initWithTipMultipleViewOfMessage:(NSString *)message LableFrame:(CGRect)lableFrame {
    if (self == [super init]) {
        self.messageLab = [[UILabel alloc] initWithFrame:lableFrame];
        self.lableFrame = lableFrame;
        self.messageLab.backgroundColor = [UIColor blackColor];
        self.messageLab.alpha = 0.8;
        self.messageLab.layer.masksToBounds = YES;
        self.messageLab.layer.cornerRadius = 5.0;
        self.messageLab.numberOfLines = 0;
        self.messageLab.text = message;
        self.messageLab.textAlignment = NSTextAlignmentCenter;
        self.messageLab.textColor = [UIColor whiteColor];
        self.messageLab.font = kMediumFont(13.0);
        
        self.messageLab.frame = lableFrame;
        
        [self addSubview:self.messageLab];
    }
    return self;
}

- (id)initWithTipViewOfMessage:(NSString *)message LableFrame:(CGRect)lableFrame{
    if (self == [super init]) {
        self.messageLab = [[UILabel alloc] initWithFrame:lableFrame];
        self.lableFrame = lableFrame;
        self.messageLab.backgroundColor = [UIColor blackColor];
        self.messageLab.alpha = 0.8;
        self.messageLab.layer.masksToBounds = YES;
        self.messageLab.layer.cornerRadius = 5.0;
        self.messageLab.numberOfLines = 0;
        self.messageLab.text = message;
        self.messageLab.textAlignment = NSTextAlignmentCenter;
        self.messageLab.textColor = [UIColor whiteColor];
        self.messageLab.font = kMediumFont(13.0);
        CGSize lableSize = [self.messageLab.text boundingRectWithSize:CGSizeMake(lableFrame.size.width, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:self.messageLab.font}context:nil].size;
        [self.messageLab setFrame:CGRectMake(lableFrame.origin.x, lableFrame.origin.y, lableFrame.size.width, lableSize.height +10)];
        [self addSubview:self.messageLab];
    }
    return self;
}

- (void)show{
    UIViewController *topVC = [self appRootViewController];
    self.frame = self.lableFrame;
    [topVC.view addSubview:self];
    [UIView animateWithDuration:5.0f animations:^{
        self.messageLab.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (UIViewController *)appRootViewController{
    UIViewController *appRootVC = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *topVC = appRootVC;
    while (topVC.presentedViewController) {
        topVC = topVC.presentedViewController;
    }
    return topVC;
}

@end
