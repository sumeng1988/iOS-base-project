//
//  SocketCommunicateVC.h
//  Base
//
//  Created by sumeng on 4/27/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "UIViewControllerExt.h"

@interface SocketCommunicateVC : UITableViewController

@property (nonatomic, copy) NSString *ip;
@property (nonatomic, assign) UInt16 port;

@end
