//
//  SocketHelper.m
//  Base
//
//  Created by sumeng on 4/24/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "SocketHelper.h"
#import "GCDAsyncSocket.h"

#define SOCKET_SERVER_PORT 61234

typedef enum _SocketTag {
    SocketTagHead = 1,
    SocketTagBody,
    
    SocketTagTotal
}SocketTag;

@interface SocketHost ()

@property (nonatomic, strong) GCDAsyncSocket* socket;

@end

@implementation SocketHost

@end

@interface SocketHelper () <GCDAsyncSocketDelegate>

@property (nonatomic, strong) GCDAsyncSocket *socket;
@property (nonatomic, strong) SocketHost *serverHost;
@property (nonatomic, strong) NSMutableArray *clientHosts;
@property (nonatomic, assign) BOOL isServer;

@property (nonatomic, strong) NSMutableDictionary *cachedHeadDict;

@end

@implementation SocketHelper

- (id)init {
    self  = [super init];
    if (self) {
        _serverHost = nil;
        _clientHosts = [[NSMutableArray alloc] init];
        _cachedHeadDict = [[NSMutableDictionary alloc] init];
    }
    return self;
}

- (void)open {
    [self close];
    self.socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_main_queue()];
}

- (void)close {
    if (_socket) {
        [_socket disconnect];
        self.socket = nil;
    }
    [_clientHosts removeAllObjects];
    self.serverHost = nil;
}

- (BOOL)accept {
    [self open];
    NSError *err = nil;
    if (![_socket acceptOnPort:SOCKET_SERVER_PORT error:&err]) {
        LOG(@"socket accept() err:%@", err);
        return NO;
    }
    _isServer = YES;
    return YES;
}

- (BOOL)connectToHost:(NSString *)host port:(uint16_t)port {
    if (host && host.length > 0 && port > 0) {
        [self open];
        NSError *err = nil;
        if (![_socket connectToHost:host onPort:port withTimeout:1 error:&err]) {
            LOG(@"socket connectToHost() err:%@", err);
            return NO;
        }
        _isServer = NO;
        return YES;
    }
    return NO;
}

- (void)send:(NSData *)data {
    if (_isServer) {
        [self send:data toHosts:[self clientHosts]];
    }
    else {
        [self send:data toHost:[self serverHost]];
    }
}

- (void)send:(NSData *)data toHost:(SocketHost *)host; {
    [host.socket writeData:data withTimeout:-1 tag:1];
}

- (void)send:(NSData *)data toHosts:(NSArray *)hosts {
    for (SocketHost *host in hosts) {
        [self send:data toHost:host];
    }
}

- (BOOL)isServer {
    return _isServer;
}

- (NSArray *)clientHosts {
    return _clientHosts;
}

- (SocketHost *)serverHost {
    return _serverHost;
}

- (SocketHost *)host:(GCDAsyncSocket *)socket {
    if (_isServer) {
        for (SocketHost *host in _clientHosts) {
            if (host.socket == socket) {
                return host;
            }
        }
    }
    else {
        if (_serverHost.socket == socket) {
            return _serverHost;
        }
    }
    return nil;
}

- (void)read:(NSData *)data tag:(long)tag host:(SocketHost *)host {
    switch (tag) {
        case SocketTagHead: {
            SocketPacketHead *head = [[SocketPacketHead alloc] init];
            [head parse:data];
            if ([head isValid]) {
                LOG(@"socket recieved head, type:%d", head.type);
                [self cacheHead:head host:host];
                [host.socket readDataToLength:[head bodyLength]
                                  withTimeout:-1
                                          tag:SocketTagBody];
            }
            else {
                [host.socket readDataToLength:[SocketPacketHead length]
                                  withTimeout:-1
                                          tag:SocketTagHead];
            }
            break;
        }
        case SocketTagBody: {
            LOG(@"socket recieved body:%@", [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            SocketPacketHead *head = [self cachedHead:host];
            if (head) {
                SocketPacketBody *body = [SocketPacketBodyFactory create:head.type];
                if (body) {
                    SocketPacket *packet = [SocketPacket packetWithHead:head
                                                                   body:body];
                    if (_delegate && [_delegate respondsToSelector:@selector(socketHelper:recievePacket:host:)]) {
                        [_delegate socketHelper:self recievePacket:packet host:host];
                    }
                }
                [self removeCachedHead:host];
            }
            [host.socket readDataToLength:[SocketPacketHead length]
                              withTimeout:-1
                                      tag:SocketTagHead];
            break;
        }
        default:
            break;
    }
}

- (void)cacheHead:(SocketPacketHead *)head host:(SocketHost *)host {
    [_cachedHeadDict setObject:head forKey:[NSString stringWithFormat:@"%@:%d", host.host, host.port]];
}

- (SocketPacketHead *)cachedHead:(SocketHost *)host {
    id obj = [_cachedHeadDict objectForKey:[NSString stringWithFormat:@"%@:%d", host.host, host.port]];
    return [obj isKindOfClass:[SocketPacketHead class]] ? obj : nil;
}

- (void)removeCachedHead:(SocketHost *)host {
    [_cachedHeadDict removeObjectForKey:[NSString stringWithFormat:@"%@:%d", host.host, host.port]];
}

#pragma mark - GCDAsyncSocketDelegate

- (void)socket:(GCDAsyncSocket *)sock didAcceptNewSocket:(GCDAsyncSocket *)newSocket
{
    SocketHost *host = [[SocketHost alloc] init];
    host.socket = newSocket;
    host.host = newSocket.connectedHost;
    host.port = newSocket.connectedPort;
    [_clientHosts addObject:host];
    
    if (_delegate && [_delegate respondsToSelector:@selector(socketHelper:acceptHost:)])
    {
        [_delegate socketHelper:self acceptHost:host];
    }
    
    [newSocket readDataToLength:[SocketPacketHead length]
                    withTimeout:-1
                            tag:SocketTagHead];
}

- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    self.serverHost = [[SocketHost alloc] init];
    _serverHost.socket = sock;
    _serverHost.host = host;
    _serverHost.port = port;
    
    if (_delegate && [_delegate respondsToSelector:@selector(socketHelper:connectToHost:)])
    {
        [_delegate socketHelper:self connectToHost:_serverHost];
    }
    
    [sock readDataToLength:[SocketPacketHead length]
               withTimeout:-1
                       tag:SocketTagHead];
}

- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    switch (tag) {
        case SocketTagHead:
            [self read:data tag:tag host:[self host:sock]];
            break;
        case SocketTagBody:
            [self read:data tag:tag host:[self host:sock]];
            break;
        default:
            break;
    }
}

- (void)socket:(GCDAsyncSocket *)sock didReadPartialDataOfLength:(NSUInteger)partialLength tag:(long)tag
{
    
}

- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    
}

- (NSTimeInterval)socket:(GCDAsyncSocket *)sock shouldTimeoutReadWithTag:(long)tag elapsed:(NSTimeInterval)elapsed bytesDone:(NSUInteger)length
{
    return elapsed;
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err {
    SocketHost *host = nil;
    if (sock) {
        if (sock == _socket) {
            [self close];
        }
        else {
            host = [self host:sock];
            [_clientHosts removeObject:[self host:sock]];
        }
    }
    if (_delegate && [_delegate respondsToSelector:@selector(socketHelper:disconnect:)])
    {
        [_delegate socketHelper:self disconnect:host];
    }
}

@end

