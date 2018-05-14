//
//  WPGTaskGiftBagModel.h
//  WePlayGame
//
//  Created by 刘金丰 on 2018/4/23.
//  Copyright © 2018年 WePlay. All rights reserved.
//

#import <Foundation/Foundation.h>


@class WPGTaskGiftBagModel,WPGTaskGiftBagData;
@interface WPGTaskGiftBagModel : NSObject

@property (nonatomic, strong) WPGTaskGiftBagData *data;

@end


@interface WPGTaskGiftBagData : NSObject

@property (nonatomic, assign) NSInteger currentCompleted;//完成多少次

@property (nonatomic, assign) NSInteger totalCompleted;//共要完成多少次游戏

@property (nonatomic, assign) NSInteger statusGot;//可以领 0 不可领, 1 = 可以领，-1已领完

@property (nonatomic, assign) NSInteger cons;//礼物数量


@end

