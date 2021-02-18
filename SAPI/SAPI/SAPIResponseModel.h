//
//  SAPIResponseModel.h
//  SAPI
//
//  Created by mrd on 2021/1/4.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SAPIResponseModel : NSObject

@property (nonatomic, copy) NSString * code;
@property (nonatomic, copy) NSString * msg;
@property (nonatomic, retain) id data;

@property (nonatomic, retain) id responseObject;

@property (nonatomic, retain) id model;

@end

NS_ASSUME_NONNULL_END
