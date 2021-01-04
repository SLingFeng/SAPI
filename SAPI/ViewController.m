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
    NSDictionary *dict = @{ @"id":@"41" };
    
    SAPI *api = [[[[[[[[[SAPI new] makeUrlString:@"http://"] makeParameters:dict] makeCodeKey:@"status"] makeTrClass:[TestUser class]] makeHeaders:@{@"TOKEN" : @"IOS"}] makeDidSuccessBlock:^(SAPIResponseModel * _Nonnull response) {
        NSLog(@"qwe:%@", self.api);
        NSLog(@"%@", response.model);
        
    }] makeDidFailureBlock:^(SAPIResponseModel * _Nonnull response) {
        
    }] POST];
    
    self.api = api;
}


@end
