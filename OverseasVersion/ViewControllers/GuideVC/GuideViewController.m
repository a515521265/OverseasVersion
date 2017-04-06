//
//  GuideViewController.m
//  OverseasVersion
//
//  Created by 恒善信诚科技有限公司 on 17/2/27.
//  Copyright © 2017年 梁家文. All rights reserved.
//

#import "GuideViewController.h"
#import "ShadowView.h"
#import "LoginViewController.h"
@interface GuideViewController ()<UIScrollViewDelegate,UIGestureRecognizerDelegate>
@property (strong, nonatomic) UIPageControl *page;
@property (strong, nonatomic) UIScrollView *scrollView;

@property (nonatomic,strong) JWScrollviewCell * guideCell1;

@property (nonatomic,strong) JWScrollviewCell * guideCell2;

@property (nonatomic,strong) JWScrollviewCell * guideCell3;

@property (nonatomic,strong) JWScrollviewCell * guideCell4;

@property (nonatomic,strong) NSMutableArray <JWScrollviewCell *>* viewList;

@end

@implementation GuideViewController


-(NSMutableArray<JWScrollviewCell *> *)viewList{
    if (!_viewList) {
        _viewList = [NSMutableArray arrayWithCapacity:10];
    }
    return _viewList;
}

-(JWScrollviewCell *)guideCell1{

    if (!_guideCell1) {
        _guideCell1 = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
//        _guideCell1.contentView.backgroundColor = [UIColor redColor];
        
        JWLabel * welcomeLab = [[JWLabel alloc]initWithFrame:CGRectMake(0,adaptY(50), kScreenWidth, adaptY(40))];
        welcomeLab.font = kMediumFont(15);
        welcomeLab.text = @"Welcome to";
        welcomeLab.textColor = commonBlackBtnColor;
        welcomeLab.textAlignment =1;
        [_guideCell1.contentView addSubview:welcomeLab];
        
        
        JWLabel * picaLabel = [[JWLabel alloc]init];
        picaLabel.font = kLightFont(60);
        picaLabel.isShadow = true;
        picaLabel.colors = commonColorS;
        picaLabel.text = @"PICA";
        picaLabel.tag = 2001;
        picaLabel.textAlignment =1;
        [picaLabel sizeToFit];
        picaLabel.center = CGPointMake(_guideCell1.bounds.size.width * 0.5, CGRectGetMaxY(welcomeLab.frame)+adaptY(40));
        [_guideCell1.contentView addSubview:picaLabel];
        

        JWLabel * tiplab1 = [[JWLabel alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(picaLabel.frame)+50, kScreenWidth, adaptY(40))];
        tiplab1.font = kLightFont(15);
        tiplab1.text = @"Swipe right for more info";
        tiplab1.textColor = commonBlackBtnColor;
        tiplab1.textAlignment =1;
        [_guideCell1.contentView addSubview:tiplab1];
        
        HXWeak_self
        ShadowView * startedBtn = [[ShadowView alloc] initWithFrame:
                                  CGRectMake(20,CGRectGetMaxY(tiplab1.frame)+50,kScreenWidth-40,ShadowViewHeight)];
        startedBtn.colors =commonColorS;
        [startedBtn addSingleTapEvent:^{
            HXStrong_self
            [self getStarted];
        }];
        [_guideCell1.contentView addSubview:startedBtn];
        
        JWLabel * startedLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, startedBtn.y, startedBtn.width, startedBtn.height)];
        startedLab.text = Internationalization(@"开始", @"Get Started");
        startedLab.textAlignment = 1;
        startedLab.textColor = [UIColor whiteColor];
        startedLab.font = kMediumFont(15);
        [_guideCell1.contentView addSubview:startedLab];
        
        JWLabel *tiplab2 = [[JWLabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(startedBtn.frame)+5, kScreenWidth-40,adaptY(30))];
        tiplab2.font = kMediumFont(9);
        tiplab2.textColor = commonGrayColor;
        tiplab2.textAlignment = NSTextAlignmentCenter;
        tiplab2.numberOfLines = 0;
        tiplab2.text = Internationalization(@"点击上面的按钮开始注册", @"Click the button above to get started with the registration");
        tiplab2.tag = 1999;
        [_guideCell1.contentView addSubview:tiplab2];
        
        
        [_guideCell1 setUPSpacing:0 andDownSpacing:0];
    }
    return _guideCell1;
}

