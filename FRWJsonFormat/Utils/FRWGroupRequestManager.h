//
//  FRWGroupRequestManager.h
//  FRWJsonFormat
//
//  Created by yiner on 2018/8/15.
//  Copyright © 2018年 yiner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MockJsonModel.h"


static NSString *const FRWHttpGroupUrl = @"urls";
static NSString *const FRWHttpGroupParameters = @"parameters";

@interface FRWGroupRequestManager : NSObject

+ (NSDictionary *)requestParametersFrom:(MockJsonModel *)jsonModel;

@end
