//
//  JWAlertView.m
//  富文本测试
//
//  Created by 梁家文 on 16/3/23.
//  Copyright © 2016年 梁家文. All rights reserved.
//

#define TitleFont [UIFont fontWithName:@"Helvetica-Bold" size:17]

#define MessageFont [UIFont systemFontOfSize:15]

#define ButtonFont [UIFont systemFontOfSize:17]

#import "JWAlertView.h"

#import "JWLabel.h"

#import "UIView+Extension.h"

#import "projectHeader.h"


@interface JWAlertViewQueue : NSObject
@property(nonatomic, strong) NSMutableArray *allAlerts;
@property(nonatomic, assign) BOOL noShow;

+ (instancetype)sharedQueue;
- (BOOL)contains:(JWAlertView *)alertView;
- (JWAlertView *)dequeue;
- (void)enqueue:(JWAlertView *)alertView;
- (void)remove:(JWAlertView *)alertView;
@end

@implementation JWAlertViewQueue

+ (instancetype)sharedQueue{
    static JWAlertViewQueue *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[JWAlertViewQueue alloc] init];
    });
    return instance;
}

- (instancetype)init{
    if(self=[super init]){
        _allAlerts = @[].mutableCopy;
    }
    return self;
}

- (BOOL)contains:(JWAlertView *)alertView{
    return [_allAlerts containsObject:alertView];
}

- (JWAlertView *)dequeue{
    if(_allAlerts.count > 0){
        self.noShow = NO;
        return [_allAlerts firstObject];
    }
    return nil;
}

- (void)enqueue:(JWAlertView *)alertView{
    [_allAlerts addObject:alertView];
}

- (void)remove:(JWAlertView *)alertView{
    if(_allAlerts.count>0){
        if([self contains:alertView]){
            [_allAlerts removeObject:alertView];
        }
    }
}

@end


@interface JWAlertView ()

@property (nonatomic,strong) UIView * whiteView;

@property (nonatomic) CGFloat  whiteViewkWidth;

@property (nonatomic) CGFloat  whiteViewkheight;

@end


@implementation JWAlertView

