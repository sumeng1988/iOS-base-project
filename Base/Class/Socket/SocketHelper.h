//
//  SocketHelper.h
//  Base
//
//  Created by sumeng on 4/24/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketPacket.h"

@protocol SocketHelperDelegate;

@interface SocketHost : NSObject

@property (nonatomic, strong) NSString *host;
@property (nonatomic, assign) uint16_t port;

@end

@interface SocketHelper : NSObject

@property (nonatomic, assign) id<SocketHelperDelegate> delegate;

- (BOOL)accept;
- (BOOL)connectToHost:(NSString *)host port:(uint16_t)port;
- (void)send:(NSData *)data;
- (void)send:(NSData *)data toHost:(SocketHost *)host;
- (void)send:(NSData *)data toHosts:(NSArray *)hosts;
- (void)close;

- (BOOL)isServer;
- (NSArray *)clientHosts;
- (SocketHost *)serverHost;

@end

@protocol SocketHelperDelegate <NSObject>

@optional

- (void)socketHelper:(SocketHelper *)helper
          acceptHost:(SocketHost *)host;

- (void)socketHelper:(SocketHelper *)helper
       connectToHost:(SocketHost *)host;

- (void)socketHelper:(SocketHelper *)helper
       recievePacket:(SocketPacket *)packet
                host:(SocketHost *)host;

- (void)socketHelper:(SocketHelper *)helper
          disconnect:(SocketHost *)host;

@end
