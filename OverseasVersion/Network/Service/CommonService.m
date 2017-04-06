//
//  CommonService.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/8.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "CommonService.h"
#import "projectHeader.h"
#import <CommonCrypto/CommonDigest.h>

@implementation CommonService

+ (AFHTTPRequestOperationManager *)createObject {
    AFHTTPRequestOperationManager * manger = [AFHTTPRequestOperationManager manager];
    AFSecurityPolicy * securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manger.securityPolicy = securityPolicy;
    manger.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/x-javascript",@"application/json",@"text/plain",@"text/html", @"image/jpeg", @"image/jpg", nil];
    return  manger;
}


/**
 *  获取平台token
 *
 *  @param success access_token
 *  @param failure error/operation
 */
+ (void)requestAccesstokensuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSString * timeStamp = [NSString stringWithFormat:@"%ld",(long)[[NSDate dateWithTimeIntervalSinceNow:0] timeIntervalSince1970]];
    NSString * appVersion = [NSString stringWithFormat:@"V%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    
    NSString * system = [NSString stringWithFormat:@"iOS%@",[[UIDevice currentDevice] systemVersion]];
    NSString * width = [NSString stringWithFormat:@"%.f",kScreenWidth];
    NSString * height = [NSString stringWithFormat:@"%.f",kScreenHeight];
    NSDictionary * param = @{@"timestamp": timeStamp,@"token": @"&*0$(97$&*&dJhfK-29(@5jdfGgjdX29",@"source": @"mobile",@"version": appVersion,@"system": system,@"width": width,@"height": height};
    NSMutableDictionary * paramsDic = [NSMutableDictionary dictionary];
    if (param) {
        [paramsDic setValuesForKeysWithDictionary:param];
    }
    NSMutableString * signatureString = [NSMutableString string];
    NSArray * sortedKeys = [[paramsDic allValues] sortedArrayUsingSelector:@selector(compare:)];
    for (NSString * key in sortedKeys) {
        [signatureString appendFormat:@"%@",key];
    }
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    NSData * stringBytes = [signatureString dataUsingEncoding:NSUTF8StringEncoding];
    NSString * signature = [NSString string];
    if (CC_SHA1([stringBytes bytes], (CC_LONG)[stringBytes length], digest)) {
        /* SHA-1 hash has been calculated and stored in 'digest'. */
        NSMutableString * digestString = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH];
        for (int i = 0; i< CC_SHA1_DIGEST_LENGTH; i++) {
            unsigned char aChar = digest[i];
            [digestString appendFormat:@"%02x",aChar];
        }
        signature = digestString;
    }
    NSDictionary * parameters = @{@"signature": signature, @"timestamp": timeStamp, @"source": @"mobile",@"version": appVersion,@"system": system,@"width": width,@"height": height};
    AFHTTPRequestOperationManager * manger = [AFHTTPRequestOperationManager manager];
    AFSecurityPolicy * securityPolicy = [AFSecurityPolicy defaultPolicy];
    securityPolicy.allowInvalidCertificates = YES;
    manger.securityPolicy = securityPolicy;
    [manger POST:[NSString stringWithFormat:@"%@/accesstoken",BaseUrl] parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(operation, responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(operation, error);
        }
    }];
}


#pragma mark - 上传图片
/**
 *  上传图片
 *
 *  @param block   图片数据流
 */
+ (void)uploadImgWithconstructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                  access_token:(NSString *)access_token
                                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    NSMutableDictionary * parameters = @{@"source" : @"ios"}.mutableCopy;
    
    [parameters setObject:access_token forKey:@"access_token"];

    
    AFHTTPRequestOperationManager * manger = [self createObject];
    [manger POST:[NSString stringWithFormat:@"%@/common/uploadImg",BaseUrl]
      parameters:parameters
constructingBodyWithBlock:block
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
}


#pragma mark 短信验证码（注册专用）
/**
 *  短信验证码（注册专用）
 *
 *  @param mobile  手机号
 */
