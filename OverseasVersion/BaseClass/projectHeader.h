//
//  projectHeader.h
//  GTriches
//
//  Created by devair on 14-10-9.
//  Copyright (c) 2014年 eric. All rights reserved.
//
#import <Foundation/Foundation.h>
#import "AppDelegate.h"
#import <UIKit/UIKit.h>
#ifndef GTriches_projectHeader_h
#define GTriches_projectHeader_h

//颜色
#define UIColorFromRGB(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
// RGB颜色
#define RGBColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define DEGREES_TO_RADOANS(x) (M_PI * (x) / 180.0) // 将角度转为弧度
#define PROGRESS_LINE_WIDTH 20 //弧线的宽度
#define commonBlueColor             UIColorFromRGB(0x42aef7)
#define commonRedColor              UIColorFromRGB(0xe85a4e)
#define commonGrayColor             UIColorFromRGB(0x666666)
#define commonBlackColor            UIColorFromRGB(0x333333)
#define commonWhiteColor            [UIColor whiteColor]
#define commonClearColor            [UIColor clearColor]
#define cuttingLineColor            UIColorFromRGB(0xe8e8e8)
#define backGroundColor             UIColorFromRGB(0xf7f7f7)
#define identityCardColor           UIColorFromRGB(0xf0831e)
#define BaseTitleTextColor              UIColorFromRGB(0x4c5f70)
#define detailTextColor             UIColorFromRGB(0x67849d)
#define sectionTextColor            UIColorFromRGB(0x8297a9)
#define textFieldPlaceHolerColor    UIColorFromRGB(0xccd1d6)
#define progressGrayColor           UIColorFromRGB(0xccd1d6)


#define commonGreenColor            UIColorFromRGB(0x31c6e3)
#define commonVioletColor           UIColorFromRGB(0x7a3dd2)
#define commonPlaceholderColor      UIColorFromRGB(0xc0bfbf)

#define commonBlackFontColor             UIColorFromRGB(0x454545)

#define commonBlackBtnColor             UIColorFromRGB(0x444444)
#define commonGrayBtnColor              UIColorFromRGB(0xd0d0d0)
#define commonErrorColor              UIColorFromRGB(0xf67777)

#define commonEmptyTextColoer       UIColorFromRGB(0x929292)

#define commonColorS @[(id)UIColorFromRGB(0x9164db).CGColor, (id)UIColorFromRGB(0x46bbe3).CGColor]

//简单国际化
//#if TARGET_IPHONE_SIMULATOR
//#define Internationalization(Chinese,English) [[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] isEqualToString:@"zh-Hans-US"] ? Chinese : English
//#elif TARGET_OS_IPHONE
//#define Internationalization(Chinese,English) [[[[NSUserDefaults standardUserDefaults] objectForKey:@"AppleLanguages"] objectAtIndex:0] isEqualToString:@"zh-Hans-CN"] ? Chinese : English
//#endif
//弱引用

#define Internationalization(Chinese,English) English

#define HXWeak_(arg) \
__weak typeof(arg) weak_##arg = arg;
#define HXStrong_(arg) \
__strong typeof(weak_##arg) arg = weak_##arg;

#define HXWeak_self \
HXWeak_(self)
#define HXStrong_self \
HXStrong_(self)
//网络状态
#define NETSTAT(...)    [NetworkState WithSuccessBlock:^(BOOL status) {\
if (status == true) {\
__VA_ARGS__; \
} else {\
[self errorRemind:nil];\
}\
}];

