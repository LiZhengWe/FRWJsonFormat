//
//  FRWStringFormat.h
//  FRWJsonFormat
//
//  Created by yiner on 2018/6/26.
//  Copyright © 2018年 yiner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRWStringFormat : NSObject

+ (FRWStringFormat *)shareInstance;
+ (NSString *)urlFromOriginalUrl:(NSString *)baseUrl;

@property (nonatomic, copy) NSString *globalMockUrl;

@end