+ (void)getVerifyCodeWithMobile:(NSString *)mobile
                   accountToken:(NSString *)accountToken
                      area_code:(NSString *)area_code
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure {
    
    NSMutableDictionary * parameters = @{
                                          @"business": @"onLineRegister",
                                          @"type": @(0),
                                          @"source" : @"ios"}.mutableCopy;
    
    
    [parameters setObject:accountToken forKey:@"access_token"];
    [parameters setObject:mobile forKey:@"mobile"];
    [parameters setObject:area_code forKey:@"areaCode"];
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];

    [manger POST:[NSString stringWithFormat:@"%@/msg/getVerifyCodeForStore",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
}


/*
 1、注册
 /pica/userRegister
 参数：email、password、mobile、verifycode 、name
 */

+ (void)requestUserRegisterOfaccess_token:(NSString *)access_token email:(NSString *)email password:(NSString *)password mobile:(NSString *)mobile verifycode:(NSString *)verifycode firstname:(NSString *)firstname lastname:(NSString *)lastname success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    NSMutableDictionary * parameters = @{}.mutableCopy;
    
    [parameters setObject:access_token forKey:@"access_token"];
    [parameters setObject:email forKey:@"email"];
    [parameters setObject:[password md5] forKey:@"password"];
    [parameters setObject:mobile forKey:@"mobile"];
    [parameters setObject:verifycode forKey:@"verifycode"];
    [parameters setObject:firstname forKey:@"firstName"];
    [parameters setObject:lastname forKey:@"lastName"];
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/userRegister",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];

}


/*
 2、登录
 /pica/userLogin
 参数：email、password
 */

+ (void)requestUserLoginOfaccess_token:(NSString *)access_token email:(NSString *)email password:(NSString *)password success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    NSMutableDictionary * parameters = @{
                                         }.mutableCopy;
    
    [parameters setObject:access_token forKey:@"access_token"];
    [parameters setObject:email forKey:@"email"];
    [parameters setObject:[password md5] forKey:@"password"];
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/userLogin",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
    
}


/*
 3、用户信息
 /pica/userInfo
 参数：无
 */

+ (void)requestUserInfoOfaccess_token:(NSString *)access_token success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    NSMutableDictionary * parameters = @{
                                  }.mutableCopy;
    [parameters setObject:access_token forKey:@"access_token"];
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/userInfo",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];

}


/*
 4、忘记密码
 /pica/forgetPassword
 参数：mobile,code,newpassword
 */

+ (void)requestForgetPasswordOfaccess_token:(NSString *)access_token mobile:(NSString *)mobile code:(NSString *)code newpassword:(NSString *)newpassword success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    NSMutableDictionary * parameters = @{
                                  }.mutableCopy;
    
    [parameters setObject:access_token forKey:@"access_token"];
    [parameters setObject:mobile forKey:@"mobile"];
    [parameters setObject:code forKey:@"code"];
    [parameters setObject:[newpassword md5] forKey:@"newpassword"];
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/forgetPassword",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];

    
    
}


/*
 5、设置支付密码
 /pica/resetPayPwd
 参数：payPassword，code
 */

+ (void)requestResetPayPwdOfaccess_token:(NSString *)access_token payPassword:(NSString *)payPassword code:(NSString *)code success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    NSMutableDictionary * parameters = @{
                                  }.mutableCopy;
    
    [parameters setObject:access_token forKey:@"access_token"];
    [parameters setObject:[payPassword md5] forKey:@"payPassword"];
    [parameters setObject:code forKey:@"code"];
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/resetPayPwd",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
    
}


/**
 *  短信验证码
 *
 *  @param mobile  手机号
 */
+ (void)getForgetPasswordVerifyCodeWithMobile:(NSString *)mobile
                                 accountToken:(NSString *)accountToken
                                    area_code:(NSString *)area_code
                                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSMutableDictionary * parameters = @{
                                  @"business": @"forgetPassword",
                                  @"type": @(0),
                                  @"source" : @"ios"}.mutableCopy;
    
    [parameters setObject:accountToken forKey:@"access_token"];
    [parameters setObject:mobile forKey:@"mobile"];
    [parameters setObject:area_code forKey:@"areaCode"];
    [parameters setObject:@(0) forKey:@"type"];

    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/msg/getVerifyCodeForStore",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
}

/**
 *  短信验证码（设置支付密码专用）
 *
 *  @param mobile  手机号
 */
+ (void)getResetPayPwdVerifyCodeWithMobile:(NSString *)mobile
                              accountToken:(NSString *)accountToken
                                 area_code:(NSString *)area_code
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    NSMutableDictionary * parameters = @{
                                  @"business": @"resetPayPwd",
                                  @"type": @(0),
                                  @"source" : @"ios"}.mutableCopy;
    
    
    [parameters setObject:accountToken forKey:@"access_token"];
    [parameters setObject:mobile forKey:@"mobile"];
    [parameters setObject:area_code forKey:@"areaCode"];
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/msg/getVerifyCodeForStore",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
}


