//
//  ViewController.m
//  ColorPicker
//
//  Created by fonglaaam on 16/1/14.
//  Copyright (c) 2016年 fonglaaam. All rights reserved.
//


#define APP_RGB(r,g,b)              [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]

#import "DetailViewController.h"

@interface DetailViewController ()<ZWColorPickerDelegate,UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet ColorPickerView *imageView;
@property(nonatomic,strong)UILabel *lab;
@end

@implementation DetailViewController{
    UITextField *tf1;
    UITextField *tf2;
    UITextField *tf3;
    UIView *view;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    __weak typeof(self) weakself = self;
    [self.imageView setPickerStyle:_pickStyle andBlock:^(UIColor *color) {
        weakself.view.backgroundColor = color;
         weakself.lab.text = [NSString stringWithFormat:@"十六进制: %@  RGB: %@",[weakself hexStringFromColor:color],[weakself changecolor:color]] ;
    }];

    if (_pickStyle == ZWColorPickerStyleRing) {
        [self.imageView setPickerInnerRadius:91];
    }
    
    _lab = [[UILabel alloc]initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-30, [[UIScreen mainScreen] bounds].size.width, 30)];
    _lab.textColor = [UIColor blackColor];
    _lab.backgroundColor = [UIColor whiteColor];
    _lab.alpha = 0.5;
    _lab.text = @"请使用拾取器选色或红绿蓝框填入0-255之间的数字";
    _lab.font = [UIFont systemFontOfSize:14];
    [self.view addSubview:_lab];
    
    view = [[UIView new]initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-60, 120, 30)];
    view.userInteractionEnabled = YES;
    [self.view addSubview:view];
    
    tf1 = [[UITextField alloc]initWithFrame:CGRectMake(0, [[UIScreen mainScreen] bounds].size.height-60, 60, 30)];
    tf1.backgroundColor = [UIColor redColor];
    tf1.delegate = self;
    tf1.tag = 11;
    tf1.placeholder = @"red";
    [self.view addSubview:tf1];
    
    tf2 = [[UITextField alloc]initWithFrame:CGRectMake(60, [[UIScreen mainScreen] bounds].size.height-60, 60, 30)];
    tf2.backgroundColor = [UIColor greenColor];
    tf2.delegate = self;
    tf2.tag = 22;
    tf2.placeholder = @"green";
    [self.view addSubview:tf2];
    
    tf3 = [[UITextField alloc]initWithFrame:CGRectMake(120, [[UIScreen mainScreen] bounds].size.height-60, 60, 30)];
    tf3.backgroundColor = [UIColor blueColor];
    tf3.delegate = self;
    tf3.tag = 33;
    tf3.placeholder = @"blue";
    [self.view addSubview:tf3];
    
    tf1.keyboardType = UIKeyboardTypeNumberPad;
    tf2.keyboardType = UIKeyboardTypeNumberPad;
    tf3.keyboardType = UIKeyboardTypeNumberPad;
    
    UITapGestureRecognizer *tapgest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapBackAction)];
    [self.view addGestureRecognizer:tapgest];
}

- (void)viewWillAppear:(BOOL)animated {
    // 添加对键盘的监控
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)tapBackAction {
    [tf1 resignFirstResponder];
    [tf3 resignFirstResponder];
    [tf2 resignFirstResponder];
}

-(void)keyboardShow:(NSNotification *)note
{
    CGRect keyBoardRect=[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat deltaY=keyBoardRect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        tf1.transform=CGAffineTransformMakeTranslation(0, -deltaY);
        tf2.transform=CGAffineTransformMakeTranslation(0, -deltaY);
        tf3.transform=CGAffineTransformMakeTranslation(0, -deltaY);

    }];
}

-(void)keyboardHide:(NSNotification *)note
{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        tf1.transform=CGAffineTransformIdentity;
        tf2.transform=CGAffineTransformIdentity;
        tf3.transform=CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
//        view.textView.text=@"";
//        [view removeFromSuperview];
    }];
}

- (void)colorPickerDidSelectColor:(UIColor * __nullable)color {
    self.view.backgroundColor = color;
   
}
- (NSString *)hexStringFromColor:(UIColor *)color {
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    
    return [NSString stringWithFormat:@"#%02lX%02lX%02lX",
            lroundf(r * 255),
            lroundf(g * 255),
            lroundf(b * 255)];
}

-(NSString *)changecolor:(UIColor *)color{
    const CGFloat *components = CGColorGetComponents(color.CGColor);
    
    CGFloat r = components[0];
    CGFloat g = components[1];
    CGFloat b = components[2];
    return [NSString stringWithFormat:@"%ld, %ld, %ld",lroundf(r * 255),lroundf(g * 255),lroundf(b * 255)];
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if(tf1.text.length!=0&&tf2.text.length!=0&&tf3.text.length!=0){
       self.view.backgroundColor = APP_RGB(tf1.text.floatValue, tf2.text.floatValue, tf3.text.floatValue);
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if(tf1.text.length!=0&&tf2.text.length!=0&&tf3.text.length!=0){
       self.view.backgroundColor = APP_RGB(tf1.text.floatValue, tf2.text.floatValue, tf3.text.floatValue);
    }
    
    return YES;
}
@end
