//
//  JWLabel.m
//  JWKit
//
//  Created by 薄睿杰 on 16/6/7.
//  Copyright © 2016年 梁家文. All rights reserved.
//

#import "projectHeader.h"

#import "JWLabel.h"

#import "YYWeakProxy.h"

@interface JWLabel ()

@property(nonatomic, strong) UIColor *tempBackgroundColor;
@property(nonatomic, strong) UILongPressGestureRecognizer *longGestureRecognizer;

@end

@implementation JWLabel

+(JWLabel *)setLabelTitle:(NSString *)title setLabelFrame:(CGRect)frame setLabelColor:(UIColor *)color setLabelFont:(UIFont *)font
{
    JWLabel * label = [[JWLabel alloc] initWithFrame:frame];
    label.font = font;
    label.textColor = color;
    if (title) {
        label.text = title;
    }else
    {
        label.text = @"--";
    }
    return label;
}
+(JWLabel *)setLabelTitle:(NSString *)title setLabelSize:(CGSize)size setLabelFrameX:(CGFloat)frameOriginX setLabelFrameY:(CGFloat)frameOriginY setLabelColor:(UIColor *)color setLabelFont:(UIFont *)font{
    JWLabel * label = [JWLabel new];
    label.font = font;
    label.text = title;
    label.textColor = color;
    label.numberOfLines = 0;
    CGSize labelSize = [label.text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:label.font} context:nil].size;
    CGFloat x = frameOriginX;
    CGFloat y = frameOriginY;
    label.frame = (CGRect){{x,y},labelSize};
    return label;
}
- (void)setNumberAnimationForValueContent:(double)value
{
    CGFloat lastValue = [self.text floatValue];
    CGFloat delta = value - lastValue;
    if (delta == 0) return;
    
    if (delta > 0) {
        
        CGFloat ratio = value / 60.0;
        
        NSDictionary *userInfo = @{@"label" : self,
                                   @"value" : @(value),
                                   @"ratio" : @(ratio)
                                   };
        NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.02 target:[YYWeakProxy proxyWithTarget:self] selector:@selector(setupLabelUp:) userInfo:userInfo repeats:YES];
        [[NSRunLoop mainRunLoop] addTimer:timer forMode:NSRunLoopCommonModes];
    }else if (delta < 0){
        self.text = [NSString stringWithFormat:@"%.2f", value];
    }
}

- (void)setupLabelUp:(NSTimer *)timer
{
    NSDictionary *userInfo = timer.userInfo;
    UILabel *label = userInfo[@"label"];
    CGFloat value = [userInfo[@"value"] floatValue];
    CGFloat ratio = [userInfo[@"ratio"] floatValue];
    
    static int flag = 1;
    CGFloat lastValue = [label.text floatValue];
    CGFloat randomDelta = (arc4random_uniform(2) + 1) * ratio;
    CGFloat resValue = lastValue + randomDelta;
    
    if ((resValue >= value) || (flag == 50)) {
        label.text = [NSString stringWithFormat:@"%.2f", value];
        flag = 1;
        [timer invalidate];
        timer = nil;
        return;
    } else {
        label.text = [NSString stringWithFormat:@"%.2f", resValue];
    }
    flag++;
}

