//
//  REEditTableViewCell.h
//  Remember
//
//  Created by Lelouch on 2016/11/23.
//  Copyright © 2016年 enice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface REEditTableViewCell : UITableViewCell

@property (strong, nonatomic) UILabel *keyLabel;
//@property (strong, nonatomic) UILabel *valueLabel;
@property (strong, nonatomic) UITextField *eventTextField;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;

@end
