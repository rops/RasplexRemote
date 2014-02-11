//
//  JsonRPCClientDelegate.h
//  RasplexRemote
//
//  Created by Daniele Rossetti on 14/11/13.
//  Copyright (c) 2013 Daniele Rossetti. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol JsonRPCClientDelegate <NSObject>
@optional
- (void) messageSent;
- (void) messageFail;
@end
