//
//  HSAJsonFormatOptionalWindow.m
//  FRWJsonFormat
//
//  Created by yiner on 2018/9/21.
//  Copyright © 2018年 yiner. All rights reserved.
//

#import "HSAJsonFormatOptionalWindow.h"

@interface HSAJsonFormatOptionalWindow ()
@property (weak) IBOutlet NSButton *selectAllBtn;
@property (weak) IBOutlet NSScrollView *bgScrollView;
@property (nonatomic, strong) NSMutableArray<actionList *> *datasource;
@property (nonatomic, strong) NSMutableArray<actionList *> *selectRequest;
@end

@implementation HSAJsonFormatOptionalWindow

- (void)windowDidLoad {
    [super windowDidLoad];
    
    // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
    self.bgScrollView.scrollerStyle = NSScrollerStyleOverlay;
    [self.bgScrollView setPostsBoundsChangedNotifications:YES];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(scrollViewDidChange:) name:NSViewBoundsDidChangeNotification object:nil];
    [self configureData];
}

- (void)configureView {

    NSView *view = [[NSView alloc] initWithFrame:NSRectFromCGRect(CGRectMake(0, 0, 320, self.datasource.count *35))];
    for (int i = 0; i < self.datasource.count; i++) {
        actionList *action = self.datasource[i];
        NSButton *button = [NSButton checkboxWithTitle:[NSString stringWithFormat:@"%@ %ld",action.name,(long)action.ID] target:self action:@selector(btnSelect:)];
        button.state = NSControlStateValueOn;
        button.tag = i + 12138;
        button.frame = NSMakeRect(20, i*10 + i * 25, 300, 25);
        [view addSubview:button];
    }
    self.bgScrollView.documentView = view;
}

- (void)btnSelect:(NSButton *)btn {
 
    if (btn.state == NSOnState) {
        [self.selectRequest addObject:self.datasource[btn.tag - 12138]];
    }
    else {
        [self.selectRequest removeObject:self.datasource[btn.tag - 12138]];
    }
}

- (IBAction)selectAllBtn:(NSButton *)sender {
    
    if (sender.state == NSControlStateValueOff) {
        for (NSButton *btn in self.bgScrollView.documentView.subviews) {
            if ([btn isKindOfClass:[NSButton class]]) {
                btn.state = NSControlStateValueOff;
            }
        }
        [self.selectRequest removeAllObjects];
    }
    else if (sender.state == NSControlStateValueOn) {
        for (NSButton *btn in self.bgScrollView.documentView.subviews) {
            if ([btn isKindOfClass:[NSButton class]]) {
                btn.state = NSControlStateValueOn;
            }
        }
        [self.selectRequest removeAllObjects];
        [self.selectRequest addObjectsFromArray:self.datasource];
    }
}
- (IBAction)next:(NSButton *)sender {
    !self.selectBlock?:self.selectBlock(self.selectRequest);
    [self close];
}

- (void)configureData {
    for (moduleList *module in self.jsonModel.moduleList) {
        for (pageList *page in module.pageList) {
            for (actionList *action in page.actionList) {
                [self.datasource addObject:action];
            }
        }
    }
    [self configureView];
}

- (void)scrollWheel:(NSEvent *)event {
    [super scrollWheel:event];
}

- (void)scrollViewDidChange:(NSNotification *)notify {
    NSClipView *clipView = [notify object];
    NSPoint changePoint = [clipView documentVisibleRect].origin;
    NSLog(@"------X:%f, Y:%f------",changePoint.x,changePoint.y);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [[self.window standardWindowButton:NSWindowMiniaturizeButton] setHidden:YES];
    [[self.window standardWindowButton:NSWindowZoomButton] setHidden:YES];
    [[self.window standardWindowButton:NSWindowCloseButton] setHidden:YES];
}

- (void)close {
    [super close];
    [NSApp stopModal];
    [NSApp stop:self];
}

- (NSMutableArray<actionList *> *)selectRequest {
    if (!_selectRequest) {
        _selectRequest = [[NSMutableArray alloc] initWithArray:self.datasource];
    }
    return _selectRequest;
}

- (NSMutableArray<actionList *> *)datasource {
    if (!_datasource) {
        _datasource = [[NSMutableArray alloc] init];
    }
    return _datasource;
}

@end
