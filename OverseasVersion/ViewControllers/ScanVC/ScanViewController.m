//
//  ScanViewController.m
//  OverseasVersion
//
//  Created by 梁家文 on 17/2/6.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "ScanViewController.h"

#import <AVFoundation/AVFoundation.h>

#import "OppositePayViewController.h"

#import "UIImage+QRImage.h"

#import "ShadowView.h"

#import "QRCodeImage.h"

#import "FriendsViewController.h"

#import "QRCodeGenerator.h"
#import "UIImage+instask.h"
#import "LGAlertView.h"

#import "ALAssetsLibrary+CustomPhotoAlbum.h"


@interface ScanViewController ()<AVCaptureMetadataOutputObjectsDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate,LGAlertViewDelegate>
{
    AVCaptureSession * session;//输入输出的中间桥梁
}

@property (nonatomic,strong) JWScrollviewCell * QRCodeCell;

@property (nonatomic,strong) JWScrollviewCell * scanQRCodeCell;

@property (nonatomic,assign) BOOL isScan;

@property (nonatomic,strong) UIImagePickerController *imagrPicker;

@end

@implementation ScanViewController

-(UIImagePickerController *)imagrPicker{

    if (!_imagrPicker) {
        _imagrPicker = [[UIImagePickerController alloc]init];
        _imagrPicker.delegate = self;
        _imagrPicker.allowsEditing = YES;
        //将来源设置为相册
        _imagrPicker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        
        [self presentViewController:_imagrPicker animated:YES completion:nil];
    }
    return _imagrPicker;
}

-(JWScrollviewCell *)scanQRCodeCell{

    if (!_scanQRCodeCell) {
        _scanQRCodeCell = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        
        NSString *mediaType = AVMediaTypeVideo;
        AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
        if(authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        
            //不支持相机
            UIImageView * imageView = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth - kScreenWidth/2)/2, 40, kScreenWidth/2, kScreenWidth/2)];
            [_scanQRCodeCell.contentView addSubview:imageView];
            
            UIImageView * image1 = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth - kScreenWidth/2)/2, 39, 25.5, 25.5)];
            image1.image = [UIImage imageNamed:@"左上"];
            [_scanQRCodeCell.contentView addSubview:image1];
            
            UIImageView * image2 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)-24.5, 39, 25.5, 25.5)];
            image2.image = [UIImage imageNamed:@"右上"];
            [_scanQRCodeCell.contentView addSubview:image2];
            
            UIImageView * image3 = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth - kScreenWidth/2)/2, CGRectGetMaxY(imageView.frame)-23.5, 25.5, 25.5)];
            image3.image = [UIImage imageNamed:@"左下"];
            [_scanQRCodeCell.contentView addSubview:image3];
            
            UIImageView * image4 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(imageView.frame)-24.5, CGRectGetMaxY(imageView.frame)-23.5, 25.5, 25.5)];
            image4.image = [UIImage imageNamed:@"右下"];
            [_scanQRCodeCell.contentView addSubview:image4];
            
            
            ShadowView * lineView1 = [ShadowView new];
            lineView1.colors =commonColorS;
            lineView1.frame = CGRectMake(imageView.x+20,40 + imageView.height/2, imageView.width-40, 2);
