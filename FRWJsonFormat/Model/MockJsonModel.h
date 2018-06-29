//
//  MockJsonModel.h
//  FRWJsonFormat
//
//  Created by lizhengwei on 2018/06/14
//  Copyright © 2018年 lizhengwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class user;
@class moduleList;
@class pageList;
@class actionList;
@class responseParameterList;
@class parameterList;
@class requestParameterList;

@interface MockJsonModel : NSObject

@property (nonatomic, copy) NSString *introduction;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *createDateStr;

@property (nonatomic, strong) NSArray<moduleList *> *moduleList;

@property (nonatomic, copy) NSString *version;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, strong) user *user;

@end
@interface user : NSObject

@property (nonatomic, copy) NSString *name;

@property (nonatomic, assign) NSInteger ID;

@end

@interface moduleList : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *introduction;

@property (nonatomic, strong) NSArray<pageList *> *pageList;

@property (nonatomic, copy) NSString *name;

@end

@interface pageList : NSObject

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *introduction;

@property (nonatomic, strong) NSArray<actionList *> *actionList;

@property (nonatomic, copy) NSString *name;

@end

@interface actionList : NSObject

@property (nonatomic, copy) NSString *requestUrl;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, copy) NSString *responseTemplate;

@property (nonatomic, strong) NSArray<requestParameterList *> *requestParameterList;

@property (nonatomic, copy) NSString *description;

@property (nonatomic, strong) NSArray<responseParameterList *> *responseParameterList;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *requestType;

@end

@interface responseParameterList : NSObject

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *dataType;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, strong) NSArray<parameterList *> *parameterList;

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, copy) NSString *validator;

@property (nonatomic, copy) NSString *name;

@end

@interface parameterList : NSObject

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *dataType;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, strong) NSArray *parameterList;

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, copy) NSString *validator;

@property (nonatomic, copy) NSString *name;

@end

@interface requestParameterList : NSObject

@property (nonatomic, copy) NSString *remark;

@property (nonatomic, copy) NSString *dataType;

@property (nonatomic, assign) NSInteger ID;

@property (nonatomic, strong) NSArray *parameterList;

@property (nonatomic, copy) NSString *identifier;

@property (nonatomic, copy) NSString *validator;

@property (nonatomic, copy) NSString *name;

@end