- ( instancetype)initJWAlertViewWithTitle:(NSString *)title message:(NSString *)message delegate:( id)delegate cancelButtonTitle:(NSString *)cancelButtonTitle otherButtonTitles:(NSArray *)otherButtonTitles{
    self = [super init];
    if (self) {
        
        self.delegate = delegate;
        
        NSMutableArray * btnarr = @[].mutableCopy;
        
        self.frame = [UIScreen mainScreen].bounds;
        
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        self.whiteView =[[UIView alloc]initWithFrame:CGRectMake((kScreenWidth -kScreenWidth*0.8)/2, kScreenHeight/5, kScreenWidth*0.8, 200)];
        
        self.whiteView.backgroundColor = [UIColor whiteColor];
        
        self.whiteView.layer.masksToBounds = YES;
        
        self.whiteView.layer.cornerRadius = 15;
        
        self.whiteViewkWidth = kScreenWidth*0.8;
        
        if (title) {
            CGSize titleSize = [title boundingRectWithSize:CGSizeMake(self.whiteView.width*0.8, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:TitleFont} context:nil].size;
            self.titleLab = [[UITextView alloc]initWithFrame:CGRectMake((self.whiteView.width - self.whiteView.width*0.8)/2, CGRectGetMaxY(self.titleLab.frame)+15, self.whiteView.width*0.8, titleSize.height+20)];
            self.titleLab.font = TitleFont;
            self.titleLab.userInteractionEnabled=false;
            self.titleLab.text = title;
            self.titleLab.textAlignment = 1;
            [self.whiteView addSubview: self.titleLab];
            
        }
        if (message) {
            
            
            CGSize titleSize = [message boundingRectWithSize:CGSizeMake(self.whiteView.width*0.8, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:MessageFont} context:nil].size;
            
            self.messageLab = [[UITextView alloc]initWithFrame:CGRectMake((self.whiteView.width - self.whiteView.width*0.8)/2, CGRectGetMaxY(self.titleLab.frame), self.whiteView.width*0.8, titleSize.height+20)];
            if (!title) {
                self.messageLab.y = 20;
            }
            self.messageLab.font = MessageFont;
            self.messageLab.userInteractionEnabled=false;
            self.messageLab.text = message;
            self.messageLab.textAlignment = 1;
            [self.whiteView addSubview: self.messageLab];
            
        }
        JWLabel * lineLab = [JWLabel addLineLabel:CGRectMake(0, CGRectGetMaxY(self.titleLab.frame)+10, self.whiteView.width, 0.5)];
        if (message) {
            lineLab.y=  CGRectGetMaxY(self.messageLab.frame)+10;
        }
        [self.whiteView addSubview: lineLab];
        
        [self addSubview: self.whiteView];
        
        !cancelButtonTitle ? : [btnarr addObject:cancelButtonTitle];
        
        if (otherButtonTitles) {
            for (NSString * titles in otherButtonTitles) {
                [btnarr addObject:titles];
            }
        }
        
        if (btnarr.count==2) {
            for (int i =0; i<btnarr.count; i++) {
                UIButton * button =[UIButton buttonWithType:UIButtonTypeSystem];
                button.frame=CGRectMake(i*self.whiteView.width/2, CGRectGetMaxY(lineLab.frame), self.whiteView.width/2, 50);
                button.tag = 9200+i;
                [button setTitle:btnarr[i] forState:UIControlStateNormal];
                [self.whiteView addSubview: button];
                button.titleLabel.font = ButtonFont;
                [button addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
                !i ?:[self.whiteView addSubview:[JWLabel addLineLabel:CGRectMake(self.whiteView.width/2, CGRectGetMaxY(lineLab.frame), 0.5, 50)]];
                
                self.whiteView.height = CGRectGetMaxY(button.frame);
                
                self.whiteViewkheight = self.whiteView.height;
            }
        }else{
            if (btnarr.count) {
                for (int i =0; i<btnarr.count; i++) {
                    UIButton * button =[UIButton buttonWithType:UIButtonTypeSystem];
                    button.frame=CGRectMake(0, CGRectGetMaxY(lineLab.frame)+50*i, self.whiteView.width, 50);
                    button.tag = 9200+i;
                    [button setTitle:btnarr[i] forState:UIControlStateNormal];
                    [button addTarget:self action:@selector(tapBtn:) forControlEvents:UIControlEventTouchUpInside];
                    button.titleLabel.font = ButtonFont;
                    [self.whiteView addSubview: button];
                    !i ? :[self.whiteView addSubview:[JWLabel addLineLabel:CGRectMake(0, CGRectGetMaxY(lineLab.frame)+50*i, self.whiteView.width, 0.5)]];
                    self.whiteView.height = CGRectGetMaxY(button.frame);
                    self.whiteViewkheight = self.whiteView.height;
                }
            }else{
                if (!title) {
                    
                    lineLab.hidden=true;
                    
                    self.titleLab.hidden=true;
                    
                    self.messageLab.y = 20;
                    
                    self.whiteView.height = CGRectGetMaxY(self.messageLab.frame)+20;
                    self.whiteViewkheight = self.whiteView.height;
                }else {
                    lineLab.hidden=true;
                    self.whiteView.height = CGRectGetMaxY(self.messageLab.frame)+20;
                    self.whiteViewkheight = self.whiteView.height;
                }
                
            }
            
        }
    }
    
    if(![[JWAlertViewQueue sharedQueue] contains:self]){
        [[JWAlertViewQueue sharedQueue] enqueue:self];
    }
    
    return self;
}

-(void)setTitleLabColor:(UIColor *)color{
    self.titleLab.textColor = color;
}
-(void)setMessageLabColor:(UIColor *)color{
    self.messageLab.textColor = color;
}



-(void)setBtnColor:(UIColor *)color atIndex:(NSInteger)index{
    
    for (UIView * subViews in self.whiteView.subviews) {
        if (subViews.tag == index+9200) {
            UIButton * button = (UIButton *)subViews;
            [button setTitleColor:color forState:UIControlStateNormal];
        }
    }
}

-(void)setBtnBoldFountWithIndex:(NSInteger)index{
    for (UIView * subViews in self.whiteView.subviews) {
        if (subViews.tag == index+9200) {
            UIButton * button = (UIButton *)subViews;
            button.titleLabel.font = TitleFont;
        }
    }
}

-(void)setDelayRemoveTimes:(NSInteger)time{
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(time * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
    
}

-(void)tapBtn:(UIButton *)button{
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(JWalertView:clickedButtonAtIndex:clickedButtonAtTitle:)]) {
        [self.delegate JWalertView:self clickedButtonAtIndex:button.tag-9200 clickedButtonAtTitle:button.titleLabel.text];
    }
    !self.dismissAlertTapEvent ? nil:self.dismissAlertTapEvent();
    if (!self.permanentShow) {
        [self removeFromSuperview];
    }else{
        
        [self.subviews enumerateObjectsUsingBlock:^(__kindof UIView * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            
            obj.userInteractionEnabled = false;
            
        }];
        
    }
    
    if ([JWAlertViewQueue sharedQueue].allAlerts.count != 0) {
        [[JWAlertViewQueue sharedQueue] remove:[JWAlertViewQueue sharedQueue].allAlerts.firstObject];
        JWAlertView *nextAlertView = [[JWAlertViewQueue sharedQueue] dequeue];
        if(nextAlertView){
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [nextAlertView alertShow];
            });
        }else{
            [JWAlertViewQueue sharedQueue].noShow = NO;
        }
    }
    
}

