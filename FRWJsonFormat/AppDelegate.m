//
//  AppDelegate.m
//  FRWJsonFormat
//
//  Created by yiner on 2018/3/2.
//  Copyright © 2018年 yiner. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    
    self.inputViewController = [[FRWInputJsonViewController alloc] initWithNibName:@"FRWInputJsonViewController" bundle:nil];
    self.window = [[NSApplication sharedApplication] keyWindow];
    [self.window.contentView addSubview:self.inputViewController.view];
    self.inputViewController.view.frame = self.window.contentView.bounds;
    
}


- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}


@end
