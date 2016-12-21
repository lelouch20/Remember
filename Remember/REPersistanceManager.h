//
//  REPersistanceManager.h
//  ScanInfo
//
//  Created by Lelouch on 16/11/22.
//  Copyright © 2016年 enice. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface REPersistanceManager : NSObject

+ (void)setObject:(id)value forKey:(NSString *)key;
+ (id)objectForKey:(NSString *)key;
+ (void)saveCustomObject:(id<NSCoding>)object key:(NSString *)key;
+ (id<NSCoding>)loadCustomObjectWithKey:(NSString *)key;

@end
