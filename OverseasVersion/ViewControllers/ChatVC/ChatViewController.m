//
//  ChatViewController.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/21.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "ChatViewController.h"
#import "MessageCell.h"
#import "HCInputBar.h"
#import "MessageImageCell.h"
#import "showImgView.h"

#import "MessageModel.h"

@interface ChatViewController ()<UITableViewDelegate,UITableViewDataSource,UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@property (strong, nonatomic) HCInputBar *inputBar;
@property (nonatomic,strong) UITableView *tableView;
@property (nonatomic,strong) NSMutableArray *MessageArr;
@property (nonatomic,strong) UIImagePickerController *picker;
@property (strong, nonatomic) UIView *emptyView;/**< 空视图 */
@end

@implementation ChatViewController

static NSString *identifier = @"Cell";
static NSString *identifierMessageImageCell = @"MessageImageCell";

-(NSMutableArray *)MessageArr {
    if (!_MessageArr) {
        _MessageArr = [NSMutableArray arrayWithCapacity:10];
    }
    return _MessageArr;
}

- (HCInputBar *)inputBar {
    if (!_inputBar) {
        
        _inputBar = [[HCInputBar alloc]initWithStyle:CustomInputBarStyle];
        
        _inputBar.keyboard.showAddBtn = NO;
        
        _inputBar.placeHolder = @"";
        
    }
    return _inputBar;
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.picker = [[UIImagePickerController alloc]init];
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.picker.delegate = self;
    
//    __block typeof(self) weakSelf = self;
//    [self createImageBarButtonItemStyle:BtnRightType Image:@"图片" TapEvent:^{
//        [weakSelf presentViewController:weakSelf.picker animated:YES completion:nil];
//    }];
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 50-64)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[MessageCell class] forCellReuseIdentifier:identifier];
    [self.tableView registerClass:[MessageImageCell class] forCellReuseIdentifier:identifierMessageImageCell];
    
    [self.view addSubview:self.inputBar];
    [self.inputBar showInputViewContents:^(NSString *contents) {
        [self sendMessage:contents];
    }];
    [self getmessageList];
}



#pragma mark - UITableViewDelegate,UITableViewDataSource
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.MessageArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MessageCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    MessageImageCell *imageCell = [tableView dequeueReusableCellWithIdentifier:identifierMessageImageCell];
    Message *msg = self.MessageArr[indexPath.row];
    msg.leftheaderImageURL = self.leftImageURL;
    imageCell.message = msg;
    
    if (msg.image != nil || msg.imageStr.length > 0) {
        return imageCell;
    }
    
    cell.message = msg;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    Message *msg = self.MessageArr[indexPath.row];
    return msg.bounds.size.height;
    
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    Message *msg = self.MessageArr[indexPath.row];
    if (msg.image != nil) {
        CGRect rectInTableView = [tableView rectForRowAtIndexPath:indexPath];//获取cell在tableView中的位置
        CGRect rectInSuperview = [tableView convertRect:rectInTableView toView:[tableView superview]];
        
        CGRect rect = CGRectMake(msg.imageFrame.origin.x, rectInSuperview.origin.y + msg.imageFrame.origin.y, msg.imageFrame.size.width, msg.imageFrame.size.height);
        
        showImgView *show = [showImgView initWithImg:msg.image withFame:rect];
        [[UIApplication sharedApplication].keyWindow addSubview:show];
    }
}


-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    
    [self.view endEditing:YES];
    
}


-(void)openKeyboard:(NSNotification*)notification{
    
    CGRect frame = [notification.userInfo[UIKeyboardFrameEndUserInfoKey]CGRectValue];
    NSTimeInterval durition = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    UIViewAnimationOptions option = [notification.userInfo [UIKeyboardAnimationCurveUserInfoKey]intValue];
    [UIView animateWithDuration:durition delay:0 options:option animations:^{
        
        self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 50 - frame.size.height);
        if (self.MessageArr.count) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.MessageArr.count - 1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }
        
    } completion:nil];
}

-(void)closeKeyboard:(NSNotification*)notification{
    
    NSTimeInterval durition = [notification.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    UIViewAnimationOptions option = [notification.userInfo [UIKeyboardAnimationCurveUserInfoKey]intValue];
    [UIView animateWithDuration:durition delay:0 options:option animations:^{
        self.tableView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height - 50);
    } completion:nil];
    
}


-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(openKeyboard:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(closeKeyboard:) name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillDisappear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
    
}

