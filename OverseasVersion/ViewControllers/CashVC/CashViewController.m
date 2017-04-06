//
//  CashViewController.m
//  OverseasVersion
//
//  Created by 梁家文 on 17/2/6.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "CashViewController.h"
#import "ShadowView.h"
#import "CashTableViewCell.h"
#import <GoogleMaps/GoogleMaps.h>
#import "QRCodeImage.h"
#import "ShopModel.h"
#import "OtherTool.h"
#import "XLNotificationTransfer.h"
#import "WKTextFieldFormatter.h"

@interface CashViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (nonatomic,strong) JWScrollviewCell * cashheardCell;

@property (nonatomic,strong) JWScrollviewCell * emptyView;
@property (nonatomic,strong) JWScrollviewCell * rightEmptyView;//右边界面
@property (nonatomic,strong) JWScrollviewCell * searchResultView; //搜索结果
@property (nonatomic,strong) JWScrollviewCell * rightSearchResultView; //右边搜索结果

@property (nonatomic,strong) GMSMapView * mapView;

@property (nonatomic,strong) GMSMapView * rightMapView;

@property (nonatomic,strong) UIButton * selectBtn;

@property (nonatomic,assign) double  lat;

@property (nonatomic,assign) double  lon;

@property (nonatomic,strong) NSMutableArray <ShopModel * >* shopList;
@property (nonatomic,strong) NSMutableArray <ShopModel * >* rightshopList;

@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UITableView * rightTableView;

@property (nonatomic,strong) GMSPolyline * leftPolyline;

@property (nonatomic,strong) GMSPolyline * rightPolyline;

@property (nonatomic,strong) WKTextFieldFormatter * formatter;

@end

@implementation CashViewController

static BOOL isfirst;


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


-(JWScrollviewCell *)rightSearchResultView{

    if (!_rightSearchResultView) {
        _rightSearchResultView = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-44)];
        [self.rightEmptyView addSubview:_rightSearchResultView];
        
        JWLabel * moneyLab = [[JWLabel alloc]init];
        moneyLab.font = kMediumFont(12);
        moneyLab.isShadow = true;
        moneyLab.colors = commonColorS;
        moneyLab.text = Internationalization(@"搜索中...", @"Searching...");
        moneyLab.textAlignment =1;
        [moneyLab sizeToFit];
        moneyLab.tag = 2000;
        moneyLab.center = CGPointMake(_rightSearchResultView.bounds.size.width * 0.5, adaptY(30));
        [_rightSearchResultView.contentView addSubview:moneyLab];
        //删除原来的
        self.rightMapView.frame = CGRectMake(20, CGRectGetMaxY(moneyLab.frame)+20, kScreenWidth-40, adaptY(130));
        [_rightSearchResultView.contentView addSubview:self.rightMapView];
        
        JWLabel * tipLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.rightMapView.frame)+5, kScreenWidth-40, adaptY(30))];
        tipLab.font = kMediumFont(13);
        tipLab.text =
        [NSString stringWithFormat:@"Nearest available %@ facility:",self.selectBtn.titleLabel.text];
        tipLab.tag = 2001;
        [_rightSearchResultView.contentView addSubview:tipLab];
        
        self.rightTableView.frame = CGRectMake(20, CGRectGetMaxY(tipLab.frame)+0, kScreenWidth, adaptY(180));
        
        [_rightSearchResultView.contentView addSubview:self.rightTableView];
        
        [_rightSearchResultView setUPSpacing:0 andDownSpacing:0];
    }
    return _rightSearchResultView;
}

