//
//  TransactionsViewController.m
//  OverseasVersion
//
//  Created by 梁家文 on 17/2/6.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "TransactionsViewController.h"
#import "TransactionsCell.h"
#import "MJRefresh.h"
#import "TradingRecordModel.h"
//支付详情
#import "ReceiptViewController.h"


@interface TransactionsViewController () <UITableViewDelegate,UITableViewDataSource,UIViewControllerPreviewingDelegate>

@property (nonatomic,strong) JWScrollviewCell * heardCell;

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) UIView * emptyView;/**< 空视图 */

@property (nonatomic,strong) UIButton * selectBtn;

@property (nonatomic,strong) NSMutableArray <TradingRecordModel *> * modelList;

@property (nonatomic,assign) NSInteger   numSize;

@end

@implementation TransactionsViewController

-(NSMutableArray<TradingRecordModel *> *)modelList{

    if (!_modelList) {
        _modelList = [NSMutableArray arrayWithCapacity:10];
    }
    return _modelList;
}

-(UITableView *)tableView{

    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(self.heardCell.frame), kScreenWidth, kScreenHeight-self.heardCell.height-(64+44)-5) style:UITableViewStyleGrouped];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.backgroundColor = [UIColor whiteColor];
        HXWeak_self
        [_tableView setHeader:[MJRefreshNormalHeader headerWithRefreshingBlock:^{
            HXStrong_self
            [self reloadTableViewData];
        }]];
        
        [_tableView setFooter:[MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            HXStrong_self
            [self reloadMoreTableViewData];
        }]];
        [self.view addSubview:_tableView];
    }
    return _tableView;
    
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    //刷新金额
    HXWeak_self
    [self getAccountInfosuccess:^(AccountInfo *accountInfo) {
        HXStrong_self
        ((JWLabel *)self.heardCell.getElementByTag(2001)).text =[NSString formatSpliceSignMoneyString:accountInfo.availableAmount.doubleValue];
        [((JWLabel *)self.heardCell.getElementByTag(2001)) sizeToFit];
        ((JWLabel *)self.heardCell.getElementByTag(2001)).center = CGPointMake(_heardCell.bounds.size.width * 0.5, CGRectGetMaxY(((JWLabel *)self.heardCell.getElementByTag(2000)).frame)+20);
    } showHud:false];
    
    //刷新列表
    [self reloadTableViewData];
}

-(void)reloadTableViewData{

    self.numSize = 10;
    if ((long)self.selectBtn.tag==1999) {
        [self requestdepositsList];
    }else if ((long)self.selectBtn.tag ==1888){
        [self requestPaymentList];
    }
    
}

-(void)reloadMoreTableViewData{
    
    self.numSize +=10;
    
    if ((long)self.selectBtn.tag==1999) {
        [self requestdepositsList];
    }else if ((long)self.selectBtn.tag==1888){
        [self requestPaymentList];
    }
    
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.heardCell];
    
    [self tableView];
    
    [self facebooksupplementaryInfo];
    
}

