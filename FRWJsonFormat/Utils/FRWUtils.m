//
//  FRWUtils.m
//  FRWJsonFormat
//
//  Created by yiner on 2018/3/26.
//  Copyright © 2018年 yiner. All rights reserved.
//

#import "FRWUtils.h"

@implementation FRWUtils

+ (NSInteger)XcodePreVsersion{
    NSAppleScript *_script = [[NSAppleScript alloc] initWithSource:@"do shell script \"xcodebuild -version\""];
    NSDictionary  *_error  = [NSDictionary new];
    NSAppleEventDescriptor *des = [_script executeAndReturnError:&_error];
    if (_error.count == 0) {
        NSString *desStr = des.stringValue;
        NSRange range = [desStr rangeOfString:@"Xcode "];
        NSInteger version = 0;
        if (range.location != NSNotFound && desStr.length>range.length) {
            version = [[desStr substringWithRange:NSMakeRange(range.length, 1)] integerValue];
        }
        return version;
    }
    else{
        return 0;
    }
}

+ (BOOL)isXcode7AndLater{
    return [self XcodePreVsersion] >= 7;
}

+ (id)dictionaryWithJson:(NSString *)jsonString {
    jsonString = [[jsonString stringByReplacingOccurrencesOfString:@" " withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    id dicOrArray = [NSJSONSerialization JSONObjectWithData:jsonData
                                                    options:NSJSONReadingMutableContainers
                                                      error:&err];
    if (err) {
        return err;
    }else{
        return dicOrArray;
    }
}

@end
