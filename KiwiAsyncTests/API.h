//
//  API.h
//  KiwiAsyncTests
//
//  Created by pragmapilot on 18/09/2014.
//  Copyright (c) 2014 pragmapilot. All rights reserved.
//

#import "AFHTTPClient.h"

@interface API : AFHTTPClient

+(API*)sharedInstance;

-(void)syncWithSuccessBlock:(void (^)())successBlock failureBlock:(void (^)(NSHTTPURLResponse *response, NSError *error))failureBlock;

-(void)syncAndMakesMoreRequestsWithSuccessBlock:(void (^)())successBlock failureBlock:(void (^)(NSHTTPURLResponse *response, NSError *error))failureBlock;

-(void)methodCalledInRequestSuccessBlock;
-(void)methodCalledInDispatchAsync;

-(void)methodCalledInRequestSuccessBlockWhichMakesAnotherRequest;
-(void)methodCalledInDispatchAsyncWhichMakesAnotherRequest;

@end
