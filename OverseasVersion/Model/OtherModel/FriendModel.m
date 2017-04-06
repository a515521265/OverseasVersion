//
//  FriendModel.m
//  OverseasVersion
//
//  Created by 梁家文 on 17/2/19.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "FriendModel.h"
#import "NSString+Utils.h"//category
@implementation FriendModel

-(void)setFirstName:(NSString *)firstName{

    if (firstName) {
        _firstName=firstName;
        _pinyin=_firstName.pinyin;
    }
    
}

@end
