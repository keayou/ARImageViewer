//
//  ViewController.m
//  ARImageViewer
//
//  Created by fk on 2017/12/20.
//  Copyright © 2017年 fk. All rights reserved.
//

#import "ViewController.h"
#import "ARImageViewerViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)startActionClick:(id)sender {
    
    ARImageViewerViewController *vc = [ARImageViewerViewController new];
    
    [self presentViewController:vc animated:YES completion:^{
        
    }];
    
    
    
}

@end
