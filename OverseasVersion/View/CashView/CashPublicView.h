//
//  CashPublicView.h
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/24.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "JWScrollviewCell.h"

@interface CashPublicView : UIView

-(JWScrollviewCell *)getleftSearchViewWithFrame:(CGRect)frame;

-(JWScrollviewCell *)getrightSearchViewWithFrame:(CGRect)fraem;

-(JWScrollviewCell *)getSearchResultViewWithFrame:(CGRect)fraem;

@end