- (void)setText:(NSString *)text
{
    if (!text) {
        [super setText:text];
    }else{
        if (([text rangeOfString:@"<"].location != NSNotFound)||([text rangeOfString:@"["].location != NSNotFound)) {
            if (!_labelAnotherFont) {
                _labelAnotherFont = [UIFont systemFontOfSize:25];
            }
            if (!_labelAnotherColor) {
                _labelAnotherColor = [UIColor redColor];
            }
            NSMutableAttributedString *AttributedStr;
            NSRange range1;
            NSRange range2;
            NSUInteger location =0;
            NSUInteger length = 0;
            NSMutableArray *rangeColorArray = [NSMutableArray array];
            NSMutableArray *rangeBoldArray = [NSMutableArray array];
            NSMutableString *mstr = [NSMutableString string];
            NSMutableString *mstr2 = [NSMutableString string];
            [mstr appendString:text];
            [mstr2 appendString:text];
            
            [mstr replaceOccurrencesOfString:@"[" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mstr.length)];
            [mstr replaceOccurrencesOfString:@"]" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mstr.length)];
            [mstr2 replaceOccurrencesOfString:@"<" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mstr2.length)];
            [mstr2 replaceOccurrencesOfString:@">" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mstr2.length)];
            
            range1.location = 0;
            while (range1.location != NSNotFound) {
                range1 = [mstr rangeOfString:@"<"];
                range2 = [mstr rangeOfString:@">"];
                
                if (range1.location != NSNotFound) {
                    location = range1.location;
                    length = range2.location - range1.location-1;
                    if (length > 5000)break;
                    
                    [mstr replaceOccurrencesOfString:@"<" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, range1.location + range1.length)];
                    [mstr replaceOccurrencesOfString:@">" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, range2.location + range2.length - 1)];
                }
                
                NSDictionary *dict = @{@"location":@(location),@"length":@(length)};
                [rangeColorArray addObject:dict];
            }
            
            range1.location = 0;
            length = 0;
            location = 0;
            while (range1.location != NSNotFound) {
                range1 = [mstr2 rangeOfString:@"["];
                range2 = [mstr2 rangeOfString:@"]"];
                
                if (range1.location != NSNotFound) {
                    location = range1.location;
                    length = range2.location - range1.location-1;
                    if (length > 5000)break;
                    
                    [mstr2 replaceOccurrencesOfString:@"[" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, range1.location + range1.length)];
                    [mstr2 replaceOccurrencesOfString:@"]" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, range2.location + range2.length - 1)];
                }
                
                NSDictionary *dict = @{@"location":@(location),@"length":@(length)};
                [rangeBoldArray addObject:dict];
            }
            [mstr2 replaceOccurrencesOfString:@"[" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mstr2.length)];
            [mstr2 replaceOccurrencesOfString:@"]" withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, mstr2.length)];
            
            AttributedStr = [[NSMutableAttributedString alloc]initWithString:mstr];
            for (NSDictionary *dict in rangeColorArray) {
                NSUInteger lo = [dict[@"location"] integerValue];
                NSUInteger le = [dict[@"length"] integerValue];
                [AttributedStr addAttribute:NSForegroundColorAttributeName
                                      value:_labelAnotherColor
                                      range:NSMakeRange(lo, le)];
                
                NSMutableParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
                paragraphStyle.alignment = NSTextAlignmentCenter;
                
                [AttributedStr addAttribute:NSParagraphStyleAttributeName
                                      value:paragraphStyle
                                      range:NSMakeRange(lo, le)];
            }
            
            for (NSDictionary *dict in rangeBoldArray) {
                NSUInteger lo = [dict[@"location"] integerValue];
                NSUInteger le = [dict[@"length"] integerValue];
                
                
                [AttributedStr addAttribute:NSFontAttributeName
                                      value:_labelAnotherFont
                                      range:NSMakeRange(lo, le)];
                
                
                NSMutableParagraphStyle *paragraphStyle = [NSParagraphStyle defaultParagraphStyle].mutableCopy;
                paragraphStyle.alignment = NSTextAlignmentCenter;
                
                [AttributedStr addAttribute:NSParagraphStyleAttributeName
                                      value:paragraphStyle
                                      range:NSMakeRange(lo, le)];
                
            }
            [self setAttributedText:AttributedStr];
        }else{
            if (self.change) {
                NSMutableAttributedString *att = [[NSMutableAttributedString alloc]initWithString:text];
                [att addAttributes:@{NSFontAttributeName:self.font} range:NSMakeRange(0, att.length - 2)];
                [att addAttributes:@{NSFontAttributeName:self.labelAnotherFont} range:NSMakeRange(att.length - 2, 2)];
                self.attributedText = att;
            }else{
                [super setText:text];
            }
        }
        
    }
}

+ (JWLabel *)addLineLabel:(CGRect)frame{
    
    JWLabel * linelab = [[JWLabel alloc] initWithFrame:frame];
    
    linelab.backgroundColor = UIColorFromRGB(0x909090);
    
    return linelab;
}


//选择复制lab实现方法
- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

/// 获取UIEdgeInsets在水平方向上的值
CG_INLINE CGFloat
UIEdgeInsetsGetHorizontalValue(UIEdgeInsets insets) {
    return insets.left + insets.right;
}
/// 获取UIEdgeInsets在垂直方向上的值
CG_INLINE CGFloat
UIEdgeInsetsGetVerticalValue(UIEdgeInsets insets) {
    return insets.top + insets.bottom;
}
- (CGSize)sizeThatFits:(CGSize)size {
    size = [super sizeThatFits:CGSizeMake(size.width - UIEdgeInsetsGetHorizontalValue(self.contentEdgeInsets), size.height - UIEdgeInsetsGetVerticalValue(self.contentEdgeInsets))];
    size.width += UIEdgeInsetsGetHorizontalValue(self.contentEdgeInsets);
    size.height += UIEdgeInsetsGetVerticalValue(self.contentEdgeInsets);
    return size;
}

- (void)drawTextInRect:(CGRect)rect {
    return [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.contentEdgeInsets)];
}

