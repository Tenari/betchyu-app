//  API.m
//  betchyu
//
//  Created by Daniel Zapata on 12/11/13.
//  Copyright (c) 2013 BetchyuLLC. All rights reserved.

#import "API.h"

//#define kAPIHost @"http://betchyu.herokuapp.com"
#define kAPIHost @"http://localhost:5000"

@implementation API

#pragma mark - Singleton methods
/**
 * Singleton methods
 */
+(API*)sharedInstance
{
    static API *sharedInstance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        sharedInstance = [[self alloc] initWithBaseURL:[NSURL URLWithString:kAPIHost]];
    });
    
    return sharedInstance;
}

#pragma mark - init
//intialize the API class with the destination host name

-(API*)init
{
    //call super init
    self = [super init];
    
    if (self != nil) {

        [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
        
        // Accept HTTP Header; see http://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.1
        [self setDefaultHeader:@"Accept" value:@"application/json"];
    }
    
    return self;
}

-(void)post:(NSString *)path withParams:(NSMutableDictionary*)params onCompletion:(JSONResponseBlock)completionBlock
{
    if ([self checkConnectionError]) {
        return;
    }
    NSMutableURLRequest *apiRequest =
    [self multipartFormRequestWithMethod:@"POST"
                                    path:path
                              parameters:params
               constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
                   //TODO: attach file if needed
               }];
    
    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: apiRequest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //success!
        completionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //failure :(
        completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    
    [operation start];
}
-(void)get:(NSString *)path withParams:(NSMutableDictionary*)params onCompletion:(JSONResponseBlock)completionBlock
{
    if ([self checkConnectionError]) {
        return;
    }
    NSMutableURLRequest *apiRequest = [self requestWithMethod:@"GET" path:path parameters:params];
    
    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: apiRequest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //success!
        completionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //failure :(
        completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    
    [operation start];
}
-(void)put:(NSString *)path withParams:(NSMutableDictionary*)params onCompletion:(JSONResponseBlock)completionBlock
{
    if ([self checkConnectionError]) {
        return;
    }
    NSMutableURLRequest *apiRequest =[self requestWithMethod:@"PUT" path:path parameters:params];
    
    AFJSONRequestOperation* operation = [[AFJSONRequestOperation alloc] initWithRequest: apiRequest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        //success!
        completionBlock(responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //failure :(
        completionBlock([NSDictionary dictionaryWithObject:[error localizedDescription] forKey:@"error"]);
    }];
    
    [operation start];
}

/// returns YES if there is a problem
-(BOOL)checkConnectionError {
    Reachability *networkReachability = [Reachability reachabilityForInternetConnection];
    NetworkStatus networkStatus = [networkReachability currentReachabilityStatus];
    if (networkStatus == NotReachable) {
        [[[UIAlertView alloc] initWithTitle:@"Connection Error" message:@"You don't appear to be connected to the internet. Sorry." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil] show];
        return YES;
    }
    return NO;
}

@end