/*
 6、账户信息
 /pica/userAccountInfo
 参数：无
 */

+ (void)requestUserAccountInfoOfaccess_token:(NSString *)access_token success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    NSMutableDictionary * parameters = @{
                                  @"source" : @"ios"}.mutableCopy;
    
    [parameters setObject:access_token forKey:@"access_token"];
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/userAccountInfo",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
    
}


/*
 7、根据二维码内容获取收款方信息
 /pica/getReceiptUserInfo
 参数：qrContent
 */

+ (void)requestGetReceiptUserInfoOfaccess_token:(NSString *)access_token qrContent:(NSString *)qrContent success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{


    NSMutableDictionary * parameters = @{
                                  @"source" : @"ios"}.mutableCopy;
    
    [parameters setObject:access_token forKey:@"access_token"];
    [parameters setObject:qrContent forKey:@"qrContent"];
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/getReceiptUserInfo",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
}
/*
 8、转账
 /pica/userPayment
 参数：qrContent二维码加密串，amount转账金额
 //    经度 longitude
 //    纬度 latitude
 */
+ (void)requestUserPaymentOfaccess_token:(NSString *)access_token
                               qrContent:(NSString *)qrContent
                                  amount:(NSString *)amount
                             payPassword:(NSString *)payPassword
                               longitude:(double )longitude
                                latitude:(double )latitude
                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    NSMutableDictionary * parameters = @{
                                          @"source" : @"ios"}.mutableCopy;
    
    
    [parameters setObject:access_token forKey:@"access_token"];
    [parameters setObject:qrContent forKey:@"qrContent"];
    [parameters setObject:amount forKey:@"amount"];
    [parameters setObject:[payPassword md5] forKey:@"payPassword"];
    [parameters setObject:@(longitude) forKey:@"lon"];
    [parameters setObject:@(latitude) forKey:@"lat"];
    
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/userPayment",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
    
}


/*
 9、支付、收款列表
 /pica/paymentList
 参数：pageNum，pageSize
 */

+ (void)requestPaymentListOfaccess_token:(NSString *)access_token
                                 pageNum:(NSInteger )pageNum
                                pageSize:(NSInteger )pageSize
                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    NSMutableDictionary * parameters = @{
                                  @"source" : @"ios"}.mutableCopy;
    
    [parameters setObject:access_token forKey:@"access_token"];
    [parameters setObject:@(pageNum) forKey:@"pageNum"];
    [parameters setObject:@(pageSize) forKey:@"pageSize"];
    
    
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/paymentList",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
    
}

/*
 10、充值、提现列表
 /pica/depositsList
 参数：pageNum，pageSize
 */

+ (void)requestdepositsListOfaccess_token:(NSString *)access_token
                                  pageNum:(NSInteger )pageNum
                                 pageSize:(NSInteger )pageSize
                                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    NSMutableDictionary * parameters = @{
                                  @"source" : @"ios"}.mutableCopy;
    
    [parameters setObject:access_token forKey:@"access_token"];
    [parameters setObject:@(pageNum) forKey:@"pageNum"];
    [parameters setObject:@(pageSize) forKey:@"pageSize"];
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/depositsList",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
}

/*
 11、搜索充值网点
 /pica/getOutletList
 参数：lat，lon，amount
 */

+ (void)requestGetOutletListOfaccess_token:(NSString *)access_token
                                       lat:(double )lat
                                       lon:(double )lon
                                    amount:(NSString *)amount
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    NSMutableDictionary * parameters = @{
                                          @"source" : @"ios"}.mutableCopy;
    
    
    [parameters setObject:access_token forKey:@"access_token"];
    [parameters setObject:@(lat) forKey:@"lat"];
    [parameters setObject:@(lon) forKey:@"lon"];
    [parameters setObject:amount forKey:@"amount"];
    
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/getOutletList",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
    

}

/*
 12、验证码校验
 /pica/checkCode
 参数：business，code mobile
 */



+ (void)requestCheckCodeOfaccess_token:(NSString *)access_token
                              business:(NSString *)business
                                  code:(NSString *)code
                                mobile:(NSString *)mobile
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{


    NSMutableDictionary * parameters = @{
                                  @"source" : @"ios"}.mutableCopy;
    
    
    [parameters setObject:access_token forKey:@"access_token"];
    [parameters setObject:business forKey:@"business"];
    [parameters setObject:code forKey:@"code"];
    [parameters setObject:mobile forKey:@"mobile"];
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/checkCode",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
    
}

/*
 12、校验邮箱
 /pica/checkEmail
 参数：email
 */

