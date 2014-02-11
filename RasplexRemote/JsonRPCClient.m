//
//  JsonRPCClient.m
//  RasplexRemote
//
//  Created by Daniele Rossetti on 14/11/13.
//  Copyright (c) 2013 Daniele Rossetti. All rights reserved.
//

#import "JsonRPCClient.h"
#define HOST_KEY @"JRPCCHost"
#define HOST_DEFAULT @"rasplex.local"
#define PORT_KEY @"JRPCCPort"
#define PORT_DEFAULT @"3005"

@interface JsonRPCClient()<NSURLSessionDelegate>
@property (nonatomic,strong) NSURLSessionConfiguration *sessionConfig;
@property (nonatomic,weak) id delegate;
@end

@implementation JsonRPCClient
@synthesize host=_host;
@synthesize port=_port;

- (void)setHost:(NSString *)host{
    if ([host isEqualToString:@""]){
        host = HOST_DEFAULT;
    }
    _host = host;
    NSLog(@"New host saved: %@",host);
    [[NSUserDefaults standardUserDefaults] setObject:host forKey:HOST_KEY];
}
- (NSString*)host{
    if (!_host){
        _host = [[NSUserDefaults standardUserDefaults] objectForKey:HOST_KEY];
        if(!_host) _host = HOST_DEFAULT;
    }
    return _host;
}
- (void)setPort:(NSString *)port{
    if ([port isEqualToString:@""]){
        port = PORT_DEFAULT;
    }
    _port = port;
    NSLog(@"New port saved: %@",port);
    [[NSUserDefaults standardUserDefaults] setObject:port forKey:PORT_KEY];
}
- (NSString*)port{
    if (!_port){
        _port = [[NSUserDefaults standardUserDefaults] objectForKey:PORT_KEY];
        if(!_port) _port = PORT_DEFAULT;
    }
    return _port;
}

- (id)initWithDelegate:(id<JsonRPCClientDelegate>)delegate{
    self = [super init];
    if (self){
        _sessionConfig =[NSURLSessionConfiguration defaultSessionConfiguration];
        _sessionConfig.timeoutIntervalForRequest = 2.0;
        _sessionConfig.allowsCellularAccess = NO;
        [_sessionConfig setHTTPAdditionalHeaders:@{@"Accept": @"application/json",@"Accept-Encoding":@"gzip",@"Content-Type":@"application/json"}];
        _delegate = delegate;
    }
    return self;
}
- (NSString*) serverURL{
    return [NSString stringWithFormat:@"http://%@:%@/jsonrpc",self.host,self.port];
}
- (void) down{
    [self sendMethod:@"Input.Down" params:nil];
}
- (void) up{
    [self sendMethod:@"Input.Up" params:nil];
}
- (void) left{
    [self sendMethod:@"Input.Left" params:nil];
}
- (void) right{
    [self sendMethod:@"Input.Right" params:nil];
}
- (void) ok{
    [self sendMethod:@"Input.Select" params:nil];
}
- (void) back{
    [self sendMethod:@"Input.Back" params:nil];
}
- (void) play{
    [self sendMethod:@"Player.PlayPause" params:@{@"playerid":@(1)}];
}
- (void) stop{
    [self sendMethod:@"Player.Stop" params:@{@"playerid":@(1)}];
}
- (void) rewind{
    [self sendMethod:@"Player.SetSpeed" params:@{@"playerid":@(1),@"speed": @(-2)}];
}
- (void) fastForward{
    [self sendMethod:@"Player.SetSpeed" params:@{@"playerid":@(1),@"speed": @(2)}];
}
- (void) stepForward{
    [self sendMethod:@"Input.StepForward" params:@{@"playerid":@(1)}];
}
- (void) bigStepForward{
    [self sendMethod:@"Input.BigStepForward" params:@{@"playerid":@(1)}];
}
- (void) stepBack{
    [self sendMethod:@"Input.StepBackward" params:@{@"playerid":@(1)}];
}
- (void) bigStepBack{
    [self sendMethod:@"Input.BigStepBackward" params:@{@"playerid":@(1)}];
}
- (void) setVolume:(NSUInteger) volume{
    [self sendMethod:@"Application.SetVolume" params:@{@"volume":@(volume)}];
}
- (void)toggleMenu{
    [self sendMethod:@"Input.ShowOSD" params:nil];
}

- (void) sendMethod:(NSString*)method params:(NSDictionary*)params{
    NSURLSession *session =[NSURLSession sessionWithConfiguration:self.sessionConfig
                                                         delegate:self
                                                    delegateQueue:nil];
    NSURL *url = [NSURL URLWithString:[self serverURL]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    NSMutableDictionary *d = [NSMutableDictionary dictionaryWithDictionary:@{@"jsonrpc":@"2.0",@"method": method}];
    if (params >0){
        [d addEntriesFromDictionary:@{@"params":params}];
    }
    request.HTTPBody = [NSJSONSerialization dataWithJSONObject:d options:0 error:nil];
    request.HTTPMethod = @"POST";
    NSURLSessionTask * task = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate messageFail];
            });
            
        }else{
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate messageSent];
            });
        }
    }];
    [task resume];
}



@end