- (void)setHighlightedBackgroundColor:(UIColor *)highlightedBackgroundColor {
    if (highlightedBackgroundColor) {
        self.tempBackgroundColor = self.backgroundColor;
        _highlightedBackgroundColor = highlightedBackgroundColor;
    }
}

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    if (self.highlightedBackgroundColor) {
        self.backgroundColor = highlighted ? self.highlightedBackgroundColor : self.tempBackgroundColor;
    }
}

#pragma mark - 长按复制功能

- (void)setCanPerformCopyAction:(BOOL)canPerformCopyAction {
    _canPerformCopyAction = canPerformCopyAction;
    if (_canPerformCopyAction && !self.longGestureRecognizer) {
        self.userInteractionEnabled = YES;
        self.longGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPressGestureRecognizer:)];
        [self addGestureRecognizer:self.longGestureRecognizer];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleMenuWillHideNotification:) name:UIMenuControllerWillHideMenuNotification object:nil];
        
        if (!self.highlightedBackgroundColor) {
            self.highlightedBackgroundColor = [UIColor colorWithRed:232/255.0 green:232/255.0 blue:232/255.0 alpha:1]; // 设置个默认值
        }
    } else if (!_canPerformCopyAction && self.longGestureRecognizer) {
        [self removeGestureRecognizer:self.longGestureRecognizer];
        self.longGestureRecognizer = nil;
        self.userInteractionEnabled = NO;
        
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

- (BOOL)canBecomeFirstResponder {
    return self.canPerformCopyAction;
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    if ([self canBecomeFirstResponder]) {
        return action == @selector(copyString:);
    }
    return NO;
}

- (void)copyString:(id)sender {
    if (self.canPerformCopyAction) {
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        if (self.text) {
            pasteboard.string = self.text;
        }
    }
}

- (void)handleLongPressGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (!self.canPerformCopyAction) {
        return;
    }
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        [self becomeFirstResponder];
        UIMenuController *menuController = [UIMenuController sharedMenuController];
        UIMenuItem *copyMenuItem = [[UIMenuItem alloc] initWithTitle:@"copy" action:@selector(copyString:)];
        [[UIMenuController sharedMenuController] setMenuItems:@[copyMenuItem]];
        [menuController setTargetRect:self.frame inView:self.superview];
        [menuController setMenuVisible:YES animated:YES];
        
        // 默认背景色
        self.tempBackgroundColor = self.backgroundColor;
        self.backgroundColor = self.highlightedBackgroundColor;
    }
}

- (void)handleMenuWillHideNotification:(NSNotification *)notification {
    if (!self.canPerformCopyAction) {
        return;
    }
    if (self.tempBackgroundColor) {
        self.backgroundColor = self.tempBackgroundColor;
    }
}


- (void)drawRect:(CGRect)rect
{
    if (self.isShadow) {
        CGSize textSize = [self.text sizeWithAttributes:@{NSFontAttributeName : self.font}];
        CGRect textRect = (CGRect){0, 0, textSize};
        
        // 画文字(不做显示用 主要作用是设置layer的mask)
        CGContextRef context = UIGraphicsGetCurrentContext();
        [self.textColor set];
//        [self.text drawWithRect:rect options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.font} context:NULL];
        if (self.change) {
            [self.attributedText drawWithRect:rect options:NSStringDrawingUsesLineFragmentOrigin context:nil];
        }else{
            [self.text drawWithRect:rect options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : self.font} context:NULL];
        }
        
        // 坐标 (只对设置后的画到context起作用 之前画的文字不起作用)
        CGContextTranslateCTM(context, 0.0f, rect.size.height- (rect.size.height - textSize.height)*0.5);
        CGContextScaleCTM(context, 1.0f, -1.0f);
        
        CGImageRef alphaMask = NULL;
        alphaMask = CGBitmapContextCreateImage(context);
        CGContextClearRect(context, rect);// 清除之前画的文字
        
        
        // 设置mask
        CGContextClipToMask(context, rect, alphaMask);
        
        // 画渐变色
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)self.colors, NULL);
        CGPoint startPoint = CGPointMake(textRect.origin.x,
                                         textRect.origin.y);
        CGPoint endPoint = CGPointMake(textRect.origin.x + textRect.size.width,
                                       textRect.origin.y + textRect.size.height);
        CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
        
        // 释放内存
        CGColorSpaceRelease(colorSpace);
        CGGradientRelease(gradient);
        CFRelease(alphaMask);
    }else{
        [super drawRect:rect];
    }
    
    
}


-(CGSize)getLabelSize:(UILabel *)label{
    
    CGSize tipLabelsize2 = [label.text boundingRectWithSize:CGSizeMake(kScreenWidth-50, 0)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName : label.font}
                                                    context:nil].size;
    return tipLabelsize2;
}




@end