+ (void)requestCheckEmailOfaccess_token:(NSString *)access_token
                                  email:(NSString *)email
                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    NSMutableDictionary * parameters = @{
                                  @"source" : @"ios"}.mutableCopy;
    
    
    [parameters setObject:access_token forKey:@"access_token"];
    [parameters setObject:email forKey:@"email"];
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/checkEmail",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
    
}

/*
 13、设置头像
 /pica/uploadHeadPic
 参数：picUrl
 */

+ (void)requestUPloadHeadPicOfaccess_token:(NSString *)access_token
                                    picUrl:(NSString *)picUrl
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    NSMutableDictionary * parameters = @{
                                          @"source" : @"ios"}.mutableCopy;
    
    [parameters setObject:access_token forKey:@"access_token"];
    [parameters setObject:picUrl forKey:@"picUrl"];
    

    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/uploadHeadPic",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
    
}

/*
 14、获取好友列表
 /pica/getUserContacts
 */

+ (void)requestGetUserContactsOfaccess_token:(NSString *)access_token
                                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    
    NSMutableDictionary * parameters = @{
                                  @"source" : @"ios"}.mutableCopy;
    [parameters setObject:access_token forKey:@"access_token"];
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/getUserContacts",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
    
}


/*
 14、facebook登陆
 /pica/facebookLogin
 
 userType 1个人
 2企业
 
 
 */

+ (void)requestFacebookLoginOfaccess_token:(NSString *)access_token
                                 firstName:(NSString *)firstName
                                  lastName:(NSString *)lastName
                                  password:(NSString *)password
                                facebookId:(NSString *)facebookId
                                  userType:(NSInteger )userType
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{


    
    NSMutableDictionary * parameters = @{
                                  @"source" : @"ios"}.mutableCopy;
    
    
    [parameters setObject:access_token forKey:@"access_token"];
    [parameters setObject:firstName forKey:@"firstName"];
    [parameters setObject:lastName forKey:@"lastName"];
    [parameters setObject:[password md5] forKey:@"password"];
    [parameters setObject:facebookId forKey:@"facebookId"];
    [parameters setObject:@(userType) forKey:@"userType"];
    
    
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/facebookLogin",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
    
}


/*
 14、facebook完善资料
 /pica/supplementaryInfo
 */

+ (void)requestSupplementaryInfoOfaccess_token:(NSString *)access_token
                                        mobile:(NSString *)mobile
                                         email:(NSString *)email
                                      password:(NSString *)password
                                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    NSMutableDictionary * parameters = @{
                                  @"source" : @"ios"}.mutableCopy;
    
    [parameters setObject:access_token forKey:@"access_token"];
    [parameters setObject:mobile forKey:@"mobile"];
    [parameters setObject:email forKey:@"email"];
    [parameters setObject:[password md5] forKey:@"password"];

    
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/supplementaryInfo",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
}


/*
 15、获取全部商铺列表新闻
 /pica/getNewsList
 */

+ (void)requestGetNewsListOfaccess_token:(NSString *)access_token
                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    
    NSMutableDictionary * parameters = @{@"source" : @"ios"}.mutableCopy;
    
    [parameters setObject:access_token forKey:@"access_token"];
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/getNewsList",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
}

/*
 16、获取商铺详情列表新闻
 /pica/getNewsListByShopId
 参数：shopId
 */

+ (void)requestgetNewsListByShopIdOfaccess_token:(NSString *)access_token
                                          shopId:(NSInteger)shopId
                                         success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    
    NSMutableDictionary * parameters = @{
                                  @"source" : @"ios"}.mutableCopy;
    
    [parameters setObject:access_token forKey:@"access_token"];
    [parameters setObject:@(shopId) forKey:@"shopId"];
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/getNewsListByShopId",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
}
/*
 17、上传证件照
 /pica/uploadGovernmentId
 参数：picUrl
 */
+ (void)requestuploadGovernmentIdOfaccess_token:(NSString *)access_token
                                         picUrl:(NSString *)picUrl
                                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSMutableDictionary * parameters = @{
                                  @"source" : @"ios"}.mutableCopy;
    
    
    [parameters setObject:access_token forKey:@"access_token"];
    [parameters setObject:picUrl forKey:@"picUrl"];
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/uploadGovernmentId",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
    
}

/*
 18、查询证件照信息
 /pica/myGovernmentId
 */
