//
//  ZZBViewController.m
//  PTFSSDK
//
//  Created by 孙启明 on 06/21/2019.
//  Copyright (c) 2019 孙启明. All rights reserved.
//

#import "ZZBViewController.h"
#import "PTFSSDK.h"

@interface ZZBViewController ()

@end

@implementation ZZBViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    [[PTFSSDK sharedInstance] initializePTFSRepoWithCompletion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
