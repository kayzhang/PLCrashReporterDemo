//
//  ViewController.m
//  PLCrashReporterDemo
//
//  Created by Zhang, Kai on 2023/2/21.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (IBAction)triggerAssertionCrash:(UIButton *)sender {
    NSLog(@"Local Testing - Triggering an assertion crash");
    assert(NO);
}

@end
