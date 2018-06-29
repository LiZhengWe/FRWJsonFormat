//
//  FRWParseForFiles.m
//  FRWJsonFormat
//
//  Created by yiner on 2018/6/26.
//  Copyright © 2018年 yiner. All rights reserved.
//

#import "FRWParseForFiles.h"
#import "FRWDialogController.h"


@implementation FRWParseForFiles

- (instancetype)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (FRWJsonParse *)handleClassWithResult:(id)result {
    
    __block FRWJsonParse *classFromParse = nil;
    
    if ([result isKindOfClass:[NSDictionary class]]) {
        FRWDialogController *dialog = [[FRWDialogController alloc] initWithWindowNibName:@"FRWDialogController"];
        
        NSString *message = [NSString stringWithFormat:@"输入Model的名字："];
        
        __weak typeof (self) weakSelf = self;
        [dialog dataWithMessage:message defaultClassName:@"HSARootClass" start:^(NSString *className) {
            classFromParse = [[FRWJsonParse alloc] initWithClassNameKey:@"HSARootClass" className:className classDic:result];
            weakSelf.modelName = className;
        }];
        
        [NSApp beginSheet:[dialog window] modalForWindow:[NSApp mainWindow] modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [NSApp runModalForWindow:[dialog window]];
        
        [self dealPropertyNameWithClassInfo:classFromParse];
    }
    else if([result isKindOfClass:[NSArray class]]) {
        FRWDialogController *dialog = [[FRWDialogController alloc] initWithWindowNibName:@"FRWDialogController"];
        NSString *message = [NSString stringWithFormat:@"输入Model的名字："];
        __block NSString *rootClassName = @"HSARootClass";
        __weak typeof (self) weakSelf = self;
        [dialog dataWithMessage:message defaultClassName:@"HSARootClass" start:^(NSString *className) {
            rootClassName = className;
            weakSelf.modelName = className;
        }];
        
        [NSApp beginSheet:[dialog window] modalForWindow:[NSApp mainWindow] modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [NSApp runModalForWindow:[dialog window]];
        
        dialog = [[FRWDialogController alloc] initWithWindowNibName:@"FRWDialogController"];
        message = @"请输入当前数组对象的名字：";
        [dialog dataWithMessage:message defaultClassName:@"Array" start:^(NSString *className) {
            NSDictionary *dic = [NSDictionary dictionaryWithObject:result forKey:className];
            classFromParse = [[FRWJsonParse alloc] initWithClassNameKey:@"HSARootClass" className:rootClassName classDic:dic];
        }];
        [NSApp beginSheet:[dialog window] modalForWindow:[NSApp mainWindow] modalDelegate:nil didEndSelector:nil contextInfo:nil];
        [NSApp runModalForWindow:[dialog window]];
        
        [self dealPropertyNameWithClassInfo:classFromParse];
    }
    
    NSLog(@"%@",classFromParse.className);
    return classFromParse;
}

- (FRWJsonParse *)dealPropertyNameWithClassInfo:(FRWJsonParse *)classInfo {
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithDictionary:classInfo.classDic];
    for (NSString *key in dic) {
        //取出的可能是NSDictionary或者NSArray
        id obj = dic[key];
        if ([obj isKindOfClass:[NSArray class]] || [obj isKindOfClass:[NSDictionary class]]) {
            FRWDialogController *dialog = [[FRWDialogController alloc] initWithWindowNibName:@"FRWDialogController"];
            NSString *message = [NSString stringWithFormat:@"输入对象 '%@' 对应的名字:",key];
            if ([obj isKindOfClass:[NSArray class]]) {
                
                if (!([[obj firstObject] isKindOfClass:[NSDictionary class]] || [[obj firstObject] isKindOfClass:[NSArray class]])) {
                    continue;
                }
                message = [NSString stringWithFormat:@"输入'%@' 对应的model:",key];
            }
            __block NSString *childClassName;//Record the current class name
            [dialog dataWithMessage:message defaultClassName:key start:^(NSString *className) {
                if (![className isEqualToString:key]) {
                    self.replaceClassNames[key] = className;
                }
                childClassName = className;
            }];
            [NSApp beginSheet:[dialog window] modalForWindow:[NSApp mainWindow] modalDelegate:nil didEndSelector:nil contextInfo:nil];
            [NSApp runModalForWindow:[dialog window]];
            //如果当前obj是 NSDictionary 或者 NSArray，继续向下遍历
            if ([obj isKindOfClass:[NSDictionary class]]) {
                FRWJsonParse *childClassInfo = [[FRWJsonParse alloc] initWithClassNameKey:key className:childClassName classDic:obj];
                [self dealPropertyNameWithClassInfo:childClassInfo];
                //设置classInfo里面属性对应class
                [classInfo.propertyClassDic setObject:childClassInfo forKey:key];
            }else if([obj isKindOfClass:[NSArray class]]){
                //如果是 NSArray 取出第一个元素向下遍历
                NSArray *array = obj;
                if (array.firstObject) {
                    NSObject *obj = [array firstObject];
                    //May be 'NSString'，will crash
                    if ([obj isKindOfClass:[NSDictionary class]]) {
                        FRWJsonParse *childClassInfo = [[FRWJsonParse alloc] initWithClassNameKey:key className:childClassName classDic:(NSDictionary *)obj];
                        [self dealPropertyNameWithClassInfo:childClassInfo];
                        //设置classInfo里面属性类型为 NSArray 情况下，NSArray 内部元素类型的对应的class
                        [classInfo.propertyArrayDic setObject:childClassInfo forKey:key];
                    }
                }
            }
        }
    }
    return classInfo;
}


- (NSMutableDictionary *)replaceClassNames {
    if (!_replaceClassNames) {
        _replaceClassNames = [NSMutableDictionary dictionary];
    }
    return _replaceClassNames;
    
}

@end
