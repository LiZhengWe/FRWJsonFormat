//
//  FRWHttpTool.m
//  FRWJsonFormat
//
//  Created by yiner on 2018/8/13.
//  Copyright © 2018年 yiner. All rights reserved.
//

#import "FRWHttpTool.h"
#import <AFNetworking/AFNetworking.h>

@interface FRWHttpTool ()
@property (nonatomic, strong) AFHTTPSessionManager *manager;
@end

@implementation FRWHttpTool

+(instancetype)shareTool {
    static FRWHttpTool *tool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        tool = [[FRWHttpTool alloc] init];
    });
    
    return tool;
}

- (void)configureHttpEngineInitInfomations {
    self.manager = [FRWHttpTool managerWithBaseUrl:[NSURL URLWithString:self.baseUrl]];
    self.manager.requestSerializer.timeoutInterval = 20;
    self.manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/plain",@"text/html",nil];
    
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        
    }];
}

- (void)beginRequestWithUrlString:(NSString *)path parameters:(id)parameters requestType:(RequestType)requestType success:(FRWSuccess)successBlock failure:(FRWFailure)failureBlock {
    if (requestType == RequestTypePost) {
        [self postRequestWithPath:path
                           params:parameters
                          success:successBlock
                          failure:failureBlock];
    }
    else {
        [self getRequestWithPath:path
                          params:parameters
                         success:successBlock
                         failure:failureBlock];
    }
}

- (void)postRequestWithPath:(NSString *)path params:(NSDictionary *)params success:(FRWSuccess)success failure:(FRWFailure)failure {
    [self.manager POST:path
            parameters:params
              progress:NULL
               success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                   if (responseObject && [responseObject isNotEqualTo:[NSNull null]]) {
                       success(YES, [FRWHttpTool dictionaryToJson:responseObject]);
                   }
                   else {
                       success(NO, @"");
                   }
               }
               failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                   !failure?:failure(error);
               }];
}

- (void)getRequestWithPath:(NSString *)path params:(NSDictionary *)params success:(FRWSuccess)success failure:(FRWFailure)failure {
    [self.manager GET:path
           parameters:params
             progress:NULL
              success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
                  if (responseObject && [responseObject isNotEqualTo:[NSNull null]]) {
                      success(YES, [FRWHttpTool dictionaryToJson:responseObject]);
                  }
                  else {
                      success(NO, @"");
                  }
              }
              failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                  !failure?:failure(error);
              }];
}

- (void)groupRequestWith:(NSArray<NSString *> *)paths params:(NSArray<NSDictionary *> *)parameters respondseObject:(void (^)(NSDictionary *))respondseObject {
    
    dispatch_group_t group = dispatch_group_create();
    
    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
    
    for (int i = 0; i < paths.count; i++) {
        
        dispatch_group_enter(group);
        [self getRequestWithPath:paths[i] params:parameters[i] success:^(BOOL success, NSString *json) {
            if (success) {
                [dic setObject:json forKey:paths[i]];
            }
            
            dispatch_group_leave(group);
        } failure:^(NSError *error) {
            
            [dic setObject:error forKey:paths[i]];
            
            dispatch_group_leave(group);
        }];
    }
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        !respondseObject?:respondseObject(dic);
    });
}

+ (AFHTTPSessionManager *)managerWithBaseUrl:(NSURL *)baseUrl {
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithBaseURL:baseUrl];
    return manager;
}

//转换成json字符串
+ (NSString*)dictionaryToJson:(NSDictionary *)dic

{
    if (!dic) {
        return @"";
    }
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}
@end
