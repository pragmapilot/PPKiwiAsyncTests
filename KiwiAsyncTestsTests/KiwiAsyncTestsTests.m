//
//  KiwiAsyncTestsTests.m
//  KiwiAsyncTestsTests
//
//  Created by pragmapilot on 18/09/2014.
//  Copyright (c) 2014 pragmapilot. All rights reserved.
//

#import "Kiwi.h"
#import <OHHTTPStubs/OHHTTPStubs.h>
#import "API.h"

SPEC_BEGIN(KIWIASYNCTESTSSPEC)

describe(@"Kiwi Async Tests", ^{

    __block id<OHHTTPStubsDescriptor> stub = nil;
    
    __block API *api;
    
    beforeAll(^{
        api = [API sharedInstance];
    });
    
    afterAll(^{
        api = nil;
    });
    
    beforeEach(^{
       stub = [OHHTTPStubs stubRequestsPassingTest:^BOOL(NSURLRequest *request) {
           return YES;
       } withStubResponse:^OHHTTPStubsResponse *(NSURLRequest *request) {
           return [OHHTTPStubsResponse responseWithFileAtPath:OHPathForFileInBundle(@"success.json", nil)
                                                   statusCode:200
                                                      headers:@{@"Content-Type":@"text/json"}];
       }];
        stub.name = @"success";
    });
    afterEach(^{
        [OHHTTPStubs removeStub:stub];
    });
    
    it(@"should work", ^{
        [api syncWithSuccessBlock:nil failureBlock:nil];
        [[api shouldEventually] receive:@selector(methodCalledInRequestSuccessBlock)];
    });
    
    it(@"should also work", ^{
        [api syncWithSuccessBlock:nil failureBlock:nil];
        [[api shouldEventually] receive:@selector(methodCalledInDispatchAsync)];
    });
    
    it(@"should call block", ^{
        
        __block BOOL calledBlock = NO;
        
       [api syncWithSuccessBlock:^{
           calledBlock = YES;
       } failureBlock:nil];
        
        [[expectFutureValue(theValue(calledBlock)) shouldEventually] beTrue];
    });
    
    context(@"Methods that make web calls", ^{
        it(@"should work", ^{
            [api syncAndMakesMoreRequestsWithSuccessBlock:nil failureBlock:nil];
            [[api shouldEventually] receive:@selector(methodCalledInRequestSuccessBlockWhichMakesAnotherRequest)];
        });
        
        it(@"should also work", ^{
            [api syncAndMakesMoreRequestsWithSuccessBlock:nil failureBlock:nil];
            [[api shouldEventually] receive:@selector(methodCalledInDispatchAsyncWhichMakesAnotherRequest)];
        });
    });
});

SPEC_END