//            lineView1.transform = CGAffineTransformMakeRotation(95);
            [_scanQRCodeCell.contentView addSubview:lineView1];
            
            ShadowView * skipBtn = [[ShadowView alloc] initWithFrame:
                                      CGRectMake(20,CGRectGetMaxY(imageView.frame)+adaptY(30),kScreenWidth-40,ShadowViewHeight)];
            skipBtn.colors =commonColorS;
            [skipBtn addSingleTapEvent:^{
                [self skipSetting];
            }];
            [_scanQRCodeCell.contentView addSubview:skipBtn];
            

            JWLabel * skipLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, skipBtn.y, skipBtn.width, skipBtn.height)];
            skipLab.text = Internationalization(@"打开", @"Open");
            skipLab.textAlignment = 1;
            skipLab.textColor = [UIColor whiteColor];
            skipLab.font = kMediumFont(14);
            [_scanQRCodeCell.contentView addSubview:skipLab];
            
            
            JWLabel *tipLabel = [[JWLabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(skipBtn.frame)+5, kScreenWidth, 30)];
            tipLabel.font = kLightFont(11);
            tipLabel.textColor = commonGrayColor;
            tipLabel.textAlignment = NSTextAlignmentCenter;
            tipLabel.numberOfLines = 0;
            tipLabel.text = Internationalization(@"点击上面的按钮去开启相机权限", @"Click the button above Camera permission open");
            tipLabel.tag = 1999;
            [_scanQRCodeCell.contentView addSubview:tipLabel];
            
            
            JWLabel * tipLab = [[JWLabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(tipLabel.frame)+adaptY(20),kScreenWidth , 50)];
            tipLab.text = Internationalization(@"我的二维码", @"My QR Code");;
            tipLab.font = kMediumFont(14);
            tipLab.textAlignment = 1;
            tipLab.textColor = commonGrayColor;
            [_scanQRCodeCell.contentView addSubview:tipLab];
            
            HXWeak_self
            UIImageView * tipimageView= [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-48)/2, (CGRectGetMaxY(tipLab.frame)), 48, 48)];
            tipimageView.image = [UIImage imageNamed:@"二维码"];
            
            [tipimageView addSingleTapEvent:^{
                HXStrong_self
                [self.view addSubview:self.QRCodeCell];
                self.isScan = false;
                [self.scanQRCodeCell removeFromSuperview];
                self.scanQRCodeCell = nil;
            }];
            [_scanQRCodeCell.contentView addSubview:tipimageView];
            

        }else{

            NSError *error;
            //获取摄像设备
            AVCaptureDevice * device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
            //创建输入流
            AVCaptureDeviceInput * input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
            if (!input) {
                NSLog(@"%@", [error localizedDescription]);
                return _scanQRCodeCell;
            }
            //创建输出流
            AVCaptureMetadataOutput * output = [[AVCaptureMetadataOutput alloc] init];
            //设置敏感区域
            //    output.rectOfInterest = CGRectMake(toTop/KScreen_Height, ((KScreen_Width - size)/2)/KScreen_Width, (size)/KScreen_Height, (size)/KScreen_Width);
            output.rectOfInterest = CGRectMake(0, 0, kScreenWidth, kScreenHeight);
            //设置代理 在主线程里刷新
            [output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
            //初始化链接对象
            session = [[AVCaptureSession alloc] init];
            //高质量采集率
            [session setSessionPreset:AVCaptureSessionPresetHigh];
            //添加输入输出流
            [session addInput:input];
            [session addOutput:output];
            //设置扫码支持的编码格式(如下设置条形码和二维码兼容)
            output.metadataObjectTypes = @[AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code];
            
            AVCaptureVideoPreviewLayer * layer = [AVCaptureVideoPreviewLayer layerWithSession:session];
            layer.videoGravity = AVLayerVideoGravityResizeAspectFill;
            layer.frame = CGRectMake(42, 40, kScreenWidth-84, kScreenWidth-84);
            [_scanQRCodeCell.contentView.layer insertSublayer:layer atIndex:0];
            
            UIImageView * image1 = [[UIImageView alloc]initWithFrame:CGRectMake(41, 39, 25.5, 25.5)];
            image1.image = [UIImage imageNamed:@"左上"];
            [_scanQRCodeCell.contentView addSubview:image1];
            
            UIImageView * image2 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(layer.frame)-24.5, 39, 25.5, 25.5)];
            image2.image = [UIImage imageNamed:@"右上"];
            [_scanQRCodeCell.contentView addSubview:image2];
            
            UIImageView * image3 = [[UIImageView alloc]initWithFrame:CGRectMake(41, CGRectGetMaxY(layer.frame)-23.5, 25.5, 25.5)];
            image3.image = [UIImage imageNamed:@"左下"];
            [_scanQRCodeCell.contentView addSubview:image3];
            
            UIImageView * image4 = [[UIImageView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(layer.frame)-24.5, CGRectGetMaxY(layer.frame)-23.5, 25.5, 25.5)];
            image4.image = [UIImage imageNamed:@"右下"];
            [_scanQRCodeCell.contentView addSubview:image4];
            
            
            ShadowView * lineView = [ShadowView new];
            lineView.colors =commonColorS;
            lineView.frame = CGRectMake(50, 40, kScreenWidth-100, 2);
            [_scanQRCodeCell.contentView addSubview:lineView];
            
            
            CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
            animation.duration = 2; // 持续时间
            animation.repeatCount = MAXFLOAT;
            // 起始帧和终了帧的设定
            animation.fromValue = [NSValue valueWithCGPoint:CGPointMake(_scanQRCodeCell.contentView.centerX, 40)];
            animation.toValue = [NSValue valueWithCGPoint:CGPointMake(_scanQRCodeCell.contentView.centerX, CGRectGetMaxY(layer.frame))];
            //不断执行动画
            animation.removedOnCompletion = NO;
            [lineView.layer addAnimation:animation forKey:@"move-layer"];
            
            
            HXWeak_self
            JWLabel * tipLab = [[JWLabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(layer.frame)+30,kScreenWidth , 50)];
            tipLab.text = Internationalization(@"我的二维码", @"My QR Code");;
            tipLab.font = kMediumFont(14);
            tipLab.textAlignment = 1;
            tipLab.textColor = commonGrayColor;
            [_scanQRCodeCell.contentView addSubview:tipLab];
            
            UIImageView * tipimageView= [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-48)/2, (CGRectGetMaxY(tipLab.frame)), 48, 48)];
            tipimageView.image = [UIImage imageNamed:@"二维码"];
            
            [tipimageView addSingleTapEvent:^{
                HXStrong_self
                [self.view addSubview:self.QRCodeCell];
                self.isScan = false;
            }];
            [_scanQRCodeCell.contentView addSubview:tipimageView];
            
        }
        [_scanQRCodeCell setUPSpacing:0 andDownSpacing:0];
        
    }
    return _scanQRCodeCell;
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    [session startRunning];
    HXWeak_self
    [self getUserInfosuccess:^(UserInfoModel *userInfo) {
        HXStrong_self
        [self setQRcodeImagewithStr:userInfo.qrCode];

    } showHud:false];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self ValidateCamera];
    
    HXWeak_self
    [self createImageBarButtonItemStyle:BtnRightType Image:@"图片" TapEvent:^{
        HXStrong_self
        [self imagrPicker];
    }];
    
    [self.view addSubview:self.QRCodeCell];
    
    [self createImageBarButtonItemStyle:BtnLeftType Image:@"选中-6" TapEvent:^{
        
        FriendsViewController * friendsVC = [FriendsViewController new];
        friendsVC.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:friendsVC animated:true];
        
    }];
    
    
    [self facebooksupplementaryInfo];
    
}

