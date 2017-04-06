//
//  CashPublicView.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/24.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "CashPublicView.h"
#import "projectHeader.h"
#import "UIView+Extension.h"
#import "JWLabel.h"
#import "OtherTool.h"
#import "ShadowView.h"
#import "NSString+CustomString.h"

#import <GoogleMaps/GoogleMaps.h>

#import "ShopModel.h"

@interface CashPublicView () <UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) GMSMapView * mapView;

@property (nonatomic,strong) GMSMapView * rightMapView;

@property (nonatomic,strong) NSMutableArray <ShopModel * >* shopList;
@property (nonatomic,strong) NSMutableArray <ShopModel * >* rightshopList;

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UITableView * rightTableView;

@property (nonatomic,strong) GMSPolyline * leftPolyline;

@property (nonatomic,strong) GMSPolyline * rightPolyline;

@property (nonatomic,assign) double  lat;

@property (nonatomic,assign) double  lon;


@property (nonatomic,strong) UIButton * selectBtn;

@end

@implementation CashPublicView

-(GMSMapView *)mapView{
    
    if (!_mapView) {
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.lat
                                                                longitude:self.lon
                                                                     zoom:12];
        _mapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
        _mapView.settings.compassButton = YES;
        _mapView.settings.myLocationButton = YES;
        [_mapView addObserver:self
                   forKeyPath:@"myLocation"
                      options:NSKeyValueObservingOptionNew
                      context:NULL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _mapView.myLocationEnabled = YES;
        });
    }
    return _mapView;
}

-(GMSMapView *)rightMapView{
    
    if (!_rightMapView) {
        GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:self.lat
                                                                longitude:self.lon
                                                                     zoom:12];
        _rightMapView = [GMSMapView mapWithFrame:CGRectZero camera:camera];
        _rightMapView.settings.compassButton = YES;
        _rightMapView.settings.myLocationButton = YES;
        [_rightMapView addObserver:self
                        forKeyPath:@"myLocation"
                           options:NSKeyValueObservingOptionNew
                           context:NULL];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            _rightMapView.myLocationEnabled = YES;
        });
    }
    return _rightMapView;
}


-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 0, kScreenWidth, adaptY(180)) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
    }
    return _tableView;
}

-(UITableView *)rightTableView{
    
    if (!_rightTableView) {
        _rightTableView = [[UITableView alloc]initWithFrame:CGRectMake(20, 0, kScreenWidth, adaptY(180)) style:UITableViewStyleGrouped];
        _rightTableView.delegate = self;
        _rightTableView.dataSource = self;
        _rightTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _rightTableView.backgroundColor = [UIColor whiteColor];
    }
    return _rightTableView;
    
}

-(NSMutableArray<ShopModel *> *)shopList{
    
    if (!_shopList) {
        _shopList = [NSMutableArray arrayWithCapacity:10];
    }
    return _shopList;
}

-(NSMutableArray<ShopModel *> *)rightshopList{
    
    if (!_rightshopList) {
        _rightshopList = [NSMutableArray arrayWithCapacity:10];
    }
    return _rightshopList;
}


-(JWScrollviewCell *)getleftSearchViewWithFrame:(CGRect)frame{

        JWScrollviewCell * item = [[JWScrollviewCell alloc]initWithFrame:frame];
        JWLabel *emptyLabel = [[JWLabel alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, 30)];
        emptyLabel.font = kMediumFont(13);
        emptyLabel.textColor = commonGrayColor;
        emptyLabel.textAlignment = NSTextAlignmentCenter;
        emptyLabel.numberOfLines = 0;
        emptyLabel.text = @"Remaining free Cash In: <2>";
        emptyLabel.labelAnotherColor = commonErrorColor;
        emptyLabel.tag = 1995;
        //How much would you like to cash out?
        [item.contentView addSubview:emptyLabel];
    
        JWLabel * moreinfoBtn = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(emptyLabel.frame), kScreenWidth-40, 30)];
        moreinfoBtn.text = Internationalization(@"更多信息", @"more info");
        moreinfoBtn.textColor = commonGrayColor;
        moreinfoBtn.font = kItalicFont(13);
        moreinfoBtn.textAlignment = 1;
        moreinfoBtn.tag = 2000;
        [moreinfoBtn addSingleTapEvent:^{
//            [self showMoreAlert];
        }];
        NSRange contentRange = {0,moreinfoBtn.text.length};
        [OtherTool addUnderlineLabel:moreinfoBtn labText:moreinfoBtn.text range:contentRange];
        [item.contentView addSubview:moreinfoBtn];
    
        JWTextField * textfield = [[JWTextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(emptyLabel.frame)+20, kScreenWidth-40, 50)];
        //        textfield.placeholder = @"₱0.00";
        textfield.textColor = commonVioletColor;
        textfield.textAlignment = 1;
        textfield.tag = 1996;
        textfield.keyboardType = UIKeyboardTypeDecimalPad;
        textfield.hidden = true;
        textfield.importStyle = TextFieldImportStyleRightfulMoney;
        [item.contentView addSubview:textfield];
        
        
        ShadowView * searchBtn = [[ShadowView alloc] initWithFrame:
                                  CGRectMake(20,CGRectGetMaxY(textfield.frame)+20,kScreenWidth-40,ShadowViewHeight)];
        searchBtn.colors =commonColorS;
        [searchBtn addSingleTapEvent:^{
            NSLog(@"searchBtn");
//            [self TapSearch];
        }];
        [item.contentView addSubview:searchBtn];
        
        JWLabel * searchLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, searchBtn.y, searchBtn.width, searchBtn.height)];
        searchLab.text = Internationalization(@"搜索", @"Search");
        searchLab.textAlignment = 1;
        searchLab.textColor = [UIColor whiteColor];
        [item.contentView addSubview:searchLab];
        
        JWLabel *tipLabel = [[JWLabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(searchBtn.frame)+5, kScreenWidth, 60)];
        tipLabel.font = kLightFont(11);
        tipLabel.textColor = commonGrayColor;
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.numberOfLines = 0;
        tipLabel.text = Internationalization(@"点击上面的按钮找到最近的存款设备", @"Click the button above to find the nearest Cash In facility");
        tipLabel.tag = 1999;
        [item.contentView addSubview:tipLabel];
        
        [item setUPSpacing:0 andDownSpacing:0];
    
    return item;
}


