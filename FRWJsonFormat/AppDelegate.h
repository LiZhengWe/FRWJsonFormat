//
//  AppDelegate.h
//  FRWJsonFormat
//
//  Created by yiner on 2018/3/2.
//  Copyright © 2018年 yiner. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "FRWInputJsonViewController.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (nonatomic, strong) FRWInputJsonViewController *inputViewController;
@property (nonatomic, strong) NSWindow *window;

@end

