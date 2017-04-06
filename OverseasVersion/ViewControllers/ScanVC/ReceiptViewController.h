//
//  ReceiptViewController.h
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/8.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "MainViewController.h"
#import "TradingRecordModel.h"

@interface ReceiptViewController : MainViewController

//交易模型
@property (nonatomic,strong) TradingRecordModel * recordModel;

@end
