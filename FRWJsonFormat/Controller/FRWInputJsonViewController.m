//
//  FRWInputJsonViewController.m
//  FRWJsonFormat
//
//  Created by yiner on 2018/3/2.
//  Copyright © 2018年 yiner. All rights reserved.
//

#import "FRWInputJsonViewController.h"
#import "FRWJsonParse.h"
#import "FRWDialogController.h"
#import "FRWJsonFormatSetting.h"
#import "FRWFileManager.h"
#import "FRWParameterModel.h"
#import "FRWChooseModelWindow.h"
#import "Mock.h"
#import "MockJsonModel.h"
#import "FRWHelpWindowController.h"
#import "FRWStringFormat.h"
#import "FRWParseForFiles.h"
#import "FRWUtils.h"
#import "FRWFileContentFormat.h"
#import <YYModel/YYModel.h>
#import "FRWLoadingView.h"
#import "FRWHttpTool.h"

@interface FRWInputJsonViewController ()<NSTabViewDelegate, NSTableViewDataSource, NSTextFieldDelegate, NSTextDelegate>

@property (nonatomic, strong) FRWDialogController *dialog;

@property (nonatomic, copy) NSString *requestClassName;

// baseUrl
@property (weak) IBOutlet NSTextField *baseUrlTextField;
// 参数tableView
@property (weak) IBOutlet NSTableView *tableView;
// 全局Mock按钮， 选中后会使用rap某个项目的url获取此项目所有接口mock信息， 并选择其中一个进行生成文件
@property (weak) IBOutlet NSButton *globalMockBtn;
// 是否生成请求文件
@property (weak) IBOutlet NSButton *requestFileBtn;
//  帮助按钮
@property (weak) IBOutlet NSButton *helpBtn;
//  是否选择全部生成文件
@property (weak) IBOutlet NSButton *allToFileBtn;
// 保存参数模型数组
@property (nonatomic,strong) NSMutableArray *dataArr;
// 记录tableView中celld个数
@property (nonatomic,assign) NSInteger rowCount;
// 当前选中
@property (nonatomic,assign) NSInteger  selectedRow;
// request Type
@property (nonatomic,assign) BOOL isPost;
// model.H文件
@property (nonatomic, copy) NSString *modelHString;
// model.M文件
@property (nonatomic, copy) NSString *modelMString;

@property (nonatomic, assign) BOOL mockSecondRequest;

@property (nonatomic, strong) actionList *currentActionList;

@property (nonatomic, strong) FRWParseForFiles *parseFiles;

@end

@implementation FRWInputJsonViewController

- (void)awakeFromNib {
    [super awakeFromNib];
    self.mockSecondRequest = NO;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    NSString *baseUrl = [[NSUserDefaults standardUserDefaults] valueForKey:@"BaseUrl"];
    if (baseUrl.length > 0) {
        self.baseUrlTextField.stringValue = baseUrl;
        if ([baseUrl isEqualToString:[FRWStringFormat shareInstance].globalMockUrl]) {
            self.globalMockBtn.state = NSControlStateValueOn;
            self.requestFileBtn.state = NSControlStateValueOn;
        }
        else {
            self.globalMockBtn.state = NSControlStateValueOff;
            self.requestFileBtn.state = NSControlStateValueOff;
        }
    }
    else {
        self.baseUrlTextField.stringValue = self.globalMockBtn.state == NSControlStateValueOn ? [FRWStringFormat shareInstance].globalMockUrl : @"";
    }
    if (self.globalMockBtn.state == NSControlStateValueOn) {
        [self globalMockDataArr];
    }
    else {
        [self clearDataArr];
    }
    self.baseUrlTextField.delegate = self;
    [self.tableView reloadData];
}

- (instancetype)initWithNibName:(NSNibName)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.rowCount = 1;
        self.selectedRow = -1;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(creatFileSuccess:) name:@"creatFileSuccess" object:nil];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do view setup here.
    
}

#pragma mark - NSTableViewDataSource -
- (NSInteger)numberOfRowsInTableView:(NSTableView *)tableView {
    return self.rowCount;
}

- (nullable id)tableView:(NSTableView *)tableView objectValueForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row {
    return nil;
}

- (CGFloat)tableView:(NSTableView *)tableView heightOfRow:(NSInteger)row
{
    return 58;
}

