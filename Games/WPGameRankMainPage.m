//
//  WPGameRankMainPage.m
//  WePlayGame
//
//  Created by leviduan on 2018/4/13.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import "WPGameRankMainPage.h"
#import "WPGGameTotalRankPage.h"
#import "WPGCharmRanking.h"
#import "WPGScrollPageBar.h"
#import "WPGScrollPage.h"
#import "WPGRuleView.h"

@interface WPGameRankMainPage () <WPGRuleViewDelegate>

@property (nonatomic, strong) WPGScrollPage *scrollPage;
@property (nonatomic, strong) UIView *goBackView;
@property (nonatomic, strong) UIView *rightView;
@property (nonatomic, assign) NSInteger pageIndex;
@property (nonatomic, strong) WPGRuleView *ruleView;

@end

@implementation WPGameRankMainPage

- (void)dealloc
{
    [_rightView removeFromSuperview];
    _rightView = nil;
    
    [_goBackView removeFromSuperview];
    _goBackView = nil;
    IDSLOG(@"WPGameRankMainPage dealloc");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initWithView];
    self.title = @"任务";
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (_rightView) self.rightView.hidden = NO;
    if (_goBackView) self.goBackView.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    if (_rightView) _rightView.hidden = YES;
    if (_goBackView) _goBackView.hidden = YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleDefault;
}

- (void)initWithView
{
    _pageIndex = 0;
    NSMutableArray *barModelArray = [NSMutableArray array];
    
    //玩家总榜
    WPGGameTotalRankPage *gameTotalRankPage = [[WPGGameTotalRankPage alloc] init];
    WPGPageBarModel *barModelA = [WPGPageBarModel modelWithPage:gameTotalRankPage barName:@"玩家总榜"];
    [barModelArray cl_addObject:barModelA];
    
    //魅力榜
    WPGCharmRanking *charmRankPage = [[WPGCharmRanking alloc] init];
    WPGPageBarModel *barModelB = [WPGPageBarModel modelWithPage:charmRankPage barName:@"魅力榜"];
    [barModelArray cl_addObject:barModelB];
    
    WPGPageViewConfig *config = [[WPGPageViewConfig alloc] init];
    
    config.isBarBtnUseCustomWidth = NO;
    config.barBtnPaddingTop = 10;
    config.barViewH = 64;
    if (IS_IPHONE_X) {
        config.barBtnPaddingTop = 20;
        config.barViewH = 64+30;
    }
    config.barBtnFont = [UIFont boldSystemFontOfSize:18];
    config.barTitleColor  = [ColorUtil cl_colorWithHexString:@"#999999"];
    config.barTitleSelectedColor = [ColorUtil cl_colorWithHexString:@"#7262FF"];
    config.barColor = [UIColor whiteColor];
    config.indicatorHeight = 4.f;
    config.indicatorWidthPercent = 0.3f;
    config.horizontalLineWidth = SCREEN_WIDTH;
    config.barBtnMargin = 15;
    config.barScrollMargin = (SCREEN_WIDTH - 99 - 81 - 15)/2.0;
    config.indicatorColor = [ColorUtil cl_colorWithHexString:@"#7262FF"];
    config.indicatorWidthDividedButtonWidth = 0.5;
    config.indicatorBottomOffset = 2;
    config.returnBtnBool = YES;
    
    _scrollPage = [WPGScrollPage viewWithOwnerVC:self pageModels:barModelArray config:config];
    
    self.scrollPage.backgroundColor = kBgColor;
    _scrollPage.scrollBarView.showsVerticalScrollIndicator = false;
    _scrollPage.scrollBarView.showsHorizontalScrollIndicator = false;
    [self.view addSubview:self.scrollPage];
    
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.goBackView];
    [window addSubview:self.rightView];
    
    // 如果不加这句话 子View会自动下移64px
    self.automaticallyAdjustsScrollViewInsets = NO;
}

- (NSInteger)currentTabBarIndex
{
    return 1;
}

- (UIView *)goBackView
{
    if (!_goBackView) {
        _goBackView = [[UIView alloc] initWithFrame:CGRectMake(10, 25, 35, 35)];
        if (IS_IPHONE_X) {
            _goBackView.frame = CGRectMake(10, 45, 35, 35);
        }
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goBackPage)];
        [_goBackView addGestureRecognizer:gesture];
    }
    return _goBackView;
}

- (UIView *)rightView
{
    if (!_rightView) {
        _rightView = [[UIView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH-40, 25, 40, 40)];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gotoNewPage)];
        [_rightView addGestureRecognizer:gesture];
    }
    return _rightView;
}

- (void)goBackPage
{
    [_goBackView removeFromSuperview];
    _goBackView = nil;
    [self goBack];
}

- (void)gotoNewPage
{
    if (!_ruleView) {
        _ruleView = [[WPGRuleView alloc] init];
        [_ruleView addTotalFrameView];
        _ruleView.delegate = self;
        [self.view addSubview:_ruleView];
    }
}

- (void)closeTheRuleview:(WPGRuleView *)ruleView
{
    [_ruleView removeFromSuperview];
    _ruleView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    [self doGoBack];
    // Dispose of any resources that can be recreated.
}

@end
