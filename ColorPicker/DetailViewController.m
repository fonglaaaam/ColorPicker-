//
//  ViewController.m
//  ColorPicker
//
//  Created by midea on 16/1/14.
//  Copyright (c) 2016年 midea. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()<ZWColorPickerDelegate>

@property (weak, nonatomic) IBOutlet ColorPickerView *imageView;

@end

@implementation DetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    __weak typeof(self) weakself = self;
    [self.imageView setPickerStyle:_pickStyle andBlock:^(UIColor *color) {
        weakself.view.backgroundColor = color;
    }];
//    [self.imageView setPickerStyle:_pickStyle andDelegate:self];
    if (_pickStyle == ZWColorPickerStyleRing) {
        [self.imageView setPickerInnerRadius:91];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)colorPickerDidSelectColor:(UIColor * __nullable)color {
    self.view.backgroundColor = color;
}

@end
