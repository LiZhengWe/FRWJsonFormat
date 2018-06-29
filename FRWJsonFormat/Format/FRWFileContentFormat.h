//
//  FRWFileContentFormat.h
//  FRWJsonFormat
//
//  Created by yiner on 2018/6/27.
//  Copyright © 2018年 yiner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRWFileContentFormat : NSObject

+ (FRWFileContentFormat *)shareInstance;
- (void)creatRequestFile;


@property (nonatomic, strong) NSArray *dataArr;
@property (nonatomic, copy) NSString *urlPath;
@property (nonatomic, assign) BOOL isPost;

@end
