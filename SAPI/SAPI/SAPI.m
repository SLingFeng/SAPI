//
//  SAPI.m
//  SAPI
//
//  Created by s on 2021/1/4.
//

#import "SAPI.h"

#define sWeakSelf __weak typeof(&*self) weakSelf = self;

@interface SAPI ()

@property (nonatomic, retain) NSDictionary *parameters;

@property (nonatomic, copy) NSString *urlString;

@property (nonatomic, copy) void(^didProgressBlock)(NSProgress * progress);

@property (nonatomic, copy) void(^didSuccessBlock)(SAPIResponseModel * response);

@property (nonatomic, copy) void(^didFailureBlock)(SAPIResponseModel * response);
///判断 成功code为当前设置，才调用回掉。默认200
@property (nonatomic, assign) NSInteger successCode;
///转换model
@property (nonatomic, retain) Class trClass;

@property (nonatomic, copy) NSString *dataKey;
@property (nonatomic, copy) NSString *msgKey;
@property (nonatomic, copy) NSString *codeKey;
///raw body
@property (nonatomic, copy) NSString *bodyStr;

@property (nonatomic, retain) NSDictionary<id, NSString *> * headers;

@property (nonatomic, weak) NSURLSessionDataTask *task;
@end

@implementation SAPI
//AFHTTPSessionManager
static AFHTTPSessionManager *_sessionManager = nil;

+ (AFHTTPSessionManager *)sessionManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sessionManager = [[AFHTTPSessionManager alloc] init];
        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    });
    return _sessionManager;
}

//AFURLSessionManager
static AFURLSessionManager *_urlSessionManager = nil;

+ (AFURLSessionManager *)urlSessionManager {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _urlSessionManager = [[AFURLSessionManager alloc] initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
//        _sessionManager.responseSerializer = [AFJSONResponseSerializer serializer];
//        _sessionManager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript",@"text/html", nil];
    });
    return _urlSessionManager;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.successCode = 200;
        
    }
    return self;
}

#pragma mark - 请求 设置相关参数
- (instancetype)makeParameters:(NSDictionary *)parameters {
    self.parameters = parameters;
    return self;
}

- (instancetype)makeUrlString:(NSString *)urlString {
    self.urlString = urlString;
    return self;
}

- (instancetype)makeSuccessCode:(NSInteger)successCode {
    self.successCode = successCode;
    return self;
}

- (instancetype)makeTrClass:(Class)trClass {
    self.trClass = trClass;
    return self;
}

- (instancetype)makeDataKey:(NSString *)dataKey {
    self.dataKey = dataKey;
    return self;
}

- (instancetype)makeMsgKey:(NSString *)msgKey {
    self.msgKey = msgKey;
    return self;
}

- (instancetype)makeCodeKey:(NSString *)codeKey {
    self.codeKey = codeKey;
    return self;
}

- (instancetype)makeBodyStr:(NSString *)bodyStr {
    self.bodyStr = bodyStr;
    return self;
}

- (instancetype)makeHeaders:(NSDictionary <NSString *,NSString *> *)headers {
    self.headers = headers;
    return self;
}

- (instancetype)makeDidProgress:(void(^) (NSProgress * progress))didProgressBlock {
    self.didProgressBlock = didProgressBlock;
    return self;
}

- (instancetype)makeDidSuccessBlock:(void(^) (SAPIResponseModel * response))didSuccessBlock {
    self.didSuccessBlock = didSuccessBlock;
    return self;
}

- (instancetype)makeDidFailureBlock:(void(^) (SAPIResponseModel * response))didFailureBlock {
    self.didFailureBlock = didFailureBlock;
    return self;
}
//
//- (instancetype)makeParameters:(NSDictionary *)parameters {
//    self.parameters = parameters;
//    return self;
//}

#pragma mark - 请求 AFHTTPSessionManager
//NSURLSessionDataTask *

- (instancetype)GET {
    sWeakSelf;
    NSURLSessionDataTask *task = [[SAPI sessionManager] GET:self.urlString parameters:self.parameters headers:self.headers progress:^(NSProgress * _Nonnull downloadProgress) {
        if (weakSelf.didProgressBlock) {
            weakSelf.didProgressBlock(downloadProgress);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        weakSelf.task = task;
        //使用self才能请求结束回掉，不然提起释放
        [self requestDidSuccee:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        weakSelf.task = task;
        [self requestDidFailure:error];
        
    }];
    self.task = task;
    
    return self;
}

- (instancetype)POST {
    sWeakSelf;
    NSURLSessionDataTask *task = [[SAPI sessionManager] POST:self.urlString parameters:self.parameters headers:self.headers progress:^(NSProgress * _Nonnull downloadProgress) {
        if (weakSelf.didProgressBlock) {
            weakSelf.didProgressBlock(downloadProgress);
        }
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        weakSelf.task = task;
        //使用self才能请求结束回掉，不然提起释放
        [self requestDidSuccee:responseObject];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//        weakSelf.task = task;        
        [self requestDidFailure:error];
        
    }];
    self.task = task;
    
    return self;
}

#pragma mark - 请求 AFURLSessionManager

- (instancetype)GET_URL {
    sWeakSelf;
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"GET" URLString:self.urlString parameters:self.parameters error:nil];
    
    NSData *postData = [self.bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:[NSString stringWithFormat:@"%lu",postData.length] forHTTPHeaderField:@"Content-Length"];

    [req setHTTPBody:postData];

    [self.headers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id _Nonnull obj, BOOL * _Nonnull stop) {
        [req setValue:obj forHTTPHeaderField:key];
    }];
    
    NSURLSessionDataTask *task = [[SAPI urlSessionManager] dataTaskWithRequest:req uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        if (weakSelf.didProgressBlock) {
            weakSelf.didProgressBlock(uploadProgress);
        }
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        weakSelf.task = task;
        if (error) {
            [self requestDidFailure:error];
        }else {
        //使用self才能请求结束回掉，不然提起释放
            [self requestDidSuccee:responseObject];
        }
    }];
    [task resume];
    self.task = task;

    return self;
}

