//
//  JsonRPCClient.h
//  RasplexRemote
//
//  Created by Daniele Rossetti on 14/11/13.
//  Copyright (c) 2013 Daniele Rossetti. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "JsonRPCClientDelegate.h"

@interface JsonRPCClient : NSObject
@property (nonatomic,strong) NSString* host;
@property (nonatomic,strong) NSString* port;
- (id) initWithDelegate:(id<JsonRPCClientDelegate>)delegate;
- (void) down;
- (void) up;
- (void) left;
- (void) right;
- (void) ok;
- (void) back;
- (void) play;
- (void) stop;
- (void) rewind;
- (void) fastForward;
- (void) stepForward;
- (void) bigStepForward;
- (void) stepBack;
- (void) bigStepBack;
- (void) setVolume:(NSUInteger) volume;
- (void) toggleMenu;
@end
