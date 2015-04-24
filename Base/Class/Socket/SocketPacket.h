//
//  SocketPacket.h
//  Base
//
//  Created by sumeng on 4/24/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 *  |0                                                 32|
 *  |----------------------------------------------------|
 *  |                   Total Length                     |
 *  |----------------------------------------------------|
 *  |    Flags   |    Type    |           Tail           |
 *  |----------------------------------------------------|
 *  |                       Data                         |
 *  |----------------------------------------------------|
 */

typedef enum _SocketPacketType {
    SocketPacketTypeMsg = 1,
    
    SocketPacketTypeTotal
}SocketPacketType;

@class SocketPacketHead;
@class SocketPacketBody;

@interface SocketPacket : NSObject

@property (nonatomic, strong) SocketPacketHead *head;
@property (nonatomic, strong) SocketPacketBody *body;

- (NSData *)data;

+ (SocketPacket *)packetWithBody:(SocketPacketBody *)body;

+ (SocketPacket *)packetWithHead:(SocketPacketHead *)head
                            body:(SocketPacketBody *)body;

@end

@interface SocketPacketHead : NSObject

@property (nonatomic, assign) UInt32 length;
@property (nonatomic, assign) UInt8 flags;
@property (nonatomic, assign) UInt8 type;
@property (nonatomic, assign) UInt16 tail;

@property (nonatomic, assign) UInt32 bodyLength;

- (void)parse:(NSData *)data;
- (NSData *)data;
- (BOOL)isValid;

+ (SocketPacketHead *)headFromBody:(SocketPacketBody *)body;
+ (UInt32)length;

@end

@interface SocketPacketBody : NSObject

@property (nonatomic, assign) SocketPacketType type;
@property (nonatomic, assign) UInt32 length;

- (void)parse:(NSData *)data;
- (NSData *)data;

@end

@interface SocketPacketMsg : SocketPacketBody

@property (nonatomic, copy) NSString *msg;

@end


@interface SocketPacketBodyFactory : NSObject

+ (SocketPacketBody *)create:(SocketPacketType)type;

@end
