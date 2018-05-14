//
//  WPGGameShareModel.h
//  WePlayGame
//
//  Created by 刘金丰 on 2018/4/20.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import <Foundation/Foundation.h>


@class WPGGameShareModel,WPGGameShareData;
@interface WPGGameShareModel : NSObject

@property (nonatomic, strong) WPGGameShareData *data;

@end


@interface WPGGameShareData : NSObject

@property (nonatomic, strong) NSString *title;//标题

@property (nonatomic, strong) NSString *content;//内容

@property (nonatomic, strong) NSString *icon;//图标

@property (nonatomic, strong) NSString *url;//链接


@end


