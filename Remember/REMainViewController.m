//
//  REMainViewController.m
//  Remember
//
//  Created by Lelouch on 2016/11/22.
//  Copyright © 2016年 enice. All rights reserved.
//

#import "REMainViewController.h"
#import "REMDefine.h"
#import "REDateTableViewCell.h"
#import "REEventModel.h"
#import "REUniversalTool.h"
#import "REPersistanceManager.h"
#import "REEventEditViewController.h"
#import "RESlideViewController.h"
#import <UserNotifications/UserNotifications.h>
#import "REMainTableViewCell.h"

@interface REMainViewController ()<UITableViewDelegate, UITableViewDataSource, UNUserNotificationCenterDelegate>

@property (strong, nonatomic) UITableView *dateTableView;
@property (strong, nonatomic) REEventModel *eventModel;
@property (copy, nonatomic) NSMutableArray *dateList;
@property (strong, nonatomic) UIView *headView;
@property (strong, nonatomic) UILabel *headViewDaysLabel;
@property (strong, nonatomic) UILabel *headViewEventLabel;
@property (strong, nonatomic) UILabel *headViewEventDateLabel;
@property (strong, nonatomic) RESlideViewController *slideVC;
@property (strong, nonatomic) UISwipeGestureRecognizer *rightSwipeGestureRecognizer;
@property (strong, nonatomic) UISwipeGestureRecognizer *leftSwipeGestureRecognizer;

@end

NSString *const daysString = @"无";
NSString *const dateString = @"目标日：无";
NSString *const eventString = @"无";

@implementation REMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    //浅色状态栏
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    [self preferredStatusBarStyle];
    
    self.navigationItem.title = @"Remember";
    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:nil action:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addEvent)];
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(10, 0, 27, 27)];
    [button setBackgroundImage:[UIImage imageNamed:@"settingButton.png"]
                      forState:UIControlStateNormal];
    [button addTarget:self action:@selector(showSlideViewMenu)
     forControlEvents:UIControlEventTouchUpInside];
    ADD_NAVI_LEFT_BACK_BTN(button);
    
    //add Observer
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadData) name:@"reloadEventList" object:nil];
    
    [self initUI];
}

#pragma mark - init
- (void)initUI {
    
    _headView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, 205)];
    _headView.backgroundColor = ThemeColor;
    
    _headViewDaysLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 35, _headView.frame.size.width - 10, 95)];
    _headViewDaysLabel.textAlignment = NSTextAlignmentCenter;
    _headViewDaysLabel.attributedText = [self getAttributedStringForhHeadViewDaysLabelWithDaysString:dateString];
    [_headView addSubview:_headViewDaysLabel];
    
    _headViewEventLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, _headViewDaysLabel.frame.origin.y + _headViewDaysLabel.frame.size.height + 5, _headView.frame.size.width - 10, 40)];
    _headViewEventLabel.textColor = [UIColor whiteColor];
    _headViewEventLabel.font = [UIFont systemFontOfSize:20.0f];
    _headViewEventLabel.textAlignment = NSTextAlignmentCenter;
    _headViewEventLabel.text = eventString;
    [_headView addSubview:_headViewEventLabel];
    
    _headViewEventDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, _headViewEventLabel.frame.origin.y + _headViewEventLabel.frame.size.height + 5, _headView.frame.size.width - 10, 15)];
    _headViewEventDateLabel.textColor = [UIColor whiteColor];
    _headViewEventDateLabel.font = [UIFont systemFontOfSize:11.0f];
    _headViewEventDateLabel.textAlignment = NSTextAlignmentCenter;
    _headViewEventDateLabel.textColor = [UIColor whiteColor];
    _headViewEventDateLabel.text = dateString;
    [_headView addSubview:_headViewEventDateLabel];
    
    [self loadData];
    [self.view addSubview:self.dateTableView];
    [self.view addSubview:_headView];
    
    self.leftSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    self.rightSwipeGestureRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipes:)];
    
    self.leftSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionLeft;
    self.rightSwipeGestureRecognizer.direction = UISwipeGestureRecognizerDirectionRight;
    
    [self.view addGestureRecognizer:self.leftSwipeGestureRecognizer];
    [self.view addGestureRecognizer:self.rightSwipeGestureRecognizer];
    
}

//lazy load
- (UITableView *)dateTableView {
    
    if (!_dateTableView) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 205 , ScreenWidth, ScreenHeight - 205 - 64) style:UITableViewStylePlain];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = [UIColor colorWithRed:242/255.0f green:241/255.0f blue:237/255.0f alpha:1.0f];
//        tableView.backgroundColor = [UIColor whiteColor];
        tableView.bounces = NO;
        _dateTableView = tableView;
    }
    
    return _dateTableView;
}

