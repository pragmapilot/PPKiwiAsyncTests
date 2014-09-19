//
//  API.m
//  KiwiAsyncTests
//
//  Created by pragmapilot on 18/09/2014.
//  Copyright (c) 2014 pragmapilot. All rights reserved.
//

#import "API.h"
#import "AFJSONRequestOperation.h"

@implementation API

+ (API *)sharedInstance {
    static API *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedClient = [[API alloc] initWithBaseURL:[NSURL URLWithString:@"www.google.com"]];
    });
    
    return _sharedClient;
}

- (void)syncWithSuccessBlock:(void (^)())successBlock failureBlock:(void (^)(NSHTTPURLResponse *response, NSError *error))failureBlock
{
    NSMutableURLRequest *request = [self requestWithMethod:@"GET"
                                                          path:nil
                                                    parameters:nil];
    
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        [self methodCalledInRequestSuccessBlock];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self methodCalledInDispatchAsync];
            
            if (successBlock)
                successBlock();
        });
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (failureBlock) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                failureBlock(response, error);
            });
        }
    }];
    [self enqueueHTTPRequestOperation:operation];    
}

-(void)syncAndMakesMoreRequestsWithSuccessBlock:(void (^)())successBlock failureBlock:(void (^)(NSHTTPURLResponse *response, NSError *error))failureBlock
{
    NSMutableURLRequest *request = [self requestWithMethod:@"GET"
                                                      path:nil
                                                parameters:nil];
    
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {

        [self methodCalledInRequestSuccessBlockWhichMakesAnotherRequest];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self methodCalledInDispatchAsyncWhichMakesAnotherRequest];
            
            if (successBlock)
                successBlock();
        });
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        if (failureBlock) {
            dispatch_async(dispatch_get_main_queue(), ^(void){
                failureBlock(response, error);
            });
        }
    }];
    [self enqueueHTTPRequestOperation:operation];
}


-(void)methodCalledInRequestSuccessBlock
{
    NSLog(@"*** %s",__PRETTY_FUNCTION__);
}

-(void)methodCalledInDispatchAsync
{
    NSLog(@"*** %s",__PRETTY_FUNCTION__);
}

-(void)methodCalledInRequestSuccessBlockWhichMakesAnotherRequest
{
    NSMutableURLRequest *request = [self requestWithMethod:@"GET"
                                                      path:nil
                                                parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"*** %s OK!",__PRETTY_FUNCTION__);

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"*** %s OK!",__PRETTY_FUNCTION__);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
}

-(void)methodCalledInDispatchAsyncWhichMakesAnotherRequest
{
    NSMutableURLRequest *request = [self requestWithMethod:@"GET"
                                                      path:nil
                                                parameters:nil];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        NSLog(@"*** %s OK!",__PRETTY_FUNCTION__);
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        NSLog(@"*** %s OK!",__PRETTY_FUNCTION__);
    }];
    
    [self enqueueHTTPRequestOperation:operation];
}

@end
