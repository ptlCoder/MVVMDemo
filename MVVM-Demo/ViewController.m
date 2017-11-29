//
//  ViewController.m
//  MVVM-Demo
//
//  Created by soliloquy on 2017/11/28.
//  Copyright © 2017年 soliloquy. All rights reserved.
//


#import "ViewController.h"
#import "ViewModel.h"
#import "Persion.h"
@interface ViewController ()
{
    RACCommand *_command;
}
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UITextField *tf;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIView *redView;



/** <#注释#> */
@property (nonatomic, strong) ViewModel *viewModel;
/** <#注释#>*/
@property (nonatomic, strong) NSArray *dataSource;


@end

@implementation ViewController

-(NSArray *)dataSource {
    if (!_dataSource) {
        _dataSource = [[NSArray alloc]init];
    }
    return _dataSource;
}

-(ViewModel *)viewModel {
    if (!_viewModel) {
        _viewModel = [[ViewModel alloc]init];
    }
    return _viewModel;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // RACMulticastConnection使用步骤:
    // 1.创建信号 + (RACSignal *)createSignal:(RACDisposable * (^)(id<RACSubscriber> subscriber))didSubscribe
    // 2.创建连接 RACMulticastConnection *connect = [signal publish];
    // 3.订阅信号,注意：订阅的不在是之前的信号，而是连接的信号。 [connect.signal subscribeNext:nextBlock]
    // 4.连接 [connect connect]
    
    // RACMulticastConnection底层原理:
    /*
     1.创建connect，connect.sourceSignal -> RACSignal(原始信号)  connect.signal -> RACSubject
     2.订阅connect.signal，会调用RACSubject的subscribeNext，创建订阅者，而且把订阅者保存起来，不会执行block。
     3.[connect connect]内部会订阅RACSignal(原始信号)，并且订阅者是RACSubject
     3.1.订阅原始信号，就会调用原始信号中的didSubscribe
     3.2 didSubscribe，拿到订阅者调用sendNext，其实是调用RACSubject的sendNext
     4.RACSubject的sendNext,会遍历RACSubject所有订阅者发送信号。
     4.1 因为刚刚第二步，都是在订阅RACSubject，因此会拿到第二步所有的订阅者，调用他们的nextBlock
    */
    
    // 需求：假设在一个信号中发送请求，每次订阅一次都会发送请求，这样就会导致多次请求。
    // 解决：使用RACMulticastConnection就能解决.
    
    // 1.创建请求信号
    RACSignal *signal1 = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        
        NSLog(@"发送数据");
        
        return nil;
    }];
    // 2.订阅信号
    [signal1 subscribeNext:^(id x) {
        
        NSLog(@"接收数据");
        
    }];
    // 2.订阅信号
    [signal1 subscribeNext:^(id x) {
        
        NSLog(@"接收数据");
        
    }];
    
    // 3.运行结果，会执行两遍发送请求，也就是每次订阅都会发送一次请求
    
    
    // RACMulticastConnection:解决重复请求问题
    // 1.创建信号
    RACSignal *signal = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {


        NSLog(@"发送请求");
        [subscriber sendNext:@"我是数据源"];

        return nil;
    }];

    // 2.创建连接
    RACMulticastConnection *connect = [signal publish];

    // 3.订阅信号，
    // 注意：订阅信号，也不能激活信号，只是保存订阅者到数组. 必须通过连接,当调用连接，就会一次性调用所有订阅者的sendNext:
    [connect.signal subscribeNext:^(id x) {

        NSLog(@"订阅者一:%@", x);

    }];

    [connect.signal subscribeNext:^(id x) {

        NSLog(@"订阅者二:%@", x);

    }];

    // 4.连接,激活信号
    [connect connect];
}


- (void)test2 {
    
//    NSArray *arr = @[@"哈哈",@"呵呵", @"嘿嘿", @"哼哼"];
//    [arr.rac_sequence.signal subscribeNext:^(id x) {
//        NSLog(@"x: %@", x);
//    }];
    
    /*
    NSArray *arr = @[
                     @{@"name": @"soliloquy", @"age": @26},
                     @{@"name": @"ptl", @"age": @21},
                     ];

//    [arr.rac_sequence.signal subscribeNext:^(id x) {
//        // 解包元组，会把元组的值，按顺序给参数里面的变量赋值
////        RACTupleUnpack(NSString *key,NSString *value) = x;
////        NSLog(@"%@ %@",key,value);
//        NSLog(@"x: %@", x);
//
//    }];
    
    NSArray *ay = [[arr.rac_sequence map:^id(id value) {
        
        return [Persion modelWithDict:value];
        
    }] array];
    
    NSLog(@"ay: %@", ay);
    
    for (Persion *model in ay) {
        NSLog(@"%@---%zd", model.name, model.age);
    }
    
     */

    /*
     2017-11-29 11:29:39.211551+0800 MVVM-Demo[1301:456193] x: <RACTuple: 0x608000013fe0> (
     name,
     soliloquy
     )
     2017-11-29 11:29:39.211992+0800 MVVM-Demo[1301:456193] x: <RACTuple: 0x6000000141f0> (
     age,
     26
     )

    */
    
    /*
     一、RACCommand使用步骤:
     1.创建命令 initWithSignalBlock:(RACSignal * (^)(id input))signalBlock
     2.在signalBlock中，创建RACSignal，并且作为signalBlock的返回值
     3.执行命令 - (RACSignal *)execute:(id)input
    
     二、RACCommand使用注意:
     1.signalBlock必须要返回一个信号，不能传nil.
     2.如果不想要传递信号，直接创建空的信号[RACSignal empty];
     3.RACCommand中信号如果数据传递完，必须调用[subscriber sendCompleted]，这时命令才会执行完毕，否则永远处于执行中。
     4.RACCommand需要被强引用，否则接收不到RACCommand中的信号，因此RACCommand中的信号是延迟发送的。
    
     三、RACCommand设计思想：内部signalBlock为什么要返回一个信号，这个信号有什么用。
     1.在RAC开发中，通常会把网络请求封装到RACCommand，直接执行某个RACCommand就能发送请求。
     2.当RACCommand内部请求到数据的时候，需要把请求的数据传递给外界，这时候就需要通过signalBlock返回的信号传递了。
    
     四、如何拿到RACCommand中返回信号发出的数据。
     1.RACCommand有个执行信号源executionSignals，这个是signal of signals(信号的信号),意思是信号发出的数据是信号，不是普通的类型。
     2.订阅executionSignals就能拿到RACCommand中返回的信号，然后订阅signalBlock返回的信号，就能获取发出的值。
    
     五、监听当前命令是否正在执行executing
    
     六、使用场景,监听按钮点击，网络请求
    */
    
    // 1.创建命令
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        // 创建空信号,必须返回信号
        //        return [RACSignal empty];
        
        // 2.创建信号,用来传递数据
        return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
            
            NSArray *arr = @[@"123",@"321", @"132", @"312"];
            
            [subscriber sendNext:arr];
            
            // 注意：数据传递完，最好调用sendCompleted，这时命令才执行完毕。
            [subscriber sendCompleted];
            
            return nil;
        }];
        
    }];
    
    // 强引用命令，不要被销毁，否则接收不到数据
    _command = command;
    
    
   
    // 3.订阅RACCommand中的信号
