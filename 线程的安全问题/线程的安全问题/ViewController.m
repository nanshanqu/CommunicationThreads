//
//  ViewController.m
//  线程的安全问题
//
//  Created by Mac on 2020/5/9.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

/// 售票员1
@property (nonatomic, strong) NSThread * thread1;

/// 售票员2
@property (nonatomic, strong) NSThread * thread2;

/// 售票员3
@property (nonatomic, strong) NSThread * thread3;

/// 总共50张票
@property (nonatomic, assign) NSInteger totalTicketCount;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.totalTicketCount = 50;
    
    self.thread1 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil];
    self.thread1.name = @"1号窗口";
    
    self.thread2 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil];
    self.thread2.name = @"2号窗口";
    
    self.thread3 = [[NSThread alloc] initWithTarget:self selector:@selector(saleTicket) object:nil];
    self.thread3.name = @"3号窗口";
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    if (self.totalTicketCount <= 0) return;
    
    // 总票数大于0，三个售票员一起开始卖票
    [self.thread1 start];
    [self.thread2 start];
    [self.thread3 start];
}

/// 卖票
- (void)saleTicket {
    
    while (1) {
        
        // ()小括号里面放的是锁对象
        @synchronized (self) {  // 开始加锁
            
            NSInteger leftTicketCount = self.totalTicketCount;
            
            if (leftTicketCount > 0) {
                
                [NSThread sleepForTimeInterval:0.05];
                self.totalTicketCount = leftTicketCount - 1;
                NSLog(@"%@卖了一张票, 剩余%ld张票", [NSThread currentThread].name, self.totalTicketCount);
                
            } else {
                
                return; // 退出循环
            }
        } // 解锁
    }
}


@end
