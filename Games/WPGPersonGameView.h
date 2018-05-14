//
//  WPGPersonGameView.h
//  WePlayGame
//
//  Created by leviduan on 2018/4/19.
//  Copyright © 2018年 WePlay. All rights reserved.
//
//   @content：个人中心游戏模块
//

#import <UIKit/UIKit.h>
#import "WPGProfileCenterModel.h"

@interface WPGPersonGameView : UIView <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *gameCollectionView;
@property (nonatomic, copy) NSArray *dataArray;

/**
 * 加载个人中心游戏模块的数据
 */
- (void)loadDataWithModel:(NSArray<WPGameListModel *> *)gameArray;

@end
