//
//  HSAJsonFormatOptionalWindow.h
//  FRWJsonFormat
//
//  Created by yiner on 2018/9/21.
//  Copyright © 2018年 yiner. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "MockJsonModel.h"

@interface HSAJsonFormatOptionalWindow : NSWindowController

@property (nonatomic, strong) MockJsonModel *jsonModel;
@property (nonatomic, copy) void(^selectBlock)(NSArray *selectRequest);

@end