-(JWScrollviewCell *)heardCell{

    if (!_heardCell) {
        _heardCell = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 145)];
        JWLabel * tipLab = [[JWLabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
        tipLab.text = Internationalization(@"收支", @"BALANCE");
        tipLab.textColor = UIColorFromRGB(0xa5a09e);
        tipLab.font = kLightFont(10);
        tipLab.textAlignment = 1;
        tipLab.tag = 2000;
        [_heardCell.contentView addSubview:tipLab];
        
        JWLabel * moneyLab = [[JWLabel alloc]init];
        moneyLab.font = kMediumFont(30);
        moneyLab.isShadow = true;
        moneyLab.colors = commonColorS;
        moneyLab.tag = 2001;
        moneyLab.labelAnotherFont = kMediumFont(18);
        moneyLab.changeTextSize = true;
        moneyLab.text = @"₱0.00";
        moneyLab.textAlignment =1;
        [moneyLab sizeToFit];
        moneyLab.center = CGPointMake(_heardCell.bounds.size.width * 0.5, CGRectGetMaxY(tipLab.frame)+20);
        
        [_heardCell.contentView addSubview:moneyLab];
        
        UIButton * leftbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftbutton.titleLabel.font = kMediumFont(16);
        [leftbutton setTitle:Internationalization(@"支出", @"Payments") forState:UIControlStateNormal];
        leftbutton.frame = CGRectMake(0, CGRectGetMaxY(moneyLab.frame), kScreenWidth/2, 50);
        leftbutton.selected = true;
        [leftbutton setTitleColor:commonGrayBtnColor forState:UIControlStateNormal];
        [leftbutton setTitleColor:commonBlackBtnColor forState:UIControlStateSelected];
        
        leftbutton.tag = 1888;
        [_heardCell.contentView addSubview:leftbutton];
        
        UIButton * rightbutton = [UIButton buttonWithType:UIButtonTypeCustom];
        rightbutton.titleLabel.font = kMediumFont(16);
        [rightbutton setTitle:Internationalization(@"收入", @"Deposits") forState:UIControlStateNormal];
        rightbutton.frame = CGRectMake( kScreenWidth/2, CGRectGetMaxY(moneyLab.frame), kScreenWidth/2, 50);
        rightbutton.selected = false;
        [rightbutton setTitleColor:commonGrayBtnColor forState:UIControlStateNormal];
        [rightbutton setTitleColor:commonBlackBtnColor forState:UIControlStateSelected];
        rightbutton.tag = 1999;
        self.selectBtn =leftbutton;
        
        [_heardCell.contentView addSubview:rightbutton];
        
        JWLabel * leftLine = [[JWLabel alloc]initWithFrame:CGRectMake((leftbutton.width-leftbutton.width/1.5)/2, CGRectGetMaxY(leftbutton.frame), leftbutton.width/1.5, 1)];
        leftLine.backgroundColor = commonBlackBtnColor;
        [_heardCell.contentView addSubview:leftLine];
        CGRect leftFrame = leftLine.frame;
        
        JWLabel * rightLine = [[JWLabel alloc]initWithFrame:CGRectMake((rightbutton.width-rightbutton.width/1.5)/2 + CGRectGetMaxX(leftbutton.frame), CGRectGetMaxY(rightbutton.frame), rightbutton.width/1.5, 1)];
        rightLine.backgroundColor = commonBlackBtnColor;
        rightLine.hidden = true;
        [_heardCell.contentView addSubview:rightLine];
        CGRect  rightFrame = rightLine.frame;
        
        HXWeak_(rightbutton)
        HXWeak_(leftbutton)
        [rightbutton addSingleTapEvent:^{
            HXStrong_(rightbutton)
            HXStrong_(leftbutton)
            rightbutton.selected = true;
            leftbutton.selected = false;
            self.selectBtn = rightbutton;
            [self reloadTableViewData];
            
            [UIView animateWithDuration:0.3 animations:^{
                leftLine.frame = rightFrame;
            } completion:nil];
            
        }];
        
        [leftbutton addSingleTapEvent:^{
            HXStrong_(rightbutton)
            HXStrong_(leftbutton)
            rightbutton.selected = false;
            leftbutton.selected = true;
            self.selectBtn = leftbutton;
            [self reloadTableViewData];
            
            [UIView animateWithDuration:0.3 animations:^{
                leftLine.frame = leftFrame;
            } completion:nil];
            
        }];

        _heardCell.contentView.height = CGRectGetMaxY(rightLine.frame);
        [_heardCell setUPSpacing:0 andDownSpacing:0];
    }
    return _heardCell;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    TransactionsCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    if (!cell) {
        cell = [[TransactionsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    cell.model = self.modelList[indexPath.row];

    
    if ([self isVersion9]) {
        if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
            //给cell注册3DTouch的peek（预览）和pop功能
            [self registerForPreviewingWithDelegate:self sourceView:cell];
        } else {
            
        }
    }
    return cell;
}




//peek(预览)
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    //获取按压的cell所在行，[previewingContext sourceView]就是按压的那个视图
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell* )[previewingContext sourceView]];
    //调整不被虚化的范围，按压的那个cell不被虚化（轻轻按压时周边会被虚化，再少用力展示预览，再加力跳页至设定界面）
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width,adaptY(50));
    previewingContext.sourceRect = rect;
    ReceiptViewController * receiptVC = [ReceiptViewController new];
    receiptVC.hidesBottomBarWhenPushed = true;
    receiptVC.recordModel = self.modelList[indexPath.row];
    return receiptVC;
    
}

