//
//  UniversalTool.m
//  ScanInfo
//
//  Created by Lelouch on 16/11/22.
//  Copyright © 2016年 enice. All rights reserved.
//

#import "REUniversalTool.h"

static const NSTimeInterval kAnimationDuration = 0.1;

@implementation REUniversalTool

+ (REUniversalTool *)sharedInstance {
    
    static REUniversalTool *universalTool = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        universalTool = [[REUniversalTool alloc] init];
        
    });
    
    return universalTool;
    
}

- (NSString *)getCurrentDateString {
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    NSDate *date = [NSDate date];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *str = [formatter stringFromDate:date];
    
    return str;
    
}

- (NSString *)getCurrentYearString {
    
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    // 获取当前日期
    NSDate *dt = [NSDate date];
    // 定义一个时间字段的旗标，指定将会获取指定年、月、日、时、分、秒的信息
    unsigned unitFlags = NSCalendarUnitYear;
    // 获取不同时间字段的信息
    NSDateComponents *comp = [gregorian components:unitFlags
                                          fromDate:dt];

    NSLog(@"年份:%zi", comp.year);
    return [NSString stringWithFormat:@"%zi", comp.year];
}


- (BOOL)isDateStringA:(NSString *)dateStringA laterThanDateStringB:(NSString *)dateStringB {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd"];
    NSDate *dateA = [dateFormatter dateFromString:dateStringA];
    NSDate *dateB = [dateFormatter dateFromString:dateStringB];
    
    NSTimeInterval interval = [dateA timeIntervalSinceDate:dateB];
    if (interval > 0) {
        
        return YES;
        
    } else {
        
        return NO;
        
    }
}

- (NSInteger)calculateDaysBetweenDateStringA:(NSString *)dateStringA dateStringB:(NSString *)dateStringB {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat: @"yyyy-MM-dd"];
    NSDate *dateA = [dateFormatter dateFromString:dateStringA];
    NSDate *dateB = [dateFormatter dateFromString:dateStringB];
    
    NSTimeInterval interval = [dateA timeIntervalSinceDate:dateB];
    NSInteger days = interval/3600/24;
    
    NSLog(@"%@离%@指定日还差%zi天", dateStringA, dateStringB, days);
    
    return days > 0 ? days: -days;
}

- (BOOL)deleteWithFolderName:(NSString *)folderName format:(NSString *)format{
    NSString *extension = format;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *picPath = [NSString stringWithFormat:@"%@/%@",documentsDirectory,folderName];
    
    NSArray *contents = [fileManager contentsOfDirectoryAtPath:picPath error:NULL];
    if ([contents count]) {
        
        NSEnumerator *e = [contents objectEnumerator];
        NSString *filename;
        while ((filename = [e nextObject])) {
            
            if ([[filename pathExtension] isEqualToString:extension]) {
                
                [fileManager removeItemAtPath:[documentsDirectory stringByAppendingPathComponent:filename] error:NULL];
                
            }
        }
        
        return YES;
        
    } else {
        
        return NO;
        
    }
}

//由URL载入图片
+ (void)loadPicAdImageWithURL:(NSString *)url forImageView:(UIImageView *)imageView {
    
    if (!url) {
        
        return;
        
    }
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSFileManager *fm = [[NSFileManager alloc] init];
        NSString *fileName = [url lastPathComponent];
        NSString *path = [NSTemporaryDirectory() stringByAppendingPathComponent:fileName];
        UIImage *image = nil;
        if ([fm fileExistsAtPath:path]) {
            
            image = [UIImage imageWithContentsOfFile:path];
            
        } else {
            
            @try {
                
                NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:url]];
                image = [UIImage imageWithData:data];
                [fm createFileAtPath:path contents:data attributes:nil];
                
            }
            @catch (NSException *exception) {
                
                image = nil;
                
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            if (!image) {
                
                return;
                
            }
            [imageView setImage:image];
        });
    });
}

//淡入动画
+ (void)showWithView:(UIView *)view
                Name:(NSString *)name {
    
    view.alpha = 0.0;
    [UIView beginAnimations:name context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseIn];
    [UIView setAnimationDuration:kAnimationDuration];
    [UIView setAnimationDelegate:self];
    view.alpha = 1.0;
    [UIView commitAnimations];
    
}

//淡出动画
+ (void)dismissWithView:(UIView *)view
                   Name:(NSString *)name {
    
    [UIView beginAnimations:name context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseOut];
    [UIView setAnimationDuration:kAnimationDuration];
    view.alpha = 0.0;
    [UIView commitAnimations];
    
}

//平移动画
+ (void)moveAnimationWithView:(UIView *)view
                     duration:(NSInteger)duration
                       movedX:(CGFloat)movedX
                       movedY:(CGFloat)movedY {
    
    [UIView beginAnimations:nil context:nil]; // 开始动画
    [UIView setAnimationDuration:duration]; // 动画时长
    
    CGPoint point = view.center;
    point.x += movedX;
    point.y += movedY;
    [view setCenter:point];
    
    [UIView commitAnimations]; // 提交动画
    
}

@end
