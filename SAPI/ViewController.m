//
//  ViewController.m
//  SAPI
//
//  Created by mrd on 2021/1/4.
//

#import "ViewController.h"
#import "SAPI.h"
#import "TestUser.h"
@interface ViewController ()
@property (nonatomic, retain) SAPI *api;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    
    
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    NSDictionary *dict = @{ @"id":@"68" };
    
    SAPI *api = [[[[[[[[[SAPI new] makeUrlString:@"http://47.107.48.238:3001/v1/user/getUserInfoById.do"] makeParameters:dict] makeCodeKey:@"status"] makeTrClass:[TestUser class]] makeHeaders:@{@"TOKEN" : @"IOS-0cbeaad468aa444bbf18f149fc66b0bd"}] makeDidSuccessBlock:^(SAPIResponseModel * _Nonnull response) {
            NSLog(@"qwe:%@", self.api);
            NSLog(@"%@", response.model);
            
        }] makeDidFailureBlock:^(SAPIResponseModel * _Nonnull response) {
            
        }] POST];
        
//        self.api = api;
}


@end
