//
//  MyOrderViewController.m
//  KababjeesChanges
//
//  Created by Amerald on 06/09/2016.
//  Copyright © 2016 attribe. All rights reserved.
//

#import "MyOrderViewController.h"

@interface MyOrderViewController ()
{
    CGFloat Dlwidth,NLwidth;
    NSInteger Dlines,num;
    NSString *T_price;
    NSMutableArray
    *Myorders;
}
@end

@implementation MyOrderViewController
@synthesize mytable;
- (void)viewDidLoad {
    [super viewDidLoad];
    [self show];
    [self data];
}
#pragma mark - UITableDelegate Method

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [tableView reloadData];
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return Myorders.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    
    return NLwidth+Dlines+25;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] init];
    headerView.backgroundColor = [UIColor clearColor];
    return headerView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"MyOrderTableViewCell";
    
    MyOrderTableViewCell *cell = (MyOrderTableViewCell *)[tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    if (cell == nil)
    {
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"MyOrderTableViewCell" owner:self options:nil];
        cell = [nib objectAtIndex:0];
    }
  
    
    cell.backgroundColor =[UIColor colorWithRed:1. green:1. blue:1. alpha:0.5];
    Dlines=[Myorders[indexPath.section] count]*25;
    
    NLwidth=25;
    
    cell.nameLabel.frame=CGRectMake(cell.nameLabel.frame.origin.x,cell.frame.origin.y+10, cell.nameLabel.frame.size.width, NLwidth);
    
    cell.descriptionLabel.frame=CGRectMake(cell.descriptionLabel.frame.origin.x,cell.nameLabel.frame.origin.y+NLwidth, cell.descriptionLabel.frame.size.width, Dlines);
    cell.nameLabel.text = [@"Order " stringByAppendingString:[NSString stringWithFormat: @"%ld", (long)indexPath.section+1]];
    cell.descriptionLabel.text=@"";
    cell.descriptionLabel.textAlignment=NSTextAlignmentLeft;
    cell.nameLabel.textAlignment = NSTextAlignmentLeft;
    cell.nameLabel.textColor=[[GlobalVariables class]color:0];
    int k;
    
    for(k=0;k<[Myorders[indexPath.section] count]-1;k++)
    {
         cell.descriptionLabel.text=[[[cell.descriptionLabel.text stringByAppendingString:[[[[Myorders objectAtIndex:indexPath.section] objectAtIndex:k]valueForKey:QKey] stringByAppendingString:@" x " ]] stringByAppendingString:[[[Myorders objectAtIndex:indexPath.section] objectAtIndex:k]valueForKey:@"item_name"]] stringByAppendingString:@"\n"];
        
        
    }
    cell.priceLabel.text=[@"TotalPrice: "  stringByAppendingString:[[Myorders objectAtIndex:indexPath.section] objectAtIndex:k] ];
        return cell;
}
-(void) data
{
    defaults = [NSUserDefaults standardUserDefaults];
 
    Myorders = [defaults objectForKey:@"Orders"];
    if(Myorders.count==0)
        [self showMessage:@"Welcome!" :@"You have not ordered any thing yet."];
    [mytable reloadData];
}
-(void)show{
    
    UIBarButtonItem *menu = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"menu-icon" ] style:UIBarButtonItemStylePlain target:self.revealViewController action:@selector(revealToggle:)];
    
    self.navigationItem.leftBarButtonItem = menu;
    self.navigationItem.leftBarButtonItem.tintColor=[UIColor whiteColor];
    
    self.navigationItem.title=[[GlobalVariables class]Title:@"MyOrders"];
    [self.view addGestureRecognizer:self.revealViewController.panGestureRecognizer];
    [self.view addGestureRecognizer:self.revealViewController.tapGestureRecognizer];
    
}
-(void)viewWillDisappear:(BOOL)animated
{
    [self.mytable deselectRowAtIndexPath:[self.mytable indexPathForSelectedRow] animated:NO];
    [self.mytable setContentOffset:CGPointZero animated:NO];
    
}
#pragma mark - Scroll View Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    mytable.alwaysBounceVertical = NO;
}
-(void)showMessage:(NSString*)Title :(NSString *)message
{
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:Title message:message preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [alertController dismissViewControllerAnimated:YES completion:^{
            SWRevealViewController *sv=self.revealViewController;
            [sv revealToggle:self];

            
        }];
        
    });
    
}
@end
