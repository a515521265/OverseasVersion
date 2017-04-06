//
//  FriendsViewController.m
//  OverseasVersion
//
//  Created by 梁家文 on 17/2/6.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "FriendsViewController.h"

#import "FriendModel.h"
#import "FriendsTableViewCell.h"
#import "ContactDataHelper.h"//根据拼音A~Z~#进行排序的tool
//聊天
#import "ChatViewController.h"

#import "OppositePayViewController.h"


#import "FriendDetailViewController.h"

@interface FriendsViewController ()
<UITableViewDelegate,UITableViewDataSource,
UISearchBarDelegate,UISearchDisplayDelegate,UIViewControllerPreviewingDelegate>
{
    NSArray *_rowArr;//row arr
    NSArray *_sectionArr;//section arr
}

@property (nonatomic,strong) UITableView *tableView;
//@property (nonatomic,strong) NSArray *serverDataArr;//数据源
@property (nonatomic,strong) NSMutableArray *dataArr;
@property (nonatomic,strong) UISearchBar *mySearchBar;
@property (nonatomic,strong) NSMutableArray *searchResultArr;
@property (nonatomic,strong) UISearchDisplayController *searchDisplayController;


@property (nonatomic,strong) UIView * emptyView;/**< 空视图 */

@end


@implementation FriendsViewController

#pragma mark - 空数据页面
- (void)createEmptyView{
    
    self.emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.tableView.height)];
    self.emptyView.backgroundColor = [UIColor whiteColor];
    [self.tableView addSubview:self.emptyView];
    UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, (self.tableView.height-adaptY(20))/2 , kScreenWidth-60, adaptY(20))];
    emptyLabel.font = kMediumFont(15);
    emptyLabel.textColor = commonEmptyTextColoer;
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.numberOfLines = 0;
    emptyLabel.text = Internationalization(@"暂无好友列表", @"No friends list");
    [self.emptyView addSubview:emptyLabel];
    
}

-(NSMutableArray *)searchResultArr{
    
    if (!_searchResultArr) {
        _searchResultArr = [NSMutableArray arrayWithCapacity:10];
    }
    return _searchResultArr;
}

-(NSMutableArray *)dataArr{
    
    if (!_dataArr) {
        _dataArr = [NSMutableArray arrayWithCapacity:10];
    }
    return _dataArr;
    
}

-(UISearchBar *)mySearchBar{
    
    if (!_mySearchBar) {
        _mySearchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 64, 320, 40)];
        _mySearchBar.delegate = self;
        [_mySearchBar setPlaceholder:Internationalization(@"搜索", @"Search")];
    }
    return _mySearchBar;
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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.view addSubview:self.tableView];
    
    [self getFriendsList];
    
}

- (UITableView *)tableView{
    if (!_tableView) {
        _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
        [_tableView setDelegate:self];
        [_tableView setDataSource:self];
        [_tableView setBackgroundColor:[UIColor whiteColor]];
        _tableView.tableHeaderView=self.mySearchBar;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //cell无数据时，不显示间隔线
        UIView *v = [[UIView alloc] initWithFrame:CGRectZero];
        [_tableView setTableFooterView:v];
    }
    return _tableView;
}

#pragma mark - UITableView delegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    //section
    if (tableView==_searchDisplayController.searchResultsTableView) {
        return 1;
    }else{
        return _rowArr.count;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    //row
    if (tableView==_searchDisplayController.searchResultsTableView) {
        return self.searchResultArr.count;
    }else{
        return [_rowArr[section] count];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return 60.0;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    UIView * headerview = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, 30)];
    headerview.backgroundColor = [UIColor whiteColor];
    JWLabel * tipLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, 0, kScreenWidth-40, 30)];
    tipLab.text = [NSString stringWithFormat:@"%@",_sectionArr[section+1]];
    tipLab.font = kMediumFont(14);
    tipLab.textColor = commonBlackFontColor;
    [headerview addSubview:tipLab];
    return headerview;
    
}
//侧边快捷检索
//- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView{
//    if (tableView!=_searchDisplayController.searchResultsTableView) {
//        return _sectionArr;
//    }else{
//        return nil;
//    }
//}
- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    return index-1;
}
- (CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (tableView==_searchDisplayController.searchResultsTableView) {
        return 0;
    }else{
        return 30;
    }
}

