//
//  UIImage+QRImage.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/10.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "UIImage+QRImage.h"

#import "projectHeader.h"

@implementation UIImage (QRImage)

#pragma mark - 生成二维码
+(CIImage *)erweimaWithURL:(NSString *)url
{
    //二维码滤镜
    
    CIFilter *filter=[CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    //恢复滤镜的默认属性
    
    [filter setDefaults];
    
    //将字符串转换成NSData
    
    NSData *data=[url dataUsingEncoding:NSUTF8StringEncoding];
    
    //通过KVO设置滤镜inputmessage数据
    
    [filter setValue:data forKey:@"inputMessage"];
    
    //获得滤镜输出的图像
    CIImage *outputImage=[filter outputImage];
    
    return outputImage;
}

//改变二维码大小
//+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
//    
//    CGRect extent = CGRectIntegral(image.extent);
//    
//    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
//    
//    // 创建bitmap;
//    
//    size_t width = CGRectGetWidth(extent) * scale;
//    
//    size_t height = CGRectGetHeight(extent) * scale;
//    
//    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
//    
//    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
//    
//    CIContext *context = [CIContext contextWithOptions:nil];
//    
//    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
//    
//    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
//    
//    CGContextScaleCTM(bitmapRef, scale, scale);
//    
//    CGContextDrawImage(bitmapRef, extent, bitmapImage);
//    
//    // 保存bitmap到图片
//    
//    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
//    
//    CGContextRelease(bitmapRef);
//    
//    CGImageRelease(bitmapImage);
//    
//    return [UIImage imageWithCGImage:scaledImage];
//
//}


+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size {
    
    CGRect extent = CGRectIntegral(image.extent);
    
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 创建bitmap;
    
    size_t width = CGRectGetWidth(extent) * scale;
    
    size_t height = CGRectGetHeight(extent) * scale;
    
    
    //画渐变？
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)commonColorS, NULL);
    CGPoint startPoint = CGPointMake(extent.origin.x,
                                     extent.origin.y);
    CGPoint endPoint = CGPointMake(extent.origin.x + extent.size.width,
                                   extent.origin.y + extent.size.height);
    
    
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, colorSpace, (CGBitmapInfo)kCGImageAlphaNone);
    
    CGContextDrawLinearGradient(bitmapRef, gradient, startPoint, endPoint, kCGGradientDrawsBeforeStartLocation | kCGGradientDrawsAfterEndLocation);
    

    
    CIContext *context = [CIContext contextWithOptions:nil];
    
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    
    CGContextScaleCTM(bitmapRef, scale, scale);
    
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 保存bitmap到图片
    
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    
    CGContextRelease(bitmapRef);
    
    CGImageRelease(bitmapImage);
    
    return [UIImage imageWithCGImage:scaledImage];
    
    
    //    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    //    CGFloat locations[] = { 0.0, 1.0 };
    //
    //    NSArray *colors = @[(__bridge id) startColor, (__bridge id) endColor];
    //
    //    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef) colors, locations);
    //
    //
    //    CGRect pathRect = CGPathGetBoundingBox(path);
    //
    //    //具体方向可根据需求修改
    //    CGPoint startPoint = CGPointMake(CGRectGetMinX(pathRect), CGRectGetMidY(pathRect));
    //    CGPoint endPoint = CGPointMake(CGRectGetMaxX(pathRect), CGRectGetMidY(pathRect));
    //
    //    CGContextSaveGState(context);
    //    CGContextAddPath(context, path);
    //    CGContextClip(context);
    //    CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
    //    CGContextRestoreGState(context);
    //
    //    CGGradientRelease(gradient);
    //    CGColorSpaceRelease(colorSpace);
    
}

+ (UIImage *)imageWithScreenshot{
    
    NSData *imageData = [self dataWithScreenshotInPNGFormat];
    return [UIImage imageWithData:imageData];
}

/**
 *  截取当前屏幕
 *
 *  @return NSData *
 */
+ (NSData *)dataWithScreenshotInPNGFormat
{
    CGSize imageSize = CGSizeZero;
    UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
    if (UIInterfaceOrientationIsPortrait(orientation))
        imageSize = [UIScreen mainScreen].bounds.size;
    else
        imageSize = CGSizeMake([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (UIWindow *window in [[UIApplication sharedApplication] windows])
    {
        CGContextSaveGState(context);
        CGContextTranslateCTM(context, window.center.x, window.center.y);
        CGContextConcatCTM(context, window.transform);
        CGContextTranslateCTM(context, -window.bounds.size.width * window.layer.anchorPoint.x, -window.bounds.size.height * window.layer.anchorPoint.y);
        if (orientation == UIInterfaceOrientationLandscapeLeft)
        {
            CGContextRotateCTM(context, M_PI_2);
            CGContextTranslateCTM(context, 0, -imageSize.width);
        }
        else if (orientation == UIInterfaceOrientationLandscapeRight)
        {
            CGContextRotateCTM(context, -M_PI_2);
            CGContextTranslateCTM(context, -imageSize.height, 0);
        } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
            CGContextRotateCTM(context, M_PI);
            CGContextTranslateCTM(context, -imageSize.width, -imageSize.height);
        }
        if ([window respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)])
        {
            [window drawViewHierarchyInRect:window.bounds afterScreenUpdates:YES];
        }
        else
        {
            [window.layer renderInContext:context];
        }
        CGContextRestoreGState(context);
    }
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return UIImagePNGRepresentation(image);
}


//压缩图片
+ (UIImage *)selectAndUniformScaleImageOfImage:(UIImage *)image {
    UIImage * newImage = nil;
    CGSize imageSize = image.size;
    CGFloat imageWidth = imageSize.width;
    CGFloat imageHeight = imageSize.height;
    CGFloat maxFloat = 1280;
    CGFloat newImageWidth;
    CGFloat newImageHeight;
    if (imageWidth > imageHeight) {
        if (imageWidth > maxFloat) {
            newImageWidth = maxFloat;
            newImageHeight = (maxFloat * imageHeight) / imageWidth;
        }else{
            newImageWidth = imageWidth;
            newImageHeight = imageHeight;
        }
    }else if (imageHeight > imageWidth){
        if (imageHeight > maxFloat) {
            newImageHeight = maxFloat;
            newImageWidth = (maxFloat * imageWidth) / imageHeight;
        }else{
            newImageHeight = imageHeight;
            newImageWidth = imageWidth;
        }
    }else if (imageHeight == imageWidth){
        if (imageWidth > maxFloat) {
            newImageHeight = maxFloat;
            newImageWidth = maxFloat;
        }else{
            newImageHeight = imageHeight;
            newImageWidth = imageWidth;
        }
    }
    CGSize newImageSize = CGSizeMake(newImageWidth, newImageHeight);
    UIGraphicsBeginImageContext(newImageSize);
    [image drawInRect:CGRectMake(0, 0, newImageSize.width, newImageSize.height)];
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if (newImage == nil) {
        NSLog(@"scale image fail");
    }
    UIGraphicsEndImageContext();
    return newImage;
}



@end
