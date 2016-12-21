//
//  REEventModel.m
//  Remember
//
//  Created by Lelouch on 2016/11/22.
//  Copyright © 2016年 enice. All rights reserved.
//

#import "REEventModel.h"

@implementation REEventModel

- (id)initWithCoder:(NSCoder *)decoder {
    
    if(self = [super init]) {
        
        self.event = [decoder decodeObjectForKey:@"event"];
        self.eventDate = [decoder decodeObjectForKey:@"eventDate"];
        self.isTop = [decoder decodeObjectForKey:@"isTop"];
        self.isRepeat = [decoder decodeObjectForKey:@"isRepeat"];
        
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeObject:self.event forKey:@"event"];
    [encoder encodeObject:self.eventDate forKey:@"eventDate"];
    [encoder encodeObject:self.isTop forKey:@"isTop"];
    [encoder encodeObject:self.isRepeat forKey:@"isRepeat"];
    
}

- (id)copyWithZone:(NSZone *)zone {
    
    REEventModel *model = [[REEventModel alloc] init];
    model.event = [self.event copy];
    model.eventDate = [self.eventDate copy];
    model.isTop = [self.isTop copy];
    model.isRepeat = [self.isRepeat copy];

    return model;
    
}

- (NSString *)description {
    
    return [NSString stringWithFormat:@"%@",@{@"event":_event,
                                              @"eventDate":_eventDate,
                                              @"isTop":_isTop,
                                              @"isRepeat":_isRepeat}];
    
}

@end
