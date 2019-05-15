//
//  Client.m
//  LuaGameDebugerDemo
//
//  Created by 袁超 on 2019/5/11.
//  Copyright © 2019年 yuanchao. All rights reserved.
//

#import "Client.h"
#import "GCDAsyncSocket.h"
#import "IMMsgModel.h"
#import "YYModel.h"

typedef NS_ENUM(NSUInteger, Command) {
    CommandArchive = 100,
    CommandLog     = 101,
    CommandAllFile = 102,
};

@interface Client ()<GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket *socket;

@end

@implementation Client

+ (Client *)sharedClient {
    static Client *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[Client alloc] init];
    });
    return instance;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        _socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
    }
    return self;
}

- (void)connect {
    NSError *error;
    [self.socket connectToHost:@"172.16.232.68" onPort:8090 error:&error];
}

- (void)login {
    NSString *loginInfo = @"iam:I am login!";
    NSData *loginData = [loginInfo dataUsingEncoding: NSUTF8StringEncoding];
    //发送登录指令。-1表示不超时。tag200表示这个指令的标识，很大用处
    [self.socket writeData:loginData withTimeout:-1 tag:201];
}

- (void)sendMsg:(NSString *)msg {
    NSData *sendData = [msg dataUsingEncoding: NSUTF8StringEncoding];
    [self.socket writeData:sendData withTimeout:-1 tag:201];
}

- (void)disconnect {
    [self.socket disconnectAfterReadingAndWriting];
}

#pragma GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag {
    NSLog(@"didReadData");
    [self handleReceivedPacket:data];
    [sock readDataWithTimeout:-1 tag:tag];
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    NSLog(@"didWriteDataWithTag:%ld",tag);
    [sock readDataWithTimeout:-1 tag:tag];
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port {
    NSLog(@"didConnectToHost:%@ port=%d",host, port);
    [sock readDataWithTimeout:-1 tag:200];
}

- (void)handleReceivedPacket:(NSData *)data {
    IMMsgModel *msgModel = [IMMsgModel yy_modelWithJSON:data];
    Command command = msgModel.eventId;
    NSString *dataStr = msgModel.data;
    switch (command) {
        case CommandArchive:
        {
            NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:[dataStr  dataUsingEncoding:NSUTF8StringEncoding]  options:NSJSONReadingAllowFragments error:nil];
            NSString *allFileJson = [self getAllFileJson:dict];
            IMMsgModel *msgModel = [IMMsgModel new];
            msgModel.eventId = CommandAllFile;
            msgModel.data = allFileJson;
            [self sendMsg:[msgModel yy_modelToJSONString]];
        }
            break;
        default:
            break;
    }
    
    
    
}

- (NSString *)getAllFileJson:(NSDictionary *)dict {
    NSString *rootPath = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"LuaGame"];
    BOOL isDir;
    if (![[NSFileManager defaultManager] fileExistsAtPath:rootPath isDirectory:&isDir] || !isDir) {
        [[NSFileManager defaultManager] createDirectoryAtPath:rootPath withIntermediateDirectories:NO attributes:nil error:nil];
        return @"";
    }
    
    return @"";
}

@end
