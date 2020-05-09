//
//  ViewController.m
//  线程间的通信
//
//  Created by Mac on 2020/5/9.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "ViewController.h"
#import <Masonry.h>
#import "ASCommunicationBetweenThreads.h"

@interface ViewController ()

@property (nonatomic, strong) UIImageView * imgView;

@property (nonatomic, strong) UIButton * threadButton;

@property (nonatomic, strong) UIButton * gcdButton;

@property (nonatomic, strong) UIButton * queueButton;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupUI];
}

- (void)setupUI {
    
    [self.view addSubview:self.imgView];
    [self.imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self.view);
        make.size.mas_equalTo(CGSizeMake(400, 300));
    }];
    
    [self.view addSubview:self.threadButton];
    [self.threadButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(20);
        make.bottom.mas_equalTo(self.view).offset(-100);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    
    [self.view addSubview:self.gcdButton];
    [self.gcdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(20*2+100);
        make.bottom.mas_equalTo(self.view).offset(-100);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    
    [self.view addSubview:self.queueButton];
    [self.queueButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).offset(20*3+200);
        make.bottom.mas_equalTo(self.view).offset(-100);
        make.size.mas_equalTo(CGSizeMake(100, 40));
    }];
    
}

#pragma mark- function

/// 使用NSThread
- (void)threadButtonAction {
    
    NSString *imgUrl = @"http://a3.att.hudong.com/14/75/01300000164186121366756803686.jpg";
    [[[ASCommunicationBetweenThreads alloc] init] communicationBetweenThreadsWithNSThreadWithIconUrl:[NSURL URLWithString:imgUrl] imageOperation:^(UIImage * _Nonnull image) {
        
        self.imgView.image = image;
    }];
}

/// 使用GCD
- (void)gcdButtonAction {
    
    NSString *imgUrl = @"http://a4.att.hudong.com/58/27/01300000290906122849276486503.jpg";
    [[[ASCommunicationBetweenThreads alloc] init] communicationBetweenThreadsWithGCDWithIconUrl:[NSURL URLWithString:imgUrl] imageOperation:^(UIImage * _Nonnull image) {
        
        self.imgView.image = image;
    }];
}

/// 使用NSOperationQueue
- (void)queueButtonAction {
    
    NSString *imgUrl = @"http://a3.att.hudong.com/04/56/20300542128627138760566581551.jpg";
    [[[ASCommunicationBetweenThreads alloc] init] communicationBetweenThreadsWithNSOperationQueueWithIconUrl:[NSURL URLWithString:imgUrl] imageOperation:^(UIImage * _Nonnull image) {
        
        self.imgView.image = image;
    }];
}

#pragma mark- lazying

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [[UIImageView alloc] init];
    }
    return _imgView;
}

- (UIButton *)threadButton {
    if (!_threadButton) {
        _threadButton = [[UIButton alloc] init];
        _threadButton.layer.cornerRadius = 20;
        _threadButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _threadButton.backgroundColor = [UIColor blueColor];
        [_threadButton setTitle:@"ThreadClick" forState:UIControlStateNormal];
        [_threadButton addTarget:self action:@selector(threadButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _threadButton;
}

- (UIButton *)gcdButton {
    if (!_gcdButton) {
        _gcdButton = [[UIButton alloc] init];
        _gcdButton.layer.cornerRadius = 20;
        _gcdButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _gcdButton.backgroundColor = [UIColor blueColor];
        [_gcdButton setTitle:@"GCDClick" forState:UIControlStateNormal];
        [_gcdButton addTarget:self action:@selector(gcdButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _gcdButton;
}

- (UIButton *)queueButton {
    if (!_queueButton) {
        _queueButton = [[UIButton alloc] init];
        _queueButton.layer.cornerRadius = 20;
        _queueButton.titleLabel.font = [UIFont systemFontOfSize:12];
        _queueButton.backgroundColor = [UIColor blueColor];
        [_queueButton setTitle:@"QueueClick" forState:UIControlStateNormal];
        [_queueButton addTarget:self action:@selector(queueButtonAction) forControlEvents:UIControlEventTouchUpInside];
    }
    return _queueButton;
}




@end
