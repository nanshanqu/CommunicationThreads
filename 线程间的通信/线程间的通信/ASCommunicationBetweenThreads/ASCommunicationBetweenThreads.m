//
//  ASCommunicationBetweenThreads.m
//  线程间的通信
//
//  Created by Mac on 2020/5/9.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "ASCommunicationBetweenThreads.h"

@interface ASCommunicationBetweenThreads ()

@property (nonatomic, copy) void(^imageOperation)(UIImage *image);

@end

@implementation ASCommunicationBetweenThreads

#pragma mark-  使用NSThread

///  使用NSThread
/// @param iconUrl 图片下载URL
/// @param imageOperation 成功下载之后的回调
- (void)communicationBetweenThreadsWithNSThreadWithIconUrl:(NSURL *)iconUrl imageOperation:(void(^)(UIImage *image))imageOperation {
    
    [self downloadImageWithIconUrl:iconUrl];
    self.imageOperation = imageOperation;
    
}

/// 下载图片
/// @param iconUrl 图片地址
- (void)downloadImageWithIconUrl:(NSURL *)iconUrl {
    
    NSLog(@"download---%@", [NSThread currentThread]);
    // 根据地址下载图片的二进制数据(这句代码最耗时)
    NSData *data = [NSData dataWithContentsOfURL:iconUrl];
    
    // 设置图片
    UIImage *image = [UIImage imageWithData:data];
    
    // 回到主线程，刷新UI界面(为了线程安全)
    [self performSelectorOnMainThread:@selector(downloadFinished:) withObject:image waitUntilDone:NO];
//    [self performSelector:@selector(downloadFinished:) onThread:[NSThread mainThread] withObject:image waitUntilDone:YES];
//    [self.imageView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:YES];
}

- (void)downloadFinished:(UIImage *)image {
    
    NSLog(@"setting---%@ %@", [NSThread currentThread], image);
    if (self.imageOperation) {
        self.imageOperation(image);
    }
}

#pragma mark-  使用GCD

/// 使用GCD
/// @param iconUrl 图片下载URL
/// @param imageOperation 成功下载之后的回调
- (void)communicationBetweenThreadsWithGCDWithIconUrl:(NSURL *)iconUrl imageOperation:(void(^)(UIImage *image))imageOperation {
    
    [self userGCDActionWithIconUrl:iconUrl];
    self.imageOperation = imageOperation;
}

- (void)userGCDActionWithIconUrl:(NSURL *)iconUrl {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSLog(@"donwload---%@", [NSThread currentThread]);
        // 子线程下载图片
        NSData *data = [NSData dataWithContentsOfURL:iconUrl];
        UIImage *image = [UIImage imageWithData:data];
        
        // 回到主线程设置图片
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSLog(@"setting---%@ %@", [NSThread currentThread], image);
            if (self.imageOperation) {
                self.imageOperation(image);
            }
        });
    });
}

#pragma mark-  使用NSOperationQueue

/// 使用NSOperationQueue
/// @param iconUrl 图片下载URL
/// @param imageOperation 成功下载之后的回调
- (void)communicationBetweenThreadsWithNSOperationQueueWithIconUrl:(NSURL *)iconUrl imageOperation:(void(^)(UIImage *image))imageOperation {
    
    [self useNSOperationQueueWithIconUrl:iconUrl];
    self.imageOperation = imageOperation;
}

- (void)useNSOperationQueueWithIconUrl:(NSURL *)iconUrl {
    
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [queue addOperationWithBlock:^{
        
        NSLog(@"donwload---%@", [NSThread currentThread]);
        // 异步下载图片
        NSData *data = [NSData dataWithContentsOfURL:iconUrl];
        UIImage *image = [UIImage imageWithData:data];
        
        // 回到主线程，显示图片
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            
            NSLog(@"setting---%@ %@", [NSThread currentThread], image);
            if (self.imageOperation) {
                self.imageOperation(image);
            }
        }];
    }];
}

@end
