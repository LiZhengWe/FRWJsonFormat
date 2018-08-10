//
//  FRWLoadingView.m
//  FRWJsonFormat
//
//  Created by yiner on 2018/8/9.
//  Copyright © 2018年 yiner. All rights reserved.
//

#import "FRWLoadingView.h"

@interface FRWLoadingView ()
@property (nonatomic, strong) NSImageView *loadingImageView;
@end

@implementation FRWLoadingView

+ (instancetype)loadView {
    static FRWLoadingView *loadView = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        loadView = [[FRWLoadingView alloc] init];
    });
    return loadView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.loadingImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.loadingImageView];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingImageView attribute:NSLayoutAttributeLeft relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeft multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingImageView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.loadingImageView attribute:NSLayoutAttributeRight relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeRight multiplier:1 constant:0]];
    }
    return self;
}

+ (void)showLoadingWithView:(NSView *)superView {
    FRWLoadingView *load = [FRWLoadingView loadView];
    load.translatesAutoresizingMaskIntoConstraints = NO;
    [superView addSubview:load];
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:load attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    [superView addConstraint:[NSLayoutConstraint constraintWithItem:load attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:superView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    [load addConstraint:[NSLayoutConstraint constraintWithItem:load attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:200]];
    [load addConstraint:[NSLayoutConstraint constraintWithItem:load attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:100]];
}

+ (void)hiddenLoading {
    dispatch_sync(dispatch_get_main_queue(), ^{
        [[FRWLoadingView loadView] removeFromSuperview];
    });
}

- (NSImageView *)loadingImageView {
    if (!_loadingImageView) {
        _loadingImageView = [[NSImageView alloc] init];
        _loadingImageView.image = [NSImage imageNamed:@"load.gif"];
        _loadingImageView.animates = YES;
        _loadingImageView.imageScaling = NSImageScaleNone;
        _loadingImageView.imageAlignment = NSImageAlignCenter;
    }
    return _loadingImageView;
}

@end
