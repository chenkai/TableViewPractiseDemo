//
//  DataRequestHandler.m
//  HelloWorld
//
//  Created by Shuo.Xiong on 14-10-16.
//  Copyright (c) 2014年 kai.chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DataRequestHandler.h"
@class CityInfo;

@implementation DataRequestHandler

- (void) setRequestUrl:(NSString *)url
{
    requestUrl=url;
}

- (NSData *) requestResult
{
    if ([requestUrl length] == 0) {
        NSLog(@"request url is empty.please set request url.");
        exit(1);
    }
  
    //init request data
    NSURL *url=[[NSURL alloc] initWithString: requestUrl];
    NSMutableURLRequest *request=[[NSMutableURLRequest alloc] initWithURL: url];
    [request setHTTPMethod: @"GET"];
    
    
    //handle data request
    NSURLResponse *response;
    NSError *error;
    NSData *result=[NSURLConnection sendSynchronousRequest:request returningResponse: &response error: &error];

    return (result);
}









- (void) testDataRequestFunction
{
    //NSURLRequest only support get method
    //NSMutableURLRequest support get and post
    NSURL *defineUrl=[[NSURL alloc] initWithString: requestUrl];
    
    NSURLRequest *request=[[NSURLRequest alloc] initWithURL: defineUrl];
    NSMutableURLRequest *moreRequest=[[NSMutableURLRequest alloc] initWithURL: defineUrl];
    
    //user factory method create request action
    NSURLRequest *ftRequest=[NSURLRequest requestWithURL: defineUrl];
    NSMutableURLRequest *ftMoreRequest=[NSMutableURLRequest requestWithURL: defineUrl];
    
    //set datetime with datacache and outtime
    NSTimeInterval outTime=[[NSDate date] timeIntervalSince1970];
    NSMutableURLRequest *setRequest=[NSURLRequest requestWithURL: defineUrl cachePolicy: NSURLRequestReloadIgnoringCacheData timeoutInterval: outTime];
    
    //set http header dic
    NSDictionary *headers=[setRequest allHTTPHeaderFields];
    [headers setValue:@"IOS-Client-TempKey" forKey: @"User-Agent"];
    
    //set data request method
    [setRequest setHTTPMethod: @"GET"];
    [setRequest setHTTPMethod: @"POST"];
    
    //set data request content [only for post method]
    NSString *content=@"username=chenkai&password=frankchen";
    NSData *data=[content dataUsingEncoding: NSUTF8StringEncoding];
    [setRequest setHTTPBody: data];
    
    //sync data request
    NSURLResponse *response;
    NSError *error;
    NSData *result= [NSURLConnection sendSynchronousRequest: request returningResponse:&response error: &error];
    
    
    //get response data to string
    NSString *resultToString=[[NSString alloc] initWithData: result encoding: NSUTF8StringEncoding];
    NSString *errorToString=[error localizedDescription];
    
    // get response statuscode and header information
    NSHTTPURLResponse *httpResponse=(NSHTTPURLResponse *) response;
    NSInteger statusCode=[httpResponse statusCode];
    
    NSDictionary *responseHeaders=[httpResponse allHeaderFields];
    NSString *cookie=[responseHeaders valueForKey:@"Set-Cookie"];
}

@end