+ (void)requestmyGovernmentIdOfaccess_token:(NSString *)access_token
                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSMutableDictionary * parameters = @{
                                         @"source" : @"ios"}.mutableCopy;
    
    [parameters setObject:access_token forKey:@"access_token"];
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/myGovernmentId",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
}

/*
 19、上传住址信息
 /pica/uploadAddress
 参数：province，city，barangay，address，postCode
 */
+ (void)requestuploadAddressOfaccess_token:(NSString *)access_token
                                  province:(NSString *)province
                                      city:(NSString *)city
                                  barangay:(NSString *)barangay
                                   address:(NSString *)address
                                  postCode:(NSString *)postCode
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSMutableDictionary * parameters = @{
                                  @"source" : @"ios"}.mutableCopy;
    
    
    [parameters setObject:access_token forKey:@"access_token"];
    [parameters setObject:province forKey:@"province"];
    [parameters setObject:city forKey:@"city"];
    [parameters setObject:barangay forKey:@"barangay"];
    [parameters setObject:address forKey:@"address"];
    [parameters setObject:postCode forKey:@"postCode"];

    
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/uploadAddress",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
}
/*
 
 20、获取城市列表
 /pica/getCityList
 
 */
+ (void)requestgetCityListOfaccess_token:(NSString *)access_token
                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    NSMutableDictionary * parameters = @{
                                  @"source" : @"ios"}.mutableCopy;
    
    
    [parameters setObject:access_token forKey:@"access_token"];
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/getCityList",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
    
}

/*
 21、上传手持证件照：
 /pica/uploadSelfieGovernmentId
 参数：picUrl
 */
+ (void)requestuploadSelfieGovernmentIdOfaccess_token:(NSString *)access_token
                                               picUrl:(NSString *)picUrl
                                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    NSMutableDictionary * parameters = @{
                                  @"source" : @"ios"}.mutableCopy;
    
    
    [parameters setObject:access_token forKey:@"access_token"];
    [parameters setObject:picUrl forKey:@"picUrl"];
    
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/uploadSelfieGovernmentId",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
    
}

/*
 22、查看手持照片信息
 /pica/selfieGovernmentId
 */
+ (void)requestselfieGovernmentIdOfaccess_token:(NSString *)access_token
                                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    NSMutableDictionary * parameters = @{
                                  @"source" : @"ios"}.mutableCopy;
    
    
    [parameters setObject:access_token forKey:@"access_token"];
    
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/selfieGovernmentId",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
    
}
/*
 23、问题列表
 /pica/securityQue
 */
+ (void)requestsecurityQueOfaccess_token:(NSString *)access_token
                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    NSMutableDictionary * parameters = @{
                                  @"source" : @"ios"}.mutableCopy;
    
    [parameters setObject:access_token forKey:@"access_token"];
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/securityQue",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
    
}
/*
 24、上传个人信息
 /pica/uploadSecurityDetails
 参数：sex，birthDay，question1，answer1，question2，answer2，
 */
+ (void)requestuploadSecurityDetailsOfaccess_token:(NSString *)access_token
                                               sex:(NSString *)sex
                                          birthDay:(NSString *)birthDay
                                         question1:(NSString *)question1
                                           answer1:(NSString *)answer1
                                         question2:(NSString *)question2
                                           answer2:(NSString *)answer2
                                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    NSMutableDictionary * parameters = @{
                                  @"source" : @"ios"}.mutableCopy;
    
    [parameters setObject:access_token forKey:@"access_token"];
    [parameters setObject:sex forKey:@"sex"];
    [parameters setObject:birthDay forKey:@"birthDay"];
    [parameters setObject:question1 forKey:@"question1"];
    [parameters setObject:answer1 forKey:@"answer1"];
    [parameters setObject:question2 forKey:@"question2"];
    [parameters setObject:answer2 forKey:@"answer2"];
    
    
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/uploadSecurityDetails",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
    
}
/*
 25、上传账单
 /pica/uploadBillPic
 参数：picUrl
 */
+ (void)requestuploadBillPicOfaccess_token:(NSString *)access_token
                                    picUrl:(NSString *)picUrl
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSMutableDictionary * parameters = @{
                                  @"source" : @"ios"}.mutableCopy;
    
    
    [parameters setObject:access_token forKey:@"access_token"];
    [parameters setObject:picUrl forKey:@"picUrl"];
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/uploadBillPic",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
}
/*
 26、账单信息
 /pica/userBillPic
 */
+ (void)requestuserBillPicOfaccess_token:(NSString *)access_token
                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    NSMutableDictionary * parameters = @{
                                  @"source" : @"ios"}.mutableCopy;
    
    
    [parameters setObject:access_token forKey:@"access_token"];
    
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/userBillPic",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
    
}

