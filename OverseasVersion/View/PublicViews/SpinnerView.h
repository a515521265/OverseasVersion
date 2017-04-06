//
//  SpinnerView.h
//  CustomView_IOS
//
//  Created by 恒善信诚科技有限公司 on 17/1/22.
//
//

#import <UIKit/UIKit.h>

@protocol SpinnerViewDelegate <NSObject>

- (CGFloat)spinnerItemHeight; // !< SpinnerViewDelegate

@end


@interface SpinnerView : UIView

-(instancetype)initShowSpinnerWithRelevanceView:(UIView *)view;

@property (nonatomic,strong)NSMutableArray * modelArr;

@property (nonatomic, copy) void(^backModel)(id );

@property (nonatomic, copy) void(^backindex)(id );

@property (nonatomic,assign) BOOL  isNavHeight; //是否有导航栏

@property (nonatomic,assign) BOOL  tapDisappear; //点击其他位置消失

@property (nonatomic,assign) id <SpinnerViewDelegate> delegate;

@property (nonatomic,assign) BOOL   isModelArr;

-(void)ShowView;

-(void)hiddenView;

@end
