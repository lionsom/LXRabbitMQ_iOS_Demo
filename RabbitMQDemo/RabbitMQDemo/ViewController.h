//
//  ViewController.h
//  RabbitMQDemo
//
//  Created by misrobot on 2017/6/27.
//  Copyright © 2017年 misrobot. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <RMQClient/RMQClient.h>

@interface ViewController : UIViewController

@property (nonatomic, strong) RMQConnection *conn;
@property (nonatomic, strong) id<RMQChannel> ch;
@property (nonatomic, strong) NSString *queueName;

@property (weak, nonatomic) IBOutlet UITextView *mLogTextView;

@property (weak, nonatomic) IBOutlet UITextField *mQueueTextField;

//- (void) login:(NSString*) userID passWD : (NSString *) pwd;
- (void) startRabbitMQ:(NSString *) queueNameStr;
- (void)consume:(NSString *) queueNameStr;

- (void) publish:(NSString*) message;

@end

