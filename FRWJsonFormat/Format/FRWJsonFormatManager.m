//
//  FRWJsonFormatManager.m
//  FRWJsonFormat
//
//  Created by yiner on 2018/3/26.
//  Copyright © 2018年 yiner. All rights reserved.
//

#import "FRWJsonFormatManager.h"
#import "FRWJsonFormatSetting.h"
#import "FRWJsonParse.h"
#import "FRWUtils.h"

@implementation FRWJsonFormatManager

+ (NSString *)parsePropertyContentWithClassInfo:(FRWJsonParse *)classInfo {
    NSMutableString *resultStr = [NSMutableString string];
    NSDictionary *dic = classInfo.classDic;
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, NSObject *obj, BOOL *stop) {
        [resultStr appendFormat:@"\n%@",[self formatObjcWithKey:key value:obj classInfo:classInfo]];
    }];
    return resultStr;
}

+ (NSString *)formatObjcWithKey:(NSString *)key value:(NSObject *)value classInfo:(FRWJsonParse *)classInfo {
    NSString *qualifierStr = @"copy";
    NSString *typeStr = @"NSString";
    //判断大小写
    if ([@[@"id"] containsObject:key] && [FRWJsonFormatSetting defaultSetting].uppercaseKeyWordForId) {
        key = [key uppercaseString];
    }
    if ([value isKindOfClass:[NSString class]]) {
        return [NSString stringWithFormat:@"@property (nonatomic, %@) %@ *%@;",qualifierStr,typeStr,key];
    }else if([value isKindOfClass:[@(YES) class]]){
        //the 'NSCFBoolean' is private subclass of 'NSNumber'
        qualifierStr = @"assign";
        typeStr = @"BOOL";
        return [NSString stringWithFormat:@"@property (nonatomic, %@) %@ %@;",qualifierStr,typeStr,key];
    }else if([value isKindOfClass:[NSNumber class]]){
        qualifierStr = @"assign";
        NSString *valueStr = [NSString stringWithFormat:@"%@",value];
        if ([valueStr rangeOfString:@"."].location!=NSNotFound){
            typeStr = @"CGFloat";
        }else{
            NSNumber *valueNumber = (NSNumber *)value;
            if ([valueNumber longValue]<2147483648) {
                typeStr = @"NSInteger";
            }else{
                typeStr = @"long long";
            }
        }
        return [NSString stringWithFormat:@"@property (nonatomic, %@) %@ %@;",qualifierStr,typeStr,key];
    }else if([value isKindOfClass:[NSArray class]]){
        NSArray *array = (NSArray *)value;
        
        //May be 'NSString'，will crash
        NSString *genericTypeStr = @"";
        NSObject *firstObj = [array firstObject];
        if ([firstObj isKindOfClass:[NSDictionary class]]) {
            FRWJsonParse *childInfo = classInfo.propertyArrayDic[key];
            genericTypeStr = [NSString stringWithFormat:@"<%@ *>",[childInfo.className capitalizedString]];
        }else if ([firstObj isKindOfClass:[NSString class]]){
            genericTypeStr = @"<NSString *>";
        }else if ([firstObj isKindOfClass:[NSNumber class]]){
            NSNumber *valueNumber = (NSNumber *)firstObj;
            if ([valueNumber longValue]<2147483648) {
                genericTypeStr = @"<NSInteger *>";
            }
            else {
                genericTypeStr = @"<NSNumber *>";
            }
        }
        qualifierStr = @"strong";
        typeStr = @"NSArray";
        return [NSString stringWithFormat:@"@property (nonatomic, %@) %@%@ *%@;",qualifierStr,typeStr,genericTypeStr,key];
        
    }else if ([value isKindOfClass:[NSDictionary class]]){
        qualifierStr = @"strong";
        FRWJsonParse *childInfo = classInfo.propertyClassDic[key];
        typeStr = childInfo.className;
        if (!typeStr) {
            typeStr = [key capitalizedString];
        }
        return [NSString stringWithFormat:@"@property (nonatomic, %@) %@ *%@;",qualifierStr,[typeStr capitalizedString],key];
    }
    return [NSString stringWithFormat:@"@property (nonatomic, %@) %@ *%@;",qualifierStr,typeStr,key];
}

+ (NSString *)parseClassHeaderContentWithClassInfo:(FRWJsonParse *)classInfo {
    return [self parseClassHeaderContentForOjbcWithClassInfo:classInfo];
}

+ (NSString *)parseClassHeaderContentForOjbcWithClassInfo:(FRWJsonParse *)classInfo{
    NSString *superClassString = [[NSUserDefaults standardUserDefaults] valueForKey:@"SuperClass"];
    NSMutableString *result = nil;
    if (superClassString && superClassString.length > 0) {
        result = [NSMutableString stringWithFormat:@"@interface %@ : %@\n", [classInfo.className substringWithRange:NSMakeRange(0, 1)],superClassString];
    }else{
        result = [NSMutableString stringWithFormat:@"@interface %@ : NSObject\n",classInfo.className];
    }
    [result appendString:classInfo.propertyContent];
    [result appendString:@"\n@end\n"];

    if ([FRWJsonFormatSetting defaultSetting].outputToFiles) {
        //headerStr
        NSMutableString *headerString = [NSMutableString stringWithString:[self dealHeaderStrWithClassInfo:classInfo type:@"h"]];
        //@class
        [headerString appendString:[NSString stringWithFormat:@"%@\n\n",classInfo.classContent]];
        [result insertString:headerString atIndex:0];
    }
    return [result copy];
}