#pragma mark - UITableView dataSource
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIde=@"cellIde";
    FriendsTableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:cellIde];
    if (cell==nil) {
        cell=[[FriendsTableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIde];
    }
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    if (tableView==_searchDisplayController.searchResultsTableView){
        cell.cellModel = self.searchResultArr[indexPath.row];
    }else{
        cell.cellModel = _rowArr[indexPath.section][indexPath.row];
        //        if ([self isVersion9]) {
        //            if (self.traitCollection.forceTouchCapability == UIForceTouchCapabilityAvailable) {
        //                //给cell注册3DTouch的peek（预览）和pop功能
        //                [self registerForPreviewingWithDelegate:self sourceView:cell];
        //            } else {
        //
        //            }
        //        }
    }
    
    HXWeak_self
    cell.backCellModel = ^(FriendModel * friendModel){
        HXStrong_self
        OppositePayViewController * oppositePayVC = [OppositePayViewController new];
        oppositePayVC.friendModel = friendModel;
        [self.navigationController pushViewController:oppositePayVC animated:true];
        
    };
    return cell;
}


//peek(预览)
- (nullable UIViewController *)previewingContext:(id <UIViewControllerPreviewing>)previewingContext viewControllerForLocation:(CGPoint)location
{
    if (self.tableView != _searchDisplayController.searchResultsTableView) {
        //获取按压的cell所在行，[previewingContext sourceView]就是按压的那个视图
        NSIndexPath *indexPath = [self.tableView indexPathForCell:(UITableViewCell* )[previewingContext sourceView]];
        //调整不被虚化的范围，按压的那个cell不被虚化（轻轻按压时周边会被虚化，再少用力展示预览，再加力跳页至设定界面）
        CGRect rect = CGRectMake(0, 0, self.view.frame.size.width,59);
        previewingContext.sourceRect = rect;
        FriendDetailViewController * friendDetailVC = [FriendDetailViewController new];
        friendDetailVC.model = _rowArr[indexPath.section][indexPath.row];
        return friendDetailVC;
    }else{
        return nil;
    }
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    FriendModel *model=_rowArr[indexPath.section][indexPath.row];
    NSLog(@"%@",model.firstName);
    //    ChatViewController * chatVC = [ChatViewController new];
    //    chatVC.hidesBottomBarWhenPushed = true;
    //    [self.navigationController pushViewController:chatVC animated:true];
    
}


#pragma UISearchDisplayDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterContentForSearchText:self.mySearchBar.text
                               scope:searchText];
}

#pragma mark - 源字符串内容是否包含或等于要搜索的字符串内容
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    NSMutableArray *tempResults = [NSMutableArray array];
    NSUInteger searchOptions = NSCaseInsensitiveSearch | NSDiacriticInsensitiveSearch;
    for (int i = 0; i < self.dataArr.count; i++) {
        NSString *storeString = [(FriendModel *)self.dataArr[i] firstName];
        NSRange storeRange = NSMakeRange(0, storeString.length);
        NSRange foundRange = [storeString rangeOfString:searchText options:searchOptions range:storeRange];
        if (foundRange.length) {
            FriendModel * model = self.dataArr[i];
            [tempResults addObject:model];
        }
    }
    [self.searchResultArr removeAllObjects];
    [self.searchResultArr addObjectsFromArray:tempResults];
}

-(void)getFriendsList{
    
    customHUD * hud = [[customHUD alloc]init];
    [hud showCustomHUDWithView:self.view];
    [CommonService requestGetUserContactsOfaccess_token:self.defaultSetting.access_token success:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        [self.emptyView removeFromSuperview];
        
        if ([[responseObject objectForKey:@"errorCode"] integerValue] ==0) {
            
            [self.dataArr removeAllObjects];
            
            NSArray *dataArr = [NSArray arrayWithArray:[responseObject objectForKey:@"data"]];
            if (dataArr.count > 0) {
                for (NSDictionary *dic in dataArr) {
                    FriendModel *model=[FriendModel yy_modelWithDictionary:dic];
                    [self.dataArr addObject:model];
                }
            }
            _rowArr=[ContactDataHelper getFriendListDataBy:self.dataArr];
            _sectionArr=[ContactDataHelper getFriendListSectionBy:[_rowArr mutableCopy]];
            
            if (self.dataArr.count==0) {
                [self createEmptyView];
            }else{
                [self.emptyView removeFromSuperview];
            }
            
            [self.tableView reloadData];
            
            
        }else{
            [self showTip:[responseObject objectForKey:@"errorMessage"]];
        }
        [hud hideCustomHUD];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [hud hideCustomHUD];
        [self errorDispose:[[operation response] statusCode] judgeMent:nil];
        
        [self getFriendsList];
    }];
}



@end
