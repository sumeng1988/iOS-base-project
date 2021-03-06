//
//  ApiDemo.m
//  Base
//
//  Created by sumeng on 4/17/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "ApiDemo.h"

@implementation ApiDemo

- (instancetype)init {
    self = [super init];
    if (self) {
        self.clsRspDataGET = [ApiDemoRspData class];
    }
    return self;
}

- (NSString *)url {
    return @"/adat/sk/101010100.html";
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

@implementation ApiDemoRspInfo

- (void)parseDict:(NSDictionary *)dict {
    [super parseDict:dict];
    _name = [dict stringForKey:@"name"];
}

@end

@implementation ApiDemoRspData

- (instancetype)init {
    self = [super init];
    if (self) {

    }
    return self;
}

- (void)parseDict:(NSDictionary *)dict {
    [super parseDict:dict];
    
    self.infos = [self.class parseArray:[dict arrayForKey:@"infos"] cls:[ApiDemoRspInfo class]];
    self.moods = [self.class parseArray:[dict arrayForKey:@"moods"] cls:[NSString class]];
}

@end
