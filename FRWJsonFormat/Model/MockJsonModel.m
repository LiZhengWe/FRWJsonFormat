//
//  MockJsonModel.m
//  FRWJsonFormat
//
//  Created by lizhengwei on 2018/06/14
//  Copyright © 2018年 lizhengwei. All rights reserved.
//

#import "MockJsonModel.h" 
@implementation MockJsonModel

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"moduleList" : [moduleList class]};
}


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end

@implementation user


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


@implementation moduleList

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"pageList" : [pageList class]};
}


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


@implementation pageList

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"actionList" : [actionList class]};
}


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


@implementation actionList

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"responseParameterList" : [responseParameterList class], @"requestParameterList" : [requestParameterList class]};
}


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


@implementation responseParameterList

+ (NSDictionary<NSString *,id> *)modelContainerPropertyGenericClass{
    return @{@"parameterList" : [parameterList class]};
}


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


@implementation parameterList


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


@implementation requestParameterList


+ (NSDictionary<NSString *,id> *)modelCustomPropertyMapper{
    return @{@"ID":@"id"};
}

@end