-(JWScrollviewCell *)rightEmptyView{

    if (!_rightEmptyView) {
        _rightEmptyView = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cashheardCell.frame), kScreenWidth, kScreenHeight)];
        [self.view addSubview:_rightEmptyView];
        JWLabel *emptyLabel = [[JWLabel alloc] initWithFrame:CGRectMake(0, adaptY(40), kScreenWidth,adaptY(30))];
        emptyLabel.font = kMediumFont(13);
        emptyLabel.textColor = commonGrayColor;
        emptyLabel.textAlignment = NSTextAlignmentCenter;
        emptyLabel.numberOfLines = 0;
        emptyLabel.text = Internationalization(@"您想兑换多少钱？", @"How much would you like to cash out?");
        emptyLabel.tag = 1995;
        [_rightEmptyView.contentView addSubview:emptyLabel];
        
        JWLabel * placeholderLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(emptyLabel.frame)+adaptY(20), kScreenWidth-40, adaptY(30))];
        placeholderLab.font = kMediumFont(20);
        placeholderLab.labelAnotherFont = kMediumFont(12);
        placeholderLab.textColor = commonVioletColor;
        placeholderLab.text = @"₱0.[00]";
        placeholderLab.textAlignment = 1;
        
        JWTextField * textfield = [[JWTextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(emptyLabel.frame)+adaptY(20), kScreenWidth-40, adaptY(30))];
        textfield.textColor = [UIColor clearColor];
        textfield.tintColor =[UIColor clearColor];
        textfield.textAlignment = 1;
        textfield.tag = 1996;
        textfield.keyboardType = UIKeyboardTypeDecimalPad;
        self.formatter = [[WKTextFieldFormatter alloc] initWithTextField:textfield];
        self.formatter.formatterType = WKFormatterTypeDecimal;
        self.formatter.decimalPlace = 2;
        self.formatter.backStr = ^(NSString * backS){
            placeholderLab.text = [NSString formatSpecialMoneyString:backS.doubleValue];
        };
        [_rightEmptyView.contentView addSubview:textfield];
        
        [_rightEmptyView.contentView addSubview:placeholderLab];
        
        
        
        
        JWLabel * line1 = [[JWLabel alloc]initWithFrame:CGRectMake(40, CGRectGetMaxY(textfield.frame), kScreenWidth-80, 1)];
        line1.backgroundColor = UIColorFromRGB(0xe1e1e1);
        [_rightEmptyView.contentView addSubview:line1];
        
        
        ShadowView * searchBtn = [[ShadowView alloc] initWithFrame:
                                  CGRectMake(20,CGRectGetMaxY(textfield.frame)+adaptY(25),kScreenWidth-40,ShadowViewHeight)];
        searchBtn.colors =commonColorS;
        [searchBtn addSingleTapEvent:^{
            NSLog(@"searchBtn");
            [self TapSearch];
        }];
        [_rightEmptyView.contentView addSubview:searchBtn];
        
        JWLabel * searchLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, searchBtn.y, searchBtn.width, searchBtn.height)];
        searchLab.text = Internationalization(@"搜索", @"Search");
        searchLab.textAlignment = 1;
        searchLab.textColor = [UIColor whiteColor];
        searchLab.font = kMediumFont(14);
        [_rightEmptyView.contentView addSubview:searchLab];
        
        
        JWLabel *tipLabel = [[JWLabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(searchBtn.frame)+adaptY(10), kScreenWidth, adaptY(15))];
        tipLabel.font = kLightFont(10);
        tipLabel.textColor = commonGrayColor;
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.numberOfLines = 0;
        tipLabel.text = Internationalization(@"点击上面的按钮找到最近的取款设备", @"Click the button above to find the nearest Cash Out facility");
        tipLabel.tag = 1999;
        [_rightEmptyView.contentView addSubview:tipLabel];
        
        
        [_rightEmptyView setUPSpacing:0 andDownSpacing:0];
        
    }
    return _rightEmptyView;
}


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

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    HXWeak_self
    [self getAccountInfosuccess:^(AccountInfo *accountInfo) {
        HXStrong_self
        ((JWLabel *)self.emptyView.getElementByTag(1995)).text =
        [NSString stringWithFormat:@"Remaining free Cash In: <%ld>",(long)accountInfo.freeCashNum];
    } showHud:false];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self addNotification];
    
    [self.view addSubview:self.cashheardCell];
    
    [self emptyView];
    
    [self rightEmptyView];
    
    self.rightEmptyView.hidden = true;
    
    [self facebooksupplementaryInfo];
    
//    [self getUserLocation];
    
}

-(void)getUserLocation{

    HXWeak_self
    [HXMapLocationManager getGps:^(double lattitude, double longitude) {
       HXStrong_self
        self.lat = lattitude;
        self.lon = longitude;
    }];
    
}