-(JWScrollviewCell *)QRCodeCell{

    if (!_QRCodeCell) {
        _QRCodeCell = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
        UIImageView * ORimageView = [[UIImageView alloc]initWithFrame:CGRectMake(42, 40, kScreenWidth-84, kScreenWidth-84)];
        [_QRCodeCell.contentView addSubview:ORimageView];
        ORimageView.tag = 2000;
        HXWeak_self
        [ORimageView addSingleTapEvent:^{
            HXStrong_self
            [self saveQRcode];
        }];
        [self getUserInfosuccess:^(UserInfoModel *userInfo) {
            HXStrong_self
            [self setQRcodeImagewithStr:userInfo.qrCode];
            
        } showHud:true];
        JWLabel * tipLab = [[JWLabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(ORimageView.frame)+30,kScreenWidth , 50)];
        tipLab.text = Internationalization(@"扫描二维码", @"Scan QR Code");
        tipLab.font = kMediumFont(14);
        tipLab.textAlignment = 1;
        tipLab.textColor = commonGrayColor;
        [_QRCodeCell.contentView addSubview:tipLab];
        UIImageView * tipimageView= [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-48)/2, (CGRectGetMaxY(tipLab.frame)), 48, 48)];
        tipimageView.image = [UIImage imageNamed:@"扫一扫"];
        [tipimageView addSingleTapEvent:^{
            HXStrong_self
            [self.view addSubview:self.scanQRCodeCell];
            [session startRunning];
            [self.QRCodeCell removeFromSuperview];
            self.QRCodeCell = nil;
            self.isScan = true;
        }];
        [_QRCodeCell.contentView addSubview:tipimageView];
        [_QRCodeCell setUPSpacing:0 andDownSpacing:0];
    }
    return _QRCodeCell;
}

