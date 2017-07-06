//
//  LXRabbitMQManager.m
//  RabbitMQDemo
//
//  Created by linxiang on 2017/7/4.
//  Copyright © 2017年 misrobot. All rights reserved.
//

#import "LXRabbitMQManager.h"

@implementation LXRabbitMQManager

+(LXRabbitMQManager *) sharedInstance
{
    static LXRabbitMQManager *sharedInstace = nil;
    
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        sharedInstace = [[self alloc] init];
    });
    
    return sharedInstace;
}

-(instancetype)init {
    
    self = [super init];
    
    if (self) {
        
    }
    
    return self;
}

- (void)Start{
    [self startRabbitMQ:@"LX"]; //QueueName];
}

- (void)Stop{
    [self stopRabbitMQ];
}

- (void)Restart{
    [self Stop];
    [self Start];
}


- (NSString *)SetHttpURL:(NSString *)amqp :(NSString *)userName :(NSString *)passWord :(NSString *)IP :(NSString *)Port :(NSString *)vHost {
    
    NSString * resultURL = [NSString stringWithFormat:@"%@://%@:%@@%@:%@/%@",amqp,userName,passWord,IP,Port,vHost];
    
    return resultURL;
}

- (void) startRabbitMQ:(NSString *) queueNameStr {
    NSString * url = [self SetHttpURL:@"amqp" :@"admin" :@"misrobot" :@"192.168.10.200" :@"5672" :@"TestHost"];
    
    [[[NSThread alloc] initWithBlock:^{
        // 创建连接     @"amqp://admin:misrobot@192.168.10.200:5672/TestHost"
        _conn = [[RMQConnection alloc] initWithUri:url delegate:[RMQConnectionDelegateLogger new]];
        [_conn start:^{
            
            NSLog(@"连接成功！！");
            
            [self consume:queueNameStr];
            
            _queueName = queueNameStr;
        }];
    }] start];
}

- (void)consume:(NSString *) queueNameStr {
 
    if(_conn == nil){
        NSLog(@"conn == nil");
        return;
    }
    // 获取信道
    _ch = [_conn createChannel];
    if (_ch == nil) {
        NSLog(@"ch == nil");
        return;
    }
    // 声明队列
    RMQQueue *q = [_ch queue:queueNameStr];
    if (q == nil) {
        NSLog(@"q == nil");
        return;
    }
    //RMQQueue *q = [ch queue:@"iOS"];
    // 接收信息
    //    [q subscribe:^(RMQMessage * _Nonnull message) {
    //
    //        NSString *msg  = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
    //
    //        NSLog(@"Received %@", msg);
    //
    //        [self performSelectorOnMainThread:@selector(onGetMQMessage:) withObject:msg waitUntilDone:YES];
    //    }];
    

     @try {
         [q subscribe:^(RMQMessage * _Nonnull message) {
     
             NSString *msg  = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
     
             NSLog(@"Received %@", msg);
         }];
     } @catch (NSException *exception) {
         NSLog(@"Try-Catch ERROR == %@",exception.reason);
         
         [self Restart];
     } @finally {
         NSLog(@"Try-Catch @finally");
     }
}

- (void)stopRabbitMQ
{
    if(_conn !=nil)  [_conn close];
    
    if(_ch != nil) [_ch close];
    
    _conn = nil; _ch = nil;
}


@end
