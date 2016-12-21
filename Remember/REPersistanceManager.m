//
//  REPersistanceManager.m
//  ScanInfo
//
//  Created by Lelouch on 16/11/22.
//  Copyright © 2016年 enice. All rights reserved.
//

#import "REPersistanceManager.h"

@implementation REPersistanceManager

+ (void)setObject:(id)value forKey:(NSString *)key {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:value forKey:key];
    [defaults synchronize];
    
}

+ (id)objectForKey:(NSString *)key {
    
    if (!key) {
        
        return nil;
        
    }
                              
    return [[NSUserDefaults standardUserDefaults] valueForKey:key];
    
}

+ (void)saveCustomObject:(id<NSCoding>)object key:(NSString *)key {
    
    if (!key) {
        
        return;
        
    }
    if (!object) {
        
        [REPersistanceManager setObject:nil forKey:key];
        
        return;
        
    }
    
    NSData *encodedObject = [NSKeyedArchiver archivedDataWithRootObject:object];
    [REPersistanceManager setObject:encodedObject forKey:key];
    
}

+ (id<NSCoding>)loadCustomObjectWithKey:(NSString *)key {
    
    if (!key) {
        
        return nil;
        
    }
    
    NSData *encodedObject = [REPersistanceManager objectForKey:key];
    if (!encodedObject) {
        
        return nil;
        
    }
    
    id<NSCoding> object = [NSKeyedUnarchiver unarchiveObjectWithData:encodedObject];
    
    return object;
}

@end
