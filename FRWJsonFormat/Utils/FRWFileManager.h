//
//  FRWFileManager.h
//  FRWJsonFormat
//
//  Created by yiner on 2018/3/27.
//  Copyright © 2018年 yiner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FRWFileManager : NSObject
+ (FRWFileManager *)sharedInstance;
- (void)handlePath:(NSString *)folderPath
         hFileName:(NSString *)hFileName
         mFileName:(NSString *)mFileName
         hContent :(NSString *)hContent
         mContent :(NSString *)mContent
     isRequestFile:(BOOL)isRequestFile;

@end