//AppDelegate
#define commonAppDelegate ((AppDelegate *)[UIApplication sharedApplication].delegate)
//Font
#define kLightFont(float) [UIFont systemFontOfSize:float*commonAppDelegate.autoSizeScaleX]
#define kMediumFont(float) [UIFont boldSystemFontOfSize:float*commonAppDelegate.autoSizeScaleX]
#define kItalicFont(float) [UIFont italicSystemFontOfSize:float*commonAppDelegate.autoSizeScaleX]
//Rect
#define resetRectXYWH(x, y, width, height) CGRectMake(x *commonAppDelegate.autoSizeScaleX, y *commonAppDelegate.autoSizeScaleY, width *commonAppDelegate.autoSizeScaleX, height *commonAppDelegate.autoSizeScaleY)
#define resetRectXYWH2(x, y, width, height) CGRectMake(x *commonAppDelegate.autoSizeScaleX, y *commonAppDelegate.autoSizeScaleY, width *commonAppDelegate.autoSizeScaleX, height *commonAppDelegate.autoSizeScaleX)
#define resetRectXYH(x, y, width, height) CGRectMake(x *commonAppDelegate.autoSizeScaleX, y *commonAppDelegate.autoSizeScaleY, width, height *commonAppDelegate.autoSizeScaleY)
#define resetRectXYW(x, y, width, height) CGRectMake(x *commonAppDelegate.autoSizeScaleX, y *commonAppDelegate.autoSizeScaleY, width *commonAppDelegate.autoSizeScaleX, height)
#define resetRectWH(x, y, width, height) CGRectMake(x, y, width *commonAppDelegate.autoSizeScaleX, height *commonAppDelegate.autoSizeScaleY)
#define resetRectWH2(x, y, width, height) CGRectMake(x, y, width *commonAppDelegate.autoSizeScaleX, height *commonAppDelegate.autoSizeScaleX)
#define resetRectXWH(x, y, width, height) CGRectMake(x *commonAppDelegate.autoSizeScaleX, y, width *commonAppDelegate.autoSizeScaleX, height *commonAppDelegate.autoSizeScaleY)
//BaseUrl
//#define BaseUrl @"https://www.songshubank.com/app"//正式环境
#define BaseUrl @"https://app.pica.songzidai.com"//开发环境


//屏幕尺寸z
#define kScreenFrame    [UIScreen mainScreen].bounds
#define kScreenWidth    [UIScreen mainScreen].bounds.size.width
#define kScreenHeight   [UIScreen mainScreen].bounds.size.height
#define adaptX(num) num *commonAppDelegate.autoSizeScaleX
#define adaptY(num) num *commonAppDelegate.autoSizeScaleY

//UMeng
#define KumengAppKey        @"5628523d67e58e394b0002a6"
#define KumengQQAppId       @"1104847039"
#define KumengQQAppKey      @"SE6VNnnOmg6ns7oz"
#define KumengShareURL      @"https://www.songshubank.com"
#define KumengWeixinAppID   @"wxd6a090db421aa687"
#define KumengWeixinAppSecret @"d4624c36b6795d1d99dcf0547af5443d"
#define KumengSinaAppID     @"3068051373"
#define KumengSinaAppSecret @"4bbeef0317e16630f94edabba7f6de81"
//JPush
#define KJPushAppKey @"79975cd49409bb76c5fa8ab6"
#define KJPushChannel @"Publish channel"

#define GlobalFrameOne CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)
#define GlobalFrameTwo CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-44-49*commonAppDelegate.autoSizeScaleY)
#define GlobalFrameThree CGRectMake(0, 0, kScreenWidth, kScreenHeight -64-45*commonAppDelegate.autoSizeScaleY)
//第三方appkey

#define KGoogleMapsKey @"AIzaSyAN-FL66CE2fg8q0fanvyz1DZd3OBlSg0A"

#define JSPatchKey @"0f664735ee1a51c9"

#if DEBUG
#define BugTagsKey @"3f8c011ebbab8f784c0df885591e3602"
#else
#define BugTagsKey @"1341ee88e00c6945a917c471410b3f2c"
#endif

//共用控件尺寸
#define ShadowViewHeight adaptY(35)


//___________友盟统计点位_____________


@interface NSString (encrypto)
- (NSString *) md5;
- (NSString *) sha1;
- (NSString *) formatDateSince1970:(long long)date formatString:(NSString *)format;
- (NSString *) formatLocationCurrency:(double)currency;
@end
#endif
