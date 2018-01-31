//
//  TwoViewController.m
//  ReactiveCocoaDemo
//
//  Created by Jason on 2018/1/31.
//  Copyright © 2018年 陆林. All rights reserved.
//

#import "TwoViewController.h"

@interface TwoViewController ()


@property (nonatomic, strong)UIButton *btn;
@property (nonatomic, strong)UITextField *textField;
@end

@implementation TwoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
       self.view.backgroundColor = [UIColor whiteColor];
    
        [self.view addSubview:self.btn];
        [self.view addSubview:self.textField];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    _btn.frame = CGRectMake(100, 100, 100, 50);
    _textField.frame = CGRectMake(100, 200, 200, 30);
}

- (UIButton *)btn {
    _btn = [UIButton new];
    [_btn setTitle:@"test" forState:UIControlStateNormal];
    [_btn setBackgroundColor:[UIColor grayColor]];
    [_btn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
     return _btn;
}

- (UITextField *)textField {
    _textField = [UITextField new];
    _textField.placeholder = @"input";
    _textField.borderStyle = UITextBorderStyleRoundedRect;
    return _textField;
}

- (void)btnAction {
    if (self.delegateSignal) {
        [self.delegateSignal sendNext:_textField.text];
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
