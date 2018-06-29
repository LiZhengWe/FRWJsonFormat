//
//  FRWJsonFormatManager.h
//  FRWJsonFormat
//
//  Created by yiner on 2018/3/26.
//  Copyright © 2018年 yiner. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FRWJsonParse;
@interface FRWJsonFormatManager : NSObject

/**
 解析类里属性字段的内容

 @param classInfo 类信息
 @return 类信息转为文件内容
 */
+ (NSString *)parsePropertyContentWithClassInfo:(FRWJsonParse *)classInfo;

/**
 解析一个类头文件的内容(会根据是否创建文件返回的内容有所不同)
 
 @param classInfo 类信息
 
 @return 类头文件里面的内容
 */
+ (NSString *)parseClassHeaderContentWithClassInfo:(FRWJsonParse *)classInfo;

/**
 创建文件
 
 @param folderPath 输出的文件夹路径
 @param classInfo  类信息
 */
+ (void)createFileWithFolderPath:(NSString *)folderPath classInfo:(FRWJsonParse *)classInfo;

/**
 解析一个类实现文件内容
 
 @param classInfo 类信息
 
 @return 实现文件里面的内容
 */
+ (NSString *)parseClassImpContentWithClassInfo:(FRWJsonParse *)classInfo;

/**
 生成 MJExtension2.0 的集合中指定对象的方法
 
 @param classInfo 指定类信息
 
 @return
 */
+ (NSString *)methodContentOfObjectClassInArrayWithClassInfo:(FRWJsonParse *)classInfo;
@end
