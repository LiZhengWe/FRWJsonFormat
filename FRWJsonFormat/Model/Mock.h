//
//  Mock.h
//  FRWJsonFormat
//
//  Created by lizhengwei on 2018/05/22
//  Copyright © 2018年 lizhengwei. All rights reserved.
//

#import <Foundation/Foundation.h>

@class mockjsMap;

@interface Mock : NSObject

@property (nonatomic, copy) NSString *modelJSON;

@property (nonatomic, assign) NSInteger code;

@property (nonatomic, assign) NSInteger msg;

@property (nonatomic, strong) mockjsMap *mockjsMap;

@end
@interface mockjsMap : NSObject

@property (nonatomic, copy) NSString *qqq;

@property (nonatomic, copy) NSString *qqss;

@end