-(void)ValidateCamera{
    
    
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
        JWAlertView * alert  = [[JWAlertView alloc]initJWAlertViewWithTitle:@"Reminder" message:[TIPTEXT errorCamera] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alert alertShow];
        return;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [session stopRunning];
}

//AVCaptureMetadataOutputObjectsDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection {
    if ((metadataObjects != nil) && ([metadataObjects count] > 0)) {
        [session stopRunning];
        AVMetadataMachineReadableCodeObject * metadataObject = [metadataObjects objectAtIndex : 0 ];
         [self getReceiptUserInfo:metadataObject.stringValue];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info{
    //获取选中的照片
    UIImage *image = info[UIImagePickerControllerEditedImage];
    
    if (!image) {
        image = info[UIImagePickerControllerOriginalImage];
    }
    //初始化  将类型设置为二维码
    CIDetector *detector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:nil options:nil];
    
    [picker dismissViewControllerAnimated:YES completion:^{
        //设置数组，放置识别完之后的数据
        NSArray *features = [detector featuresInImage:[CIImage imageWithData:UIImagePNGRepresentation(image)]];
        //判断是否有数据（即是否是二维码）
        if (features.count >= 1) {
            //取第一个元素就是二维码所存放的文本信息
            CIQRCodeFeature *feature = features[0];
            NSString *scannedResult = feature.messageString;
            //通过对话框的形式呈现
            [self getReceiptUserInfophotoStr:scannedResult];
        }else{
            [self showTip:[TIPTEXT QRcodefail]];
        }
    }];
    
    self.imagrPicker = nil;
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{

    [picker dismissViewControllerAnimated:true completion:^{
        self.imagrPicker = nil;
    }];
}

-(void)getReceiptUserInfo:(NSString *)qrCode{

    if (!self.isScan) {
        return;
    }
    
    if (![self verificationPayPwdSettings]) {
        self.tabBarController.selectedIndex=3;
        return;
    }
    
    HXWeak_self
    [self showHud];
    [CommonService requestGetReceiptUserInfoOfaccess_token:self.defaultSetting.access_token qrContent:qrCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HXStrong_self
        if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
            OppositePayViewController * oppositePay = [OppositePayViewController new];
            oppositePay.hidesBottomBarWhenPushed = true;
            oppositePay.transmitObject = responseObject;
            [self.navigationController pushViewController:oppositePay animated:true];
        }else{
            [self showTip:[responseObject objectForKey:@"errorMessage"]];
            [session startRunning];
        }
        [self closeHud];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HXStrong_self
        [self closeHud];
        [self errorDispose:[[operation response] statusCode] judgeMent:nil];
    }];
    
}

