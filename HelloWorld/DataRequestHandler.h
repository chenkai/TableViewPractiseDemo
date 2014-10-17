//
//  DataRequestHandler.h
//  HelloWorld
//
//  Created by Shuo.Xiong on 14-10-16.
//  Copyright (c) 2014年 kai.chen. All rights reserved.
//

#import <Foundation/Foundation.h>
@class CityInfo,AppDelegate;


@interface DataRequestHandler : NSObject
{
    @public
    NSString *requestUrl;
}

- (void) setRequestUrl:(NSString *) url;
- (NSData *) requestResult;
@end
