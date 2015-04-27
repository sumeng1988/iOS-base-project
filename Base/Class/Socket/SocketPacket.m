//
//  SocketPacket.m
//  Base
//
//  Created by sumeng on 4/24/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "SocketPacket.h"

static const UInt16 sHeadTail = 0x0D0A;

@implementation SocketPacket

- (NSData *)data {
    if (_head && _body) {
        NSMutableData *data = [[NSMutableData alloc] init];
        [data appendData:[_head data]];
        [data appendData:[_body data]];
        return data;
    }
    return nil;
}

+ (SocketPacket *)packetWithBody:(SocketPacketBody *)body {
    return [self packetWithHead:nil body:body];
}

+ (SocketPacket *)packetWithHead:(SocketPacketHead *)head
                            body:(SocketPacketBody *)body
{
    SocketPacket *packet = [[SocketPacket alloc] init];
    packet.head = head ? head : [SocketPacketHead headFromBody:body];
    packet.body = body;
    return packet;
}

@end

@implementation SocketPacketHead

- (void)parse:(NSData *)data {
    if (data.length < [[self class] length]) {
        return;
    }
    NSUInteger offset = 0;
    _length = ntohl([data readUInt:offset]);
    offset += sizeof(_length);
    
    _flags = [data readByte:offset];
    offset += sizeof(_flags);
    
    _type = [data readByte:offset];
    offset += sizeof(_type);
    
    _tail = ntohs([data readUShort:offset]);
    offset += sizeof(_tail);
}

- (NSData *)data {
    NSMutableData* data = [[NSMutableData alloc] init];
    [data appendUInt:htonl(_length)];
    [data appendByte:_flags];
    [data appendByte:_type];
    [data appendUShort:htons(_tail)];
    return data;
}

- (BOOL)isValid {
    return _tail == sHeadTail && _length > [[self class] length];
}

- (void)setBodyLength:(UInt32)bodyLength {
    _length = [[self class] length] + bodyLength;
}

- (UInt32)bodyLength {
    if (_length > [[self class] length]) {
        return _length - [[self class] length];
    }
    return 0;
}

+ (UInt32)length {
    return 2 * sizeof(UInt32);
}

+ (SocketPacketHead *)headFromBody:(SocketPacketBody *)body {
    SocketPacketHead *head = [[SocketPacketHead alloc] init];
    head.bodyLength = body.length;
    head.type = body.type;
    head.tail = sHeadTail;
    return head;
}

@end

@implementation SocketPacketBody

- (void)parse:(NSData *)data {
    
}

- (NSData *)data {
    return nil;
}

- (UInt32)length {
    return 0;
}

@end

@implementation SocketPacketMsg

- (instancetype)init {
    self = [super init];
    if (self) {
        self.type = SocketPacketTypeMsg;
    }
    return self;
}

- (void)parse:(NSData *)data {
    self.msg = [[NSString alloc] initWithData:data
                                     encoding:NSUTF8StringEncoding];
}

- (NSData *)data {
    return [_msg dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)setMsg:(NSString *)msg {
    _msg = msg;
}

- (UInt32)length {
    return (UInt32)[self data].length;
}

@end

@implementation SocketPacketBodyFactory

+ (SocketPacketBody *)create:(SocketPacketType)type {
    switch (type) {
        case SocketPacketTypeMsg:
            return [[SocketPacketMsg alloc] init];
        default:
            return nil;
    }
}

@end
