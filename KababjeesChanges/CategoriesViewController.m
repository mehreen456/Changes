
//  CategoriesViewController.m
//  ResturantApp
//
//  Created by Amerald on 01/07/2016.
//  Copyright © 2016 attribe. All rights reserved.
//

#import "CategoriesViewController.h"


@implementation CategoriesViewController


@synthesize CategoriesArray,myTable,HeaderView,Json;

- (void)viewDidLoad {
  
    [super viewDidLoad];
    [self.view endEditing:YES];
     ItemsOrder =[[NSMutableArray alloc]init];
     [self retriveData];
   
}


#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;

}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return CategoriesArray.count;
   }


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *simpleTableIdentifier = @"CCELL";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:simpleTableIdentifier];
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:simpleTableIdentifier];
    }
    
    Categories *currentCat=[CategoriesArray objectAtIndex:indexPath.row];
    cell.textLabel.text=currentCat.CName ;
    cell.backgroundColor=[UIColor whiteColor];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Categories *c1= [CategoriesArray objectAtIndex:indexPath.row];
    CID=c1.CId; 
    CTitle=c1.CName;
   
   }

#pragma mark - My Methods

-(void) retriveData
{
    NSString *string = [NSString stringWithFormat:@"%@/categories", BaseUrl];
    NSURL *url = [NSURL URLWithString:string];
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager.requestSerializer setValue:DataType forHTTPHeaderField:CType];
    [manager.requestSerializer setValue:Key forHTTPHeaderField:Authorization];
   
    manager.responseSerializer=[AFJSONResponseSerializer serializer];
    [manager GET:url.absoluteString parameters:nil progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        Json = (NSMutableArray *)responseObject;
        CategoriesArray =[[NSMutableArray alloc]init];
        
        for(int i=0;i<Json.count;i++)
        {
            NSString *CName = [[Json objectAtIndex:i]valueForKey:NKey];
            NSString *CId = [[[Json objectAtIndex:i]valueForKey:IKey ]stringValue] ;
            Categories *Cobj=[[Categories alloc] initWithCId:CId andCName:CName];
            
            [CategoriesArray addObject:Cobj];
        }
     
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Data retrived faild");
        [self.view makeToast:@"No Internet Connection"];
    }];
 
     [self.myTable reloadData];
}

#pragma mark - Passing Data Through Segue

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    
    if ( [segue isKindOfClass: [SWRevealViewControllerSegue class]] ) {
        SWRevealViewControllerSegue *swSegue = (SWRevealViewControllerSegue*) segue;
        Relaod=0;
        swSegue.performBlock = ^(SWRevealViewControllerSegue* rvc_segue, UIViewController* svc, UIViewController* dvc) {
  
            UINavigationController* navController = (UINavigationController*)self.revealViewController.frontViewController;
            [navController.navigationBar setBackgroundColor: [[GlobalVariables class]color:0]];
                       [navController setViewControllers: @[dvc] animated: NO ];
                       [self.revealViewController setFrontViewPosition: FrontViewPositionLeft animated: YES];
                 };
        
}
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView.contentOffset.y<self.view.frame.size.height )
    {
    
    CGRect rect = self.myview.frame;
    rect.origin.y =-(scrollView.contentOffset.y+50);
    self.myview.frame = rect;
    CGRect rect2 = self.myTable.frame;
    rect2.origin.y=self.myview.frame.size.height+self.myview.frame.origin.y;
    rect2.size.height=+(self.view.frame.size.height-rect2.origin.y);
    self.myTable.frame=rect2;
 
    }
    if(scrollView.contentOffset.y==0)
    {
        self.myview.frame=CGRectMake(0, 0, self.myview.frame.size.width, self.myview.frame.size.height);
        self.myTable.frame=CGRectMake(0, self.myview.frame.size.height+self.myview.frame.origin.y, self.myTable.frame.size.width, self.myTable.frame.size.height);
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
   [self.myTable deselectRowAtIndexPath:[self.myTable indexPathForSelectedRow] animated:NO];
    NSIndexPath *firstCellIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.myTable scrollToRowAtIndexPath:firstCellIndex atScrollPosition:UITableViewScrollPositionTop animated:NO];
}


@end
