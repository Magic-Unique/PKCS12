//
//  PViewController.m
//  PKCS12
//
//  Created by Magic-Unique on 07/07/2022.
//  Copyright (c) 2022 Magic-Unique. All rights reserved.
//

#import "PViewController.h"
#import <PKCS12/PKCS12.h>
#import <MUFoundation/MUPath.h>

@interface PViewController ()

@end

@implementation PViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    MUPath *path = [[MUPath mainBundlePath] subpathWithComponent:@"cert.p12"];
    P12 *p12 = [P12 p12WithContentsOfFile:path.string password:@"1" error:NULL];
    NSLog(@"%@", p12.name);
    NSLog(@"%@", p12.serialNumber);
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        BOOL revoked = [p12 syncCheckIsRevoked];
        NSLog(@"%@", revoked ? @"Revoked" : @"Enable");
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
