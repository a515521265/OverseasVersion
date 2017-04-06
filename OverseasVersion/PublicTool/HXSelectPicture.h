//
//  HXSelectPicture.h
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/24.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef void (^HXmagePickerFinishAction)(UIImage *image);

@interface HXSelectPicture : NSObject

/**
 @param viewController  用于present UIImagePickerController对象
 @param allowsEditing   是否允许用户编辑图像
 */
+ (void)showImagePickerFromViewController:(UIViewController *)viewController
                            allowsEditing:(BOOL)allowsEditing
                             finishAction:(HXmagePickerFinishAction)finishAction;

@end
