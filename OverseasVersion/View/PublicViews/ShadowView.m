//
//  ShadowView.m
//  OverseasVersion
//
//  Created by 梁家文 on 17/2/6.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "ShadowView.h"

@interface ShadowView ()<CAAnimationDelegate>

@end

@implementation ShadowView

-(instancetype)init{
    
    if (self = [super init]) {
        [self setClipsToBounds:YES];
    }
    return self;
    
}

-(instancetype)initWithFrame:(CGRect)frame{
    
    if (self= [super initWithFrame:frame]) {
        [self setClipsToBounds:YES];
    }
    return self;
    
}


#define initialSize 1

-(void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag{
    CALayer *layer = [anim valueForKey:@"animationLayer"];
    if(layer){
        [layer removeAnimationForKey:@"scale"];
        [layer removeFromSuperlayer];
        layer = nil;
        anim = nil;
    }
}

-(BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    
    UITouch *aTouch = touch;
    CGPoint aPntTapLocation = [aTouch locationInView:self];
    CALayer *aLayer = [CALayer layer];
    aLayer.backgroundColor = self.tintColor?self.tintColor.CGColor:[UIColor colorWithWhite:1.0 alpha:0.3].CGColor;
    aLayer.frame = CGRectMake(0, 0, initialSize, initialSize);
    aLayer.cornerRadius = initialSize/2;
    aLayer.masksToBounds =  YES;
    aLayer.position = aPntTapLocation;
    [self.layer addSublayer:aLayer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    [animation setToValue:[NSNumber numberWithFloat:(2.5*MAX(self.frame.size.height, self.frame.size.width))/initialSize]];
    [animation setDuration:0.6f];
    [animation setRemovedOnCompletion:NO];
    [animation setFillMode:kCAFillModeForwards];
    
    CAKeyframeAnimation *fade = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
    fade.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:1.0],[NSNumber numberWithFloat:0.5],[NSNumber numberWithFloat:0.0], nil];
    fade.duration = 0.5;
    fade.removedOnCompletion = NO;
    
    CAAnimationGroup *animGroup = [CAAnimationGroup animation];
    animGroup.duration = 0.5f;
    animGroup.delegate=self;
    animGroup.removedOnCompletion = NO;
    animGroup.animations = [NSArray arrayWithObjects:animation,fade, nil];
    [animGroup setValue:aLayer forKey:@"animationLayer"];
    [aLayer addAnimation:animGroup forKey:@"scale"];
    
    return YES;
}

-(void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event{
    [self sendActionsForControlEvents:UIControlEventTouchUpInside];
}



- (void)drawRect:(CGRect)rect
{
    CGContextRef context =UIGraphicsGetCurrentContext();
    
    NSMutableArray *colors = [NSMutableArray arrayWithCapacity:[self.colors count]];
    
    [self.colors enumerateObjectsUsingBlock:^(id obj,NSUInteger idx, BOOL *stop) {
        if ([obj isKindOfClass:[UIColor class]]) {
            [colors addObject:(__bridge id)[obj CGColor]];
        } else if (CFGetTypeID((__bridge void *)obj) == CGColorGetTypeID()) {
            [colors addObject:obj];
        } else {
            @throw [NSException exceptionWithName:@"CRGradientLabelError"
                                          reason:@"Object in gradientColors array is not a UIColor or CGColorRef"
                                        userInfo:NULL];
        }
    }];
    
    CGContextSaveGState(context);
    CGContextScaleCTM(context,1.0, -1.0);
    CGContextTranslateCTM(context,0, -rect.size.height);
    
    
    CGGradientRef gradient =CGGradientCreateWithColors(NULL, (__bridge CFArrayRef)colors, NULL);
    //上下渐变
//    CGPoint startPoint =CGPointMake(CGRectGetMidX(rect),CGRectGetMinY(rect));
//    CGPoint endPoint =CGPointMake(CGRectGetMidX(rect),CGRectGetMaxY(rect));
    //左右渐变
    CGPoint startPoint = CGPointMake(rect.origin.x,
                                     rect.origin.y);
    CGPoint endPoint = CGPointMake(rect.origin.x + rect.size.width,
                                   rect.origin.y + rect.size.height);
    
    
    
    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint,
                                kCGGradientDrawsAfterEndLocation |kCGGradientDrawsBeforeStartLocation);
    
    CGGradientRelease(gradient);
    CGContextRestoreGState(context);
    
    [super drawRect: rect];
}

@end
