//
//  Client.h
//  LuaGameDebugerDemo
//
//  Created by 袁超 on 2019/5/11.
//  Copyright © 2019年 yuanchao. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Client : NSObject

+ (Client *)sharedClient;

- (void)connect;

- (void)login;

- (void)sendMsg:(NSString *)msg;

- (void)disconnect;

@end

NS_ASSUME_NONNULL_END
