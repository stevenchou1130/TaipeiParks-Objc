//
//  ParkProvider.m
//  TaipeiParks-Objc
//
//  Created by steven.chou on 2017/5/30.
//  Copyright © 2017年 stevenchou. All rights reserved.
//

#import "ParkProvider.h"

@implementation ParkProvider

// Singleton
+(instancetype) sharedInstance {

    static ParkProvider *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[ParkProvider alloc] init];
    });

    return instance;
}

-(void) getParkDataWithLimitNum:(int)limitNum withOffsetNum:(int)offsetNum {

    NSString *urlString = @"http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=bf073841-c734-49bf-a97f-3757a6013812";

    NSString *urlWithParams = [NSString stringWithFormat:@"%@&limit=%d&offset=%d", urlString , limitNum, offsetNum];

    NSLog(@"%@", urlWithParams);

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlWithParams]];
    [request setHTTPMethod:@"GET"];

    NSURLSession *session = [NSURLSession sharedSession];

    NSURLSessionDataTask *dataTask =
    [
     session dataTaskWithRequest:request
     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        if (error) {
                NSLog(@"===Error: %@", error);
            } else {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;

                switch (httpResponse.statusCode) {
                    case 200:
                        NSLog(@"statusCode is 200.");

                        // todo: parse JSON
                        // todo: completionHandler

                        break;

                    default:
                        NSLog(@"httpResponse statusCode is not 200.");
                        break;
                }
            }
        }
     ];

    [dataTask resume];
}

-(NSMutableArray<ParkModel *> *) parseParkJSON:(NSData *)data {

    return nil;
}

@end
