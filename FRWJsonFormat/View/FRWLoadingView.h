//
//  FRWLoadingView.h
//  FRWJsonFormat
//
//  Created by yiner on 2018/8/9.
//  Copyright © 2018年 yiner. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface FRWLoadingView : NSView
+ (instancetype)loadView;
+ (void)showLoadingWithView:(NSView *)superView;
+ (void)hiddenLoading;
@end
