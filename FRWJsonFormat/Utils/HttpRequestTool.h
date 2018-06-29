//
//  HttpRequestTool.h
//  ESJsonFormatForMac
//
//  Created by ZX on 2017/6/2.
//  Copyright © 2017年 ZX. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^CompletioBlock)(NSDictionary *dic, NSURLResponse *response, NSError *error);
typedef void (^SuccessBlock)(NSString *jsonStr);
typedef void (^FailureBlock)(NSError *error);
typedef NS_ENUM(NSUInteger, RequestType) {
    RequestTypeGet = 1,
    RequestTypePost = 2,
};
@interface HttpRequestTool : NSObject<NSURLSessionDelegate>
/**
 *  get请求
 */
+ (void)getWithUrlString:(NSString *)url parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

/**
 * post请求
 */
+ (void)postWithUrlString:(NSString *)url parameters:(id)parameters success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;


+ (void)beginRequestWithUrlString:(NSString *)url parameters:(id)parameters requestType:(RequestType)requestType success:(SuccessBlock)successBlock failure:(FailureBlock)failureBlock;

@end
