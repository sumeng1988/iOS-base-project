//
//  SocketCreateVC.m
//  Base
//
//  Created by sumeng on 4/27/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "SocketCreateVC.h"
#import "SocketCommunicateVC.h"

@interface SocketCreateVC ()

@property (nonatomic, strong) UITextField *ipTf;
@property (nonatomic, strong) UITextField *portTf;

@end

@implementation SocketCreateVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIButton *createBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [createBtn setTitle:@"Create" forState:UIControlStateNormal];
    createBtn.leftTop = CGPointMake(10, 70);
    [createBtn sizeToFit];
    [createBtn addActionForControlEvents:UIControlEventTouchUpInside usingBlock:^(UIControl *sender, UIEvent *event) {
        SocketCommunicateVC *vc = [[SocketCommunicateVC alloc] init];
        [self.navigationController pushViewController:vc animated:YES];;
    }];
    [self.view addSubview:createBtn];
    
    UIButton *joinBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [joinBtn setTitle:@"Join" forState:UIControlStateNormal];
    joinBtn.leftTop = CGPointMake(10, 100);
    [joinBtn sizeToFit];
    [joinBtn addActionForControlEvents:UIControlEventTouchUpInside usingBlock:^(UIControl *sender, UIEvent *event) {
        SocketCommunicateVC *vc = [[SocketCommunicateVC alloc] init];
        vc.ip = _ipTf.text;
        vc.port = [_portTf.text intValue];
        [self.navigationController pushViewController:vc animated:YES];;
    }];
    [self.view addSubview:joinBtn];
    
    UILabel *ipLbl = [[UILabel alloc] init];
    ipLbl.text = @"Server IP:";
    [ipLbl sizeToFit];
    ipLbl.leftCenter = CGPointMake(joinBtn.rightCenter.x+10, joinBtn.rightCenter.y);
    [self.view addSubview:ipLbl];
    
    _ipTf = [[UITextField alloc] init];
    _ipTf.borderStyle = UITextBorderStyleRoundedRect;
    _ipTf.placeholder = @"Server IP";
    _ipTf.size = CGSizeMake(150, 30);
    _ipTf.leftCenter = CGPointMake(ipLbl.rightCenter.x+10, joinBtn.rightCenter.y);
    [self.view addSubview:_ipTf];
    
    UILabel *portLbl = [[UILabel alloc] init];
    portLbl.text = @"Port:";
    [portLbl sizeToFit];
    portLbl.rightCenter = CGPointMake(ipLbl.rightCenter.x, ipLbl.rightCenter.y+40);
    [self.view addSubview:portLbl];
    
    _portTf = [[UITextField alloc] init];
    _portTf.borderStyle = UITextBorderStyleRoundedRect;
    _portTf.placeholder = @"Port";
    _portTf.size = CGSizeMake(80, 30);
    _portTf.leftCenter = CGPointMake(portLbl.rightCenter.x+10, portLbl.rightCenter.y);
    [self.view addSubview:_portTf];
    
    _ipTf.text = @"192.168.1.47";
    _portTf.text = @"61234";
}

#pragma mark - private

@end
