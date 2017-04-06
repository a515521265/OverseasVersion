//
//  CommonService.h
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/8.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "network.h"

@interface CommonService : NSObject

/**
 *  获取平台token
 *
 *  @param success access_token
 *  @param failure error/operation
 */
+ (void)requestAccesstokensuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


#pragma mark - 上传图片
/**
 *  上传图片
 *
 *  @param block   图片数据流
 */
+ (void)uploadImgWithconstructingBodyWithBlock:(void (^)(id <AFMultipartFormData> formData))block
                                  access_token:(NSString *)access_token
                                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                       failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

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
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  短信验证码（找回密码专用）
 *
 *  @param mobile  手机号
 */
+ (void)getForgetPasswordVerifyCodeWithMobile:(NSString *)mobile
                   accountToken:(NSString *)accountToken
                      area_code:(NSString *)area_code
                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/**
 *  短信验证码（设置支付密码专用）
 *
 *  @param mobile  手机号
 */
+ (void)getResetPayPwdVerifyCodeWithMobile:(NSString *)mobile
                                 accountToken:(NSString *)accountToken
                                 area_code:(NSString *)area_code
                                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/*
 1、注册
 /pica/userRegister
 参数：email、password、mobile、verifycode
 */

+ (void)requestUserRegisterOfaccess_token:(NSString *)access_token email:(NSString *)email password:(NSString *)password mobile:(NSString *)mobile verifycode:(NSString *)verifycode firstname:(NSString *)firstname lastname:(NSString *)lastname success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/*
 2、登录
 /pica/userLogin
 参数：email、password
 */

+ (void)requestUserLoginOfaccess_token:(NSString *)access_token email:(NSString *)email password:(NSString *)password success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/*
 3、用户信息
 /pica/userInfo
 参数：无
 */

+ (void)requestUserInfoOfaccess_token:(NSString *)access_token success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/*
 4、忘记密码
 /pica/forgetPassword
 参数：mobile,code,newpassword
 */

+ (void)requestForgetPasswordOfaccess_token:(NSString *)access_token mobile:(NSString *)mobile code:(NSString *)code newpassword:(NSString *)newpassword success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/*
 5、设置支付密码
 /pica/resetPayPwd
 参数：payPassword，code
 */

+ (void)requestResetPayPwdOfaccess_token:(NSString *)access_token payPassword:(NSString *)payPassword code:(NSString *)code success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/*
 6、账户信息
 /pica/userAccountInfo
 参数：无
 */

+ (void)requestUserAccountInfoOfaccess_token:(NSString *)access_token success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;



/*
 7、根据二维码内容获取收款方信息
 /pica/getReceiptUserInfo
 参数：qrContent
 */

+ (void)requestGetReceiptUserInfoOfaccess_token:(NSString *)access_token qrContent:(NSString *)qrContent success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/*
 8、转账
 /pica/userPayment
 参数：qrContent二维码加密串，amount转账金额
 */

+ (void)requestUserPaymentOfaccess_token:(NSString *)access_token
                               qrContent:(NSString *)qrContent
                                  amount:(NSString *)amount
                             payPassword:(NSString *)payPassword
                               longitude:(double )longitude
                                latitude:(double )latitude
                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/*
 9、支付、收款列表
 /pica/paymentList
 参数：pageNum，pageSize
 */

+ (void)requestPaymentListOfaccess_token:(NSString *)access_token
                                 pageNum:(NSInteger )pageNum
                                pageSize:(NSInteger )pageSize
                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/*
 10、充值、提现列表
 /pica/depositsList
 参数：pageNum，pageSize
 */

+ (void)requestdepositsListOfaccess_token:(NSString *)access_token
                                 pageNum:(NSInteger )pageNum
                                pageSize:(NSInteger )pageSize
                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/*
 11、搜索充值网点
 /pica/getOutletList
 参数：lat，lon，amount
 */

+ (void)requestGetOutletListOfaccess_token:(NSString *)access_token
                                       lat:(double )lat
                                       lon:(double )lon
                                    amount:(NSString *)amount
                                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/*
 12、验证码校验
 /pica/checkCode
 参数：business，code mobile
 */

+ (void)requestCheckCodeOfaccess_token:(NSString *)access_token
                              business:(NSString *)business
                                  code:(NSString *)code
                                mobile:(NSString *)mobile
                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/*
 12、校验邮箱
 /pica/checkEmail
 参数：email
 */

