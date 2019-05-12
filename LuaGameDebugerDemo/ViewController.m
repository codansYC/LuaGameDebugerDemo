//
//  ViewController.m
//  LuaGameDebugerDemo
//
//  Created by 袁超 on 2019/5/11.
//  Copyright © 2019年 yuanchao. All rights reserved.
//

#import "ViewController.h"
#import "Client.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
}

- (IBAction)connect:(id)sender {
    [[Client sharedClient] connect];
}
- (IBAction)login:(id)sender {
    [[Client sharedClient] login];
}
- (IBAction)send:(id)sender {
    [[Client sharedClient] sendMsg:@""];
}
- (IBAction)disconnect:(id)sender {
    [[Client sharedClient] disconnect];
}


@end
