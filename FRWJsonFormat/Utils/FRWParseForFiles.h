//
//  FRWParseForFiles.h
//  FRWJsonFormat
//
//  Created by yiner on 2018/6/26.
//  Copyright © 2018年 yiner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FRWJsonParse.h"

@protocol FRWParseForFilesDelegate <NSObject>


@end

@interface FRWParseForFiles : NSObject

@property (nonatomic, assign) id<FRWParseForFilesDelegate> delegate;

@property (nonatomic, strong) NSMutableDictionary *replaceClassNames;
// model 文件名
@property (nonatomic, copy) NSString *modelName;

- (FRWJsonParse *)handleClassWithResult:(id)result;
- (FRWJsonParse *)dealPropertyNameWithClassInfo:(FRWJsonParse *)classInfo;


@end
