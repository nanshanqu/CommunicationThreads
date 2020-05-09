//
//  ASCommunicationBetweenThreads.h
//  线程间的通信
//
//  Created by Mac on 2020/5/9.
//  Copyright © 2020 Mac. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASCommunicationBetweenThreads : NSObject

///  使用NSThread
/// @param iconUrl 图片下载URL
/// @param imageOperation 成功下载之后的回调
- (void)communicationBetweenThreadsWithNSThreadWithIconUrl:(NSURL *)iconUrl imageOperation:(void(^)(UIImage *image))imageOperation;

/// 使用GCD
/// @param iconUrl 图片下载URL
/// @param imageOperation 成功下载之后的回调
- (void)communicationBetweenThreadsWithGCDWithIconUrl:(NSURL *)iconUrl imageOperation:(void(^)(UIImage *image))imageOperation;

/// 使用NSOperationQueue
/// @param iconUrl 图片下载URL
/// @param imageOperation 成功下载之后的回调
- (void)communicationBetweenThreadsWithNSOperationQueueWithIconUrl:(NSURL *)iconUrl imageOperation:(void(^)(UIImage *image))imageOperation;

@end

NS_ASSUME_NONNULL_END
