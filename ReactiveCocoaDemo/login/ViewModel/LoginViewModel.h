//
//  LoginViewModel.h
//  ReactiveCocoaDemo
//
//  Created by Jason on 2018/1/31.
//  Copyright © 2018年 陆林. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LoginViewModel : NSObject

@property (nonatomic,copy)NSString *userName;
@property (nonatomic,copy)NSString *password;
@property (nonatomic,copy)RACSubject *successObject;
@property (nonatomic,copy)RACSubject *failureObject;
@property (nonatomic,copy)RACSubject *errorObject;

- (id)buttonIsValid;

- (void)login;

@end
