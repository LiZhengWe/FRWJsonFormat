//
//  FRWDialogController.h
//  FRWJsonFormat
//
//  Created by yiner on 2018/3/19.
//  Copyright © 2018年 yiner. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FRWDialogController : NSWindowController

@property (nonatomic, copy) NSString *message;
@property (nonatomic, copy) NSString *className;
@property (nonatomic, copy) void (^startBlock)(NSString *className);

- (void)dataWithMessage:(NSString *)message defaultClassName:(NSString *)className  start:(void(^)(NSString *className))startBlock;

@end