-(void)alertShow{
    
    if ([JWAlertViewQueue sharedQueue].noShow) {
        return;
    }
    
    UIWindow * window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self];
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.2;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 0.8)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.1)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [self.whiteView.layer addAnimation:animation forKey:nil];
    [JWAlertViewQueue sharedQueue].noShow = YES;
}

-(void)layoutSubviews{
    [super layoutSubviews];
    
    self.frame = [UIScreen mainScreen].bounds;
    
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    
    self.whiteView.frame = CGRectMake((kScreenWidth -self.whiteViewkWidth)/2, kScreenHeight/5, self.whiteViewkWidth, self.whiteViewkheight);
    
}


#pragma mark 只有一个按钮的alert快捷实现
+ (instancetype)initAlertViewWithMessage:(NSString * )message singleTapEvent:(void(^)(void))event{
    JWAlertView * alert =[[JWAlertView alloc]initWithMessage:message dismissEvent:event];
    return alert;
}

-(instancetype)initWithMessage:(NSString *)message dismissEvent:(void(^)(void))event{
    self =[super init];
    if (self) {
        if (event) {
            self.dismissAlertTapEvent = event;
        }
        
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        self.whiteView =[[UIView alloc]initWithFrame:CGRectMake((kScreenWidth -kScreenWidth*0.8)/2, kScreenHeight/5, kScreenWidth*0.8, 200)];
        
        self.whiteView.backgroundColor = [UIColor whiteColor];
        self.whiteView.userInteractionEnabled=true;
        
        CGSize titleSize = [message boundingRectWithSize:CGSizeMake(self.whiteView.width*0.75, 0) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:MessageFont} context:nil].size;
        
        self.titleLab = [[UITextView alloc]initWithFrame:CGRectMake((self.whiteView.width - self.whiteView.width*0.8)/2, CGRectGetMaxY(self.titleLab.frame)+15, self.whiteView.width*0.8, titleSize.height+20)];
        self.titleLab.font = MessageFont;
        self.titleLab.userInteractionEnabled=false;
        self.titleLab.text = message;
        self.titleLab.textAlignment = 1;
        [self.whiteView addSubview: self.titleLab];
        
        JWLabel * lineLab = [JWLabel addLineLabel:CGRectMake(0, CGRectGetMaxY(self.titleLab.frame)+10, self.whiteView.width, 0.5)];
        
        [self.whiteView addSubview: lineLab];
        
        UIButton * button =[UIButton buttonWithType:UIButtonTypeSystem];
        
        button.frame=CGRectMake(0, CGRectGetMaxY(lineLab.frame),self.whiteView.width, 50);
        [button setTitle:@"确定" forState:UIControlStateNormal];
        [button setTitleColor:UIColorFromRGB(0xeb6120) forState:UIControlStateNormal];
        [button addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventTouchUpInside];
        [self.whiteView addSubview: button];
        
        self.whiteView.height = CGRectGetMaxY(button.frame);
        self.whiteViewkheight = self.whiteView.height;
        
        self.whiteView.layer.masksToBounds = YES;
        self.whiteView.layer.cornerRadius = 10;
        
        [self addSubview: self.whiteView];
        
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        
        
        [self show];
    }
    return self;
}

- (void)show {
    CAKeyframeAnimation* animation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    animation.duration = 0.2;
    NSMutableArray *values = [NSMutableArray array];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(0.8, 0.8, 0.8)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.1, 1.1, 1.1)]];
    [values addObject:[NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)]];
    animation.values = values;
    [self.whiteView.layer addAnimation:animation forKey:nil];
}

-(void)dismissAlert{
    !self.dismissAlertTapEvent ? nil:self.dismissAlertTapEvent();
    [self removeFromSuperview];
}

@end

