//
//  ViewController.m
//  RabbitMQDemo
//
//  Created by misrobot on 2017/6/27.
//  Copyright © 2017年 misrobot. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextFieldDelegate>

@end

@implementation ViewController

@synthesize conn;
@synthesize ch;
@synthesize queueName;
@synthesize mQueueTextField;
@synthesize mLogTextView;

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"viewWillAppear");
    
    
    
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector(JianCe)
                                                 name: @"EnterForeground"
                                               object: nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [mQueueTextField resignFirstResponder];
}

- (IBAction)onStartButtonClick:(id)sender
{
    //Connect to RabbitMQ Server...
    if ( mQueueTextField.text.length > 0 ) {
        [self startRabbitMQ:mQueueTextField.text];
    } else {
        [self AlertView:@"请输入队列名" :@""];
    }
    
}

- (IBAction)onStopButtonClick:(id)sender
{
    
    [self stopRabbitMQ];
    
}


-(void)JianCe {
    
    NSLog(@"JianCe");
    
    if (conn == nil) {
        NSLog(@"conn 为空");
    }
    
}


-(NSString *)SetHttpURL:(NSString *)amqp :(NSString *)userName :(NSString *)passWord :(NSString *)IP :(NSString *)Port :(NSString *)vHost {
    
    NSString * resultURL = [NSString stringWithFormat:@"%@://%@:%@@%@:%@/%@",amqp,userName,passWord,IP,Port,vHost];
    
    return resultURL;
}

- (void) startRabbitMQ:(NSString *) queueNameStr
{
    NSString * url = [self SetHttpURL:@"amqp" :@"admin" :@"misrobot" :@"192.168.10.200" :@"5672" :@"TestHost"];
    
    [[[NSThread alloc] initWithBlock:^{
        // 创建连接     @"amqp://admin:misrobot@192.168.10.200:5672/TestHost"
        conn = [[RMQConnection alloc] initWithUri:url delegate:[RMQConnectionDelegateLogger new]];
        [conn start:^{
            
            NSLog(@"连接成功！！");
            
            [self consume:queueNameStr];
            
            queueName = queueNameStr;
        }];
    }] start];
}

- (void) onGetMQMessage:(NSString*) message
{
    [NSThread currentThread];
    [mLogTextView insertText:[message stringByAppendingString:@"\n"]];
    [mLogTextView scrollRangeToVisible:NSMakeRange(mLogTextView.text.length, 1)];
}

- (void)consume:(NSString *) queueNameStr
{
    if(conn == nil){
        NSLog(@"conn == nil");
        return;
    }
    // 获取信道
    ch = [conn createChannel];
    if (ch == nil) {
        NSLog(@"ch == nil");
        return;
    }
    // 声明队列
    RMQQueue *q = [ch queue:queueNameStr];
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
    
/*
    @try {
        [q subscribe:^(RMQMessage * _Nonnull message) {
            
            NSString *msg  = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
            
            NSLog(@"Received %@", msg);
            
            [self performSelectorOnMainThread:@selector(onGetMQMessage:) withObject:msg waitUntilDone:YES];
        }];
    } @catch (NSException *exception) {
        NSLog(@"Try-Catch ERROR == %@",exception.reason);
        [self startRabbitMQ:mQueueTextField.text];
    } @finally {
        NSLog(@"Try-Catch @finally");
    }
 */

    
    RMQConsumer * consumer = [[RMQConsumer alloc]initWithChannel:ch queueName:queueName options:RMQBasicConsumeNoAck];
    
    [ch basicConsume:consumer];
    
    
    while (conn && ch) {

        @try {
        
            [consumer onDelivery:^(RMQMessage * _Nonnull message) {
                
                NSString *msg  = [[NSString alloc] initWithData:message.body encoding:NSUTF8StringEncoding];
                
                NSLog(@"Received %@", msg);
                
                [self performSelectorOnMainThread:@selector(onGetMQMessage:) withObject:msg waitUntilDone:YES];
                
            }];
        } @catch (NSException *exception) {
            NSLog(@"Try-Catch ERROR == %@",exception.reason);
        }
//        } @finally {
//            NSLog(@"Try-Catch @finally");
//        }
    
        
    }
 
    
}

- (void) publish:(NSString*) message
{
    if(conn == nil) return;
    // 获取信道
    ch = [conn createChannel];
    // 创建队列
    RMQQueue *q = [ch queue:queueName]; // 队列
    // 发送消息
    [ch.defaultExchange publish:[queueName dataUsingEncoding:NSUTF8StringEncoding] routingKey:q.name]; // 发送
}

- (void)stopRabbitMQ
{
    if(conn !=nil)  [conn close];
        
    if(ch != nil) [ch close];
    
    conn = nil; ch = nil;
}


-(void)AlertView:(NSString *)title :(NSString *)message{
    // 1. 实例化
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
    // 2. 添加方法
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
    }]];
    // 3. 显示
    [self presentViewController:alert animated:YES completion:nil];
}


@end
