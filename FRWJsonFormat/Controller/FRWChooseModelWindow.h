//
//  FRWChooseModelWindow.h
//  FRWJsonFormat
//
//  Created by yiner on 2018/6/14.
//  Copyright © 2018年 yiner. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FRWChooseModelWindow : NSWindowController


@property (nonatomic, copy) void (^nextBlock)(NSInteger index);
@property (nonatomic, strong) NSArray *moduleArray;

@end
