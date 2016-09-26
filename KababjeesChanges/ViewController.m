//
//  ViewController.m
//  Kababjee'sApp
//
//  Created by Amerald on 02/07/2016.
//  Copyright © 2016 attribe. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()
{
    UIBarButtonItem *rightBarButton;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self Drawer];
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@" " style:UIBarButtonItemStylePlain target:nil action:nil];
    
    if(BasketItems>0)
    {
        UIView* BLView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 110, 50)];
        UIButton *basket=[[GlobalVariables class]BarButton];
        basket.frame = BLView.frame;
        [basket addTarget:self action:@selector(basket) forControlEvents:UIControlEventTouchUpInside];
        [BLView addSubview:basket];
        
        rightBarButton = [[UIBarButtonItem alloc]initWithCustomView:BLView];
        self.navigationItem.rightBarButtonItem = rightBarButton;
    }
    
   //   [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UCInfo"];
    //  [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"UserInfo"];
   
     //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Reservations"];
     //[[NSUserDefaults standardUserDefaults] removeObjectForKey:@"Orders"];
}

-(void) viewDidAppear:(BOOL)animated
{
    [self.view endEditing:YES];
    if(Running ) {
        
        SWRevealViewController *sv=self.revealViewController;
        [sv revealToggle:self];
    }

}

-(void) Drawer
{
    
[self.navigationController.navigationBar setBackgroundColor: [[GlobalVariables class]color:0]];
SWRevealViewController *revealViewController = self.revealViewController;
if ( revealViewController )
{
    [self.barButton setTarget: self.revealViewController];
    [self.barButton setAction: @selector( revealToggle: )];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];

}
}

-(void) basket
{
    [self performSegueWithIdentifier:@"BSegue" sender:self.view];
}

@end
