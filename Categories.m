//
//  Categories.m
//  ResturantApp
//
//  Created by Amerald on 01/07/2016.
//  Copyright © 2016 attribe. All rights reserved.
//

#import "Categories.h"

@implementation Categories

@synthesize CName, CId;

-(id) initWithCId: (NSString *) cid andCName: (NSString *) cname
{
    self=[super init];
    {
        CId=cid;
        CName=cname;
    }
    return self;
    
}

@end
