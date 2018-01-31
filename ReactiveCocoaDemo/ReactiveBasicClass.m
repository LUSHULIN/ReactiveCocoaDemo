//
//  ReactiveBasicClass.m
//  ReactiveCocoaDemo
//
//  Created by Jason on 2018/1/31.
//  Copyright © 2018年 陆林. All rights reserved.
//

#import "ReactiveBasicClass.h"

@implementation ReactiveBasicClass

- (void)uppercaseString {
    
    [[[@[@"you",@"are"] rac_sequence].signal map:^id _Nullable(id  _Nullable value) {
        return [value capitalizedString];
    }] subscribeNext:^(id  _Nullable x) {
        NSLog(@"capitalizedSignal --%@",x);
    }];
    
//    RACSequence *sequence = [@[@"you",@"are",@"man"] rac_sequence];
//    RACSignal *signal = sequence.signal;
//    RACSignal *capitalizedSignal = [signal map:^id _Nullable(id  _Nullable value) {
//        return [value capitalizedString];
//    }];
//    [signal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"signal ----%@",x);
//    }];
//    [capitalizedSignal subscribeNext:^(id  _Nullable x) {
//        NSLog(@"capitalizedSignal ----%@",x);
//    }];
}
@end
