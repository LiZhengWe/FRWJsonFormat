//
//  FRWUtils.h
//  FRWJsonFormat
//
//  Created by yiner on 2018/3/26.
//  Copyright © 2018年 yiner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRWUtils : NSObject


/**
 获取Xcode大版本

 @return 版本号
 */
+ (NSInteger)XcodePreVsersion;


/**
 是否高于Xcode7

 @return 是/否
 */
+ (BOOL)isXcode7AndLater;

+ (id)dictionaryWithJson:(NSString *)jsonString;

@end
