//
//  FRWDialogController.m
//  FRWJsonFormat
//
//  Created by yiner on 2018/3/19.
//  Copyright © 2018年 yiner. All rights reserved.
//

#import "FRWDialogController.h"

@interface FRWDialogController ()<NSTextFieldDelegate,NSWindowDelegate>
@property (weak) IBOutlet NSTextField *classNameField;
@property (weak) IBOutlet NSTextField *messageLab;

@end

@implementation FRWDialogController

- (void)windowDidLoad {
    [super windowDidLoad];
    
    self.classNameField.delegate = self;
    self.window.delegate = self;
    self.classNameField.stringValue = self.className;
    self.messageLab.stringValue = self.message;
    
    [self.classNameField becomeFirstResponder];
}

- (void)dataWithMessage:(NSString *)message defaultClassName:(NSString *)className  start:(void(^)(NSString *className))startBlock {
    self.className = className;
    self.message = message;
    self.startBlock = startBlock;
}

- (void)startBtnClick:(id)sender {
    !self.startBlock?:self.startBlock(self.classNameField.stringValue);
    
    [self close];
}

#pragma mark - NSWindowDelegate -
- (void)windowWillClose:(NSNotification *)notification {
    [NSApp stopModal];
    [NSApp endSheet:self.window];
    [[self window] orderOut:nil];
}


-(void)keyUp:(NSEvent *)event {
    [super keyUp:event];
    if ([event keyCode] == 36) {  // 回车键
        [self startBtnClick:nil];
    }
    NSLog(@"keyUp %hu", event.keyCode);
}

@end
