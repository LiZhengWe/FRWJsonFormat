//
//  FRWFileManager.m
//  FRWJsonFormat
//
//  Created by yiner on 2018/3/27.
//  Copyright © 2018年 yiner. All rights reserved.
//

#import "FRWFileManager.h"

@implementation FRWFileManager

+ (FRWFileManager *)sharedInstance {
    static FRWFileManager *fileManager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        fileManager = [[self alloc] init];
    });
    
    return fileManager;
}

- (void)handlePath:(NSString *)folderPath
         hFileName:(NSString *)hFileName
         mFileName:(NSString *)mFileName
         hContent :(NSString *)hContent
         mContent :(NSString *)mContent
     isRequestFile:(BOOL)isRequestFile {

    NSDictionary *infoDic = [[NSBundle mainBundle] infoDictionary];
    NSString *appName = [infoDic objectForKey:@"CFBundleName"];
    NSString *userName = NSUserName();
    NSString *hModelInfoStr = [NSString stringWithFormat:@"//\n//  %@\n//  %@\n//\n//  Created by %@ on %@\n//  Copyright © %@ %@. All rights reserved.\n//\n\n" , hFileName, appName, userName, [self getDateStr], [self dateString], userName];
    NSString *mModelInfoStr = [NSString stringWithFormat:@"//\n//  %@\n//  %@\n//\n//  Created by %@ on %@\n//  Copyright © %@ %@. All rights reserved.\n//\n\n" , mFileName, appName, userName, [self getDateStr], [self dateString], userName];
    NSMutableString *hImportStr = nil;
    NSString *mImportStr = nil;
    NSString *newHContent = nil;
    NSString *newMContent = nil;
    
    hImportStr = [NSMutableString stringWithString:@"#import <Foundation/Foundation.h>\n\n"];

    if (isRequestFile) {
        [hImportStr appendString:@"\n#import <FRWHttp/FRWHttp.h>\n\n"];
    }
    NSString *superClassString = [[NSUserDefaults standardUserDefaults] valueForKey:@"SuperClass"];
    if (superClassString && superClassString.length > 0) {
        [hImportStr appendString:[NSString stringWithFormat:@"#import \"%@\" \n\n",superClassString]];
    }
    
    mImportStr = [NSString stringWithFormat:@"#import \"%@\" \n",hFileName];
    newHContent = [NSString stringWithFormat:@"%@%@%@", hModelInfoStr, hImportStr, hContent];
    newMContent = [NSString stringWithFormat:@"%@%@%@", mModelInfoStr, mImportStr, mContent];
    
    [self creatFileWithFolderPath:folderPath hFileName:hFileName mFileName:mFileName hContent:newHContent mContent:newMContent];
    
}

- (void)creatFileWithFolderPath:(NSString *)folderPath
                      hFileName:(NSString *)hFileName
                      mFileName:(NSString *)mFileName
                       hContent:(NSString *)hContent
                       mContent:(NSString *)mContent {
    [self creatFileWithFileName:[folderPath stringByAppendingPathComponent:hFileName] content:hContent];
    [self creatFileWithFileName:[folderPath stringByAppendingPathComponent:mFileName] content:mContent];
}

- (void)creatFileWithFileName:(NSString *)fileName content:(NSString *)content {
    
    NSFileManager *manager = [NSFileManager defaultManager];
    BOOL success = [manager createFileAtPath:fileName contents:[content dataUsingEncoding:NSUTF8StringEncoding] attributes:nil];
    
    
    if (success) {
        NSLog(@"文件创建成功！！！路径：%@", fileName);
    }
    else {
        NSLog(@"文件创建失败！！！路径：%@", fileName);
    }
}

- (NSString *)getDateStr{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy/MM/dd";
    return [formatter stringFromDate:[NSDate date]];
}

- (NSString *)dateString {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"yyyy年";
    
    return [formatter stringFromDate:[NSDate date]];
}

@end