- (instancetype)POST_URL {
    sWeakSelf;
    NSMutableURLRequest *req = [[AFJSONRequestSerializer serializer] requestWithMethod:@"POST" URLString:self.urlString parameters:self.parameters error:nil];
    
    NSData *postData = [self.bodyStr dataUsingEncoding:NSUTF8StringEncoding];
    [req setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [req setValue:@"application/json" forHTTPHeaderField:@"Accept"];
    [req setValue:[NSString stringWithFormat:@"%lu",postData.length] forHTTPHeaderField:@"Content-Length"];

    [req setHTTPBody:postData];

    [self.headers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id _Nonnull obj, BOOL * _Nonnull stop) {
        [req setValue:obj forHTTPHeaderField:key];
    }];
    
    NSURLSessionDataTask *task = [[SAPI urlSessionManager] dataTaskWithRequest:req uploadProgress:^(NSProgress * _Nonnull uploadProgress) {
        if (weakSelf.didProgressBlock) {
            weakSelf.didProgressBlock(uploadProgress);
        }
    } downloadProgress:^(NSProgress * _Nonnull downloadProgress) {
        
    } completionHandler:^(NSURLResponse * _Nonnull response, id  _Nullable responseObject, NSError * _Nullable error) {
//        weakSelf.task = task;
        if (error) {
            [self requestDidFailure:error];
        }else {
        //使用self才能请求结束回掉，不然提起释放
            [self requestDidSuccee:responseObject];
        }
    }];
    [task resume];
    self.task = task;

    return self;
}

#pragma mark - 请求成功
- (void)requestDidSuccee:(id)responseObject {
    NSLog(@"请求成功：urlString:%@-headers:%@-parameters:%@", self.urlString, self.headers, self.parameters);
    SAPIResponseModel *res = [SAPIResponseModel yy_modelWithDictionary:responseObject];
    res.responseObject = responseObject;
    
    if (self.codeKey) {
        res.code = [responseObject objectForKey:self.codeKey];
    }
    
    if ([res.code integerValue] == self.successCode) {
        //转换model
        if (self.trClass) {
            id model = [self modelGetWhitData:res];
            res.model = model;
        }
        
        //dataKey
        if (self.dataKey) {
            res.data = [responseObject objectForKey:self.dataKey];
        }
        
        if (self.msgKey) {
            res.msg = [responseObject objectForKey:self.msgKey];
        }
        
        
        if (self.didSuccessBlock) {
            self.didSuccessBlock(res);
        }
    }else {
        
        if (self.didFailureBlock) {
            self.didFailureBlock(res);
        }
    }
    
}

- (void)requestDidFailure:(NSError *)error {
    NSLog(@"请求失败：urlString:%@-headers:%@-parameters:%@", self.urlString, self.headers, self.parameters);

    SAPIResponseModel *res = [[SAPIResponseModel alloc] init];
    
    res.code = [NSString stringWithFormat:@"%ld", error.code];
    res.msg = [error localizedDescription];
    
    if (self.didFailureBlock) {
        self.didFailureBlock(res);
    }
}

- (id)modelGetWhitData:(SAPIResponseModel *)res {
    id model = nil;
    if (res.data) {
        
        if ([res.data isKindOfClass:[NSArray class]]) {
            model = [NSArray yy_modelArrayWithClass:self.trClass json:res.data];
        }else if ([res.data isKindOfClass:[NSDictionary class]]) {
            model = [self.trClass yy_modelWithDictionary:res.data];//非数组返回res.data
        }else {
            model = [self.trClass yy_modelWithDictionary:res.responseObject];
        }
        
    }
    return model;
}

- (void)dealloc {
    self.didSuccessBlock = nil;
    self.didFailureBlock = nil;
    
    [self.task cancel];
    self.task = nil;
    NSLog(@"请求结束：urlString:%@-headers:%@-parameters:%@", self.urlString, self.headers, self.parameters);
}

@end
