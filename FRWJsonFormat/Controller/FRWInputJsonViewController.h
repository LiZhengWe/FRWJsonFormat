//
//  FRWInputJsonViewController.h
//  FRWJsonFormat
//
//  Created by yiner on 2018/3/2.
//  Copyright © 2018年 yiner. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@protocol FRWInputJsonControllerDelegate <NSObject>

@optional
-(void)windowWillClose;
@end

@interface FRWInputJsonViewController : NSViewController

@property (nonatomic, weak) id<FRWInputJsonControllerDelegate> delegate;
@property (unsafe_unretained) IBOutlet NSTextView *jsonInputTxtView;

@end
