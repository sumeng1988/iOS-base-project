//
//  ApiDemo.m
//  Base
//
//  Created by sumeng on 4/17/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "ApiDemo.h"

@implementation ApiDemo

- (NSString *)url {
    return @"/demo";
}

- (void)setUsername:(NSString *)username {
    _username = username;
    [self setParam:@"username" value:username];
}

- (void)setPassword:(NSString *)password {
    _password = password;
    [self setParam:@"password" value:password];
}

- (void)setAvatar:(NSString *)avatar {
    _avatar = avatar;
    [self setFile:@"avatar" value:avatar];
}

@end