-(JWScrollviewCell *)guideCell2{
    
    if (!_guideCell2) {
        _guideCell2 = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(kScreenWidth, 0, kScreenWidth, kScreenHeight)];
        
//        _guideCell2.contentView.backgroundColor = [UIColor greenColor];
        
        JWLabel * titleLab1 = [[JWLabel alloc]initWithFrame:CGRectMake(20, 20, kScreenWidth-60, adaptY(30))];
        titleLab1.text = @"What is PICA?";
        titleLab1.font = kMediumFont(25);
        titleLab1.isShadow = true;
        titleLab1.colors = commonColorS;
        [_guideCell2.contentView addSubview:titleLab1];
        
        JWLabel * titleLab2 = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLab1.frame)+20, kScreenWidth-40, 25)];
        titleLab2.text = @"PICA, is the best mobile payment solution in the Philippines. We allow users to make payments by scanning a QR code; receive money through the app; pay bills and buy prepaid load; and many more to come!";
        titleLab2.font = kLightFont(12);
        titleLab2.numberOfLines = 0;
        titleLab2.textColor = commonBlackBtnColor;
        titleLab2.height = [titleLab2 getLabelSize:titleLab2].height+10;
        [_guideCell2.contentView addSubview:titleLab2];

        
        UIImageView * imageView= [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth -adaptX(180))/2, CGRectGetMaxY(titleLab2.frame)+20,adaptX(180), adaptX(300))];
        imageView.image = [UIImage imageNamed:@"guide-7"];
        [_guideCell2.contentView addSubview:imageView];
        
        
        [_guideCell2 setUPSpacing:0 andDownSpacing:0];
    }
    return _guideCell2;
}


-(JWScrollviewCell *)guideCell3{
    
    if (!_guideCell3) {
        _guideCell3 = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(kScreenWidth*2, 0, kScreenWidth, kScreenHeight)];
        
        JWLabel * titleLab1 = [[JWLabel alloc]initWithFrame:CGRectMake(20, 20, kScreenWidth-60, adaptY(30))];
        titleLab1.text = @"Benefits of PICA";
        titleLab1.font = kMediumFont(25);
        titleLab1.isShadow = true;
        titleLab1.colors = commonColorS;
        [_guideCell3.contentView addSubview:titleLab1];
        
        UIView * vi = [self addChildView:nil title:nil];
        
        CGFloat jwx = (kScreenWidth - 2 * vi.width)/2;
        
        NSArray * imageArr = @[@"guide-5",@"guide-1",@"guide-2",@"guide-3",@"guide-6",@"guide-4"];
        
        NSArray * titleArr = @[@"Earn rewards",@"Send money to your friends for FREE",@"Monitor your expenses",@"Live a cash-less life",@"QR payments",@"PIN triggered payments"];
        
        for (int i =0; i<imageArr.count; i++) {
            
            UIView * v = [self addChildView:imageArr[i] title:titleArr[i]];
            NSInteger a = i / 2;
            NSInteger b = i % 2;
            v.x = jwx+ (b * (v.width +1));
            v.y =(CGRectGetMaxY(titleLab1.frame)+adaptY(30)) + (a * (v.height +1));
            
            [_guideCell3.contentView addSubview:v];
        }
        
//        UIImageView * imageView= [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth -adaptX(277.2))/2, CGRectGetMaxY(titleLab1.frame)+20,adaptX(277.2), adaptX(334.8))];
//        imageView.image = [UIImage imageNamed:@"guide-9"];
//        [_guideCell3.contentView addSubview:imageView];
        
        [_guideCell3 setUPSpacing:0 andDownSpacing:0];
    }
    return _guideCell3;
}

