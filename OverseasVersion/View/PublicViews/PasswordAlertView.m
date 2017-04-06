//
//  PasswordAlertView.m
//  富文本测试
//
//  Created by 薄睿杰 on 16/5/26.
//  Copyright © 2016年 梁家文. All rights reserved.
//

//颜色
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
// RGB颜色
#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]

#import "JWLabel.h"

#import "UIView+Extension.h"

#import "PasswordAlertView.h"

#import "projectHeader.h"

@interface PasswordAlertView()<UITextFieldDelegate>

@property (nonatomic,copy) void(^passwordkBlock)(NSString *);

@property (nonatomic,strong) UIView * whiteView;

@property (nonatomic,strong) NSMutableArray * textFieldArr;

@property (nonatomic,strong) LJWTextField * textField;

@property (nonatomic,strong) JWLabel * enterLab;

@end

@implementation PasswordAlertView

-(NSMutableArray *)textFieldArr{
    if (!_textFieldArr) {
        _textFieldArr =[NSMutableArray arrayWithCapacity:10];
    }
    return _textFieldArr;
}

-(UITextField *)textField{
    if (!_textField) {
        _textField = [[LJWTextField alloc]init];
        _textField.delegate = self;
        _textField.tintColor =[UIColor clearColor];
        _textField.textColor = [UIColor clearColor];
        _textField.secureTextEntry = YES;
        _textField.keyboardType = UIKeyboardTypeNumberPad;
        [_textField becomeFirstResponder];
    }return _textField;
}

+ (instancetype)initJWAlertViewWithPaymentAmount:(NSString *)paymentAmount remainingBalance:(NSString *)remainingbalance singleTapEvent:(void(^)(NSString * ))event{
    PasswordAlertView * alert =[[PasswordAlertView alloc]initJWAlertViewWithPaymentAmount:paymentAmount remainingBalance:remainingbalance singleTapEvent:event];
    return alert;
}

- (instancetype)jwAlertViewWithPaymentAmount:(NSString *)paymentAmount remainingBalance:(NSString *)remainingbalance singleTapEvent:(void(^)(NSString * ))event{
    
    return [self initJWAlertViewWithPaymentAmount:paymentAmount remainingBalance:remainingbalance singleTapEvent:event];

}


- (void)addNotification{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotify:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardNotify:) name:UIKeyboardWillHideNotification object:nil];
}


