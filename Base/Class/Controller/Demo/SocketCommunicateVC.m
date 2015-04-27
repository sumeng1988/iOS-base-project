//
//  SocketCommunicateVC.m
//  Base
//
//  Created by sumeng on 4/27/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "SocketCommunicateVC.h"
#import "SocketHelper.h"

@interface SocketCommunicateVC () <SocketHelperDelegate>

@property (nonatomic, assign) BOOL isServer;
@property (nonatomic, strong) SocketHelper *socket;
@property (nonatomic, strong) NSMutableArray *datas;

@end

@implementation SocketCommunicateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _datas = [[NSMutableArray alloc] init];
    _socket = [[SocketHelper alloc] init];
    _socket.delegate = self;
    
    _isServer = (_ip == nil);
    if (_isServer) {
        [_socket accept];
    }
    else {
        [_socket connectToHost:_ip port:_port];
    }
}

- (void)dealloc {
    [_socket close];
    _socket.delegate = nil;
}

#pragma mark - private

- (void)insertMsg:(NSString *)msg {
    [_datas insertObject:msg atIndex:0];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - SocketHelperDelegate

- (void)socketHelper:(SocketHelper *)socket acceptHost:(SocketHost *)host {
    if (!_isServer) {
        return;
    }
    NSString *msg = [NSString stringWithFormat:@"%@:%d come in", host.host, host.port];
    [self insertMsg:msg];
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    for (SocketHost *h in socket.clientHosts) {
        if (h != host) {
            [socket send:data toHost:h];
        }
    }
}

- (void)socketHelper:(SocketHelper *)socket connectToHost:(SocketHost *)host {
    if (_isServer) {
        return;
    }
    [self insertMsg:@"connect successful"];
}

- (void)socketHelper:(SocketHelper *)socket recievePacket:(SocketPacket *)packet host:(SocketHost *)host
{
    if (packet.body.type == SocketPacketTypeMsg) {
        SocketPacketMsg *body = (SocketPacketMsg *)packet.body;
        
        NSString *msg = [NSString stringWithFormat:@"%@:%d say:%@", host.host, host.port, body.msg];
        [self insertMsg:msg];
        NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
        for (SocketHost *h in socket.clientHosts) {
            if (h != host) {
                [socket send:data toHost:h];
            }
        }
    }
}

- (void)socketHelper:(SocketHelper *)socket disconnect:(SocketHost *)host {
    if (!_isServer) {
        return;
    }
    NSString *msg = [NSString stringWithFormat:@"%@:%d has left", host.host, host.port];
    [self insertMsg:msg];
    NSData *data = [msg dataUsingEncoding:NSUTF8StringEncoding];
    [socket send:data];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *sCellId = @"cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:sCellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:sCellId];
    }
    cell.textLabel.text = _datas[indexPath.row];
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