//选相册调用的请求
-(void)getReceiptUserInfophotoStr:(NSString *)qrCode{
    
    if (![self verificationPayPwdSettings]) {
        self.tabBarController.selectedIndex=3;
        return;
    }
    
    HXWeak_self
    [self showHud];
    [CommonService requestGetReceiptUserInfoOfaccess_token:self.defaultSetting.access_token qrContent:qrCode success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HXStrong_self
        if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
            OppositePayViewController * oppositePay = [OppositePayViewController new];
            oppositePay.hidesBottomBarWhenPushed = true;
            oppositePay.transmitObject = responseObject;
            [self.navigationController pushViewController:oppositePay animated:true];
        }else{
            [self showTip:[responseObject objectForKey:@"errorMessage"]];
        }
        [self closeHud];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HXStrong_self
        [self closeHud];
        [self errorDispose:[[operation response] statusCode] judgeMent:nil];
    }];
    
}

//验证是否设置过交易密码
-(BOOL)verificationPayPwdSettings{
    
    if (!self.userInfoModel.setPayPwd) {
        [TooltipView showWithText:[TIPTEXT TransactionPassword]];
    }
    return self.userInfoModel.setPayPwd;
    
}


-(void)setQRcodeImagewithStr:(NSString *)qrString{
    
    UIImage *img = [QRCodeGenerator qrImageForString:qrString imageSize:1000 Topimg:nil withColor:[UIColor blackColor]];
    UIColor *topleftColor = commonGreenColor;
    UIColor *bottomrightColor = commonVioletColor;
    UIImage *bgImg = [img gradientColorImageFromColors:@[topleftColor, bottomrightColor] gradientType:GradientTypeUprightToLowleft imgSize:img.size];
    UIColor *color = [UIColor colorWithPatternImage:bgImg];
    ((UIImageView *)self.QRCodeCell.getElementByTag(2000)).image = [img rt_tintedImageWithColor:color];
    
}


-(void)skipSetting{

    NSURL * url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
    if([[UIApplication sharedApplication] canOpenURL:url])
    {
        NSURL*url =[NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:url];
    }
    
}

-(void)saveQRcode{

    LGAlertView *alertView = [[LGAlertView alloc] initWithTitle:nil
                                               message:nil
                                                 style:LGAlertViewStyleActionSheet
                                          buttonTitles:@[@"Save QR code"]
                                     cancelButtonTitle:@"Cancel"
                                destructiveButtonTitle:nil
                                              delegate:self];
    
//    alertView.coverColor = [UIColor colorWithWhite:1.0 alpha:0.25];
//    alertView.coverBlurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
//    alertView.coverAlpha = 0.85;
//    alertView.layerShadowColor = [UIColor colorWithWhite:0.0 alpha:0.3];
//    alertView.layerShadowRadius = 4.0;
//    alertView.layerShadowOpacity = 1.0;

    alertView.buttonsTextAlignment = NSTextAlignmentCenter;
    alertView.buttonsBackgroundColorHighlighted  = commonGrayBtnColor;
    alertView.cancelButtonBackgroundColorHighlighted = commonGrayBtnColor;
    alertView.buttonsTitleColorHighlighted =
    alertView.cancelButtonTitleColorHighlighted = alertView.cancelButtonTitleColor;
    [alertView showAnimated:YES completionHandler:nil];
}

- (void)alertView:(LGAlertView *)alertView buttonPressedWithTitle:(NSString *)title index:(NSUInteger)index {
    NSLog(@"action {title: %@, index: %lu}", title, (long unsigned)index);
    if ([title isEqualToString:@"Save QR code"]) {
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        [library saveImage:((UIImageView *)self.QRCodeCell.getElementByTag(2000)).image toAlbum:@"PICA" completion:^(NSURL *assetURL, NSError *error) {
            if (!error) {
                [self showTip:@"Save success"];
            }else{
                [self showTip:@"Save failed"];
            }
        } failure:^(NSError *error) {
            [self showTip:@"Save failed"];
        }];
    }
}


@end