- (nullable NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(nullable NSTableColumn *)tableColumn row:(NSInteger)row {
    NSString *stringId = [tableColumn identifier];
    NSTableCellView *view = [tableView makeViewWithIdentifier:stringId owner:self];
    
    if (!view) {
        view = [[NSTableCellView alloc] initWithFrame:CGRectMake(0, 0, tableColumn.width, 58)];
    }
    else {
        for (NSView *subView in view.subviews) {[subView removeFromSuperview];}
    }

    NSTextField *txtFiled = [[NSTextField alloc] initWithFrame:CGRectMake(15, 20, 150, 30)];
    
    FRWParameterModel *model = nil;
    
    if (self.dataArr.count > 0) {
        model = self.dataArr[row];
    }
    
    if ([stringId isEqualToString:@"key"]) {
        txtFiled.stringValue = model.key;
        txtFiled.placeholderString  = @"key";
        txtFiled.tag = 110+row;
    }
    
    if ([stringId isEqualToString:@"value"]) {
        txtFiled.stringValue = model.value;
        txtFiled.placeholderString  = @"value";
        txtFiled.tag = 160+row;
    }
    
    txtFiled.font = [NSFont systemFontOfSize:15.0f];
    txtFiled.textColor = [NSColor blackColor];
    txtFiled.drawsBackground = NO;
    txtFiled.bordered = NO;
    txtFiled.delegate = self;
    txtFiled.focusRingType = NSFocusRingTypeNone;
    txtFiled.editable = YES;
    [view addSubview:txtFiled];
    
    return view;
}

- (BOOL)tableView:(NSTableView *)tableView shouldSelectRow:(NSInteger)row
{
    self.selectedRow = row;
    return YES;
}

#pragma mark - NSTextFieldDelegate -
- (void)controlTextDidEndEditing:(NSNotification *)obj {
    NSTextField *txtF = (NSTextField *)obj.object;
    FRWParameterModel *model = [FRWParameterModel new];
    
    if (txtF.tag < 160 && txtF.tag >= 110) {
        model.key = txtF.stringValue;
        FRWParameterModel *parameterModel = self.dataArr[txtF.tag - 110];
        parameterModel.key = model.key;
    }
    else if (txtF.tag >= 160) {
        model.value = txtF.stringValue;
        FRWParameterModel *parameterModel = self.dataArr[txtF.tag - 160];
        parameterModel.value = model.value;
    }
    else if (txtF.tag == 99) {
        NSString *originBaseUrl = [[NSUserDefaults standardUserDefaults] valueForKey:@"BaseUrl"];
        NSString *newBaseUrl = txtF.stringValue;
        if (!originBaseUrl || ![originBaseUrl isEqualToString:newBaseUrl] || [originBaseUrl isEqualToString:@""]) {
            [[NSUserDefaults standardUserDefaults] setValue:txtF.stringValue forKey:@"BaseUrl"];
        }
    }
}

#pragma mark - Action -
// 增加参数
- (IBAction)addParamAction:(id)sender {
    
    if (self.rowCount == 10) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"\n最多添加10个参数！！"];
        [alert runModal];
        return;
    }
    
    self.rowCount += 1;
    
    [self.tableView beginUpdates];
    
    [self.tableView insertRowsAtIndexes:[NSIndexSet indexSetWithIndex:self.rowCount - 1] withAnimation:NSTableViewAnimationSlideDown];
    
    [self.tableView endUpdates];
}
// 删除参数
- (IBAction)delelteParamAction:(id)sender {
    
    if (self.rowCount == 0) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"\n没有参数了！！"];
        [alert runModal];
        return;
    }
    
    if (self.selectedRow == -1) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"\n请选择你想删除的行"];
        [alert runModal];
        return;
    }
    
    [self.tableView beginUpdates];
    
    [self.tableView removeRowsAtIndexes:[NSIndexSet indexSetWithIndex:self.selectedRow] withAnimation:NSTableViewAnimationSlideUp];
    
    [self.tableView endUpdates];
    
    [self.dataArr removeObjectAtIndex:self.selectedRow];
    FRWParameterModel *model = [FRWParameterModel new];
    model.key = @"";
    model.value = @"";
    [self.dataArr addObject:model];
    self.selectedRow = -1;
    self.rowCount -= 1;
}


