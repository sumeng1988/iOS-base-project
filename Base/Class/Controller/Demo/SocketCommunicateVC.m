//
//  SocketCommunicateVC.m
//  Base
//
//  Created by sumeng on 4/27/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "SocketCommunicateVC.h"
#import "SocketHelper.h"
#import "SMInputBar.h"

@interface SocketCommunicateVC () <SocketHelperDelegate, SMInputBarDelegate>

@property (nonatomic, assign) BOOL isServer;
@property (nonatomic, strong) SocketHelper *socket;
@property (nonatomic, strong) NSMutableArray *datas;

@property (nonatomic, strong) SMInputBar *inputBar;

@end

@implementation SocketCommunicateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _datas = [[NSMutableArray alloc] init];
    _socket = [[SocketHelper alloc] init];
    _socket.delegate = self;
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"say hello" style:UIBarButtonItemStylePlain target:self action:@selector(sayHello)];
    
    _isServer = (_ip == nil);
    if (_isServer) {
        [_socket accept];
    }
    else {
        [_socket connectToHost:_ip port:_port];
    }
    
    _inputBar = [[SMInputBar alloc] initWithFrame:CGRectMake(0, self.view.height-kInputBarHeightDefault, self.view.width, kInputBarHeightDefault)];
    _inputBar.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    _inputBar.delegate = self;
    self.footerView = _inputBar;
}

- (void)dealloc {
    [_socket close];
    _socket.delegate = nil;
}

#pragma mark - private

- (void)sayHello {
    NSString *msg = @"hello";
    [self insertMsg:msg];
    [_socket send:[[self packetWithMsg:msg] data]];
}

- (void)sendMsg:(NSString *)msg {
    [self insertMsg:msg];
    [_socket send:[[self packetWithMsg:msg] data]];
}

- (void)insertMsg:(NSString *)msg {
    [_datas insertObject:msg atIndex:0];
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}

- (SocketPacket *)packetWithMsg:(NSString *)msg {
    SocketPacketMsg *body = [[SocketPacketMsg alloc] init];
    body.msg = msg;
    return [SocketPacket packetWithBody:body];
}

#pragma mark - SocketHelperDelegate

- (void)socketHelper:(SocketHelper *)socket acceptHost:(SocketHost *)host {
    if (!_isServer) {
        return;
    }
    NSString *msg = [NSString stringWithFormat:@"%@:%d come in", host.host, host.port];
    [self insertMsg:msg];
    NSData *data = [[self packetWithMsg:msg] data];
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
        if (_isServer) {
            NSData *data = [[self packetWithMsg:msg] data];
            for (SocketHost *h in socket.clientHosts) {
                if (h != host) {
                    [socket send:data toHost:h];
                }
            }
        }
    }
}

- (void)socketHelper:(SocketHelper *)socket disconnect:(SocketHost *)host error:(NSError *)error
{
    if (_isServer) {
        NSString *msg = [NSString stringWithFormat:@"%@:%d has left", host.host, host.port];
        [self insertMsg:msg];
        NSData *data = [[self packetWithMsg:msg] data];
        [socket send:data];
    }
    else {
        NSString *msg = @"connection failed";
        [self insertMsg:msg];
    }
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

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (_inputBar.status != SMInputBarStatusNone) {
        _inputBar.status = SMInputBarStatusNone;
    }
}

#pragma mark - SMInputBarDelegate

- (void)inputBar:(SMInputBar *)bar sendText:(NSString *)text {
    LOG(@"inputBar sendText:%@", text);
    [self sendMsg:text];
}

- (void)inputBar:(SMInputBar *)bar sendImages:(NSArray *)paths {
    LOG(@"inputBar sendImages:%@", paths);
    [self sendMsg:@"[image]"];
}

- (void)inputBar:(SMInputBar *)bar willChangeFrame:(CGRect)frame withDuration:(NSTimeInterval)duration
{
    LOG(@"inputBar willChangeFrame:%.1f", frame.size.height);
    [UIView animateWithDuration:duration
                     animations:^{
                         self.tableView.height = self.view.height - frame.size.height;
                         bar.y = self.tableView.height;
                     }
                     completion:^(BOOL finished) {

                     }];
}

- (void)inputBar:(SMInputBar *)bar didChangeFrame:(CGRect)frame {
    LOG(@"inputBar didChangeFrame:%.1f", frame.size.height);
}

@end
