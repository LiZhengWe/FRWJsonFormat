//
//  FRWFileContentFormat.m
//  FRWJsonFormat
//
//  Created by yiner on 2018/6/27.
//  Copyright © 2018年 yiner. All rights reserved.
//

#import "FRWFileContentFormat.h"
#import "FRWDialogController.h"
#import "FRWFileManager.h"
#import "FRWParameterModel.h"

@interface FRWFileContentFormat ()

@property (nonatomic, copy) NSString *requestClassName;

@end

@implementation FRWFileContentFormat

+ (FRWFileContentFormat *)shareInstance {
    static FRWFileContentFormat *format = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        format = [[self alloc] init];
    });
    return format;
}

// 生成request文件
- (void)creatRequestFile {
    
    
    FRWDialogController *dialog = [[FRWDialogController alloc] initWithWindowNibName:@"FRWDialogController"];
    
    NSString *message = [NSString stringWithFormat:@"输入request类的名字："];
    
    __weak typeof (self) weakSelf = self;
    [dialog dataWithMessage:message defaultClassName:@"Request" start:^(NSString *className) {
        weakSelf.requestClassName = className;
    }];
    
    [NSApp beginSheet:[dialog window] modalForWindow:[NSApp mainWindow] modalDelegate:nil didEndSelector:nil contextInfo:nil];
    [NSApp runModalForWindow:[dialog window]];
    
    
    NSString *requestHClassName = [NSString stringWithFormat:@"%@.h",self.requestClassName];
    NSString *requestMClassName = [NSString stringWithFormat:@"%@.m",self.requestClassName];
    
    NSString *folderPath = [[NSUserDefaults standardUserDefaults] valueForKey:@"folderPath"];
    if (folderPath) {
        
        [[FRWFileManager sharedInstance] handlePath:folderPath hFileName:requestHClassName mFileName:requestMClassName hContent:[self requestClassHContent] mContent:[self requestClassMContent] isRequestFile:YES];
        [[NSWorkspace sharedWorkspace] openFile:folderPath];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"creatFileSuccess" object:nil];
    }else{
        
        NSOpenPanel *panel = [NSOpenPanel openPanel];
        [panel setCanChooseDirectories:YES];
        [panel setCanCreateDirectories:YES];
        [panel setCanChooseFiles:NO];
        
        NSInteger result = [panel runModal];
        
        if (result == NSModalResponseOK) {
            NSString *folderPath = [[[panel URLs] objectAtIndex:0] relativePath];
            [[NSUserDefaults standardUserDefaults] setValue:nil forKey:@"folderPath"];
            
            [[FRWFileManager sharedInstance] handlePath:folderPath hFileName:requestHClassName mFileName:requestMClassName hContent:[self requestClassHContent] mContent:[self requestClassMContent] isRequestFile:YES];
            [[NSWorkspace sharedWorkspace] openFile:folderPath];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"creatFileSuccess" object:nil];
        }
        else if ([panel runModal] == NSModalResponseCancel) {
            NSAlert *alert = [[NSAlert alloc] init];
            [alert setMessageText:@"取消了路径选择"];
            [alert setInformativeText:@"取消文件选择之后需重新点击“生成request文件”来再次进行类文件命名及路径选择"];
            [alert setAlertStyle:NSAlertStyleWarning];
            [alert runModal];
        }
    }
}

// 请求文件H内容
- (NSString *)requestClassHContent {
    NSString *hcontent = [NSString stringWithFormat:@"@interface %@ : NSObject<FRWHttpRequesting>\n\n", self.requestClassName];
    
    for (FRWParameterModel *model in self.dataArr) {
        if (![model.key isEqualToString:@""]) {
            hcontent = [hcontent stringByAppendingString:@"- (instancetype)initWithParams:(NSDictionary *)param;\n\n"];
            break;
        }
    }
    
    hcontent = [hcontent stringByAppendingString:@"@end"];
    
    return hcontent;
}

// 请求文件M文件内容
- (NSString *)requestClassMContent {
    
    BOOL isIncludeParams = NO;
    NSString *mcontent = @"";
    NSString *interfceString = [NSString stringWithFormat:@"@interface %@ ()\n", self.requestClassName];
    NSString *implementationString = [NSString stringWithFormat:@"@implementation %@\n", self.requestClassName];
    NSString *initMethodString = @"- (instancetype)initWithParams:(NSDictionary *)param {\n    self = [super init];\n    if (self) {\n        _param = param;\n    }\n    return self;\n}\n";
    
    
    NSString *detailString = [self requestClassMDetail];
    for (FRWParameterModel *model in self.dataArr) {
        if (![model.key isEqualToString:@""]) {
            isIncludeParams = YES;
            break;
        }
    }
    if (isIncludeParams) {
        mcontent = [[[[[mcontent stringByAppendingString:interfceString] stringByAppendingString:@"@property (nonnull, strong) NSDictionary *param;\n@end\n"] stringByAppendingString:implementationString] stringByAppendingString:initMethodString] stringByAppendingString:detailString];
    }
    else {
        mcontent = [[mcontent stringByAppendingString:implementationString] stringByAppendingString:detailString];
    }
    
    return mcontent;
}


// 请求文件M核心内容
- (NSString *)requestClassMDetail {
    
    BOOL isIncludeParams = NO;
    NSString *paramsString = @"";
    for (FRWParameterModel *model in self.dataArr) {
        if (![model.key isEqualToString:@""]) {
            isIncludeParams = YES;
            break;
        }
    }
    if (isIncludeParams) {
        paramsString = @"return self.param;";
    }
    else {
        paramsString = @"return @{};";
    }
    
    NSString *requestBlockStr = self.isPost ? @"[FRWHttpBridge postWithRequest:self success:success failure:failure];" : @"[FRWHttpBridge getWithRequest:self success:success failure:failure];";
    
    NSString *detailStirng = [NSString stringWithFormat:@"#pragma mark - FRWHttpRequesting\n/**\n *  请求路径\n *\n *  @return 路径\n */\n- (NSString *)requestPatch {\n    return @\"%@\";\n}\n/**\n *  请求所需参数\n *\n *  @return 请求参数\n */\n- (NSDictionary *)params {\n    %@\n}\n/**\n *  异步请求\n *\n *  @param success 成功回调\n *  @param failure 失败回调\n */\n- (void)asyncRequestSuccess:(HttpBridgeSuccess)success failure:(HttpBridgeFailure)failure {\n   %@\n}\n\n@end",self.urlPath, paramsString, requestBlockStr];
    return detailStirng;
}

- (void)setDataArr:(NSArray *)dataArr {
    _dataArr = dataArr;
}

- (void)setIsPost:(BOOL)isPost {
    _isPost = isPost;
}

- (void)setUrlPath:(NSString *)urlPath {
    _urlPath = urlPath;
}

@end
