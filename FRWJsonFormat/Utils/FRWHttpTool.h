//
//  FRWHttpTool.h
//  FRWJsonFormat
//
//  Created by yiner on 2018/8/13.
//  Copyright © 2018年 yiner. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^FRWSuccess)(BOOL success, NSString *json);
typedef void(^FRWFailure)(NSError *error);

typedef NS_ENUM(NSUInteger, RequestType) {
    RequestTypeGet = 1,
    RequestTypePost = 2,
};

@interface FRWHttpTool : NSObject

@property (nonatomic, copy) NSString *baseUrl;

+ (instancetype)shareTool;

- (void)configureHttpEngineInitInfomations;


/**
 post/get请求

 @param path 请求路径
 @param parameters 请求参数
 @param requestType 请求类型
 @param successBlock 请求成功回调
 @param failureBlock 请求失败回调
 */
-  (void)beginRequestWithUrlString:(NSString *)path parameters:(id)parameters requestType:(RequestType)requestType success:(FRWSuccess)successBlock failure:(FRWFailure)failureBlock;


/**
 post请求

 @param path 请求路径
 @param params 请求参数
 @param success 请求成功回调
 @param failure 请求失败回调
 */
- (void)postRequestWithPath:(NSString *)path
                     params:(NSDictionary *)params
                    success:(FRWSuccess)success
                    failure:(FRWFailure)failure;

/**
 get请求

 @param path 请求路径
 @param params 请求参数
 @param success 请求成功回调
 @param failure 请求失败回调
 */
- (void)getRequestWithPath:(NSString *)path
                    params:(NSDictionary *)params
                   success:(FRWSuccess)success
                   failure:(FRWFailure)failure;

- (void)groupRequestWith:(NSArray<NSString *> *)paths params:(NSArray<NSDictionary *> *)parameters respondseObject:(void(^)(NSDictionary *respondseDic))respondseObject;

@end
