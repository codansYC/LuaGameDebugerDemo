//
//  IMMsgModel.h
//  LuaGameDebugerDemo
//
//  Created by yuanchao on 2019/5/15.
//  Copyright © 2019年 yuanchao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IMMsgModel : NSObject

@property (nonatomic, assign) NSInteger eventId;
@property (nonatomic, copy) NSString *data;

@end

NS_ASSUME_NONNULL_END