//    [command.executionSignals subscribeNext:^(id x) {
//
//        [x subscribeNext:^(id x) {
//
//            NSLog(@"数据为： %@",x);
//        }];
//
//    }];
    
    // RAC高级用法
    // switchToLatest:用于signal of signals，获取signal of signals发出的最新信号,也就是可以直接拿到RACCommand中的信号
    [command.executionSignals.switchToLatest subscribeNext:^(id x) {

        NSLog(@"x: %@",x);
    }];
    
    // 4.监听命令是否执行完毕,默认会来一次，可以直接跳过，skip表示跳过第一次信号。
//    [[command.executing skip:1] subscribeNext:^(id x) {
//        
//        if ([x boolValue] == YES) {
//            // 正在执行
//            NSLog(@"正在执行");
//            
//        }else{
//            // 执行完成
//            NSLog(@"执行完成");
//        }
//        
//    }];
    // 5.执行命令
    [_command execute:@1];
    
}

- (void)test1 {

    /** 方法一： block回调 */
//    __weak typeof (self)weakSelf = self;
//    [self.viewModel setDataSourceBlock:^(NSArray *dataSource) {
//        weakSelf.dataSource = dataSource;
//    }];
    
    /** RAC */
    @weakify(self)
    [self.viewModel.command.executionSignals.switchToLatest  subscribeNext:^(NSArray *dataSource) {
        @strongify(self);
        self.dataSource = dataSource;
        
        NSLog(@"%@",dataSource);
    }];

    // 返回错误
    [self.viewModel.command.errors subscribeNext:^(NSError *_Nullable x) {
        NSLog(@"-- error : %@", x.description);
    }];
    
    //执行command
    [self.viewModel.command execute:nil];
    
    
 /***********UI控件*************/
    
    // 1. UIButton
    [[self.button rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        NSLog(@"x:%@", x);
    }];
    
    // 2. UITextField
    [self.tf.rac_textSignal subscribeNext:^(id x) {
         NSLog(@"x:%@", x);
        self.label.text = x;
    }];
    
    // 3. UIView
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]init];
    [tap.rac_gestureSignal subscribeNext:^(id x) {
       NSLog(@"x:%@", x);
        self.redView.backgroundColor = [UIColor yellowColor];
    }];
    [self.redView addGestureRecognizer: tap];
    
    
    [[self.tf.rac_textSignal map:^id(id value) {
        return [UIColor redColor];
    }] subscribeNext:^(id x) {
//        NSLog(@"x:%@", x);
    }];
    
    /*
    RACReplaySubject *replaySubject = [RACReplaySubject subject];
    
    // 2.发送信号
    [replaySubject sendNext:@1];
    [replaySubject sendNext:@2];
    
    // 3.订阅信号
    [replaySubject subscribeNext:^(id x) {
        
        NSLog(@"第一个订阅者接收到的数据%@",x);
    }];
    
    // 订阅信号
    [replaySubject subscribeNext:^(id x) {
        
        NSLog(@"第二个订阅者接收到的数据%@",x);
    }];
    */
    
    /*
    // 1.创建信号
    RACSignal *siganl = [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
        
        // 每当有订阅者订阅信号，就会调用block。
        // 2.发送信号
        [subscriber sendNext:@"我是一个信号📶"];
        
        // 如果不在发送数据，最好发送信号完成，内部会自动调用[RACDisposable disposable]取消订阅信号。
        [subscriber sendCompleted];
        
        return [RACDisposable disposableWithBlock:^{
            // 当信号发送完成或者发送错误，就会自动执行这个block,取消订阅信号。
            // 执行完Block后，当前信号就不在被订阅了。
            NSLog(@"信号被销毁");
            
        }];
    }];
    
    // 3.订阅信号,才会激活信号.
    [siganl subscribeNext:^(id x) {
        // block调用时刻：每当有信号发出数据，就会调用block.
        NSLog(@"接收到数据:%@",x);
    }];

    */
}



@end
