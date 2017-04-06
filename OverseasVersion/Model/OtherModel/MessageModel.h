//
//  MessageModel.h
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/3/14.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MessageModel : NSObject

@property (nonatomic,strong) NSString * content;
@property (nonatomic,assign) long long  createTime;
@property (nonatomic,assign) NSInteger  isPic;
@property (nonatomic,assign) NSInteger  type;

//type=1是发送出去的留言信息，type=2是接收到的回复

@end
