//
//  LoginViewController.m
//  ReactiveCocoaDemo
//
//  Created by Jason on 2018/1/31.
//  Copyright © 2018年 陆林. All rights reserved.
//

#import "LoginViewController.h"
#import "LoginViewModel.h"

@interface LoginViewController ()

@property (nonatomic, strong)UITextField *userNameTextField;
@property (nonatomic, strong)UITextField *passwordTextField;
@property (nonatomic, strong)UIButton *loginButton;
@property (nonatomic, strong)LoginViewModel *loginViewModel;

@end

@implementation LoginViewController

#pragma mark - lifecyle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.userNameTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.loginButton];
    
    [self bindModel];
//    [self onClick];
}

- (void)bindModel {
    _loginViewModel = [[LoginViewModel alloc] init];
    
    RAC(self.loginViewModel,userName) = self.userNameTextField.rac_textSignal;
    RAC(self.loginViewModel,password) = self.passwordTextField.rac_textSignal;
    RAC(self.loginButton,enabled) = [_loginViewModel buttonIsValid];
    
    @weakify(self);
    [self.loginViewModel.successObject subscribeNext:^(NSArray *x) {
        @strongify(self);
        NSLog(@"输入的用户名:%@ 密码:%@",x[0],x[1]);
    }];
    
}

- (void)onClick {
    //按钮点击事件
    [[self.loginButton rac_signalForControlEvents:UIControlEventTouchUpInside]
     subscribeNext:^(id x) {
         [_loginViewModel login];
     }];
    
}
- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _userNameTextField.frame = CGRectMake(100, 100, 200, 30);
    _passwordTextField.frame = CGRectMake(100, 150, 200, 30);
    _loginButton.frame = CGRectMake(100, 200, 150, 30);
}


#pragma mark - get  method
- (UITextField *)userNameTextField {
    if(!_userNameTextField){
        _userNameTextField = [[UITextField alloc]init];
        _userNameTextField.enabled = YES;
        _userNameTextField.placeholder = @"请输入用户名";
        _userNameTextField.borderStyle = UITextBorderStyleRoundedRect;
    }
    
    return _userNameTextField;
}

- (UITextField *)passwordTextField {
    if(!_passwordTextField){
        _passwordTextField = [[UITextField alloc]init];
        _passwordTextField.placeholder = @"请输入密码";
        _passwordTextField.borderStyle = UITextBorderStyleRoundedRect;
        _passwordTextField.secureTextEntry = YES;
        
        
    }
    return _passwordTextField;
    
}

- (UIButton *)loginButton {
    if(!_loginButton){
        _loginButton = [UIButton new];
        [_loginButton setTitle:@"登陆" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [_loginButton addTarget:self action:@selector(loginAction) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return _loginButton;
}

- (void)loginAction {
    
    
    
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
