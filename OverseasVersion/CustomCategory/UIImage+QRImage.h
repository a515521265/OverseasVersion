//
//  UIImage+QRImage.h
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/10.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (QRImage)

+ (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size;

+ (CIImage *)erweimaWithURL:(NSString *)url;

+ (UIImage *)imageWithScreenshot;
//压缩图片
+ (UIImage *)selectAndUniformScaleImageOfImage:(UIImage *)image;
@end
