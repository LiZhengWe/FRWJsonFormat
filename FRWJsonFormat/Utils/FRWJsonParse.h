//
//  FRWJsonParse.h
//  FRWJsonFormat
//
//  Created by yiner on 2018/3/9.
//  Copyright © 2018年 yiner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRWJsonParse : NSObject

/**
 当前类名
 */
@property (nonatomic, copy) NSString *className;

/**
 当前类在json里的对应key
 */
@property (nonatomic, copy) NSString *classNameKey;

/**
 当前类在json里对应的字典
 */
@property (nonatomic, strong) NSDictionary *classDic;

/**
 当前类引用其他class集合
 */
@property (nonatomic, strong) NSMutableArray *propertyClassArray;

/**
 当前类属性对应为集合  （key -> json的字段key   ：  value -> ）
 */
@property (nonatomic, strong) NSMutableDictionary *propertyArrayDic;

/**
 当前类属性对应为类的字典 （key -> json的字段key   ：  value -> class对象）
 */
@property (nonatomic, strong) NSMutableDictionary *propertyClassDic;

/**
 创建文件时，文件内容
 */
@property (nonatomic, copy) NSString *classContent;

/**
 所有属性对应的格式化的内容
 */
@property (nonatomic, copy) NSString *propertyContent;

/**
 整个类头文件的内容，包含头与尾 -- 会根据是否创建文件添加模板文字
 */
@property (nonatomic, copy) NSString *classContentForH;

/**
 整个类实现文件里面的内容
 */
@property (nonatomic, copy) NSString *classContentForM;

/**
 直接插入到.h文件 -- 不包含当前类里面属性字段，只有里面引用类的.h文件内容
 */
@property (nonatomic, copy) NSString *classInsertTextViewContentForH;

/**
 直接插入到.m文件的内容
 */
@property (nonatomic, copy) NSString *classInsertTextViewContentForM;


- (instancetype)initWithClassNameKey:(NSString *)classNameKey className:(NSString *)className classDic:(NSDictionary *)classDic;

+ (NSString *)propertyArrWtihJsonDic:(NSDictionary *)jsonDic;

- (void)createFileWithFolderPath:(NSString *)folderPath;


@end
