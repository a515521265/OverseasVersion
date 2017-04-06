//
//  HXSelectPicture.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/24.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "HXSelectPicture.h"

#import "LGAlertView.h"

#import <AVFoundation/AVFoundation.h>

#import "JWAlertView.h"

#import "TIPTEXT.h"

#import "projectHeader.h"
@interface HXSelectPicture ()<UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,LGAlertViewDelegate>

@property (nonatomic, weak) UIViewController *viewController;
@property (nonatomic, copy) HXmagePickerFinishAction finishAction;
@property (nonatomic, assign) BOOL allowsEditing;

@end

static HXSelectPicture * HXmagePickerInstance = nil;

@implementation HXSelectPicture

+ (void)showImagePickerFromViewController:(UIViewController *)viewController allowsEditing:(BOOL)allowsEditing finishAction:(HXmagePickerFinishAction)finishAction {
    if (HXmagePickerInstance == nil) {
        HXmagePickerInstance = [[HXSelectPicture alloc] init];
    }
    
    [HXmagePickerInstance showImagePickerFromViewController:viewController
                                              allowsEditing:allowsEditing
                                               finishAction:finishAction];
}

- (void)showImagePickerFromViewController:(UIViewController *)viewController
                            allowsEditing:(BOOL)allowsEditing
                             finishAction:(HXmagePickerFinishAction)finishAction {
    _viewController = viewController;
    _finishAction = finishAction;
    _allowsEditing = allowsEditing;
    
    LGAlertView *alertView = nil;
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        alertView = [[LGAlertView alloc] initWithTitle:nil
                                               message:nil
                                                 style:LGAlertViewStyleActionSheet
                                          buttonTitles:@[@"Camera",@"Photo Library"]
                                     cancelButtonTitle:@"Cancel"
                                destructiveButtonTitle:nil
                                              delegate:self];
        
        alertView.buttonsIconImages = @[[UIImage imageNamed:@"Camera1"],[UIImage imageNamed:@"Photo1"]];
        alertView.buttonsIconImagesHighlighted = @[[UIImage imageNamed:@"Camera1"],[UIImage imageNamed:@"Photo1"]];
        alertView.buttonsTextAlignment = NSTextAlignmentLeft;
        alertView.buttonsBackgroundColorHighlighted  = commonGrayBtnColor;
        alertView.cancelButtonBackgroundColorHighlighted = commonGrayBtnColor;
        
        alertView.buttonsTitleColorHighlighted =
        alertView.cancelButtonTitleColorHighlighted = alertView.cancelButtonTitleColor;
        
        
        [alertView showAnimated:YES completionHandler:nil];
    }else {
        alertView = [[LGAlertView alloc] initWithTitle:nil
                                               message:nil
                                                 style:LGAlertViewStyleActionSheet
                                          buttonTitles:@[@"Photo Library"]
                                     cancelButtonTitle:@"Cancel"
                                destructiveButtonTitle:nil
                                              delegate:self];
        
        alertView.buttonsIconImages = @[[UIImage imageNamed:@"Photo1"]];
        alertView.buttonsIconImagesHighlighted = @[[UIImage imageNamed:@"Photo1"]];
        alertView.buttonsTextAlignment = NSTextAlignmentLeft;
        alertView.buttonsBackgroundColorHighlighted  = commonGrayBtnColor;
        alertView.cancelButtonBackgroundColorHighlighted = commonGrayBtnColor;
        
        alertView.buttonsTitleColorHighlighted =
        alertView.cancelButtonTitleColorHighlighted = alertView.cancelButtonTitleColor;
        
        [alertView showAnimated:YES completionHandler:nil];
    }

}

//- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
//    NSString *title = [actionSheet buttonTitleAtIndex:buttonIndex];
//    if ([title isEqualToString:@"Camera"]) {
//        
//        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//        picker.delegate = self;
//        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
//        picker.allowsEditing = _allowsEditing;
//        [_viewController presentViewController:picker animated:YES completion:nil];
//        
//    }else if ([title isEqualToString:@"Photo Library"]) {
//        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
//        picker.delegate = self;
//        picker.allowsEditing = YES;
//        [_viewController presentViewController:picker animated:YES completion:nil];
//    }else {
//        HXmagePickerInstance = nil;
//    }
//}
#pragma mark - LGAlertViewDelegate

- (void)alertView:(LGAlertView *)alertView buttonPressedWithTitle:(NSString *)title index:(NSUInteger)index {
    NSLog(@"action {title: %@, index: %lu}", title, (long unsigned)index);
    
    if ([title isEqualToString:@"Camera"]) {
        
        
        if (![self ValidateCamera]) {
            return;
        }
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.allowsEditing = _allowsEditing;
        [_viewController presentViewController:picker animated:YES completion:nil];
    }else if ([title isEqualToString:@"Photo Library"]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.allowsEditing = _allowsEditing;
        [_viewController presentViewController:picker animated:YES completion:nil];
    }else{
        HXmagePickerInstance = nil;
    }
}

- (void)alertViewCancelled:(LGAlertView *)alertView {
//    NSLog(@"cancel");
}

- (void)alertViewDestructiveButtonPressed:(LGAlertView *)alertView {
//    NSLog(@"destructive");
}
#pragma mark
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *image = info[UIImagePickerControllerEditedImage];
    if (image == nil) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    
    if (_finishAction) {
        _finishAction(image);
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    HXmagePickerInstance = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    if (_finishAction) {
        _finishAction(nil);
    }
    
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    HXmagePickerInstance = nil;
}

-(BOOL)ValidateCamera{
    
    
    //主动去拿相机权限
    NSError *error;
    AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
    if (!input) {
        NSLog(@"%@", [error localizedDescription]);
    }
    //不支持的判断
    NSString *mediaType = AVMediaTypeVideo;
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
    if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            JWAlertView * alert  = [[JWAlertView alloc]initJWAlertViewWithTitle:@"Reminder" message:[TIPTEXT errorCamera] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert alertShow];
        });
        return false;
        
    }
    return true;
}



@end
