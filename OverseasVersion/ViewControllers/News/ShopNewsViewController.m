//
//  ShopNewsViewController.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/23.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "ShopNewsViewController.h"

#import "ShopNewsTableViewCell.h"
#import "ShopNewsHeadTableViewCell.h"
#import "NewsDetailsViewController.h"
#import "NewsModel.h"
#import "ChatViewController.h"

#import "ShowAlertViewController.h"

@interface ShopNewsViewController ()<UITableViewDelegate,UITableViewDataSource,UIViewControllerPreviewingDelegate>

@property (nonatomic,strong) UITableView * tableView;

@property (nonatomic,strong) NSMutableArray <NewsModel *>* newsList;

@property (nonatomic,strong) NSString * shopIcon;
@end

@implementation ShopNewsViewController

-(NSMutableArray<NewsModel *> *)newsList{
    if (!_newsList) {
        _newsList = [NSMutableArray arrayWithCapacity:10];
    }
    return _newsList;
}

-(UITableView *)tableView{
    
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
        _tableView.showsVerticalScrollIndicator = FALSE;
        _tableView.showsHorizontalScrollIndicator = FALSE;
        _tableView.delegate=self;
        _tableView.dataSource=self;
        _tableView.delaysContentTouches = false;
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    }
    return _tableView;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view addSubview:self.tableView];
    for (NSDictionary *dict in self.transmitObject[@"data"]) {
        NewsModel *model = [NewsModel yy_modelWithDictionary:dict];
        [self.newsList addObject:model];
    }
    self.shopIcon = self.transmitObject[@"extra"];
    [self.tableView reloadData];
    
    HXWeak_self
    [self createImageBarButtonItemStyle:BtnRightType Image:@"PICA_Message_Icon" TapEvent:^{
        HXStrong_self
        ChatViewController * chatVC = [ChatViewController new];
        chatVC.shopModel = self.shopModel;
        chatVC.leftImageURL = self.shopIcon;
        chatVC.hidesBottomBarWhenPushed = true;
        [self.navigationController pushViewController:chatVC animated:true];
        
    }];
    
}

#pragma UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }
    return self.newsList.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0) {
        return adaptY(70);
    }
    return adaptY(50);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{

    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section ==0) {
        static NSString *CellIdentifier = @"Cell1";
        ShopNewsHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[ShopNewsHeadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.iconImage = self.shopIcon;
        cell.tapImageView = ^(UIImageView * headImage){
            
            ShowAlertViewController * aletrVC = [[ShowAlertViewController alloc] init];
            aletrVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            aletrVC.modalPresentationStyle = UIModalPresentationCustom;
            aletrVC.showImageView = headImage;
            [self presentViewController:aletrVC animated:YES completion:nil];
            
        };
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        return cell;
    }else{
        static NSString *CellIdentifier = @"Cell2";
        ShopNewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[ShopNewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.cellModel = self.newsList[indexPath.row];
        if ([self isVersion9]) {
            if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
                //给cell注册3DTouch的peek（预览）和pop功能
                [self registerForPreviewingWithDelegate:self sourceView:cell];
            } else {
                
            }
        }
        return cell;
    }
}


//peek(预览)
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    //获取按压的cell所在行，[previewingContext sourceView]就是按压的那个视图
    NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell* )[previewingContext sourceView]];
    //调整不被虚化的范围，按压的那个cell不被虚化（轻轻按压时周边会被虚化，再少用力展示预览，再加力跳页至设定界面）
    CGRect rect = CGRectMake(0, 0, self.view.frame.size.width,adaptY(50));
    previewingContext.sourceRect = rect;
    if (indexPath.section) {
        NewsDetailsViewController * newsDetail = [NewsDetailsViewController new];
        newsDetail.loadURL = self.newsList[indexPath.row].newsUrl;
        return newsDetail;
    }else{
        return nil;
    }
    
}

//pop（按用点力进入）
- (void)previewingContext:(id <UIViewControllerPreviewing>)previewingContext commitViewController:(UIViewController *)viewControllerToCommit {
    [self showViewController:viewControllerToCommit sender:self];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    if (indexPath.section) {
        NewsDetailsViewController * newsDetail = [NewsDetailsViewController new];
        newsDetail.loadURL = self.newsList[indexPath.row].newsUrl;
        [self.navigationController pushViewController:newsDetail animated:true];
    }

}


@end