// 开始请求
- (IBAction)startRequestAction:(id)sender {
    
    NSAlert *alert = [[NSAlert alloc] init];
    
    if ([self.baseUrlTextField.stringValue isEqualToString:@""]) {
        [alert setMessageText:@"\n请输入完整的URL！！"];
        [alert runModal];
        return;
    }
    
    if (![self requestParamsCheck]) {
        [alert setMessageText:@"\n参数格式不正确！！"];
        [alert runModal];
        return;
    }
    NSString *originBaseUrl = [[NSUserDefaults standardUserDefaults] valueForKey:@"BaseUrl"];
    NSString *newBaseUrl = self.baseUrlTextField.stringValue;
    if (!originBaseUrl || ![originBaseUrl isEqualToString:newBaseUrl] || [originBaseUrl isEqualToString:@""]) {
        [[NSUserDefaults standardUserDefaults] setValue:newBaseUrl forKey:@"BaseUrl"];
    }
    
    [self requestWithUrl:self.baseUrlTextField.stringValue isPost:self.isPost parameters:[self getParamsDicFromDataArr:self.dataArr]];
}
// popUpButton
- (IBAction)postOrGetAction:(id)sender {
    
    NSPopUpButton *popUpBtn = (NSPopUpButton *)sender;
    NSInteger selectedIndex = popUpBtn.indexOfSelectedItem;
    self.isPost = selectedIndex == 0;
}

- (IBAction)globalMockAction:(NSButton *)sender {
    if (sender.state == NSControlStateValueOn) {
        self.baseUrlTextField.stringValue = [FRWStringFormat shareInstance].globalMockUrl;

        self.rowCount = 1;
        self.selectedRow = 0;
        [self globalMockDataArr];
        [self.tableView selectRowIndexes:[NSIndexSet indexSetWithIndex:0] byExtendingSelection:NO];
        [self.tableView reloadData];
        self.requestFileBtn.enabled = YES;
        self.allToFileBtn.enabled = YES;
    }
    else {
        self.requestFileBtn.enabled = NO;
        self.allToFileBtn.enabled = NO;
        self.rowCount = 1;
        self.selectedRow = -1;
        self.baseUrlTextField.stringValue = @"";
        [self.baseUrlTextField becomeFirstResponder];
        [self clearDataArr];
        [self.tableView reloadData];
    }
    self.requestFileBtn.state = sender.state;
    self.allToFileBtn.state = sender.state;
}


- (IBAction)generateModelAction:(id)sender {
    
    if (self.jsonInputTxtView.string.length < 1) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"json 不能为空"];
        [alert runModal];
        return;
    }
    
    id result = [FRWUtils dictionaryWithJson:self.jsonInputTxtView.string];
    
    if ([result isKindOfClass:[NSError class]]) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"json 格式错误"];
        [alert runModal];
    }
    else {
        __block id data = [NSDictionary dictionaryWithDictionary:result];
        [result enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            if ([key isEqualToString:@"data"]) {
                data = obj;
                *stop = YES;
            }
        }];
        FRWJsonParse *jsonClass = [self.parseFiles handleClassWithResult:data];
        [self outputResult:jsonClass];
    }
}

- (IBAction)helpBtnClick:(id)sender {
    FRWHelpWindowController *help = [[FRWHelpWindowController alloc] initWithWindowNibName:@"FRWHelpWindowController"];
    [NSApp runModalForWindow:help.window];
}

#pragma mark - Request -

- (void)requestWithUrl:(NSString *)url isPost:(BOOL)isPost parameters:(NSDictionary *)params {
    
    [FRWLoadingView showLoadingWithView:self.view];
    [[FRWHttpTool shareTool] beginRequestWithUrlString:url parameters:params requestType:isPost? RequestTypePost : RequestTypeGet success:^(BOOL success, NSString *json) {
        [FRWLoadingView hiddenLoading];
        if (success) {
            [self refreshUI:json];
        }
    } failure:^(NSError *error) {
        [FRWLoadingView hiddenLoading];
    }];
}

#pragma mark - UI Configure -
- (void)refreshUI:(NSString *)jsonStr{
    __weak typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_main_queue(), ^{
        if (jsonStr.length < 1) {
            NSAlert *alert = [[NSAlert alloc] init];
            [alert setMessageText:@"返回数据为空！！！"];
            [alert runModal];
            return ;
        }
        weakSelf.jsonInputTxtView.string = jsonStr;
        
        id result = [FRWUtils dictionaryWithJson:jsonStr];
        if ([result isKindOfClass:[NSError class]]) {
            NSAlert *alert = [[NSAlert alloc] init];
            [alert setMessageText:@"json 格式错误"];
            [alert runModal];
        }else{
            __block id data = [NSDictionary dictionaryWithDictionary:result];
            [result enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                if ([key isEqualToString:@"data"]) {
                    data = obj;
                    *stop = YES;
                }
            }];
            if (self.mockSecondRequest || self.globalMockBtn.state != NSControlStateValueOn) {
                FRWJsonParse *jsonClass = [self.parseFiles handleClassWithResult:data];
                [self outputResult:jsonClass];
                self.mockSecondRequest = NO;
            }
            else {
                
                [self mockDataParse:data];
            }
        }
    });
}