#pragma mark - UIImagePicker delegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    
    UIImage *image = info[@"UIImagePickerControllerOriginalImage"];
    
    if (image != nil) {
        [self performSelector:@selector(SendImage:)  withObject:image afterDelay:0.5];
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)SendImage:(UIImage *)image {
    HXWeak_self
    [self submitShareImage:image success:^(NSString *imageStr) {
        HXStrong_self
        [self showHud];
        
        [CommonService requestsendMessageaccess_token:self.defaultSetting.access_token
                                               shopId:self.shopModel.shopId
                                              content:imageStr
                                                isPic:1
                                              success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
                
                Message *msg = [Message messageWihtImage:image isRight:true];
                [self.MessageArr addObject:msg];
                [self addEmptyView];
                [self.tableView reloadData];
                
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.MessageArr.count - 1 inSection:0];
                [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
                
            }else{
                [self showTip:[responseObject objectForKey:@"errorMessage"]];
            }
            [self closeHud];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            [self closeHud];
            [self errorDispose:[[operation response] statusCode] judgeMent:nil];
        }];
        
    }];
    
}


#pragma mark - 空数据页面
- (void)createEmptyView{
    
    self.emptyView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.tableView.height)];
    self.emptyView.backgroundColor = [UIColor whiteColor];
    [self.tableView addSubview:self.emptyView];
    
    UILabel *emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 0, kScreenWidth-60, 100)];
    emptyLabel.font = kMediumFont(12);
    emptyLabel.textColor = commonGrayColor;
    emptyLabel.textAlignment = NSTextAlignmentCenter;
    emptyLabel.numberOfLines = 0;
    emptyLabel.text = Internationalization(@"您需要帮助吗？给我们一个信息，我们会尽快回复！：）", @"Do you need help? Send us a message, and we will reply as soon as we can! :)");
    [self.emptyView addSubview:emptyLabel];
    
}


-(void)addEmptyView{
    
    if (!self.MessageArr.count) {
        [self createEmptyView];
    }else{
        [self.emptyView removeFromSuperview];
    }
    
}


-(void)getmessageList{
    
    [self showHud];
    
    
    [CommonService requestMessageListaccess_token:self.defaultSetting.access_token
                                           shopId:self.shopModel.shopId
                                          pageNum:0
                                         pageSize:10000
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
      if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
          
          [self.MessageArr removeAllObjects];
          
          for (NSDictionary *dict in responseObject[@"data"][@"content"]) {
              MessageModel *model = [MessageModel yy_modelWithDictionary:dict];
              
              if (model.isPic) {
                  if (model.type==1) {
                      Message *msg = [Message messageWihtImageStr:model.content isRight:true];
                      [self.MessageArr addObject:msg];
                  }else if (model.type==2){
                      Message *msg = [Message messageWihtImageStr:model.content isRight:false];
                      [self.MessageArr addObject:msg];
                  }
              }else{
                  if (model.type==1) {
                      Message *msg = [Message messageWihtContent:model.content isRight:true];
                      [self.MessageArr addObject:msg];
                  }else if (model.type==2){
                      Message *msg = [Message messageWihtContent:model.content isRight:false];
                      [self.MessageArr addObject:msg];
                  }
              }
          }
          
          [self addEmptyView];
          [self.tableView reloadData];
          
          if (self.MessageArr.count) {
              NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.MessageArr.count - 1 inSection:0];
              [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:false];
          }
          
      }else{
          [self showTip:[responseObject objectForKey:@"errorMessage"]];
      }
      [self closeHud];

                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      [self closeHud];
      [self errorDispose:[[operation response] statusCode] judgeMent:nil];
                                          }];
    
}

-(void)sendMessage:(NSString *)message{
    
    [self showHud];
    
    [CommonService requestsendMessageaccess_token:self.defaultSetting.access_token
                                           shopId:self.shopModel.shopId
                                          content:message
                                            isPic:0
                                          success:^(AFHTTPRequestOperation *operation, id responseObject) {
      if ([[responseObject objectForKey:@"errorCode"] integerValue] == 0) {
          
          Message *msg = [Message messageWihtContent:message isRight:true];
          [self.MessageArr addObject:msg];
          [self addEmptyView];
          [self.tableView reloadData];
          
          NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.MessageArr.count - 1 inSection:0];
          [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
      }else{
          [self showTip:[responseObject objectForKey:@"errorMessage"]];
      }
      [self closeHud];
                                          } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
      [self closeHud];
      [self errorDispose:[[operation response] statusCode] judgeMent:nil];
                                          }];

}

@end