+ (void)requestCheckEmailOfaccess_token:(NSString *)access_token
                                  email:(NSString *)email
                               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/*
 13、设置头像
 /pica/uploadHeadPic
 参数：picUrl
 */

+ (void)requestUPloadHeadPicOfaccess_token:(NSString *)access_token
                                    picUrl:(NSString *)picUrl
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/*
 14、获取好友列表
/pica/getUserContacts
 */

+ (void)requestGetUserContactsOfaccess_token:(NSString *)access_token
                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


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
                                     success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/*
 14、facebook完善资料
 /pica/supplementaryInfo
 */

+ (void)requestSupplementaryInfoOfaccess_token:(NSString *)access_token
                                        mobile:(NSString *)mobile
                                         email:(NSString *)email
                                      password:(NSString *)password
                                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/*
 15、获取全部商铺列表新闻
 /pica/getNewsList
 */

+ (void)requestGetNewsListOfaccess_token:(NSString *)access_token
                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/*
 16、获取商铺详情列表新闻
 /pica/getNewsListByShopId
 参数：shopId
 */

+ (void)requestgetNewsListByShopIdOfaccess_token:(NSString *)access_token
                                          shopId:(NSInteger)shopId
                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/*
 17、上传证件照
 /pica/uploadGovernmentId
 参数：picUrl
 */
+ (void)requestuploadGovernmentIdOfaccess_token:(NSString *)access_token
                                         picUrl:(NSString *)picUrl
                                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/*
 18、查询证件照信息
 /pica/myGovernmentId
 
 * 资料状态
 * 0：未上传
 * 1：已上传
 * 2：审核中
 
 */
+ (void)requestmyGovernmentIdOfaccess_token:(NSString *)access_token
                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


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
                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/*
 
 20、获取城市列表
 /pica/getCityList
 
 */
+ (void)requestgetCityListOfaccess_token:(NSString *)access_token
                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/*
 21、上传手持证件照：
 /pica/uploadSelfieGovernmentId
 参数：picUrl
 */
+ (void)requestuploadSelfieGovernmentIdOfaccess_token:(NSString *)access_token
                                               picUrl:(NSString *)picUrl
                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/*
 22、查看手持照片信息
 /pica/selfieGovernmentId
 */
+ (void)requestselfieGovernmentIdOfaccess_token:(NSString *)access_token
                                              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/*
 23、问题列表
 /pica/securityQue
 */
+ (void)requestsecurityQueOfaccess_token:(NSString *)access_token
                                        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
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
                                           success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/*
 25、上传账单
 /pica/uploadBillPic
 参数：picUrl
 */
+ (void)requestuploadBillPicOfaccess_token:(NSString *)access_token
                                    picUrl:(NSString *)picUrl
                                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/*
 26、账单信息
 /pica/userBillPic
 */
+ (void)requestuserBillPicOfaccess_token:(NSString *)access_token
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/*
 27、查看个人信息
 /pica/userSecurityDetails
 */
+ (void)requestuserSecurityDetailsaccess_token:(NSString *)access_token
                                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/*
 28、查看个人地址信息
 /pica/myAddress
 */
+ (void)requestmyAddressaccess_token:(NSString *)access_token
                                       success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;
/*
 29、查看资料上传情况
 /pica/getUserInfoExt
 参数：level（int）
 */
+ (void)requestgetUserInfoExtaccess_token:(NSString *)access_token
                                    level:(NSInteger)level
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/*
 30、级别列表
 /pica/getLevelList
 */
+ (void)requestgetLevelListaccess_token:(NSString *)access_token
                                  success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/*
 31、留言
 /pica/userFeedback
 参数：content
 */
+ (void)requestuserFeedbackaccess_token:(NSString *)access_token
                                content:(NSString *)content
                                  isPic:(NSInteger)isPic
                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/*
 32、消息列表
 /pica/getFeedbackList
 */
+ (void)requestgetFeedbackListaccess_token:(NSString *)access_token
                                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


/*
 33、给商户发消息
 /pica/sendMessage
 参数：long shopId（商户ID），String content（消息内容）
 */
+ (void)requestsendMessageaccess_token:(NSString *)access_token
                                shopId:(NSInteger )shopId
                               content:(NSString *)content
                                 isPic:(NSInteger)isPic
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

/*
 34、获商铺信息列表
 /pica/messageList
 */
+ (void)requestMessageListaccess_token:(NSString *)access_token
                                shopId:(NSInteger )shopId
                               pageNum:(NSInteger)pageNum
                              pageSize:(NSInteger)pageSize
                                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

@end
