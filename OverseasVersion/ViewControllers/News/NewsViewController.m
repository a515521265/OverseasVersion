//
//  NewsViewController.m
//  OverseasVersion
//
//  Created by 梁家文 on 17/2/19.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "NewsViewController.h"
#import "NewsTableViewCell.h"

#import "NewsHeadTableViewCell.h"

#import "ShopNewsViewController.h"

#import "NewsModel.h"

#import "ChineseInclude.h"

#import "PinYinForObjc.h"

@interface NewsViewController ()<UISearchBarDelegate,UITableViewDelegate,UITableViewDataSource>
@property (nonatomic,strong) UITableView * tableView;
@property (nonatomic,strong) UISearchBar *mySearchBar;
@property (nonatomic,strong) UISearchDisplayController *searchDisplayController;

@property (nonatomic,strong) NSMutableArray <NewsModel *>* newsList;
@property (nonatomic,strong) NSMutableArray <NewsModel *>* searchResults;

@end

@implementation NewsViewController

-(NSMutableArray<NewsModel *> *)searchResults{

    if (!_searchResults) {
        _searchResults = [NSMutableArray arrayWithCapacity:10];
    }
    return _searchResults;

}

-(NSMutableArray<NewsModel *> *)newsList{
    if (!_newsList) {
        _newsList = [NSMutableArray arrayWithCapacity:10];
    }
    return _newsList;
}

-(UISearchBar *)mySearchBar{
    
    if (!_mySearchBar) {
        _mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, 320, 40)];
        _mySearchBar.delegate = self;
        [_mySearchBar setPlaceholder:@"Search by name or #hashtag"];
    }
    return _mySearchBar;
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
    [self getNewsList];
    
}

-(UISearchDisplayController *)searchDisplayController{
    
    if (!_searchDisplayController) {
        _searchDisplayController = [[UISearchDisplayController alloc]initWithSearchBar:self.mySearchBar contentsController:self];
        _searchDisplayController.active = NO;
        _searchDisplayController.searchResultsDataSource = self;
        _searchDisplayController.searchResultsDelegate = self;
    }
    return _searchDisplayController;
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
        _tableView.tableHeaderView = self.mySearchBar;
    }
    return _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.bottom.mas_equalTo(0);
    }];
    
    [self facebooksupplementaryInfo];
}

#pragma UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.searchResults.count;
    }else{
        if (section == 0) {
            return 1;
        }
        return self.newsList.count;
    }
    

}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return adaptY(50);
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 0.1;
    }
    return 0;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.0;
}

//允许编辑
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section==0 && indexPath.row==0) {
        return NO;
    }
    return NO;
}

