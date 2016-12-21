//
//  REMainTableViewCell.m
//  Remember
//
//  Created by Lelouch on 2016/12/15.
//  Copyright © 2016年 enice. All rights reserved.
//

#import "REMainTableViewCell.h"
#import "REMDefine.h"

@implementation REMainTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.backgroundColor = [UIColor clearColor];
        
        _eventLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 16, ScreenWidth - 20 - 135 - 5, 34)];
        [_eventLabel setTextColor:[UIColor whiteColor]];
        [_eventLabel setTextAlignment:NSTextAlignmentLeft];
        [_eventLabel setFont:[UIFont fontWithName:@"Arial-BoldMT" size:25.0f]];
        
        [self.contentView addSubview:_eventLabel];
        
        
        _eventDaysLabel = [[UILabel alloc] initWithFrame:CGRectMake(_eventLabel.frame.origin.x + _eventLabel.frame.size.width + 5 , 10, 135, 80.0f)];
        [_eventDaysLabel setTextAlignment:NSTextAlignmentRight];
        [self.contentView addSubview:_eventDaysLabel];
        
        
        _eventDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, _eventLabel.frame.origin.y + _eventLabel.frame.size.height + 10, _eventLabel.frame.size.width, 24)];
        [_eventDateLabel setTextColor:[UIColor whiteColor]];
        [_eventDateLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [_eventDateLabel setTextAlignment:NSTextAlignmentLeft];

        [self.contentView addSubview:_eventDateLabel];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
