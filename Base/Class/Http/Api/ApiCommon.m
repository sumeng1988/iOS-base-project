//
//  ApiCommon.m
//  Base
//
//  Created by sumeng on 4/17/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "ApiCommon.h"

@implementation ApiRspObj

- (void)parseDict:(NSDictionary *)dict {
    
}

+ (NSMutableArray *)parseArray:(NSArray *)array cls:(Class)cls {
    if ([cls isSubclassOfClass:[ApiRspObj class]]) {
        NSMutableArray *retArray = [[NSMutableArray alloc] init];
        for (id obj in array) {
            ApiRspObj *apiObj = [[cls alloc] init];
            [apiObj parseDict:obj];
            [retArray addObject:apiObj];
        }
        return retArray;
    }
    else {
        return [[NSMutableArray alloc] initWithArray:array];
    }
}

@end

@implementation ApiRspMeta

- (void)parseDict:(NSDictionary *)dict {
    [super parseDict:dict];
    _code = [dict intForKey:@"code"];
    _message = [dict stringForKey:@"message"];
    _error = [dict stringForKey:@"error"];
}

@end

@implementation ApiResponse

- (instancetype)init {
    self = [super init];
    if (self) {
        _meta = [[ApiRspMeta alloc] init];
    }
    return self;
}

- (void)parseDict:(NSDictionary *)dict {
    [super parseDict:dict];
    [_meta parseDict:[dict dictionaryForKey:@"meta"]];
    if ([_data isKindOfClass:[ApiRspObj class]]) {
        [_data parseDict:[dict dictionaryForKey:@"data"]];
    }
    else {
        _data = [dict objectForKey:@"data"];
    }
}

@end
