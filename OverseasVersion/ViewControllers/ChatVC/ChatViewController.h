//
//  ChatViewController.h
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/21.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "MainViewController.h"
#import "NewsModel.h"

@interface ChatViewController : MainViewController

@property (nonatomic,strong) NewsModel * shopModel;

@property (nonatomic,strong) NSString * leftImageURL;

@end