-(JWScrollviewCell *)cashheardCell{

    if (!_cashheardCell) {
        _cashheardCell = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 100)];
        UIButton * leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftbutton.titleLabel.font = kMediumFont(16);
        [leftbutton setTitle:Internationalization(@"转入", @"Cash In") forState:UIControlStateNormal];
        leftbutton.frame = CGRectMake(0, 0, kScreenWidth/2, adaptY(50));
        leftbutton.selected = true;
        leftbutton.tag = 1000;
        [leftbutton setTitleColor:commonGrayBtnColor forState:UIControlStateNormal];
        [leftbutton setTitleColor:commonBlackBtnColor forState:UIControlStateSelected];
        [_cashheardCell.contentView addSubview:leftbutton];
        
        UIButton * rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightbutton.titleLabel.font = kMediumFont(16);
        [rightbutton setTitle:Internationalization(@"转出", @"Cash Out") forState:UIControlStateNormal];
        rightbutton.frame = CGRectMake( kScreenWidth/2, 0, kScreenWidth/2, adaptY(50));
        rightbutton.selected = false;
        rightbutton.tag = 1001;
        [rightbutton setTitleColor:commonGrayBtnColor forState:UIControlStateNormal];
        [rightbutton setTitleColor:commonBlackBtnColor forState:UIControlStateSelected];
        
        self.selectBtn = leftbutton;
        
        [_cashheardCell.contentView addSubview:rightbutton];
        
        JWLabel * leftLine = [[JWLabel alloc]initWithFrame:CGRectMake((leftbutton.width-leftbutton.width/1.5)/2, CGRectGetMaxY(leftbutton.frame), leftbutton.width/1.5, 1)];
        leftLine.backgroundColor = commonBlackBtnColor;
        [_cashheardCell.contentView addSubview:leftLine];
        CGRect leftframe = leftLine.frame;
        
        JWLabel * rightLine = [[JWLabel alloc]initWithFrame:CGRectMake((rightbutton.width-rightbutton.width/1.5)/2 + CGRectGetMaxX(leftbutton.frame), CGRectGetMaxY(rightbutton.frame), rightbutton.width/1.5, 1)];
        rightLine.backgroundColor = commonBlackBtnColor;
        rightLine.hidden = true;
        [_cashheardCell.contentView addSubview:rightLine];
        CGRect rightframe = rightLine.frame;
        
        HXWeak_(rightbutton)
        HXWeak_(leftbutton)
        HXWeak_self
        [rightbutton addSingleTapEvent:^{
            HXStrong_(rightbutton)
            HXStrong_(leftbutton)
            rightbutton.selected = true;
            leftbutton.selected = false;
            self.selectBtn = rightbutton;
            [self reloadViewUI:rightbutton];
            [UIView animateWithDuration:0.3 animations:^{
                leftLine.frame = rightframe;
            } completion:nil];
        }];
        
        [leftbutton addSingleTapEvent:^{
            HXStrong_self
            HXStrong_(rightbutton)
            HXStrong_(leftbutton)
            [self.view endEditing:true];
            rightbutton.selected = false;
            leftbutton.selected = true;
            self.selectBtn = leftbutton;
            [self reloadViewUI:leftbutton];
            [UIView animateWithDuration:0.3 animations:^{
                leftLine.frame = leftframe;
            } completion:nil];
        }];
        
        _cashheardCell.contentView.height = CGRectGetMaxY(rightLine.frame);
        
        [_cashheardCell setUPSpacing:0 andDownSpacing:0];
    }
    return _cashheardCell;
    
}

-(JWScrollviewCell *)emptyView{

    if (!_emptyView) {
        _emptyView = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.cashheardCell.frame), kScreenWidth, kScreenHeight)];
        [self.view addSubview:_emptyView];
        JWLabel *emptyLabel = [[JWLabel alloc] initWithFrame:CGRectMake(0,adaptY(50), kScreenWidth, adaptY(15))];
        emptyLabel.font = kLightFont(12);
        emptyLabel.textColor = commonBlackBtnColor;
        emptyLabel.textAlignment = NSTextAlignmentCenter;
        emptyLabel.numberOfLines = 0;
        emptyLabel.labelAnotherColor = commonErrorColor;
        emptyLabel.text = @"Remaining free Cash In: <0>";
        emptyLabel.tag = 1995;
        [_emptyView.contentView addSubview:emptyLabel];
        
        
        JWLabel * moreinfoBtn = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(emptyLabel.frame), kScreenWidth-40, adaptY(15))];
        moreinfoBtn.text = Internationalization(@"更多信息", @"more info");
        moreinfoBtn.textColor = commonBlackBtnColor;
        moreinfoBtn.font = kItalicFont(11);
        moreinfoBtn.textAlignment = 1;
        moreinfoBtn.tag = 2000;
        [moreinfoBtn addSingleTapEvent:^{
            [self showMoreAlert];
        }];
        NSRange contentRange = {0,moreinfoBtn.text.length};
        [OtherTool addUnderlineLabel:moreinfoBtn labText:moreinfoBtn.text range:contentRange];
        [_emptyView.contentView addSubview:moreinfoBtn];
        
        
        JWTextField * textfield = [[JWTextField alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(emptyLabel.frame)+20, kScreenWidth-40, 50)];
