//
//  REDateTableViewCell.m
//  Remember
//
//  Created by Lelouch on 2016/11/22.
//  Copyright © 2016年 enice. All rights reserved.
//

#import "REDateTableViewCell.h"
#import "REMDefine.h"

@implementation REDateTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.selectedBackgroundView = [[UIView alloc] initWithFrame:self.frame] ;
        self.backgroundColor = [UIColor clearColor];
        _bottomView = [[UIView alloc] initWithFrame:CGRectMake(5, 2, ScreenWidth - 10, 76)];
        _bottomView.backgroundColor = [UIColor whiteColor];
        
        _eventLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, _bottomView.frame.size.width - 20 - 135 - 5, 30)];
        [_eventLabel setTextColor:[UIColor grayColor]];
        [_eventLabel setTextAlignment:NSTextAlignmentLeft];
        [_eventLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:22.0f]];
        
        [_bottomView addSubview:_eventLabel];
        
        _eventDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(_eventLabel.frame.origin.x, _eventLabel.frame.origin.y + _eventLabel.frame.size.height + 5, _eventLabel.frame.size.width, 21)];
        [_eventDateLabel setTextColor:[UIColor lightGrayColor]];
        [_eventDateLabel setFont:[UIFont systemFontOfSize:10.5f]];
        [_eventDateLabel setTextAlignment:NSTextAlignmentLeft];
        
        [_bottomView addSubview:_eventDateLabel];
        
        _eventDaysLabel = [[UILabel alloc] initWithFrame:CGRectMake(_eventLabel.frame.origin.x + _eventLabel.frame.size.width + 5, 15, 135, 46)];
        [_eventDaysLabel setTextAlignment:NSTextAlignmentRight];
        
        [_bottomView addSubview:_eventDaysLabel];

        
        [self.contentView addSubview:_bottomView];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