// mock HTML数据解析 >>> 解析出某个或多个接口的 mock 请求链接后再请求
- (void)mockDataParse:(id)data {
    
    Mock *mockdata = [Mock yy_modelWithJSON:data];
    NSString *jsonString = mockdata.modelJSON;
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\r\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    jsonString = [jsonString stringByReplacingOccurrencesOfString:@"\\" withString:@""];
    id result = [FRWUtils dictionaryWithJson:jsonString];

    if ([result isKindOfClass:[NSError class]]) {
        NSAlert *alert = [[NSAlert alloc] init];
        [alert setMessageText:@"json 解析异常"];
        [alert runModal];
        return;
    }
    
    MockJsonModel *jsonModel = [MockJsonModel yy_modelWithDictionary:result];
    if (self.allToFileBtn.state == YES) {
        
        return;
    }
    NSMutableArray *nameArr = @[].mutableCopy;
    for (moduleList *module in jsonModel.moduleList) {
        [nameArr addObject:module.name];
    }
    FRWChooseModelWindow *windowC = [[FRWChooseModelWindow alloc] initWithWindowNibName:@"FRWChooseModelWindow"];
    windowC.moduleArray = nameArr;
    
    __weak typeof(self) weakSelf = self;
    __weak typeof(jsonModel) weakModel = jsonModel;
    windowC.nextBlock = ^(NSInteger index) {
        [weakSelf showPageListWithModule:weakModel.moduleList[index]];
    };

    [NSApp runModalForWindow:windowC.window];
}


- (void)showPageListWithModule:(moduleList *)module {
    
    NSMutableArray *nameArr = @[].mutableCopy;
    for (pageList *page in module.pageList) {
        [nameArr addObject:page.name];
    }
    FRWChooseModelWindow *windowC = [[FRWChooseModelWindow alloc] initWithWindowNibName:@"FRWChooseModelWindow"];
    windowC.moduleArray = nameArr;
    __weak typeof(self) weakSelf = self;
    __weak typeof(module) weakModule = module;
    windowC.nextBlock = ^(NSInteger index) {
        [weakSelf showActionListWithPage:weakModule.pageList[index]];
    };
    
    [NSApp runModalForWindow:windowC.window];
}

- (void)showActionListWithPage:(pageList *)page {
    NSMutableArray *nameArr = @[].mutableCopy;
    for (actionList *action in page.actionList) {
        [nameArr addObject:action.name];
    }
    FRWChooseModelWindow *windowC = [[FRWChooseModelWindow alloc] initWithWindowNibName:@"FRWChooseModelWindow"];
    windowC.moduleArray = nameArr;
    __weak typeof(self) weakSelf = self;
    __weak typeof(page) weakPage = page;
    windowC.nextBlock = ^(NSInteger index) {
        NSLog(@"%@",weakPage.actionList[index]);
        weakSelf.currentActionList = weakPage.actionList[index];
        NSDictionary *params = [weakSelf getParamsDicFromDataArr:weakSelf.dataArr];
        NSString *projectId = params[@"projectId"];
        NSString *url = [NSString stringWithFormat:@"http://mock.2dfire-daily.com/mock-serverapi/mockjsdata/%@/%@", projectId,weakSelf.currentActionList.requestUrl];
        self.mockSecondRequest = YES;
        [weakSelf requestWithUrl:url isPost:weakSelf.isPost parameters:@{}];
    };
    
    [NSApp runModalForWindow:windowC.window];
}

#pragma mark - Creat File -
- (void)outputResult:(FRWJsonParse *)classInfo {
    
    NSString *mContent = [NSString stringWithFormat:@"%@\n%@", classInfo.classContentForM,classInfo.classInsertTextViewContentForM];
    
    self.modelMString = mContent;
    
    self.modelHString = [[classInfo.classContent stringByAppendingString:[NSString stringWithFormat:@"\n%@",classInfo.classContentForH]] stringByAppendingString:[NSString stringWithFormat:@"\n%@",classInfo.classInsertTextViewContentForH]];
    
    [self creatFile];
    
}

