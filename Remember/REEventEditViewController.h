//
//  REEventEditViewController.h
//  Remember
//
//  Created by Lelouch on 2016/11/23.
//  Copyright © 2016年 enice. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "REEventModel.h"

@interface REEventEditViewController : UIViewController

- (id)initWithEventModel:(REEventModel *)model index:(NSInteger)index;

@end
