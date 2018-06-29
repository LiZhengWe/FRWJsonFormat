//
//  FRWJsonFormatSetting.m
//  FRWJsonFormat
//
//  Created by yiner on 2018/3/26.
//  Copyright © 2018年 yiner. All rights reserved.
//

#import "FRWJsonFormatSetting.h"

NSString *const kFRWJsonFormatGeneric = @"com.EnjoySR.ESJsonFormat.Generic";
NSString *const kFRWJsonFormatOutputToFiles = @"com.EnjoySR.ESJsonFormat.OutputToFiles";
NSString *const kFRWJsonFormatImpObjClassInArray = @"com.EnjoySR.ESJsonFormat.ImpObjClassInArray";
NSString *const kFRWJsonFormatUppercaseKeyWordForId = @"com.EnjoySR.ESJsonFormat.UppercaseKeyWordForId";

@implementation FRWJsonFormatSetting

+ (FRWJsonFormatSetting *)defaultSetting
{
    static dispatch_once_t once;
    static FRWJsonFormatSetting *defaultSetting;
    dispatch_once(&once, ^ {
        defaultSetting = [[FRWJsonFormatSetting alloc] init];
        NSDictionary *defaults = @{kFRWJsonFormatGeneric: @YES,
                                   kFRWJsonFormatOutputToFiles: @NO,
                                   kFRWJsonFormatImpObjClassInArray: @YES,
                                   kFRWJsonFormatUppercaseKeyWordForId: @YES};
        [[NSUserDefaults standardUserDefaults] registerDefaults:defaults];
    });
    return defaultSetting;
}

- (void)setUseGeneric:(BOOL)useGeneric{
    [[NSUserDefaults standardUserDefaults] setBool:useGeneric forKey:kFRWJsonFormatGeneric];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)useGeneric{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kFRWJsonFormatGeneric];
}

- (void)setImpOjbClassInArray:(BOOL)impOjbClassInArray{
    [[NSUserDefaults standardUserDefaults] setBool:impOjbClassInArray forKey:kFRWJsonFormatImpObjClassInArray];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)impOjbClassInArray{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kFRWJsonFormatImpObjClassInArray];
}

- (void)setOutputToFiles:(BOOL)outputToFiles{
    [[NSUserDefaults standardUserDefaults] setBool:outputToFiles forKey:kFRWJsonFormatOutputToFiles];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)outputToFiles{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kFRWJsonFormatOutputToFiles];
}

- (void)setUppercaseKeyWordForId:(BOOL)uppercaseKeyWordForId{
    [[NSUserDefaults standardUserDefaults] setBool:uppercaseKeyWordForId forKey:kFRWJsonFormatUppercaseKeyWordForId];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (BOOL)uppercaseKeyWordForId{
    return [[NSUserDefaults standardUserDefaults] boolForKey:kFRWJsonFormatUppercaseKeyWordForId];
}

@end
