
//  CategoriesViewController.m
//  ResturantApp
//
//  Created by Amerald on 01/07/2016.
//  Copyright © 2016 attribe. All rights reserved.
//

#import "CategoriesViewController.h"


@implementation CategoriesViewController

@synthesize CategoriesArray,myTable,HeaderView,Json;

-(void) viewWillAppear:(BOOL)animated
{
    
}
- (void)viewDidLoad {
    
    [super viewDidLoad];
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

#pragma mark - Load Data Through API

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

#pragma mark - Delegate Methods

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    myTable.alwaysBounceVertical = NO;
}

-(void)viewWillDisappear:(BOOL)animated
{
   [self.myTable deselectRowAtIndexPath:[self.myTable indexPathForSelectedRow] animated:NO];
   [myTable setContentOffset:CGPointZero animated:NO];
    
}


@end
