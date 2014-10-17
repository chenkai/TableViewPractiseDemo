//
//  TableViewController.m
//  HelloWorld
//
//  Created by Shuo.Xiong on 14-10-15.
//  Copyright (c) 2014年 kai.chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TableViewController.h"
#import "AppDelegate.h"
#import "CityInfo.h"
#import "MJRefresh.h"

@interface TableViewController ()
{
   @private
    NSArray *_cityDataList;
    int *topCount;
}
@end

@implementation TableViewController

- (id) initWithStyle:(UITableViewStyle)style
{
    self=[super initWithStyle:style];
    if (self) {
        //custom initialization
        }
    
    if (self.tableView == nil) {
        self.tableView=[[UITableView alloc] init];
    }
    return self;
}

- (void) setDataRequestHandler:(DataRequestHandler *)handler
{
    requestHandler = handler;
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    //request xml data
    DataRequestHandler *dataRequest=[DataRequestHandler new];
    [dataRequest setRequestUrl:@"http://flash.weather.com.cn/wmaps/xml/china.xml"];
    [self setDataRequestHandler: dataRequest];
    NSData *requestData= [requestHandler requestResult];
    
    //parse xml to array object
    NSString *xmlDataToString=[[NSString alloc] initWithData: requestData encoding: NSUTF8StringEncoding];
    NSLog(@"%@",xmlDataToString);
    
    NSXMLParser *xmlParser=[[NSXMLParser alloc] initWithData: requestData];
    [xmlParser setDelegate: self];
    
    BOOL flag=[xmlParser parse];
    if (flag) {
        NSLog(@"解析数据成功");
    }else
    {
        NSLog(@"解析数据失败");
    }
    
 
    //_cityDataList=[[NSArray alloc] initWithObjects:@"墨迹天气",@"天气通",@"WeatherChannel", nil];
}

- (void) viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL) shouldAutomaticallyForwardRotationMethods:(UIInterfaceOrientation) interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationMaskPortrait);
}

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [citys count];
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier=@"Cell";
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    //config the tableview cell
    if (cell== nil) {
        cell=[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    //set tableview cell text content
    [cell.textLabel setText:[[citys objectAtIndex:[indexPath row]] cityName ]];
    return cell;
}

//xml startelement method
- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementName isEqualToString:@"china"]) {
        citys=[[NSMutableArray alloc] init];
    }else if ([elementName isEqualToString:@"city"])
    {
        singleCity=[[CityInfo alloc] init];
        singleCity.cityName=[attributeDict objectForKey:@"cityname"];// 3
        singleCity.provinceName=[attributeDict objectForKey:@"quName"];//0
        singleCity.pingYin=[attributeDict objectForKey:@"pyName"];//1
    }
    
    storingFlag=[elementToParse containsObject:elementName];
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    if (storingFlag) {
        if (!currentElementValue) {
            currentElementValue=[[NSMutableString alloc] initWithString:string];
        }else
        {
            [currentElementValue appendString:string];
        }
    }
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"city"]) {
        [citys addObject:singleCity];
        singleCity=nil;
    }
    
    if (storingFlag) {
        //spilt out whitespace value
        NSString *trimmedString=[currentElementValue stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        
        [currentElementValue setString:@""];
        if ([elementName isEqualToString:@"cityname"]) {
            singleCity.cityName=trimmedString;
        }
        
        if ([elementName isEqualToString:@"quName"]) {
            singleCity.provinceName=trimmedString;
        }
        
        if ([elementName isEqualToString:@"pyName"]) {
            singleCity.pingYin=trimmedString;
        }
    }
}


//pull refresh data [init method not third party]
- (void) scrollViewDidScroll:(UIScrollView *)scrollView
{
   float height= scrollView.contentSize.height > self.tableView.frame.size.height
    ? self.tableView.frame.size.height : scrollView.contentSize.height;
    
    if((height - scrollView.contentSize.height + scrollView.contentOffset.y) / height > 0.2)
    {
        //top refresh
        NSLog(@"top refresh...haha");
        
        for (int count=0; count < 10; count++) {
            CityInfo *topRefreshCity=[[CityInfo alloc] init];
            topRefreshCity.cityName=[NSString stringWithFormat:@"top refresh city_%d",count];
            [citys insertObject: topRefreshCity atIndex: 0];
        }
     
    }
    
    if (- scrollView.contentOffset.y / self.tableView.frame.size.height > 0.2)
    {
        //bottom refresh
        NSLog(@"bottom refresh... haha");
        
        
        for (int count=0; count < 10; count++) {
            CityInfo *topRefreshCity=[[CityInfo alloc] init];
            topRefreshCity.cityName=[NSString stringWithFormat:@"bottom refresh city_%d",count];
            [citys insertObject: topRefreshCity atIndex: 0];
        }
    }
    
    
    /*UIAlertView *alert=[[UIAlertView alloc] init];
    alert.alertViewStyle= UIAlertViewStyleDefault;
    alert.message=@"drag me ?";
    [alert show];*/
}







@end