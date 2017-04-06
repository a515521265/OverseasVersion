//
//  NewsModel.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/3/5.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "NewsModel.h"
#import "NSString+Utils.h"//category
@implementation NewsModel

-(void)setShopName:(NSString *)shopName{

    if (shopName) {
        _shopName = shopName;
        _pinyin = _shopName.pinyin;
    }
    
}
@end
