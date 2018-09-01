//
//  FRWGroupRequestManager.m
//  FRWJsonFormat
//
//  Created by yiner on 2018/8/15.
//  Copyright © 2018年 yiner. All rights reserved.
//

#import "FRWGroupRequestManager.h"

@implementation FRWGroupRequestManager

+ (NSDictionary *)requestParametersFrom:(MockJsonModel *)jsonModel {
    NSMutableDictionary *params = @{}.mutableCopy;
    NSMutableArray *urlArray = @[].mutableCopy;
    NSMutableArray *paramArray = @[].mutableCopy;
    for (moduleList *module in jsonModel.moduleList) {
        for (pageList *page in module.pageList) {
            for (actionList *action in page.actionList) {
                NSString *url = action.requestUrl;
                if (url.length > 0) {
                    if ([[action.requestUrl substringToIndex:1] isEqualToString:@"/"]) {
                        url = [url substringFromIndex:1];
                    }
                    url = [NSString stringWithFormat:@"http://mock.2dfire-daily.com/mock-serverapi/mockjsdata/%ld/%@", (long)jsonModel.ID,url];
                }
                else {
                    url = @"";
                }
                
                [urlArray addObject:url];
                [paramArray addObject:action.requestParameterList];
            }
        }
    }
    [params setObject:urlArray forKey:FRWHttpGroupUrl];
    [params setObject:paramArray forKey:FRWHttpGroupParameters];
    return params;
}

@end
