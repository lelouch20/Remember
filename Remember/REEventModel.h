//
//  REEventModel.h
//  Remember
//
//  Created by Lelouch on 2016/11/22.
//  Copyright © 2016年 enice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface REEventModel : NSObject

@property (copy, nonatomic) NSString *event;
@property (copy, nonatomic) NSString *eventDate;
@property (copy, nonatomic) NSString *isTop;
@property (copy, nonatomic) NSString *isRepeat;

@end
