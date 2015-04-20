//
//  ApiDemo.h
//  Base
//
//  Created by sumeng on 4/17/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "ApiModel.h"

@interface ApiDemo : ApiModel

@property (nonatomic, copy) NSString *username;
@property (nonatomic, copy) NSString *password;
@property (nonatomic, copy) NSString *avatar;  //file

@end


@interface ApiDemoRspInfo : ApiRspObj

@property (nonatomic, copy) NSString *name;

@end

@interface ApiDemoRspData : NSMutableArray  //ApiDemoRspInfo

//@property (nonatomic, strong) NSMutableArray *infos;  //ApiDemoRspInfo
//@property (nonatomic, strong) NSMutableArray *moods;  //NSString

@end
