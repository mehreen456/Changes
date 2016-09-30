//
//  Categories.m
//  ResturantApp
//
//  Created by Amerald on 01/07/2016.
//  Copyright © 2016 attribe. All rights reserved.
//

#import "Categories.h"

@implementation Categories

@synthesize CName, CId,BId,BName,BCode;

-(id) initWithCId: (NSString *) cid andCName: (NSString *) cname
{
    self=[super init];
    {
        CId=cid;
        CName=cname;
    }
    return self;
    
}
-(id) initWithBId: (NSString *) bid andBName: (NSString *) bname andCode: (NSString *) bcode
{
    self=[super init];
    {
        BId=bid;
        BName=bname;
        BCode=bcode;
    }
    return self;
    
}



@end