#pragma mark - 键盘通知接收处理
- (void)keyboardNotify:(NSNotification *)notify{
    
    NSValue * frameNum = [notify.userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect rect = frameNum.CGRectValue;
    CGFloat keyboardHeight = rect.size.height;//键盘高度
    
    CGFloat duration = [[notify.userInfo objectForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];//获取键盘动画持续时间
    NSInteger curve = [[notify.userInfo objectForKey:UIKeyboardAnimationCurveUserInfoKey] integerValue];//获取动画曲线
    
    if ([notify.name isEqualToString:UIKeyboardWillShowNotification]) {//键盘显示
        UIView * tempView = self.whiteView;
        CGPoint point = [tempView convertPoint:CGPointMake(0, 0) toView:[UIApplication sharedApplication].keyWindow];//计算响应者到和屏幕的绝对位置
        CGFloat keyboardY = kScreenHeight - keyboardHeight;
        CGFloat tempHeight = point.y + tempView.frame.size.height;
        if (tempHeight > keyboardY) {
            CGFloat offsetY;
            if (kScreenHeight-tempHeight < 0) {//判断是否超出了屏幕,超出屏幕做偏移纠正
                offsetY = keyboardY - tempHeight + (tempHeight-kScreenHeight);
            }else{
                offsetY = keyboardY - tempHeight;
            }
            if (duration > 0) {
                [UIView animateWithDuration:duration delay:0 options:curve animations:^{
                    self.whiteView.transform = CGAffineTransformMakeTranslation(0, offsetY);
                } completion:^(BOOL finished) {
                    
                }];
            }else{
                self.whiteView.transform = CGAffineTransformMakeTranslation(0, offsetY);
            }
            
        }
        
    }else if ([notify.name isEqualToString:UIKeyboardWillHideNotification]){//键盘隐藏
        if (duration > 0) {
            [UIView animateWithDuration:duration delay:0 options:curve animations:^{
                self.whiteView.transform = CGAffineTransformIdentity;
            } completion:^(BOOL finished) {
                
            }];
        }else{
            self.whiteView.transform = CGAffineTransformIdentity;
        }
    }
}


-(instancetype)initJWAlertViewWithPaymentAmount:(NSString *)paymentAmount remainingBalance:(NSString *)remainingbalance singleTapEvent:(void(^)(NSString * ))event{
    self =[super init];
    if (self) {
        if (event) {
            self.passwordkBlock = event;
        }
        [self addNotification];
        self.frame = [UIScreen mainScreen].bounds;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        
        self.whiteView =[[UIView alloc]initWithFrame:CGRectMake((kScreenWidth -kScreenWidth*0.8)/2, kScreenHeight/5, kScreenWidth*0.8, 200)];
        
        self.whiteView.backgroundColor = [UIColor whiteColor];
        self.whiteView.userInteractionEnabled=true;
        
        JWLabel * title = [[JWLabel alloc]init];
        title.frame = CGRectMake(0, 25, self.whiteView.width, adaptY(25));
        title.userInteractionEnabled=false;
        title.text = @"Pay";
        title.textAlignment = 1;
        title.font = kLightFont(18);
        title.textColor = commonBlackBtnColor;
        [self.whiteView addSubview:title];
        
        UIButton * closeBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        closeBtn.frame = CGRectMake(adaptX(-5), adaptX(-5),adaptX(25), adaptX(25));
        closeBtn.tintColor = [UIColor grayColor];
        [closeBtn setImage:[UIImage imageNamed:@"关闭"] forState:UIControlStateNormal];
        [closeBtn addTarget:self action:@selector(dismissAlert) forControlEvents:UIControlEventTouchUpInside];
        [self.whiteView addSubview:closeBtn];
        
        
        JWLabel * paymentAmountLab = [[JWLabel alloc]init];
        paymentAmountLab.frame = CGRectMake(0, CGRectGetMaxY(title.frame), self.whiteView.width,adaptY(25));
        paymentAmountLab.userInteractionEnabled=false;
        paymentAmountLab.text = paymentAmount;
        paymentAmountLab.textAlignment = 1;
        paymentAmountLab.font = kLightFont(18);
        paymentAmountLab.textColor = commonBlackBtnColor;
        [self.whiteView addSubview:paymentAmountLab];
        
        JWLabel * remainingbalanceLab = [[JWLabel alloc]init];
        remainingbalanceLab.frame = CGRectMake(0, CGRectGetMaxY(paymentAmountLab.frame), self.whiteView.width, 60);
        remainingbalanceLab.font = kMediumFont(30);
        remainingbalanceLab.userInteractionEnabled=false;
        remainingbalanceLab.textAlignment = 1;
        remainingbalanceLab.isShadow = true;
        remainingbalanceLab.colors = commonColorS;
        remainingbalanceLab.labelAnotherFont = kMediumFont(20);
        remainingbalanceLab.changeTextSize = true;
        remainingbalanceLab.text = remainingbalance;
        [remainingbalanceLab sizeToFit];
        remainingbalanceLab.center = CGPointMake(self.whiteView.bounds.size.width * 0.5, CGRectGetMaxY(paymentAmountLab.frame)+30 );;
        [self.whiteView addSubview:remainingbalanceLab];
        
        
        JWLabel * lineLab = [JWLabel addLineLabel:CGRectMake(0, CGRectGetMaxY(remainingbalanceLab.frame)+20, self.whiteView.width, 1)];
        
        [self.whiteView addSubview: lineLab];
        
        for (int i =0; i<6; i++) {
            UITextField * textField =[[UITextField alloc]initWithFrame:CGRectMake(((self.whiteView.width-234)/2) + 42 * i, CGRectGetMaxY(lineLab.frame)+15, 30, 30)];
//            textField.borderStyle = UITextBorderStyleLine;
            textField.textAlignment = 1;
            textField.userInteractionEnabled =false;
            textField.secureTextEntry = true;
            textField.layer.borderColor = [UIColorFromRGB(0xe8e8e8) CGColor];
            textField.layer.borderWidth = 1;
            [self.whiteView addSubview:textField];
            self.whiteView.height = CGRectGetMaxY(textField.frame)+15;
            
            if (i ==5) {
                self.enterLab = [[JWLabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(textField.frame), self.whiteView.width, 30)];
                self.enterLab.text = Internationalization(@"输入PIN码", @"Enter PIN Code");
                self.enterLab.textColor = commonGrayColor;
                self.enterLab.font = kLightFont(10);
                self.enterLab.textAlignment = 1;
                [self.whiteView addSubview:self.enterLab];
                self.whiteView.height = CGRectGetMaxY(self.enterLab.frame)+5;
            }
            
            [self.textFieldArr addObject:textField];
        }
        self.textField.frame = CGRectMake(0, CGRectGetMaxY(lineLab.frame)+15, self.whiteView.width, 40);
        [self.whiteView addSubview:self.textField];
        
        self.whiteView.layer.cornerRadius = 10;
        
        [self addSubview: self.whiteView];
        
        UIWindow * window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:self];
        
        [self show];
    }
    return self;
}

-(void)setErrorMessage:(NSString *)errorMessage{
    
    _errorMessage = errorMessage;
    
    self.enterLab.text = errorMessage;
    
    
    for (NSInteger i = 0; i < self.textFieldArr.count; i++)
    {
        UITextField *textField = self.textFieldArr[i];
       self.textField.text = textField.text = @"";
        textField.layer.borderColor = commonErrorColor.CGColor;
    }
    
}

-(void)closeKeyboard{
    [[UIApplication sharedApplication].keyWindow endEditing:YES];
}


-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    NSString *passwordText = [textField.text stringByReplacingCharactersInRange:range withString:string];
    
    if (passwordText.length == self.textFieldArr.count)
        [textField resignFirstResponder];// 输入完毕
    for (NSInteger i = 0; i < self.textFieldArr.count; i++)
    {
        UITextField *textField = self.textFieldArr[i];
        
        NSString *passwordChar;
        if (i < passwordText.length)
            passwordChar = [passwordText substringWithRange:NSMakeRange(i, 1)];
        textField.text = passwordChar;
    }
    if (passwordText.length == 6)
    {
        !self.passwordkBlock ? :self.passwordkBlock(passwordText);
        if (!self.permanentShow) {
            [self dismissAlert];
        }
    }
    return true;
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
    [self removeFromSuperview];
}

-(void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end


@implementation LJWTextField
-(BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return false;
}
@end
