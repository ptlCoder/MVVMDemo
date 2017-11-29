//
//  ViewModel.m
//  
//
//  Created by soliloquy on 2017/11/28.
//

//豆瓣电影API
#define url @"https://api.douban.com/v2/movie/in_theaters?apikey=0b2bdeda43b5688921839c8ecb20399b&city=%E5%8C%97%E4%BA%AC&start=0&count=100&client=&udid="

#import "ViewModel.h"
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import "Model.h"


@implementation ViewModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        __weak typeof (self)weakSelf = self;
        self.command = [[RACCommand alloc]initWithSignalBlock:^RACSignal *(id input) {
            return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
                
                [weakSelf fetchData:^(NSArray *arr) {
                    [subscriber sendNext:arr];
                    [subscriber sendCompleted];
                } failure:^(NSError *error) {
                    [subscriber sendError:error];
                }];
                
                return nil;
            }];
        }];
        
    }
    return self;
}

- (void)fetchData:(void(^)(NSArray *arr))successBlock failure:(void(^)(NSError *error))failure{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    manager.responseSerializer = [AFJSONResponseSerializer serializer];
    [manager GET:url parameters:nil progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSArray *arr = [Model mj_objectArrayWithKeyValuesArray:responseObject[@"subjects"]];
        /** 方法一：block回调出去
        if (self.dataSourceBlock) {
            self.dataSourceBlock(arr);
        }
         */
        /**
            方法二 ： ReactiveCocoa
         */
        
        if (successBlock) {
            successBlock(arr);
        }


        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        if (failure) {
            failure(error);
        }
        
    }];
}

@end