// 生成文件
- (void)creatFile {
    NSString *folderPath = [[NSUserDefaults standardUserDefaults] valueForKey:@"folderPath"];
    NSString *hName = [NSString stringWithFormat:@"%@.h",self.parseFiles.modelName];
    NSString *mName = [NSString stringWithFormat:@"%@.m",self.parseFiles.modelName];
    if (folderPath) {
        [[FRWFileManager sharedInstance] handlePath:folderPath hFileName:hName mFileName:mName hContent:self.modelHString mContent:self.modelMString isRequestFile:NO];
        [[NSWorkspace sharedWorkspace] openFile:folderPath];
    }else{
        
        NSOpenPanel *panel = [NSOpenPanel openPanel];
        [panel setCanChooseDirectories:YES];
        [panel setCanCreateDirectories:YES];
        [panel setCanChooseFiles:NO];
        
        NSInteger result = [panel runModal];
        
        if (result == NSModalResponseOK) {
            NSString *folderPath = [[[panel URLs] objectAtIndex:0] relativePath];
            [[NSUserDefaults standardUserDefaults] setValue:folderPath forKey:@"folderPath"];
            
            [[FRWFileManager sharedInstance] handlePath:folderPath hFileName:hName mFileName:mName hContent:self.modelHString mContent:self.modelMString isRequestFile:NO];
            [[NSWorkspace sharedWorkspace] openFile:folderPath];
        }
        else if ([panel runModal] == NSModalResponseCancel) {
            NSAlert *alert = [[NSAlert alloc] init];
            [alert setMessageText:@"取消了路径选择"];
            [alert setInformativeText:@"取消文件选择之后需重新点击“生成Model”来再次进行类文件命名及路径选择"];
            [alert setAlertStyle:NSAlertStyleWarning];
            [alert addButtonWithTitle:@"我知道了"];
            [alert beginSheetModalForWindow:[self.view window] completionHandler:^(NSModalResponse returnCode) {
            }];
        }
    }
    
    if (self.requestFileBtn.state == NSControlStateValueOn) {
        if (!self.currentActionList && self.globalMockBtn.state == NSControlStateValueOn) {
            NSAlert *alert = [[NSAlert alloc] init];
            [alert setMessageText:@"请重新请求， 并且选择其中一个需要生成的选项"];
            [alert runModal];
            return;
        }
        NSString *urlPath = self.globalMockBtn.state == NSControlStateValueOn ? [FRWStringFormat urlFromOriginalUrl:self.currentActionList.requestUrl] : [FRWStringFormat urlFromOriginalUrl:self.baseUrlTextField.stringValue];
        [FRWFileContentFormat shareInstance].isPost = [self requestType];
        [FRWFileContentFormat shareInstance].urlPath = urlPath;
        [FRWFileContentFormat shareInstance].dataArr = self.dataArr;
        [[FRWFileContentFormat shareInstance] creatRequestFile];
    }
}

#pragma mark - Private Method -
// 生成请求参数dic
- (NSDictionary *)getParamsDicFromDataArr:(NSArray *)dataArr{
    NSMutableDictionary * params = [NSMutableDictionary dictionary];
    for (FRWParameterModel *dataModel in self.dataArr) {
        
        if (![dataModel.key isEqualToString:@""]) {
            params[dataModel.key] = dataModel.value;
        }
    }
    return [params copy];
}

- (BOOL)requestParamsCheck {
    if (self.globalMockBtn.state == NSControlStateValueOn) {
        NSDictionary *params = [self getParamsDicFromDataArr:self.dataArr];
        NSString *value = params[@"projectId"];
        if (value.length > 0) {
            return YES;
        }
        return NO;
    }
    return YES;
}

- (BOOL)requestType {
    if (self.currentActionList && [self.currentActionList.requestType integerValue] == RequestTypePost) {
        return YES;
    }
    else {
        return self.isPost;
    }
}

#pragma mark - NSNotification -
-(void)windowWillClose:(NSNotification *)notification{
    if ([self.delegate respondsToSelector:@selector(windowWillClose)]) {
        [self.delegate windowWillClose];
    }
}

- (void)creatFileSuccess:(NSNotification *)notify {
    self.currentActionList = nil;
}

- (void)clearDataArr {
    self.dataArr = @[].mutableCopy;
    for (int i=0; i<10; i++) {
        
        FRWParameterModel *dataModel = [FRWParameterModel new];
        dataModel.key = @"";
        dataModel.value = @"";
        [self.dataArr addObject:dataModel];
    }
}

- (void)globalMockDataArr {
    
    self.dataArr = @[].mutableCopy;
    for (int i=0; i<10; i++) {
        
        FRWParameterModel *dataModel = [FRWParameterModel new];
        dataModel.key = i == 0 ? @"projectId" : @"";
        dataModel.value = @"";
        [self.dataArr addObject:dataModel];
    }
}

#pragma mark - set & get -
- (FRWParseForFiles *)parseFiles {
    if (!_parseFiles) {
        _parseFiles = [[FRWParseForFiles alloc] init];
    }
    return _parseFiles;
}

@end
