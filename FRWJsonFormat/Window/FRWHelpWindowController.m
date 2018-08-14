//
//  FRWHelpWindowController.m
//  FRWJsonFormat
//
//  Created by yiner on 2018/6/22.
//  Copyright © 2018年 yiner. All rights reserved.
//

#import "FRWHelpWindowController.h"

@interface FRWHelpWindowController ()

@end

@implementation FRWHelpWindowController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    
    [[self.window standardWindowButton:NSWindowZoomButton] setHidden:YES];
    [[self.window standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
    [[self.window standardWindowButton:NSWindowCloseButton] setTarget:self];
    [[self.window standardWindowButton:NSWindowCloseButton] setAction:@selector(close)];
}


- (void)close {
    [super close];
    [NSApp stopModal];
    [NSApp stop:self];
}

@end