//        textfield.placeholder = @"₱0.00";
        textfield.textColor = commonVioletColor;
        textfield.textAlignment = 1;
        textfield.tag = 1996;
        textfield.keyboardType = UIKeyboardTypeDecimalPad;
        textfield.hidden = true;
        textfield.importStyle = TextFieldImportStyleRightfulMoney;
        [_emptyView.contentView addSubview:textfield];
    
        
        ShadowView * searchBtn = [[ShadowView alloc] initWithFrame:
                                 CGRectMake(20,adaptY(145),kScreenWidth-40,ShadowViewHeight)];
        searchBtn.colors =commonColorS;
        [searchBtn addSingleTapEvent:^{
            NSLog(@"searchBtn");
            [self TapSearch];
        }];
        [_emptyView.contentView addSubview:searchBtn];
        
        JWLabel * searchLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, searchBtn.y, searchBtn.width, searchBtn.height)];
        searchLab.text = Internationalization(@"搜索", @"Search");
        searchLab.textAlignment = 1;
        searchLab.textColor = [UIColor whiteColor];
        searchLab.font = kMediumFont(14);
        [_emptyView.contentView addSubview:searchLab];
        
        JWLabel *tipLabel = [[JWLabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(searchBtn.frame)+adaptY(10), kScreenWidth, adaptY(15))];
        tipLabel.font = kLightFont(10);
        tipLabel.textColor = commonGrayColor;
        tipLabel.textAlignment = NSTextAlignmentCenter;
        tipLabel.numberOfLines = 0;
        tipLabel.text = Internationalization(@"点击上面的按钮找到最近的存款设备", @"Click the button above to find the nearest Cash In facility");
        tipLabel.tag = 1999;
        [_emptyView.contentView addSubview:tipLabel];
        
        [_emptyView setUPSpacing:0 andDownSpacing:0];
        
    }
    return _emptyView;
    
}


-(void)reloadViewUI:(UIButton *)btn{

    if (btn.tag == 1000) {
        self.emptyView.hidden = false;
        self.rightEmptyView.hidden = true;
        if (_searchResultView) {
            [self addleftBtn];
        }else{
            [self createTitleBarButtonItemStyle:BtnLeftType title:@"" TapEvent:nil];
        }
    }else if (btn.tag == 1001){
        self.emptyView.hidden = true;
        self.rightEmptyView.hidden = false;
        if (_rightSearchResultView) {
            [self addleftBtn];
        }else{
            [self createTitleBarButtonItemStyle:BtnLeftType title:@"" TapEvent:nil];
        }
    }
    
}

-(JWScrollviewCell *)searchResultView{

    if (!_searchResultView) {
        _searchResultView = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64-44)];
        [self.emptyView addSubview:_searchResultView];
        
        JWLabel * moneyLab = [[JWLabel alloc]init];
        moneyLab.font = kMediumFont(12);
        moneyLab.isShadow = true;
        moneyLab.colors = commonColorS;
        moneyLab.text = Internationalization(@"搜索中...", @"Searching...");
        moneyLab.textAlignment =1;
        [moneyLab sizeToFit];
        moneyLab.tag = 2000;
        moneyLab.center = CGPointMake(_searchResultView.bounds.size.width * 0.5, adaptY(30));
        [_searchResultView.contentView addSubview:moneyLab];
        //删除原来的
        self.mapView.frame = CGRectMake(20, CGRectGetMaxY(moneyLab.frame)+20, kScreenWidth-40, adaptY(130));
        [_searchResultView.contentView addSubview:self.mapView];
        JWLabel * tipLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(self.mapView.frame)+5, kScreenWidth-40, adaptY(30))];
        tipLab.font = kMediumFont(13);
        tipLab.text =
        [NSString stringWithFormat:@"Nearest available %@ facility:",self.selectBtn.titleLabel.text];
        tipLab.tag = 2001;
        [_searchResultView.contentView addSubview:tipLab];
        self.tableView.frame = CGRectMake(20, CGRectGetMaxY(tipLab.frame)+0, kScreenWidth, adaptY(180));
        [_searchResultView.contentView addSubview:self.tableView];
        
        [_searchResultView setUPSpacing:0 andDownSpacing:0];
        
    }
    
    return _searchResultView;
}


