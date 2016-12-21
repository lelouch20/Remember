//
//  TodayViewController.m
//  RememberWidget
//
//  Created by Lelouch on 2016/12/20.
//  Copyright © 2016年 enice. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>
#import "REPersistanceManager.h"
#import "REEventModel.h"
#import "REMDefine.h"
#import "REUniversalTool.h"

@interface TodayViewController () <NCWidgetProviding>

@property (weak, nonatomic) IBOutlet UILabel *eventLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventDaysLabel;
@property (weak, nonatomic) IBOutlet UILabel *eventDateLabel;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self initUI];
    // Do any additional setup after loading the view from its nib.
}

//- (void)initUI {
//    
//    dispatch_async(dispatch_get_main_queue(), ^{
//        
//        _eventDateLabel.layer.cornerRadius = 5.0f;
//        _eventDateLabel.layer.masksToBounds = YES;
//        
//        NSMutableArray *dateList = (NSMutableArray *)[REPersistanceManager loadCustomObjectWithKey:DATELIST];
//        REEventModel *model = (REEventModel *)dateList[0];
//        _eventLabel.text = model.event;
//        _eventDateLabel.text = [NSString stringWithFormat:@" 目标日:%@", model.eventDate];
//        _eventDaysLabel.text = [REPersistanceManager objectForKey:DAYS];
//        
//    });

    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