+ (NSString *)dealHeaderStrWithClassInfo:(FRWJsonParse *)classInfo type:(NSString *)type{
    //模板文字
    NSString *templateFile = [[[NSSearchPathForDirectoriesInDomains(NSApplicationSupportDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"Developer/Shared/Xcode/Plug-ins/ESJsonFormat.xcplugin"] stringByAppendingPathComponent:@"Contents/Resources/DataModelsTemplate.txt"];
    NSString *templateString = [NSString stringWithContentsOfFile:templateFile encoding:NSUTF8StringEncoding error:nil];
    //替换模型名字
    templateString = [templateString stringByReplacingOccurrencesOfString:@"__MODELNAME__" withString:[NSString stringWithFormat:@"%@.%@",classInfo.className,type]];
    //替换用户名
    templateString = [templateString stringByReplacingOccurrencesOfString:@"__NAME__" withString:NSFullUserName()];

    //时间
    templateString = [templateString stringByReplacingOccurrencesOfString:@"__DATE__" withString:[self dateStr]];

    if ([type isEqualToString:@"h"] || [type isEqualToString:@"switf"]) {
        NSMutableString *string = [NSMutableString stringWithString:templateString];
        if ([type isEqualToString:@"h"]) {
            [string appendString:@"#import <Foundation/Foundation.h>\n\n"];
            NSString *superClassString = [[NSUserDefaults standardUserDefaults] valueForKey:@"SuperClass"];
            if (superClassString&&superClassString.length>0) {
                [string appendString:[NSString stringWithFormat:@"#import \"%@.h\" \n\n",superClassString]];
            }
        }else{
            [string appendString:@"import UIKit\n\n"];
            NSString *superClassString = [[NSUserDefaults standardUserDefaults] valueForKey:@"SuperClass"];
            if (superClassString&&superClassString.length>0) {
                [string appendString:[NSString stringWithFormat:@"import %@ \n\n",superClassString]];
            }
        }
        templateString = [string copy];
    }
    return [templateString copy];
}

+ (NSString *)dateStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yy/MM/dd";
    return [formatter stringFromDate:[NSDate date]];
}

+ (NSString *)parseClassImpContentWithClassInfo:(FRWJsonParse *)classInfo{

    NSMutableString *result = [NSMutableString stringWithString:@""];
    if ([FRWJsonFormatSetting defaultSetting].impOjbClassInArray) {
            [result appendFormat:@"@implementation %@\n%@\n%@\n@end\n",classInfo.className,[self methodContentOfObjectClassInArrayWithClassInfo:classInfo],[self methodContentOfObjectIDInArrayWithClassInfo:classInfo]];
    }else{
        [result appendFormat:@"@implementation %@\n\n@end\n",classInfo.className];
    }

    if ([FRWJsonFormatSetting defaultSetting].outputToFiles) {
        //headerStr
        NSMutableString *headerString = [NSMutableString stringWithString:[self dealHeaderStrWithClassInfo:classInfo type:@"m"]];
        //import
        [headerString appendString:[NSString stringWithFormat:@"#import \"%@.h\"\n",classInfo.className]];
        for (NSString *key in classInfo.propertyArrayDic) {
            FRWJsonParse *childClassInfo = classInfo.propertyArrayDic[key];
            [headerString appendString:[NSString stringWithFormat:@"#import \"%@.h\"\n",childClassInfo.className]];
        }
        [headerString appendString:@"\n"];
        [result insertString:headerString atIndex:0];
    }
    return [result copy];
}

+ (NSString *)methodContentOfObjectIDInArrayWithClassInfo:(FRWJsonParse *)classInfo{
    
    
    NSMutableString *result = [NSMutableString string];
    NSDictionary *dic = classInfo.classDic;
    NSLog(@"%@",dic);
    [dic enumerateKeysAndObjectsUsingBlock:^(id key, NSObject *obj, BOOL *stop) {
    
        if ([@[@"id"] containsObject:key] && [FRWJsonFormatSetting defaultSetting].uppercaseKeyWordForId) {
            
            
            [result appendFormat:@"@\"%@\":@\"%@\", ",[key uppercaseString],key];
        }
        
    }];
    
    if ([result hasSuffix:@", "]) {
        result = [NSMutableString stringWithFormat:@"%@",[result substringToIndex:result.length-2]];
        NSString *methodStr = [NSString stringWithFormat:@"\n+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{\n    return @{%@};\n}\n",result];
        return methodStr;
    }
    
    return result;
}

+ (NSString *)methodContentOfObjectClassInArrayWithClassInfo:(FRWJsonParse *)classInfo{
    
    if (classInfo.propertyArrayDic.count==0) {
        return @"";
    }else{
        NSMutableString *result = [NSMutableString string];
        for (NSString *key in classInfo.propertyArrayDic) {
            FRWJsonParse *childClassInfo = classInfo.propertyArrayDic[key];
            [result appendFormat:@"@\"%@\" : [%@ class], ",key,childClassInfo.className];
        }
        if ([result hasSuffix:@", "]) {
            result = [NSMutableString stringWithFormat:@"%@",[result substringToIndex:result.length-2]];
        }
        
        NSString *methodStr = nil;
        methodStr = [NSString stringWithFormat:@"\n+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{\n    return @{%@};\n}\n",result];
        
        return methodStr;
    }
}

+ (void)createFileWithFolderPath:(NSString *)folderPath classInfo:(FRWJsonParse *)classInfo {
    //创建.h文件
    [self createFileWithFileName:[folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.h",classInfo.className]] content:classInfo.classContentForH];
    //创建.m文件
    [self createFileWithFileName:[folderPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.m",classInfo.className]] content:classInfo.classContentForM];
}

+ (void)createFileWithFileName:(NSString *)FileName content:(NSString *)content{
    NSFileManager *manager = [NSFileManager defaultManager];
    [manager createFileAtPath:FileName contents:[content dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
}
@end
