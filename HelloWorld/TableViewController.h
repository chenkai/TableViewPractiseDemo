//
//  TableViewController.h
//  HelloWorld
//
//  Created by Shuo.Xiong on 14-10-15.
//  Copyright (c) 2014年 kai.chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataRequestHandler.h"
@class AppDelegate,CityInfo;

@interface TableViewController:UITableViewController <NSXMLParserDelegate>
{
    @public
    DataRequestHandler *requestHandler;
    
    NSMutableArray *citys;
    
    NSMutableString *currentElementValue;
    
    CityInfo *singleCity;
    
    BOOL storingFlag;
    
    NSArray *elementToParse;
    
}

- (void) setDataRequestHandler:(DataRequestHandler *) handler;

@end