-(JWScrollviewCell *)guideCell4{
    
    if (!_guideCell4) {
        _guideCell4 = [[JWScrollviewCell alloc]initWithFrame:CGRectMake(kScreenWidth*3, 0, kScreenWidth, kScreenHeight)];
//        _guideCell4.contentView.backgroundColor = [UIColor yellowColor];
        
        
        JWLabel * titleLab1 = [[JWLabel alloc]initWithFrame:CGRectMake(20, 20, kScreenWidth-60, adaptY(30))];
        titleLab1.text = @"Get Started";
        titleLab1.font = kMediumFont(25);
        titleLab1.isShadow = true;
        titleLab1.colors = commonColorS;
        [_guideCell4.contentView addSubview:titleLab1];
        
        JWLabel * titleLab2 = [[JWLabel alloc]initWithFrame:CGRectMake(20, CGRectGetMaxY(titleLab1.frame)+10, kScreenWidth-40, 25)];
        titleLab2.text = @"Being a PICA user is extremely fun, from seamless payments to reward points to bills payment and so much more! Help us achieve our vision of turning Philippines into a cash-less society! Register now!";
        titleLab2.font = kLightFont(12);
        titleLab2.numberOfLines = 0;
        titleLab2.textColor = commonBlackBtnColor;
        titleLab2.height = [titleLab2 getLabelSize:titleLab2].height+10;
        [_guideCell4.contentView addSubview:titleLab2];
        
        
        UIImageView * imageView= [[UIImageView alloc]initWithFrame:CGRectMake((kScreenWidth -adaptX(127.5))/2, CGRectGetMaxY(titleLab2.frame)+ adaptY(10),adaptX(127.5), adaptX(180.5))];
        imageView.image = [UIImage imageNamed:@"guide-8"];
        [_guideCell4.contentView addSubview:imageView];
        
        
        ShadowView * startedBtn = [[ShadowView alloc] initWithFrame:
                                   CGRectMake(20,CGRectGetMaxY(imageView.frame)+50,kScreenWidth-40,ShadowViewHeight)];
        startedBtn.colors =commonColorS;
        HXWeak_self
        [startedBtn addSingleTapEvent:^{
            HXStrong_self
            [self getStarted];
        }];
        [_guideCell4.contentView addSubview:startedBtn];
        
        JWLabel * startedLab = [[JWLabel alloc]initWithFrame:CGRectMake(20, startedBtn.y, startedBtn.width, startedBtn.height)];
        startedLab.text = Internationalization(@"开始", @"Get Started");
        startedLab.textAlignment = 1;
        startedLab.textColor = [UIColor whiteColor];
        startedLab.font = kMediumFont(15);
        [_guideCell4.contentView addSubview:startedLab];
        
        JWLabel *tiplab2 = [[JWLabel alloc] initWithFrame:CGRectMake(20, CGRectGetMaxY(startedBtn.frame)+5, kScreenWidth-40,adaptY(30))];
        tiplab2.font = kMediumFont(9);
        tiplab2.textColor = commonGrayColor;
        tiplab2.textAlignment = NSTextAlignmentCenter;
        tiplab2.numberOfLines = 0;
        tiplab2.text = Internationalization(@"点击上面的按钮开始注册", @"Click the button above to get started with the registration");
        tiplab2.tag = 1999;
        [_guideCell4.contentView addSubview:tiplab2];

        
        
        
        [_guideCell4 setUPSpacing:0 andDownSpacing:0];
    }
    return _guideCell4;
}




#pragma mark - 懒加载
- (UIPageControl *)page {
    if (_page == nil) {
        _page = [[UIPageControl alloc] init];
        _page.frame = CGRectMake(0, kScreenHeight-40-64, kScreenWidth, 30);
        _page.numberOfPages = 4;
        _page.pageIndicatorTintColor = UIColorFromRGB(0xf4f2f4);
        _page.currentPageIndicatorTintColor = UIColorFromRGB(0xd1d1d1);
        [self.view addSubview:_page];
    }
    return _page;
}
- (UIScrollView *)scrollView {
    if (_scrollView == nil) {
        _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        CGSize size = _scrollView.frame.size;
        _scrollView.contentSize = CGSizeMake(4 * size.width, 0);
        _scrollView.pagingEnabled = true;
        _scrollView.showsHorizontalScrollIndicator = false;
        _scrollView.showsVerticalScrollIndicator = false;
        _scrollView.delegate = self;
        _scrollView.delaysContentTouches = false;
        [self.view addSubview:_scrollView];
    }
    return _scrollView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.viewList addObjectsFromArray:@[self.guideCell1,self.guideCell2,self.guideCell3,self.guideCell4]];
    
    [self scrollView];
    
    [self addScrollViewCell];
    
    [self page];
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    self.page.currentPage = scrollView.contentOffset.x /scrollView.bounds.size.width;
}

- (void)addScrollViewCell{
    

    for (int i = 0; i < self.viewList.count; i ++) {
        
        JWScrollviewCell * item = self.viewList[i];
        
        [self.scrollView addSubview:item];
        
    }
}

-(void)getStarted{

    LoginViewController * login = [[LoginViewController alloc]init];
    login.guide = true;
    MainNavController * nav = [[MainNavController alloc]initWithRootViewController:login];
    self.view.window.rootViewController = nav;

}

-(UIView *)addChildView:(NSString *)imageName title:(NSString *)title{

    UIView * view = [[UIView alloc]initWithFrame:CGRectMake(0, 0,adaptY(125), adaptY(100))];
    
    UIImageView * imagev = [[UIImageView alloc]initWithFrame:CGRectMake((view.width - 45)/2, 10, 45, 45)];
    imagev.image = [UIImage imageNamed:imageName];
    [view addSubview:imagev];
    
    JWLabel * labe = [[JWLabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(imagev.frame)+adaptY(15),view.width , 20)];
    labe.text = title;
    labe.textAlignment = 1;
    labe.font = kLightFont(11);
    labe.numberOfLines = 0;
    
    CGSize tipLabelsize = [labe.text boundingRectWithSize:CGSizeMake(view.width, 0)
                                                    options:NSStringDrawingUsesLineFragmentOrigin
                                                 attributes:@{NSFontAttributeName : labe.font}
                                                    context:nil].size;
    
    labe.height = tipLabelsize.height;
    
    
    [view addSubview:labe];
    
    return view;
}

@end
