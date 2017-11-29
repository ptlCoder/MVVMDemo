//
//  ViewModel.h
//  
//
//  Created by soliloquy on 2017/11/28.
//

#import <Foundation/Foundation.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

typedef void(^DataSourceBlock)(NSArray *);
@interface ViewModel : NSObject

/** <#注释#> */
@property (nonatomic, copy)DataSourceBlock dataSourceBlock;

/** 处理实际事务  网络请求 */
@property (nonatomic, strong) RACCommand *command;

@end
