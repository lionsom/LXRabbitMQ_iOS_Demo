//
//  LXRabbitMQViewController.m
//  RabbitMQDemo
//
//  Created by linxiang on 2017/7/4.
//  Copyright © 2017年 misrobot. All rights reserved.
//

#import "LXRabbitMQViewController.h"

#import "LXRabbitMQManager.h"

@interface LXRabbitMQViewController ()

@property (nonatomic , retain) LXRabbitMQManager * lxRabbitMQManager;

@end

@implementation LXRabbitMQViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _lxRabbitMQManager = [LXRabbitMQManager sharedInstance];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)StartClick:(id)sender {
    [_lxRabbitMQManager Start];
}

- (IBAction)StopClick:(id)sender {
    [_lxRabbitMQManager Stop];
}

- (IBAction)ReStart:(id)sender {
    [_lxRabbitMQManager Restart];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
