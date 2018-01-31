//
//  ViewController.m
//  ReactiveCocoaDemo
//
//  Created by Jason on 2018/1/30.
//  Copyright © 2018年 陆林. All rights reserved.
//

#import "ViewController.h"
#import "UIButton+RACCommandSupport.h"

#import "TwoViewController.h"
#import "ReactiveBasicClass.h"

@interface ViewController ()


@property (nonatomic, strong)UIButton *btn;
@property (nonatomic, strong)RACCommand *loginCommand;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    ReactiveBasicClass *basic = [[ReactiveBasicClass alloc]init];
    [basic uppercaseString];
    
//    RACSignal *letters = [@"A B C D" componentsSeparatedByString:@" "].rac_sequence.signal;
//    [letters subscribeNext:^(NSString *str) {
//        NSLog(@"%@",str);
//    }];

//    __block unsigned subscriptions = 0;
//
//    RACSignal *loggingSignal = [RACSignal createSignal:^ RACDisposable * (id<RACSubscriber> subscriber) {
//        subscriptions++;
//        [subscriber sendCompleted];
//        return nil;
//    }];
//
//    // Does not output anything yet
//    loggingSignal = [loggingSignal doCompleted:^{
//        NSLog(@"about to complete subscription %u", subscriptions);
//    }];
//
//    // Outputs:
//    // about to complete subscription 1
//    // subscription 1
//    [loggingSignal subscribeCompleted:^{
//        NSLog(@"subscription %u", subscriptions);
//    }];
    
}

- (void)createRACProperty {
    RACSubject *subject = [RACSubject subject];
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"第一个订阅者:%@",x);
    }];
    
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"第二个订阅者:%@",x);
    }];
    
    [subject subscribeCompleted:^{
        NSLog(@"信号发送完成");
    }];
    [subject sendNext:@"100"];
    
}

- (void)replayRAC {
    RACReplaySubject *subject = [RACReplaySubject subject];
    [subject sendNext:@100];
    [subject sendNext:@200];
    
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"第一个信号订阅者%@",x);
    }];
    [subject subscribeNext:^(id  _Nullable x) {
        NSLog(@"第二个信号订阅者:%@",x);
    }];
    
}
- (void)btnAction {
    TwoViewController *twoVC = [TwoViewController new];
    twoVC.delegateSignal = [RACSubject subject];
    [twoVC.delegateSignal subscribeNext:^(id  _Nullable x) {
        NSLog(@"界面二带回的参数:%@",x);
    }];
    [self presentViewController:twoVC animated:YES completion:nil];

}

- (void)arraydict {
    //遍历数组
    NSArray *numbers = @[@1,@3,@44];
    [numbers.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"value:%@",x);
    }];
    //遍历字典
    NSDictionary *dict = @{@"张三":@"3",@"李四":@"4"};
    [dict.rac_sequence.signal subscribeNext:^(id  _Nullable x) {
        RACTupleUnpack(NSString *key,NSString *value) = x;
        NSLog(@"key:%@ value:%@",key,value);
    }];
    
}

//RACCommand使用场景 监听按钮点击，网络请求
- (void)raccommand {
    RACCommand *command = [[RACCommand alloc] initWithSignalBlock:^RACSignal * _Nonnull(id  _Nullable input) {
        NSLog(@"执行命令");
        return [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
            [subscriber sendNext:@"请求网络数据"];
            [subscriber sendCompleted];
            return  nil;
        }];
    }];
    
    [command.executionSignals subscribeNext:^(id  _Nullable x) {
        [x subscribeNext:^(id  _Nullable x) {
            NSLog(@"%@",x);
        }];
    }];
    [command execute:@1];
}
//用于当一个信号被多次执行时
- (void)racmulticastConnection{
    RACSignal *signal = [RACSignal createSignal:^RACDisposable * _Nullable(id<RACSubscriber>  _Nonnull subscriber) {
        NSLog(@"发送请求");
        [subscriber sendNext:@101];
        return nil;
    }];
    
    RACMulticastConnection *connect = [signal publish];
    [connect.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅者一号");
    }];
    [connect.signal subscribeNext:^(id  _Nullable x) {
        NSLog(@"订阅者二号");
    }];
    
    [connect connect];
    
}

/*
 ReactiveCocoa开发中常用用法
 7.1 代替代理:
 
 rac_signalForSelector：用于替代代理。
 7.2 代替KVO :
 
 rac_valuesAndChangesForKeyPath：用于监听某个对象的属性改变。
 7.3 监听事件:
 
 rac_signalForControlEvents：用于监听某个事件。
 7.4 代替通知:
 
 rac_addObserverForName:用于监听某个通知。
 7.5 监听文本框文字改变:
 
 rac_textSignal:只要文本框发出改变就会发出这个信号。
 7.6 处理当界面有多次请求时，需要都获取到数据时，才能展示界面
 
 rac_liftSelector:withSignalsFromArray:Signals:当传入的Signals(信号数组)，每一个signal都至少sendNext过一次，就会去触发第一个selector参数的方法。
 使用注意：几个信号，参数一的方法就几个参数，每个参数对应信号发出的数据。

 
 */
//rac_signalForSelector:

- (void)demo {
    UIView *redV = [[UIView alloc]initWithFrame:CGRectMake(100, 100, 100, 100)];
    redV.backgroundColor = [UIColor redColor];
    [[redV rac_signalForSelector:@selector(btnClick:)] subscribeNext:^(id x) {
        NSLog(@"点击红色按钮");
    }];
    [self.view addSubview:redV];
    
    UIButton *test = [[UIButton alloc]initWithFrame:CGRectMake(50, 50, 50, 30)];
    [test setTitle:@"test" forState:UIControlStateNormal];
    [test setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [test addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
    [redV addSubview:test];
    
   
    
}

- (void)btnClick:(UIButton *)btn {
    NSLog(@"call btnclick");
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
