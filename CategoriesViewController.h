//
//  CategoriesViewController.h
//  ResturantApp
//
//  Created by Amerald on 01/07/2016.
//  Copyright © 2016 attribe. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GlobalVariables.h"
#import "Categories.h"


@interface CategoriesViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
@property (strong, nonatomic) IBOutlet UIView *HeaderView;
@property (strong, nonatomic) IBOutlet UITableView *myTable;
@property (nonatomic,strong) NSMutableArray * CategoriesArray, *Json;
-(void) retriveData;


@end
