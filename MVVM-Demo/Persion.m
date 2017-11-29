//
//  Persion.m
//  MVVM-Demo
//
//  Created by soliloquy on 2017/11/29.
//  Copyright © 2017年 soliloquy. All rights reserved.
//

#import "Persion.h"

@implementation Persion

- (instancetype)initWithDict:(NSDictionary *)dict
{
    self = [super init];
    if (self) {
        [self setValuesForKeysWithDictionary:dict];
    }
    return self;
}

+ (instancetype)modelWithDict:(NSDictionary *)dict
{
    return [[Persion alloc]initWithDict:dict];
}

-(void)setValue:(id)value forUndefinedKey:(NSString *)key {}

@end
