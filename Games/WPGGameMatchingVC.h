//
//  WPGGameMatchingVC.h
//  WePlayGame
//
//  Created by 刘金丰 on 2018/4/18.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import "BaseViewController.h"

@interface WPGGameMatchingVC : BaseViewController

@property (nonatomic, copy) NSString *ganmeId;//游戏ID

@property (nonatomic, strong) NSString *gameName;//游戏名字

- (instancetype)initWithGameId:(NSString *)gameId gameName:(NSString *)aGameName;

@end
