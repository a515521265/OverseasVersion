//
//  SpinnerCell.h
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/24.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpinnerCell : UITableViewCell

@property (nonatomic,strong) NSString * titleText;

@property (nonatomic,assign) NSInteger  cellHeight;

@property (nonatomic,assign) NSInteger  cellW;

@property (nonatomic,assign) NSInteger  returnCH;


@property (nonatomic,strong) id model;

@end
