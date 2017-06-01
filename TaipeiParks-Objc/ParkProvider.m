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

-(void) getParkDataWithLimitNum:(int)limitNum withOffsetNum:(int)offsetNum withCompletionHandler:(void (^__nonnull)(NSMutableArray<ParkModel *> * __nullable parkArray, NSError * __nullable error)) completionHandler {

    __block NSMutableArray<ParkModel*> *parkArray = [[NSMutableArray alloc] init];

    NSString *urlString = @"http://data.taipei/opendata/datalist/apiAccess?scope=resourceAquire&rid=bf073841-c734-49bf-a97f-3757a6013812";

    NSString *urlWithParams = [NSString stringWithFormat:@"%@&limit=%d&offset=%d", urlString , limitNum, offsetNum];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:urlWithParams]];
    [request setHTTPMethod:@"GET"];

    NSURLSession *session = [NSURLSession sharedSession];

    NSURLSessionDataTask *dataTask =
    [
     session dataTaskWithRequest:request
     completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {

        if (error) {
                completionHandler(nil, error);
            } else {
                NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;

                switch (httpResponse.statusCode) {
                    case 200:

                        parkArray = [self parseParkJSON:data];

                        completionHandler(parkArray, nil);

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

    NSMutableArray<ParkModel*> *parkArray = [[NSMutableArray alloc] init];

    NSError *jsonError;
    NSDictionary *jsonResponse = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];

    if (jsonError) {

        // Error Parsing JSON
        NSLog(@"===Error: %@", jsonError);

    } else {

        // Success Parsing JSON
        NSDictionary *jsonObject = (NSDictionary *)jsonResponse;
        if (jsonObject == nil) {
            return nil;
        }

        NSDictionary *result = [jsonObject objectForKey:@"result"];
        if (result == nil) {
            return nil;
        }

        NSArray *results = [result objectForKey:@"results"];
        if (results == nil) {
            return nil;
        }

        for (NSDictionary *item in results) {

            NSString *parkName = [item objectForKey:@"ParkName"];
            NSString *name = [item objectForKey:@"Name"];
            NSString *introduction = [item objectForKey:@"Introduction"];
            NSString *imageUrlString = [item objectForKey:@"Image"];

            ParkModel *park = [[ParkModel alloc] initWithParkName:parkName name:name image:imageUrlString introduction:introduction];

            [parkArray addObject:park];
        }
    }

    return parkArray;
}

@end
