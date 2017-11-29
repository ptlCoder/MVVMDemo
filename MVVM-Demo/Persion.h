//
//  Persion.h
//  MVVM-Demo
//
//  Created by soliloquy on 2017/11/29.
//  Copyright © 2017年 soliloquy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Persion : NSObject

/** <#注释#> */
@property (nonatomic, copy)NSString *name;
/** <#注释#> */
@property (nonatomic, assign)NSInteger age;


- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)modelWithDict:(NSDictionary *)dict;
@end
