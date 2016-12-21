//
//  REDateTableViewCell.h
//  Remember
//
//  Created by Lelouch on 2016/11/22.
//  Copyright © 2016年 enice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface REDateTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *eventLabel;      //事件名称
@property (strong, nonatomic) UILabel *eventDateLabel;  //事件时间
@property (strong, nonatomic) UILabel *eventDaysLabel;  //距离天数
@property (strong, nonatomic) UIView *bottomView;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
