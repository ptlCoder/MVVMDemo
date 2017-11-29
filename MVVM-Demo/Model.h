//
//  Model.h
//  MVVM-Demo
//
//  Created by soliloquy on 2017/11/28.
//  Copyright © 2017年 soliloquy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Model : NSObject

/** <#注释#>*/
@property (nonatomic, strong) NSDictionary *rating;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *genres;
/** <#注释#> */
@property (nonatomic, copy)NSString *title;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *casts;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *durations;
/** <#注释#> */
@property (nonatomic, assign) NSInteger collect_count;
/** <#注释#> */
@property (nonatomic, copy)NSString *mainland_pubdate;
/** <#注释#> */
@property (nonatomic, assign) BOOL has_video;
/** <#注释#> */
@property (nonatomic, copy) NSString *original_title;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *directors;
/** <#注释#> */
@property (nonatomic, strong) NSDictionary *images;
/** <#注释#> */
@property (nonatomic, copy)NSString *alt;
/** <#注释#> */
@property (nonatomic, copy)NSString *ID;


@end
