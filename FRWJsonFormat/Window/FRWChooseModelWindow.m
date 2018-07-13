//
//  FRWChooseModelWindow.m
//  FRWJsonFormat
//
//  Created by yiner on 2018/6/14.
//  Copyright © 2018年 yiner. All rights reserved.
//

#import "FRWChooseModelWindow.h"

@interface FRWChooseModelWindow ()

@property (weak) IBOutlet NSTextField *titleLab;

@property (weak) IBOutlet NSPopUpButton *popUpBtn;

@property (weak) IBOutlet NSButton *nextBtn;

@property (nonatomic, assign) NSInteger selectIndex;
@end

@implementation FRWChooseModelWindow

- (void)awakeFromNib {
    [super awakeFromNib];
    [[self.window standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
    [[self.window standardWindowButton:NSWindowZoomButton] setHidden:YES];
    [[self.window standardWindowButton:NSWindowCloseButton] setHidden:YES];
}

- (void)windowDidLoad {
    [super windowDidLoad];
    self.selectIndex = 0;
    [self.popUpBtn removeAllItems];
    if (self.moduleArray || self.moduleArray.count > 0) {
    
        for (NSString *itemTitle in self.moduleArray) {
            [self.popUpBtn addItemWithTitle:itemTitle];
            [[self.popUpBtn itemWithTitle:itemTitle] setEnabled:YES];
        }
        [self.popUpBtn selectItem:[self.popUpBtn itemAtIndex:0]];
    }

    NSLog(@"%ld",self.popUpBtn.menu.numberOfItems);
}

- (void)setModuleArray:(NSArray *)moduleArray {
    _moduleArray = moduleArray;
}

- (IBAction)popUpAction:(id)sender {
    NSPopUpButton *button = (NSPopUpButton *)sender;
    self.selectIndex = button.indexOfSelectedItem;
}


- (IBAction)nextAction:(id)sender {
    [self close];
    !self.nextBlock ?: self.nextBlock(self.selectIndex);
}

- (IBAction)cancelAction:(id)sender {
    [self close];
}

- (void)close {
    [super close];
    [NSApp stopModal];
    [NSApp stop:self];
}


@end
