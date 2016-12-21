//
//  REEditTableViewCell.m
//  Remember
//
//  Created by Lelouch on 2016/11/23.
//  Copyright © 2016年 enice. All rights reserved.
//

#import "REEditTableViewCell.h"
#import "REMDefine.h"

@implementation REEditTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _keyLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 5, ScreenWidth/2 - 10, 34)];
        [_keyLabel setTextColor:[UIColor blackColor]];
        [_keyLabel setTextAlignment:NSTextAlignmentLeft];
        [_keyLabel setFont:[UIFont systemFontOfSize:18.0f]];
        
        [self.contentView addSubview:_keyLabel];
        
        
        _eventTextField = [[UITextField alloc] initWithFrame:CGRectMake(ScreenWidth/2, 5, ScreenWidth/2 - 10, 34)];
        [_eventTextField setTextColor:[UIColor blackColor]];
        [_eventTextField setFont:[UIFont systemFontOfSize:18.0f]];
        [_eventTextField setTextAlignment:NSTextAlignmentRight];
        
        [self.contentView addSubview:_eventTextField];
        
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