- (RESlideViewController *)slideVC {
    
    if (!_slideVC) {
        
        RESlideViewController *vc = [[RESlideViewController alloc] init];
        vc.view.center = CGPointMake(-200.0f, vc.view.center.y);
        UIBezierPath *shadowPath = [UIBezierPath bezierPathWithRect:vc.view.bounds];
        vc.view.layer.masksToBounds = NO;
        vc.view.layer.shadowColor = [UIColor blackColor].CGColor;
        vc.view.layer.shadowOffset = CGSizeMake(2.0f,0.0f);
        vc.view.layer.shadowOpacity = 0.5f;
        vc.view.layer.shadowPath = shadowPath.CGPath;

        _slideVC = vc;
        
    } else {
        
        _slideVC.view.hidden = NO;
        
    }
    
    return _slideVC;
}

- (void)loadData {
    
    _dateList = (NSMutableArray *)[REPersistanceManager loadCustomObjectWithKey:DATELIST];
    [self updateHeadView];
    
}

- (void)updateHeadView {
    
    if ([_dateList count]) {
        
        REEventModel *model = _dateList[0];
        _headViewEventDateLabel.text = model.eventDate;
        _headViewEventLabel.text = model.event;
        
        NSString *goalDateString = [self getDateWithModel:model];
        _headViewEventDateLabel.text = goalDateString;
        _headViewDaysLabel.attributedText = [self getAttributedStringForhHeadViewDaysLabelWithDaysString:goalDateString];
        [REPersistanceManager setObject:[NSString stringWithFormat:@"%zi",[[REUniversalTool sharedInstance] calculateDaysBetweenDateStringA:goalDateString dateStringB:[[REUniversalTool sharedInstance] getCurrentDateString]]] forKey:DAYS];
        
    }
}

- (NSString *)getDateWithModel:(REEventModel *)model {
    
    NSString *goalDateString = @"";
    if ([model.isRepeat isEqualToString:@"1"]) {
        
        NSString *thisYearDate = [model.eventDate stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:[[REUniversalTool sharedInstance] getCurrentYearString]];
        if ([[REUniversalTool sharedInstance] isDateStringA:thisYearDate laterThanDateStringB:[[REUniversalTool sharedInstance] getCurrentDateString]]) {
            
            goalDateString = thisYearDate;
            
        } else {
            
            goalDateString = [model.eventDate stringByReplacingCharactersInRange:NSMakeRange(0, 4) withString:[NSString stringWithFormat:@"%zi", [[[REUniversalTool sharedInstance] getCurrentYearString] integerValue] +1]];
            
        }
        
    } else {
        
        goalDateString = model.eventDate;
        
    }
    
    return goalDateString;
    
}


- (void)reloadData {
    
    [self loadData];
    NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:0];
    [_dateTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (NSAttributedString *)getAttributedStringForhHeadViewDaysLabelWithDaysString:(NSString *)dateString {
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@""];
    
    UIColor *color1 = [UIColor whiteColor];
    NSDictionary *attributes1 = @{NSForegroundColorAttributeName:color1, NSFontAttributeName:[UIFont systemFontOfSize:90.0f]};
    
    UIColor *color2 = [UIColor whiteColor];
    NSDictionary *attributes2 = @{NSForegroundColorAttributeName:color2, NSFontAttributeName:[UIFont systemFontOfSize:20.0f]};
    
    NSAttributedString *subString1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%zi",[[REUniversalTool sharedInstance] calculateDaysBetweenDateStringA:dateString dateStringB:[[REUniversalTool sharedInstance] getCurrentDateString]]] attributes:attributes1];
    
    [attrString appendAttributedString:subString1];
    
    NSAttributedString *subString2 = [[NSAttributedString alloc] initWithString:@" 天" attributes:attributes2];
    [attrString appendAttributedString:subString2];
    
    return attrString;
    
}

- (NSAttributedString *)getAttributedStringForDaysLabelWithDaysString:(NSString *)dateString {
    
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString:@""];
    
    UIColor *color1 = ThemeColor;
    NSDictionary *attributes1 = @{NSForegroundColorAttributeName:color1, NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:35.0f]};
    
    UIColor *color2 = [UIColor darkGrayColor];
    NSDictionary *attributes2 = @{NSForegroundColorAttributeName:color2, NSFontAttributeName:[UIFont fontWithName:@"Arial-BoldMT" size:15.0f]};
    
    NSAttributedString *subString1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%zi",[[REUniversalTool sharedInstance] calculateDaysBetweenDateStringA:dateString dateStringB:[[REUniversalTool sharedInstance] getCurrentDateString]]] attributes:attributes1];
    
    [attrString appendAttributedString:subString1];
    
    NSAttributedString *subString2 = [[NSAttributedString alloc] initWithString:@" 天" attributes:attributes2];
    [attrString appendAttributedString:subString2];
    
    return attrString;
}

#pragma mark - action

- (void)addEvent {
    
    REEventEditViewController *editVC = [[REEventEditViewController alloc] init];
    [self.navigationController pushViewController:editVC animated:YES];
    
}