//pop（按用点力进入）
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [tableView deselectRowAtIndexPath:indexPath animated:true];
    ReceiptViewController * receiptVC = [ReceiptViewController new];
    receiptVC.hidesBottomBarWhenPushed = true;
    receiptVC.recordModel = self.modelList[indexPath.row];
    [self.navigationController pushViewController:receiptVC animated:true];
    
}



#pragma mark - 设置section的个数
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
#pragma mark - 设置cell的个数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelList.count;
}
#pragma mark - 设置cell的高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPat
{
    return adaptY(50);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 0.1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

#pragma mark - 空数据页面
- (void)createEmptyView{
    self.emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.tableView.height)];
    self.emptyView.backgroundColor = [UIColor whiteColor];
    [self.tableView addSubview:self.emptyView];
    
    UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 20, kScreenWidth-60, adaptY(60))];
    emptyLabel.font = kMediumFont(12);
    emptyLabel.textColor = commonEmptyTextColoer;
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.numberOfLines = 0;
    
    UIImageView * lineImage = [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth-adaptX(50)/2)/2+adaptX(20), CGRectGetMaxY(emptyLabel.frame), adaptX(50),adaptY(240))];
    lineImage.image = [UIImage imageNamed:@"lineImage-1"];
    
    if (self.selectBtn.tag ==1888 ) {
        
        emptyLabel.text = Internationalization(@"你还没有支付任何款项。开始使用PICA这样你就可以开始赚取的回报!", @"You have not made any payments yet. Start using PICA so you can start earning rewards!");
        
        [lineImage removeFromSuperview];
        
    }else if (self.selectBtn.tag ==1999){
        emptyLabel.text = Internationalization(@"到现金/外页，看看你可以存放在哪里！", @"Go to the Cash In/Out page to see where you can deposit!");

        [self.emptyView addSubview:lineImage];
        
    }
    
    [self.emptyView addSubview:emptyLabel];
}

//支付、收款列表
-(void)requestPaymentList{
    
    HXWeak_self
    [self showHud];
    [CommonService requestPaymentListOfaccess_token:self.defaultSetting.access_token pageNum:1 pageSize:self.numSize success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self.emptyView removeFromSuperview];
        HXStrong_self
        if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
            [self.modelList removeAllObjects];
            for (NSDictionary *dict in responseObject[@"data"]) {
                TradingRecordModel *model = [TradingRecordModel yy_modelWithDictionary:dict];
                [self.modelList addObject:model];
            }
            [self.tableView reloadData];
            [self.tableView.header endRefreshing];
            [self.tableView.footer endRefreshing];
            
        }else{
            [self showTip:[responseObject objectForKey:@"errorMessage"]];
            [self.tableView.header endRefreshing];
            [self.tableView.footer endRefreshing];
        }
        
        if (self.modelList.count==0) {
            [self createEmptyView];
        }else{
            [self.emptyView removeFromSuperview];
        }
        [self closeHud];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HXStrong_self
        [self closeHud];
        [self errorDispose:[[operation response] statusCode] judgeMent:nil];
    }];
    
}
//充值、提现列表
-(void)requestdepositsList{
    
    HXWeak_self
    [self showHud];
    
    [CommonService requestdepositsListOfaccess_token:self.defaultSetting.access_token pageNum:1 pageSize:self.numSize success:^(AFHTTPRequestOperation *operation, id responseObject) {
        HXStrong_self
        [self.emptyView removeFromSuperview];
        if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
            
            [self.modelList removeAllObjects];
            for (NSDictionary *dict in responseObject[@"data"]) {
                TradingRecordModel *model = [TradingRecordModel yy_modelWithDictionary:dict];
                [self.modelList addObject:model];
            }
            [self.tableView reloadData];
            [self.tableView.header endRefreshing];
            [self.tableView.footer endRefreshing];
        }else{
            [self showTip:[responseObject objectForKey:@"errorMessage"]];
            [self.tableView.header endRefreshing];
            [self.tableView.footer endRefreshing];
        }
        
        if (self.modelList.count==0) {
            [self createEmptyView];
        }else{
            [self.emptyView removeFromSuperview];
        }
        [self closeHud];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        HXStrong_self
        [self closeHud];
        [self errorDispose:[[operation response] statusCode] judgeMent:nil];
    }];
}

@end
