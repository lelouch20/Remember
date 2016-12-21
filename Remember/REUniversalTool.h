//
//  ENSUniversalTool.h
//  ScanInfo
//
//  Created by Lelouch on 16/11/22.
//  Copyright © 2016年 enice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface REUniversalTool : NSObject

+ (REUniversalTool *)sharedInstance;

/**
 *  以yyyy-MM-dd格式获取当前日期
 *
 *  @return              当前日期的string
 */
- (NSString *)getCurrentDateString;

/**
 *  获取当前年份的字符串
 *
 *  @return              当前年份的string
 */
- (NSString *)getCurrentYearString;
/**
 *  日期A是否晚于日期B
 *
 *  @param dateStringA   日期A
 *  @param dateStringB   日期B
 *  @return              返回结果
 */
- (BOOL)isDateStringA:(NSString *)dateStringA laterThanDateStringB:(NSString *)dateStringB;

/**
 *  计算两个日期相隔的天数
 *
 *  @param dateStringA   日期A
 *  @param dateStringB   日期B
 *  @return              返回天数
 */
- (NSInteger)calculateDaysBetweenDateStringA:(NSString *)dateStringA dateStringB:(NSString *)dateStringB;

/**
 *  删除指定文件夹内的指定类型文件
 *
 *  @param folderName   文件夹名
 *  @param format       文件格式
 *  @return             删除结果
 */

- (BOOL)deleteWithFolderName:(NSString *)folderName format:(NSString *)format;

/**
 *  由URL载入图片
 *
 *  @param url          图片的下载地址
 *  @param imageView    用于设置图片的imageview
 */
+ (void)loadPicAdImageWithURL:(NSString *)url forImageView:(UIImageView *)imageView;

/**
 *  淡入动画
 *
 *  @param view       使用动画的控件
 *  @param name       用于记录该动画的keyName
 */
+ (void)showWithView:(UIView *)view
                Name:(NSString *)name;
/**
 *  淡出动画
 *
 *  @param view       使用动画的控件
 *  @param name       用于记录该动画的keyName
 */
+ (void)dismissWithView:(UIView *)view
                   Name:(NSString *)name;
/**
 *  位移动画
 *
 *  @param view       使用动画的控件
 *  @param duration   动画时长
 *  @param movedX     移动的水平距离
 *  @param movedY     移动的垂直距离
 */
+ (void)moveAnimationWithView:(UIView *)view
                     duration:(NSInteger)duration
                       movedX:(CGFloat)movedX
                       movedY:(CGFloat)movedY;
@end