- (void)showSlideViewMenu {

    _dateTableView.userInteractionEnabled = NO;
    self.navigationController.navigationBar.userInteractionEnabled = NO;
    [REUniversalTool moveAnimationWithView:self.slideVC.view duration:1.0f movedX:310.0f movedY:0.0f];
    [self.navigationController.view addSubview:_slideVC.view];
    
}

- (void)hideSlideMenu {
    _dateTableView.userInteractionEnabled = YES;
    self.navigationController.navigationBar.userInteractionEnabled = YES;
    [REUniversalTool moveAnimationWithView:_slideVC.view duration:1.0f movedX:-310.0f movedY:0.0f];
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW,(int64_t)(1.0 * NSEC_PER_SEC)),dispatch_get_main_queue(), ^{
        
                       _slideVC.view.hidden = YES;
                       
                   });
    
}

- (void)handleSwipes:(UISwipeGestureRecognizer *)sender {
    
    if (sender.direction == UISwipeGestureRecognizerDirectionLeft) {
        
        [self hideSlideMenu];
        
    }
    
    if (sender.direction == UISwipeGestureRecognizerDirectionRight) {
        
        [self showSlideViewMenu];
        
    }
    
}

#pragma mark - dateTableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return [_dateList count]?[_dateList count]:1;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 80.0f;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *reuseIdentifier = @"dateCell";
    REDateTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        
        cell = [[REDateTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        
    }
    if (![_dateList count]) {
        tableView.allowsSelection = NO;
        cell.eventLabel.text = @"快来添加事件吧！";
        
    } else {
        
        tableView.allowsSelection = YES;
        REEventModel *model = (REEventModel *)_dateList[indexPath.row];
        cell.eventLabel.text = model.event;
        
        NSString *goalDateString = [self getDateWithModel:model];
        cell.eventDateLabel.text = [NSString stringWithFormat:@"目标日：%@", goalDateString];
        
        cell.eventDaysLabel.attributedText = [self getAttributedStringForDaysLabelWithDaysString:goalDateString];
        
    }
//    if (indexPath.row != [_dateList count] - 1) {
//        
//        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(cell.eventLabel.frame.origin.x, 119, cell.eventLabel.frame.size.width, 1)];
//        [lineView setBackgroundColor:[UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1.0f]];
//        [cell addSubview:lineView];
//        
//    }
    
    return  cell;
}

- (NSArray *)tableView:(UITableView *)tableView editActionsForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // 添加一个删除按钮
//    UITableViewRowAction *deleteRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDestructive title:@"删除"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
    UITableViewRowAction *editRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleNormal title:@"编辑"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {

        NSLog(@"点击了编辑");
        
        NSInteger row = indexPath.row;
        REEventModel *model = _dateList[row];
        REEventEditViewController *editVC = [[REEventEditViewController alloc] initWithEventModel:model index:row];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self.navigationController pushViewController:editVC animated:YES];
        
//        // 1. 更新数据
//        [_dateList removeObjectAtIndex:indexPath.row];
//        [REPersistanceManager saveCustomObject:_dateList key:DATELIST];
//        if (!indexPath.row) {
//            
//            [self updateHeadView];
//            
//        }
//        // 2. 更新UI
//        [tableView deleteRowsAtIndexPaths:@[indexPath]withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    editRowAction.backgroundColor = ThemeColor;
    
    // 添加一个置顶按钮
    UITableViewRowAction *topRowAction = [UITableViewRowAction rowActionWithStyle:UITableViewRowActionStyleDefault title:@"置顶"handler:^(UITableViewRowAction *action, NSIndexPath *indexPath) {
        NSLog(@"点击了置顶");
        
        // 1. 更新数据
        [tableView reloadData];
        REEventModel *originModel = (REEventModel *)_dateList[0];
        originModel.isTop = @"0";
        
        [_dateList removeObjectAtIndex:0];
        [_dateList insertObject:originModel atIndex:0];
//        [_dateList exchangeObjectAtIndex:indexPath.row withObjectAtIndex:0];
        REEventModel *model = (REEventModel *)_dateList[indexPath.row];
        model.isTop = @"1";
        [_dateList removeObjectAtIndex:indexPath.row];
        [_dateList insertObject:model atIndex:0];
        [REPersistanceManager saveCustomObject:_dateList key:DATELIST];
        
        // 2. 更新UI
        NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
        [tableView moveRowAtIndexPath:indexPath toIndexPath:firstIndexPath];
        
        [self updateHeadView];
        
    }];
    topRowAction.backgroundColor = [UIColor colorWithRed:255.0/255.0f green:215.0/255.0f blue:0.0f alpha:1.0f];
//    topRowAction.backgroundColor = ThemeColor;
    
    
    // 将设置好的按钮放到数组中返回
    return @[editRowAction, topRowAction];
}

#pragma mark - dataTableView delegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    NSInteger row = indexPath.row;
//    REEventModel *model = _dateList[row];
//    REEventEditViewController *editVC = [[REEventEditViewController alloc] initWithEventModel:model index:row];
//    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    [self.navigationController pushViewController:editVC animated:YES];
//    
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
