//
//  FRWJsonParse.m
//  FRWJsonFormat
//
//  Created by yiner on 2018/3/9.
//  Copyright © 2018年 yiner. All rights reserved.
//

#import "FRWJsonParse.h"
#import "FRWJsonFormatManager.h"

@implementation FRWJsonParse

- (instancetype)initWithClassNameKey:(NSString *)classNameKey className:(NSString *)className classDic:(NSDictionary *)classDic {
    
    self = [super init];
    if (self) {
        self.classNameKey = classNameKey;
        self.className = className;
        self.classDic = classDic;
    }
    return self;
}

- (NSMutableDictionary *)propertyArrayDic {
    if (!_propertyArrayDic) {
        _propertyArrayDic = [NSMutableDictionary dictionary];
    }
    return _propertyArrayDic;
}

- (NSMutableDictionary *)propertyClassDic {
    if (!_propertyClassDic) {
        _propertyClassDic = [NSMutableDictionary dictionary];
    }
    return _propertyClassDic;
}

- (NSMutableArray *)propertyClassArray {
    NSMutableArray *result = @[].mutableCopy;
    [self.propertyClassDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, FRWJsonParse *obj, BOOL * _Nonnull stop) {
        [result addObject:obj];
        [result addObjectsFromArray:obj.propertyClassArray];
    }];
    
    [self.propertyArrayDic enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, FRWJsonParse *obj, BOOL * _Nonnull stop) {
        [result addObject:obj];
        [result addObjectsFromArray:obj.propertyClassArray];
    }];
    
    return [result copy];
}

- (NSString *)classContent {
    NSArray *classArray = self.propertyClassArray;
    NSMutableString *importString = [NSMutableString string];
    for (FRWJsonParse *subClass in classArray) {
        [importString appendFormat:@"@class %@;\n",subClass.className];
    }
    
    return importString;
}

- (void)createFileWithFolderPath:(NSString *)folderPath{
    for (NSString *key in self.propertyClassDic) {
        FRWJsonParse *classInfo = self.propertyClassDic[key];
        [classInfo createFileWithFolderPath:folderPath];
    }
    
    for (NSString *key in self.propertyArrayDic) {
        FRWJsonParse *classInfo = self.propertyArrayDic[key];
        [classInfo createFileWithFolderPath:folderPath];
    }
    [FRWJsonFormatManager createFileWithFolderPath:folderPath classInfo:self];
}

- (NSString *)propertyContent{
    return [FRWJsonFormatManager parsePropertyContentWithClassInfo:self];
}

- (NSString *)classContentForH{
    return [FRWJsonFormatManager parseClassHeaderContentWithClassInfo:self];
}

- (NSString *)classContentForM{
    return [FRWJsonFormatManager parseClassImpContentWithClassInfo:self];
}

- (NSString *)classInsertTextViewContentForH{
    NSMutableString *result = [NSMutableString stringWithFormat:@""];
    for (NSString *key in self.propertyClassDic) {
        FRWJsonParse *classInfo = self.propertyClassDic[key];
        [result appendFormat:@"%@\n\n",classInfo.classContentForH];
        [result appendString:classInfo.classInsertTextViewContentForH];
    }
    
    for (NSString *key in self.propertyArrayDic) {
        FRWJsonParse *classInfo = self.propertyArrayDic[key];
        [result appendFormat:@"%@\n\n",classInfo.classContentForH];
        [result appendString:classInfo.classInsertTextViewContentForH];
    }
    return result;
}

- (NSString *)classInsertTextViewContentForM{
    NSMutableString *result = [NSMutableString stringWithFormat:@""];
    for (NSString *key in self.propertyClassDic) {
        FRWJsonParse *classInfo = self.propertyClassDic[key];
        [result appendFormat:@"%@\n\n",classInfo.classContentForM];
        [result appendString:classInfo.classInsertTextViewContentForM];
    }
    
    for (NSString *key in self.propertyArrayDic) {
        FRWJsonParse *classInfo = self.propertyArrayDic[key];
        [result appendFormat:@"%@\n\n",classInfo.classContentForM];
        [result appendString:classInfo.classInsertTextViewContentForM];
    }
    return result;
    
}

@end
