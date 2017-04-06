//
//  NewsModel.h
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/3/5.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsModel : NSObject

//@property (nonatomic,strong) NSString * content;
@property (nonatomic,strong) NSString * headPic;
@property (nonatomic,strong) NSString *pinyin;//拼音
@property (nonatomic,assign) long long  publicTime;
@property (nonatomic,assign) NSInteger  shopId;
@property (nonatomic,strong) NSString * shopName;
@property (nonatomic,strong) NSString * title;

@property (nonatomic,strong) NSString * newsUrl;

@property (nonatomic,strong) NSString * newsDesc;

@end
