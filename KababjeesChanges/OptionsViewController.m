//
//  OptionsViewController.m
//  KababjeesChanges
//
//  Created by Amerald on 27/08/2016.
//  Copyright © 2016 attribe. All rights reserved.
//

#import "OptionsViewController.h"

@interface OptionsViewController ()

@end

@implementation OptionsViewController
@synthesize table,order;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
     self.navigationItem.hidesBackButton = YES;
     [self.table setBackgroundColor: [[GlobalVariables class]color:1]];
     [self.order setBackgroundColor: [[GlobalVariables class]color:1]];
}
-(void) viewWillAppear:(BOOL)animated
{
    [self.view endEditing:YES];
}
@end