-(JWScrollviewCell *)getrightSearchViewWithFrame:(CGRect)fraem{

    JWScrollviewCell * item = [[JWScrollviewCell alloc]initWithFrame:fraem];
    JWLabel *emptyLabel = [[JWLabel alloc] initWithFrame:CGRectMake(0, 50, kScreenWidth, 30)];
    emptyLabel.font = kMediumFont(13);
    emptyLabel.textColor = commonGrayColor;
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.numberOfLines = 0;
    emptyLabel.text = Internationalization(@"您想兑换多少钱？", @"How much would you like to cash out?");
    emptyLabel.tag = 1995;
    [item.contentView addSubview:emptyLabel];
    
    JWLabel * placeholderLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(emptyLabel.frame)+20, kScreenWidth-40, 50)];
    placeholderLab.font = kMediumFont(20);
    placeholderLab.labelAnotherFont = kMediumFont(15);
    placeholderLab.textColor = commonVioletColor;
    placeholderLab.text = @"₱0.[00]";
    placeholderLab.textAlignment = 1;
    
    JWTextField * textfield = [[JWTextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(emptyLabel.frame)+20, kScreenWidth-40, 50)];
    textfield.textColor = [UIColor clearColor];
    textfield.tintColor =[UIColor clearColor];
    textfield.textAlignment = 1;
    textfield.tag = 1996;
    textfield.keyboardType = UIKeyboardTypeDecimalPad;
    textfield.importStyle = TextFieldImportStyleRightfulMoney;
    textfield.importBackString = ^(NSString * importStr){
        placeholderLab.text = [NSString formatSpecialMoneyString:importStr.doubleValue];
    };
    [item.contentView addSubview:textfield];
    
    [item.contentView addSubview:placeholderLab];
    
    ShadowView * searchBtn = [[ShadowView alloc] initWithFrame:
                              CGRectMake(20,CGRectGetMaxY(textfield.frame)+20,kScreenWidth-40,ShadowViewHeight)];
    searchBtn.colors =commonColorS;
    [searchBtn addSingleTapEvent:^{
        NSLog(@"searchBtn");
//        [self TapSearch];
    }];
    [item.contentView addSubview:searchBtn];
    
    JWLabel * searchLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, searchBtn.y, searchBtn.width, searchBtn.height)];
    searchLab.text = Internationalization(@"搜索", @"Search");
    searchLab.textAlignment = 1;
    searchLab.textColor = [UIColor whiteColor];
    [item.contentView addSubview:searchLab];
    
    [item setUPSpacing:0 andDownSpacing:0];

    return item;
}


-(JWScrollviewCell *)getSearchResultViewWithFrame:(CGRect)fraem{

    JWScrollviewCell * item = [[JWScrollviewCell alloc]initWithFrame:fraem];

    JWLabel * moneyLab = [[JWLabel alloc]init];
    moneyLab.font = kMediumFont(12);
    moneyLab.isShadow = true;
    moneyLab.colors = commonColorS;
    moneyLab.text = Internationalization(@"搜索中...", @"Searching...");
    moneyLab.textAlignment =1;
    [moneyLab sizeToFit];
    moneyLab.tag = 2000;
    moneyLab.center = CGPointMake(item.bounds.size.width * 0.5, adaptY(30));
    [item.contentView addSubview:moneyLab];
    //删除原来的
    self.mapView.frame = CGRectMake(20, CGRectGetMaxY(moneyLab.frame)+20, kScreenWidth-40, adaptY(130));
    [item.contentView addSubview:self.mapView];
    JWLabel * tipLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.mapView.frame)+5, kScreenWidth-40, adaptY(30))];
    tipLab.font = kMediumFont(13);
    tipLab.text =
    [NSString stringWithFormat:@"Nearest available %@ facility:",self.selectBtn.titleLabel.text];
    tipLab.tag = 2001;
    [item.contentView addSubview:tipLab];
    self.tableView.frame = CGRectMake(20, CGRectGetMaxY(tipLab.frame)+0, kScreenWidth, adaptY(180));
    [item.contentView addSubview:self.tableView];
    
    [item setUPSpacing:0 andDownSpacing:0];

    return item;
    
    
}


@end