// 进入编辑模式，进行删除操作
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{

}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewRowAction *unfollowRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"Unfollow" handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"-----");
        [self.tableView reloadData];
    }];
    return @[unfollowRowAction];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return 1;
    }
    else {
        return 2;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
    
        static NSString *CellIdentifier = @"Cell3";
        NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        }
        cell.cellModel = self.searchResults[indexPath.row];
        return cell;
        
    }else{
    
        if (indexPath.section ==0) {
            static NSString *CellIdentifier = @"Cell1";
            NewsHeadTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[NewsHeadTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            return cell;
        }else{
            static NSString *CellIdentifier = @"Cell2";
            NewsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
            if (cell == nil) {
                cell = [[NewsTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            }
            cell.cellModel = self.newsList[indexPath.row];
            return cell;
        }
    
    }
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    HXWeak_self
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        [self requestNewsListByshopModel:self.searchResults[indexPath.row] success:^{
            HXStrong_self
            [self.searchDisplayController setActive:NO animated:YES];
        }];
    }else{
        if (indexPath.section) {
            [self requestNewsListByshopModel:self.newsList[indexPath.row] success:^{}];
        }
    }
}

#pragma UISearchDisplayDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    
    [self.searchResults removeAllObjects];
    
    if (self.mySearchBar.text.length>0&&![ChineseInclude isIncludeChineseInString:self.mySearchBar.text]) {
        for (int i=0; i<self.newsList.count; i++) {
            if ([ChineseInclude isIncludeChineseInString:self.newsList[i].shopName]) {
                NSString *tempPinYinStr = [PinYinForObjc chineseConvertToPinYin:self.newsList[i].shopName];
                NSRange titleResult=[tempPinYinStr rangeOfString:self.mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [self.searchResults addObject:self.newsList[i]];
                }
                NSString *tempPinYinHeadStr = [PinYinForObjc chineseConvertToPinYinHead:self.newsList[i].shopName];
                NSRange titleHeadResult=[tempPinYinHeadStr rangeOfString:self.mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleHeadResult.length>0) {
                    [self.searchResults addObject:self.newsList[i]];
                }
            }
            else {
                NSRange titleResult=[self.newsList[i].shopName rangeOfString:self.mySearchBar.text options:NSCaseInsensitiveSearch];
                if (titleResult.length>0) {
                    [self.searchResults addObject:self.newsList[i]];
                }
            }
        }
        //过滤重复数据
        NSArray *newDataArray = self.searchResults;
        NSMutableArray *listAry = [[NSMutableArray alloc]init];
        for (NSString *str in newDataArray) {
            if (![listAry containsObject:str]) {
                [listAry addObject:str];
            }
        }
        [self.searchResults removeAllObjects];
        self.searchResults  = listAry;
        
    } else if (self.mySearchBar.text.length>0&&[ChineseInclude isIncludeChineseInString:self.mySearchBar.text]) {
        for (NewsModel * model in self.newsList) {
            NSRange titleResult=[model.shopName rangeOfString:self.mySearchBar.text options:NSCaseInsensitiveSearch];
            if (titleResult.length>0) {
                [self.searchResults addObject:model];
            }
        }
        NSArray *newDataArray = self.searchResults;
        NSMutableArray *listAry = [[NSMutableArray alloc]init];
        for (NSString *str in newDataArray) {
            if (![listAry containsObject:str]) {
                [listAry addObject:str];
            }
        }
        [self.searchResults removeAllObjects];
        self.searchResults  = listAry;
    }

}


-(void)getNewsList{

    customHUD * hud = [[customHUD alloc]init];
    [hud showCustomHUDWithView:self.view];
    [CommonService requestGetNewsListOfaccess_token:self.defaultSetting.access_token success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
            
            [self.newsList removeAllObjects];
            
            for (NSDictionary *dict in responseObject[@"data"]) {
                NewsModel *model = [NewsModel yy_modelWithDictionary:dict];
                [self.newsList addObject:model];
            }
            [self.tableView reloadData];
            
        } else {
            [self showTip:[responseObject objectForKey:@"errorMessage"]];
        }
        [hud hideCustomHUD];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hideCustomHUD];
        [self errorDispose:[[operation response] statusCode] judgeMent:nil];
    }];
    
}

-(void)requestNewsListByshopModel:(NewsModel *)shopModel success:(void (^)())success{

    customHUD * hud = [[customHUD alloc]init];
    [hud showCustomHUDWithView:self.view];
    [CommonService requestgetNewsListByShopIdOfaccess_token:self.defaultSetting.access_token shopId:shopModel.shopId success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
            ShopNewsViewController * shopNewVC = [ShopNewsViewController new];
            shopNewVC.hidesBottomBarWhenPushed = true;
            shopNewVC.transmitObject =responseObject;
            shopNewVC.shopModel = shopModel;
            [self.navigationController pushViewController:shopNewVC animated:true];
            success();
        } else {
            [self showTip:[responseObject objectForKey:@"errorMessage"]];
        }
        [hud hideCustomHUD];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hideCustomHUD];
        [self errorDispose:[[operation response] statusCode] judgeMent:nil];
    }];
    
}


@end
