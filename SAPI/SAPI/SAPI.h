//
//  SAPI.h
//  SAPI
//
//  Created by s on 2021/1/4.
//

#import <Foundation/Foundation.h>
#import <AFNetworking/AFNetworking.h>
#import <YYModel/YYModel.h>
#import "SAPIResponseModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface SAPI : NSObject

#pragma mark - 请求 设置相关参数
- (instancetype)makeParameters:(NSDictionary *)parameters;

- (instancetype)makeUrlString:(NSString *)urlString;

- (instancetype)makeSuccessCode:(NSInteger)successCode;

- (instancetype)makeTrClass:(Class)trClass;

- (instancetype)makeDataKey:(NSString *)dataKey;

- (instancetype)makeMsgKey:(NSString *)msgKey;

- (instancetype)makeCodeKey:(NSString *)codeKey;

- (instancetype)makeBodyStr:(NSString *)bodyStr;

- (instancetype)makeHeaders:(NSDictionary <NSString *,NSString *> *)headers;

- (instancetype)makeDidSuccessBlock:(void(^) (SAPIResponseModel * response))didSuccessBlock;

- (instancetype)makeDidFailureBlock:(void(^) (SAPIResponseModel * response))didFailureBlock;

#pragma mark - 请求

- (instancetype)GET;
- (instancetype)POST;

- (instancetype)GET_URL;
- (instancetype)POST_URL;

@end

NS_ASSUME_NONNULL_END