-(void)TapSearch{

    [self.view endEditing:true];
    
    isfirst = false;
    
    if (self.selectBtn.tag == 1000) {
        [self searchResultView];
        //请求充值网点数据
        [self requestGetOutletList:self.selectBtn];
    }else if (self.selectBtn.tag == 1001){
        [self rightSearchResultView];
        //请求充值网点数据
        [self requestGetOutletList:self.selectBtn];
    }
    

    [self addleftBtn];
}


-(void)addleftBtn{

    HXWeak_self
    [self createImageBarButtonItemStyle:BtnLeftType Image:@"返回" TapEvent:^{
        HXStrong_self
        if (self.selectBtn.tag == 1000) {
            HXStrong_self
            [self.searchResultView removeFromSuperview];
            self.searchResultView = nil;
            [self.mapView removeObserver:self forKeyPath:@"myLocation"];
            [self.mapView removeFromSuperview];
            self.mapView = nil;
        }else if (self.selectBtn.tag == 1001){
            [self.rightSearchResultView removeFromSuperview];
            self.rightSearchResultView = nil;
            [self.rightMapView removeObserver:self forKeyPath:@"myLocation"];
            [self.rightMapView removeFromSuperview];
            self.rightMapView = nil;
        }
        [self createTitleBarButtonItemStyle:BtnLeftType title:@"" TapEvent:nil];
    }];
    
}


#pragma mark - 设置cell的样式
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    CashTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[CashTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.index = indexPath.row+1;
    
    cell.cellClick = ^(ShopModel * cModel){
        if (tableView == self.tableView) {
            
            self.leftPolyline.map = nil;
            GMSMutablePath *path = [GMSMutablePath path];
            [path addLatitude:self.lat longitude:self.lon]; //
            [path addLatitude:cModel.lat.doubleValue longitude:cModel.lon.doubleValue]; //
            GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
            polyline.strokeColor = [UIColor greenColor];
            polyline.strokeWidth = 2.f;
            self.leftPolyline = polyline;
            self.leftPolyline.map = self.mapView;
            
        }else{
            
            self.rightPolyline.map = nil;
            GMSMutablePath *path = [GMSMutablePath path];
            [path addLatitude:self.lat longitude:self.lon]; //
            [path addLatitude:cModel.lat.doubleValue longitude:cModel.lon.doubleValue]; //
            GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
            polyline.strokeColor = [UIColor redColor];
            polyline.strokeWidth = 2.f;
            self.rightPolyline = polyline;
            self.rightPolyline.map = self.rightMapView;
        }
    };
    if (tableView == self.tableView) {
        cell.cellModel = self.shopList[indexPath.row];
    }else{
        cell.cellModel = self.rightshopList[indexPath.row];
    }
    return cell;
}

#pragma mark - 设置section的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark - 设置cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    if (tableView == self.tableView) {
        return self.shopList.count;
    }else{
        return self.rightshopList.count;
    }
    
}
#pragma mark - 设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    return adaptY(60);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}
//添加地图标记点
- (void)addMapMarkers {
    
    for (int i =0; i<self.shopList.count; i++) {

        GMSMarker *sydneyMarker = [[GMSMarker alloc] init];
        sydneyMarker.title = self.shopList[i].name;
        if (self.selectBtn.tag == 1000) {
            sydneyMarker.icon = [QRCodeImage watermarkImage:[NSString stringWithFormat:@"%d",i+1] image:@"秒点2"];;
        }else if (self.selectBtn.tag == 1001){
            sydneyMarker.icon = [QRCodeImage watermarkImage:[NSString stringWithFormat:@"%d",i+1] image:@"秒点1"];;
        }
        sydneyMarker.position = CLLocationCoordinate2DMake(self.shopList[i].lat.doubleValue, self.shopList[i].lon.doubleValue);
        sydneyMarker.map = self.mapView;
    }
}

- (void)addrightMapMarkers {
    
    
    for (int i =0; i<self.rightshopList.count; i++) {
        
        GMSMarker *sydneyMarker = [[GMSMarker alloc] init];
        sydneyMarker.title = self.rightshopList[i].name;
        if (self.selectBtn.tag == 1000) {
            sydneyMarker.icon = [QRCodeImage watermarkImage:[NSString stringWithFormat:@"%d",i+1] image:@"秒点2"];;
        }else if (self.selectBtn.tag == 1001){
            sydneyMarker.icon = [QRCodeImage watermarkImage:[NSString stringWithFormat:@"%d",i+1] image:@"秒点1"];;
        }
        sydneyMarker.position = CLLocationCoordinate2DMake(self.rightshopList[i].lat.doubleValue, self.rightshopList[i].lon.doubleValue);
        sydneyMarker.map = self.rightMapView;
    }
    
}



