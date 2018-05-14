//
//  WPGamePageEveryDayTask.m
//  WePlayGame
//
//  Created by leviduan on 2018/4/16.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import "WPGamePageEveryDayTask.h"
#import "WPGamePageEveryTaskCollectionViewCell.h"
#import "WPGGamePageRequest.h"
#import "WPGGamePageModel.h"
#import "WPGAchieveAwardView.h"
#import "WPGameLevelView.h"
#import "WPGPersonLevelView.h"

@interface WPGamePageEveryDayTask () <UICollectionViewDelegate, UICollectionViewDataSource, WPGamePageEveryTaskCollectionViewCellDelegate, WPGAchieveAwardViewDelegate, WPGPersonLevelViewDelegate>

@property (nonatomic, strong) UICollectionView *taskCollectionView;
@property (nonatomic, strong) NSMutableArray<WPGameTaskModel *> *taskDataArray;
@property (nonatomic, assign) NSInteger typeId;
@property (nonatomic, strong) WPGAchieveAwardView *achieveAwardView;
@property (nonatomic, assign) BOOL updateLevel;

@end

@implementation WPGamePageEveryDayTask

- (instancetype)initWithId:(NSInteger)typeId
{
    if (self = [super init]) {
        _typeId = typeId;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    if (_typeId == 1) self.title = @"每日任务";
    if (_typeId == 2) self.title = @"限时活动";
    [self initWithView];
    [self dataRequest];
    
    IDSAddNFObserver(@selector(userLevelUpdate:), kWPGGameUserInfoUpdateEXP);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    // 了解什么时候动画用No，什么时候不用No.
    [self.navigationController setNavigationBarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)initWithView
{
    _updateLevel = NO;
    _taskDataArray = [NSMutableArray new];
    [self.view addSubview:self.taskCollectionView];
    self.taskCollectionView.userInteractionEnabled = YES;
    [self.taskCollectionView registerClass:[WPGamePageEveryTaskCollectionViewCell class] forCellWithReuseIdentifier:@"WPGamePageEveryTaskCollectionViewCell"];
    MJRefreshHeader *header = [IDSRefresh headerWithRefreshingTarget:self
                                                    refreshingAction:@selector(doRefreshData)];
    self.taskCollectionView.mj_header = header;
}

// 经验升级
- (void)userLevelUpdate:(NSNotification *)sender
{
    NSDictionary *dic = sender.userInfo;
    NSString *up = [dic objectForKey:kWPGGameUserInfoUpdateEXPKeyUp];
    if (up.integerValue) {
        _updateLevel = YES;
    }
}

- (void)closeLevelView:(WPGPersonLevelView *)levelView
{
    [levelView removeFromSuperview];
    levelView = nil;
}

- (void)doRefreshData
{
    [self dataRequest];
    [self.taskCollectionView.mj_header endRefreshing];
}

- (void)dataRequest
{
    @weakify(self);
    [WPGGamePageRequest gameTaskRequestType:_typeId Success:^(id responseObj) {
        @strongify(self);
        [self removeLoading];
        IDSHttpResponse *responseData = [IDSHttpResponse mj_objectWithKeyValues:responseObj];
        if ([responseData isResponseOK]) {
            [_taskDataArray removeAllObjects];
            for (id unparsedModel in responseData.data) {
                WPGameTaskModel *model = [WPGameTaskModel mj_objectWithKeyValues:unparsedModel];
                [_taskDataArray cl_addObject:model];
            }
            [self.taskCollectionView reloadData];
        }
        else {
            [self warnUser:responseData.msg];
        }
        
    } fail:^(NSError *error) {
        @strongify(self);
        [self removeLoading];
        if (!_taskDataArray.count) {
            [self warnUser:@"网络拉取失败呦，请重新试试呢？"];            
        }
    }];
}

#pragma mark - delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.taskDataArray.count?:0;
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(SCREEN_WIDTH-14, 88);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    WPGamePageEveryTaskCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"WPGamePageEveryTaskCollectionViewCell" forIndexPath:indexPath];
    WPGameTaskModel *model = [_taskDataArray cl_objectAtIndex:indexPath.row];
    cell.delegate = self;
    [cell cellWithData:model];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    return;
}

- (void)closeTheView:(WPGAchieveAwardView *)achieveAwardView
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(achieveAwardViewRemove) object:nil];
    [self achieveAwardViewRemove];
    if (_updateLevel) {
        _updateLevel = NO;
        WPGPersonLevelView *levelView = [[WPGPersonLevelView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        levelView.delegate = self;
        [levelView setLevel:[NSString stringWithFormat:@"%@",@(NAccount.user.level)]];
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:levelView];
    }
}

- (void)achieveAwardViewRemove
{
    if (_achieveAwardView) {
        [_achieveAwardView removeFromSuperview];
        _achieveAwardView = nil;
    }
}

- (void)receiveTheTask:(WPGamePageEveryTaskCollectionViewCell *)collectionViewCell andTaskModel:(WPGameTaskModel *)model
{
    if (!_achieveAwardView) {
        _achieveAwardView = [[WPGAchieveAwardView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
        [_achieveAwardView achieveAwardWithCoin:model.money exp:model.exp];
        TRACK_SECOND_LEVEL_CLICK(@"street", @"task_to_receive", model.taskId);
        _achieveAwardView.delegate = self;
        UIWindow *window = [UIApplication sharedApplication].keyWindow;
        [window addSubview:_achieveAwardView];
    }
    [self performSelector:@selector(achieveAwardViewRemove) withObject:nil afterDelay:3.0];
    __weak typeof(self) weakSelf = self;
    [WPGGamePageRequest gameTaskWithTaskId:model.taskId Success:^(id responseObj) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        IDSHttpResponse *responseData = [IDSHttpResponse mj_objectWithKeyValues:responseObj];
        if ([responseData isResponseOK]) {
            // 领取奖励事件！
            IDSLOG(@"领取奖励成功");
        }
        else {
            [strongSelf warnUser:responseData.msg];
        }
    } fail:^(NSError *error) {
        __strong typeof (weakSelf) strongSelf = weakSelf;
        [strongSelf removeLoading];
        [strongSelf warnUser:@"网络拉取失败呦，请重新试试呢？"];
    }];
}

- (UICollectionView *)taskCollectionView
{
    if (!_taskCollectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        // 设置布局方向为垂直流布局
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        layout.sectionInset = UIEdgeInsetsMake(11, 10, 10, 10);
        // cell 上下间距
        layout.minimumInteritemSpacing = 0;
        // cell 间距1
        layout.minimumLineSpacing = 4;
        _taskCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height-64) collectionViewLayout:layout];
        if (IS_IPHONE_X) {
            _taskCollectionView.frame = CGRectMake(0, 0, SCREEN_WIDTH, self.view.frame.size.height-64-30);
        }
        _taskCollectionView.delegate = self;
        _taskCollectionView.dataSource = self;
        _taskCollectionView.backgroundColor = [UIColor clearColor];
        _taskCollectionView.showsVerticalScrollIndicator = NO;
        _taskCollectionView.backgroundColor = [ColorUtil cl_colorWithHexString:@"#F7F6FB"];
    }
    return _taskCollectionView;
}

@end