/*
 27、查看个人信息
 /pica/userSecurityDetails
 */
+ (void)requestuserSecurityDetailsaccess_token:(NSString *)access_token
                                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    NSMutableDictionary * parameters = @{
                                  @"source" : @"ios"}.mutableCopy;

    [parameters setObject:access_token forKey:@"access_token"];
    
    
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/userSecurityDetails",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
}

/*
 28、查看个人地址信息
 /pica/myAddress
 */
+ (void)requestmyAddressaccess_token:(NSString *)access_token
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    NSMutableDictionary * parameters = @{
                                  @"source" : @"ios"}.mutableCopy;
    
    [parameters setObject:access_token forKey:@"access_token"];
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/myAddress",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
    
}
/*
 29、查看资料上传情况
 /pica/getUserInfoExt
 参数：level（int）
 */
+ (void)requestgetUserInfoExtaccess_token:(NSString *)access_token
                                    level:(NSInteger)level
                                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    NSMutableDictionary * parameters = @{
                                  @"source" : @"ios"}.mutableCopy;
    
    [parameters setObject:access_token forKey:@"access_token"];
    [parameters setObject:@(level) forKey:@"level"];
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/getUserInfoExt",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];

}

/*
 30、级别列表
 /pica/getLevelList
 */
+ (void)requestgetLevelListaccess_token:(NSString *)access_token
                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    
    NSMutableDictionary * parameters = @{
                                         @"source" : @"ios"}.mutableCopy;
    
    [parameters setObject:access_token forKey:@"access_token"];
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/getLevelList",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
}

/*
 31、留言
 /pica/userFeedback
 参数：content
 */
+ (void)requestuserFeedbackaccess_token:(NSString *)access_token
                                content:(NSString *)content
                                  isPic:(NSInteger)isPic
                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    NSMutableDictionary * parameters = @{
                                  @"source" : @"ios"}.mutableCopy;
    
    
    [parameters setObject:access_token forKey:@"access_token"];
    [parameters setObject:content forKey:@"content"];
    [parameters setObject:@(isPic) forKey:@"isPic"];
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/userFeedback",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
    
}

/*
 32、消息列表
 /pica/getFeedbackList
 */
+ (void)requestgetFeedbackListaccess_token:(NSString *)access_token
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    NSMutableDictionary * parameters = @{
                                         @"source" : @"ios"}.mutableCopy;
    
    [parameters setObject:access_token forKey:@"access_token"];
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/getFeedbackList",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
    
}


/*
 33、给商户发消息
 /pica/sendMessage
 参数：long shopId（商户ID），String content（消息内容）
 */
+ (void)requestsendMessageaccess_token:(NSString *)access_token
                                shopId:(NSInteger )shopId
                               content:(NSString *)content
                                 isPic:(NSInteger)isPic
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{
    NSMutableDictionary * parameters = @{
                                         @"source" : @"ios"}.mutableCopy;
    
    [parameters setObject:access_token forKey:@"access_token"];
    [parameters setObject:@(shopId) forKey:@"shopId"];
    [parameters setObject:content forKey:@"content"];
    [parameters setObject:@(isPic) forKey:@"isPic"];
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/sendMessage",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
    
    
}


/*
 34、获商铺信息列表
 /pica/messageList
 */
+ (void)requestMessageListaccess_token:(NSString *)access_token
                                shopId:(NSInteger )shopId
                               pageNum:(NSInteger)pageNum
                              pageSize:(NSInteger)pageSize
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure{

    NSMutableDictionary * parameters = @{
                                         @"source" : @"ios"}.mutableCopy;
    
    [parameters setObject:access_token forKey:@"access_token"];
    [parameters setObject:@(shopId) forKey:@"shopId"];
    [parameters setObject:@(pageNum) forKey:@"pageNum"];
    [parameters setObject:@(pageSize) forKey:@"pageSize"];
    
    
    AFHTTPRequestOperationManager * manger = [self createObject];
    
    [manger POST:[NSString stringWithFormat:@"%@/pica/getMessageList",BaseUrl]
      parameters:parameters
         success:^(AFHTTPRequestOperation *operation, id responseObject) {
             if (success) {
                 success(operation, responseObject);
             }
         }
         failure:^(AFHTTPRequestOperation *operation, NSError *error) {
             if (failure) {
                 failure(operation, error);
             }
         }];
    
}

@end