- (void)dealloc {
    
    [self clearNotificationAndGesture];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
    [self.mapView removeObserver:self
                  forKeyPath:@"myLocation"
                     context:NULL];
    
    [self.rightMapView removeObserver:self
                           forKeyPath:@"myLocation"
                              context:NULL];
    
}

#pragma mark - KVO updates

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    
    if (isfirst  == false) {
        
        [self TapSearch];
        
        CLLocation *location = [change objectForKey:NSKeyValueChangeNewKey];
        ((GMSMapView *)object).camera = [GMSCameraPosition cameraWithTarget:location.coordinate
                                                                    zoom:12];
        isfirst = true;
    }
    
}

-(void)requestGetOutletList:(UIButton *)btn{

    
    HXWeak_self
    [HXMapLocationManager getGps:^(double lattitude, double longitude) {
        HXStrong_self
        self.lat = lattitude;
        self.lon = longitude;
    }];
    
    
    [CommonService requestGetOutletListOfaccess_token:self.defaultSetting.access_token lat:self.lat lon:self.lon amount:((JWTextField *)self.emptyView.getElementByTag(1996)).text success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (btn.tag==1000) {
            [self.shopList removeAllObjects];
        }else{
            [self.rightshopList removeAllObjects];
        }
        
        HXStrong_self
        if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
            
            if (btn.tag==1000) {
                for (NSDictionary *dict in responseObject[@"data"]) {
                    ShopModel *model = [ShopModel yy_modelWithDictionary:dict];
                    [self.shopList addObject:model];
                }
                //添加地图标记点
                [self addMapMarkers];
                [self.tableView reloadData];
                
                self.searchResultView.getElementByTag(2000).hidden = true;
                
            }else{
                for (NSDictionary *dict in responseObject[@"data"]) {
                    ShopModel *model = [ShopModel yy_modelWithDictionary:dict];
                    [self.rightshopList addObject:model];
                }
                //添加地图标记点
                [self addrightMapMarkers];
                [self.rightTableView reloadData];
                self.rightSearchResultView.getElementByTag(2000).hidden = true;
            }
        }else{
            [self showTip:[responseObject objectForKey:@"errorMessage"]];
        }
        [self closeHud];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HXStrong_self
        [self closeHud];
        [self errorDispose:[[operation response] statusCode] judgeMent:nil];
    }];
}


-(void)showMoreAlert{
    
    HXWeak_self
    [self getAccountInfosuccess:^(AccountInfo *accountInfo) {
        HXStrong_self

        NSString * numberStr = [NSString stringWithFormat:@"%ld",(long)accountInfo.freeCashNum];
        
        NSString * textStr = [NSString stringWithFormat:@"Remaining monthly free Cash In: "];
        
        NSString * alertTitle = [NSString stringWithFormat:@"%@%@",textStr,numberStr];
        
        JWAlertView * jwalert = [[JWAlertView alloc]initJWAlertViewWithTitle:alertTitle message:@"Every month,you receive 2 free Cash In.Meaning we will reimburse you the amount you paid to put money inside you PICA wallet. We do this by adding the fee you paid inside your PICA wallet after you Cash In. \n \n If you have any questions, feel free to message us, and we will respond to you as soon as we can. :)" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        paragraphStyle.alignment = NSTextAlignmentCenter;
        
        
        NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:jwalert.titleLab.text];
        
        [attrStr addAttribute:NSFontAttributeName
                        value:[UIFont fontWithName:@"Helvetica-Bold" size:17]
                        range:NSMakeRange(0, attrStr.length)];
        
        [attrStr addAttribute:NSForegroundColorAttributeName
                        value:[UIColor redColor]
                        range:NSMakeRange(attrStr.length-numberStr.length, numberStr.length)];
        
        [attrStr addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, jwalert.titleLab.text.length)];
        
        jwalert.titleLab.attributedText = attrStr;
        
        [jwalert alertShow];
    
    } showHud:true];
    
    
}

-(void)viewWillDisappear:(BOOL)animated{

    [super viewWillDisappear:animated];
    [HXMapLocationManager stop];
    
}



@end
