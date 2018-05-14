//
//  WPGamePageEveryDayTask.h
//  WePlayGame
//
//  Created by leviduan on 2018/4/16.
//  Copyright © 2018年 WePlay. All rights reserved.
//
//  @content：限时活动以及每日任务页面
//

#import "BaseViewController.h"

@interface WPGamePageEveryDayTask : BaseViewController

/**
 * 通过类型id进行初始化
 * @typeId : 1 每日任务 2 限时活动
 */
- (instancetype)initWithId:(NSInteger)typeId;

@end
