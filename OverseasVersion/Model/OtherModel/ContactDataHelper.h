//
//  ContactDataHelper.h
//  OverseasVersion
//
//  Created by 梁家文 on 17/2/19.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactDataHelper : NSObject

+ (NSMutableArray *) getFriendListDataBy:(NSMutableArray *)array;
+ (NSMutableArray *) getFriendListSectionBy:(NSMutableArray *)array;



+ (NSMutableArray *) getShopListDataBy:(NSMutableArray *)array;
+ (NSMutableArray *) getShopListSectionBy:(NSMutableArray *)array;


@end
