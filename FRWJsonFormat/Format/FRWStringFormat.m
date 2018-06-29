//
//  FRWStringFormat.m
//  FRWJsonFormat
//
//  Created by yiner on 2018/6/26.
//  Copyright © 2018年 yiner. All rights reserved.
//

#import "FRWStringFormat.h"

@implementation FRWStringFormat

+ (FRWStringFormat *)shareInstance {
    static FRWStringFormat *stringFormat = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        stringFormat = [[self alloc] init];
    });
    return stringFormat;
}

+ (NSString *)urlFromOriginalUrl:(NSString *)baseUrl {
    NSString *newUrl = @"";
    if (baseUrl.length < 1) {
        return @"";
    }
    if ([[baseUrl substringToIndex:1] isEqualToString:@"/"]) {
        newUrl = [baseUrl substringFromIndex:1];
    }
    newUrl = [baseUrl stringByReplacingOccurrencesOfString:@"http://mock.2dfire-daily.com/mock-serverapi/mockjsdata/" withString:@""];
    return newUrl;
}

- (NSString *)globalMockUrl {
    return @"http://mock.2dfire-daily.com/mock-serverapi/api/queryRAPModel.do";
}

@end
