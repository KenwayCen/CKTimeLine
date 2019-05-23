//
//  ViewController.m
//  CKTimeLineCovert
//
//  Created by Kenway-Pro on 2019/5/21.
//  Copyright © 2019 Kenway. All rights reserved.
//

#import "ViewController.h"
#import "CKTimeLine.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CKTimeline *timeline = [[CKTimeline alloc]init];
    NSLog(@"%@",[timeline timelineConvert:@"1557564383000"]);
    NSLog(@"%@",[timeline timelineConvert:@"1557564383"]);
    NSLog(@"%@",[timeline timelineConvert:@(1557564383000)]);
}


@end
