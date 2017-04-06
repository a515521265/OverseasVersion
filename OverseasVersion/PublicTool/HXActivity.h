//
//  HXActivity.h
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/17.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HXActivity : UIActivity

@property (nonatomic, copy) NSString * title;

@property (nonatomic, strong) UIImage * image;

@property (nonatomic, strong) NSURL * url;

@property (nonatomic, copy) NSString * type;

@property (nonatomic, strong) NSArray * shareContexts;

- (instancetype)initWithTitie:(NSString *)title withActivityImage:(UIImage *)image withUrl:(NSURL *)url withType:(NSString *)type  withShareContext:(NSArray *)shareContexts;

@end
