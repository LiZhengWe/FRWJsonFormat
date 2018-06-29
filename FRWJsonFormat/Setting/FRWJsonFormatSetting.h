//
//  FRWJsonFormatSetting.h
//  FRWJsonFormat
//
//  Created by yiner on 2018/3/26.
//  Copyright © 2018年 yiner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRWJsonFormatSetting : NSObject

+ (FRWJsonFormatSetting *)defaultSetting;

@property BOOL useGeneric;
@property BOOL impOjbClassInArray;
@property BOOL outputToFiles;
@property BOOL uppercaseKeyWordForId;

@end
