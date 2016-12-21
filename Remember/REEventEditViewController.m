//
//  REEventEditViewController.m
//  Remember
//
//  Created by Lelouch on 2016/11/23.
//  Copyright © 2016年 enice. All rights reserved.
//


#import "REEventEditViewController.h"
#import "REEditTableViewCell.h"
#import "REMDefine.h"
#import "REPersistanceManager.h"

@interface REEventEditViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (strong, nonatomic) UITableView *editTableView;
@property (strong, nonatomic) UIDatePicker *datePicker;
@property (strong, nonatomic) REEventModel *model;
@property (assign, nonatomic) NSInteger eventIndex;
@property (strong, nonatomic) UIButton *deleteBtn;
@property (assign, nonatomic) BOOL deleteBtnNeedAppear;
@property (assign, nonatomic) BOOL switchBtnForSetTopIsOn;
@property (assign, nonatomic) BOOL switchBtnForRepeatIsOn;

@end

CGFloat const rowHeight = 44.0f;
CGFloat const sectionHeaderHeight = 30.0f;

@implementation REEventEditViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self initUI];
    // Do any additional setup after loading the view.
}

- (id)initWithEventModel:(REEventModel *)model index:(NSInteger)index {
    
    if (self = [super init]) {
        
        self.model = model;
        self.eventIndex = index;
        self.switchBtnForSetTopIsOn = [model.isTop isEqualToString:@"1"] ? YES: NO;
        self.switchBtnForRepeatIsOn = [model.isRepeat isEqualToString:@"1"] ? YES: NO;
        _deleteBtnNeedAppear = YES;
    }
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    return self;
}

#pragma mark - UI

- (void)initUI {
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStylePlain target:self action:@selector(onClickCompleteBtn)];
    
    [self.view addSubview:self.editTableView];

    self.deleteBtn = [[UIButton alloc] initWithFrame:CGRectMake(15, _editTableView.frame.origin.y + _editTableView.frame.size.height + 20, ScreenWidth - 30, 44)];
    self.deleteBtn.layer.cornerRadius = 5;
    self.deleteBtn.layer.masksToBounds = YES;
    self.deleteBtn.backgroundColor = ThemeColor;
    [self.deleteBtn setTitle:@"删除事件" forState:UIControlStateNormal];
    self.deleteBtn.titleLabel.textColor = [UIColor whiteColor];
    self.deleteBtn.titleLabel.font = [UIFont systemFontOfSize:22.0f];
    [_deleteBtn addTarget:self action:@selector(onClickDeleteBtn) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:_deleteBtn];
    _deleteBtn.hidden = !_deleteBtnNeedAppear;
    
}

//lazy load
- (UITableView *)editTableView {
    
    if (!_editTableView) {
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, rowHeight * 4 + sectionHeaderHeight * 2 + 1 + 30) style:UITableViewStyleGrouped];
        tableView.dataSource = self;
        tableView.delegate = self;
        tableView.bounces = NO;
        _editTableView = tableView;
        
    }
    
    return _editTableView;
    
}

- (UIDatePicker *)datePicker {
    
    if(!_datePicker) {
        
        UIDatePicker *datePicker = [UIDatePicker new];
        datePicker.datePickerMode = UIDatePickerModeDate;
        datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh"];
        if (_model.eventDate) {
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat: @"yyyy-MM-dd"];
            [datePicker setDate:[dateFormatter dateFromString:_model.eventDate]];
        }
        [datePicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        _datePicker = datePicker;
        
    }
    
    return _datePicker;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - action

- (void)onClickBackBtn {
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)onClickCompleteBtn {
    
    [self saveInfoWithType:_deleteBtnNeedAppear?1:0];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadEventList" object:nil];
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)onClickDeleteBtn {
    
    [self showDeleteAlertView];
    
}

- (void)datePickerValueChanged:(id)sender {
    
    REEditTableViewCell *cell = [_editTableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:0]];
    NSDateFormatter *form = [[NSDateFormatter alloc]init];//格式化
    
    [form setDateFormat:@"yyyy-MM-dd"];
    NSString *dateString = [form stringFromDate:[_datePicker date]];
    cell.eventTextField.text = dateString;
    
}

- (void)showDeleteAlertView {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"注意" message:@"是否要删除该事件？" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
        
        [self deleteEventFromEventList];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"reloadEventList" object:nil];
        [self.navigationController popViewControllerAnimated:YES];
        
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:cancelAction];
    [alertController addAction:deleteAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)showReminderAlertViewWithMessage:(NSString *)message {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)switchAction:(id)sender {
    
    UISwitch *switchButton = (UISwitch *)sender;
    if (switchButton.tag == 0) {
        
        _switchBtnForSetTopIsOn = [switchButton isOn];
        
    } else {
        
        _switchBtnForRepeatIsOn = [switchButton isOn];
        
    }
    
}

#pragma mark - save/load/delete


- (void)saveInfoWithType:(NSInteger)type {
    
    REEventModel *eventModel = [[REEventModel alloc] init];
    
    for (int row = 0 ; row < 2; row ++) {
        
        REEditTableViewCell *cell = [_editTableView  cellForRowAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
        
        switch (row) {
            case 0:
                eventModel.event = cell.eventTextField.text;
                break;
            case 1:
                eventModel.eventDate = cell.eventTextField.text;
                break;
            default:
                break;
        }
    }
    
    eventModel.isTop = _switchBtnForSetTopIsOn? @"1":@"0";
    eventModel.isRepeat = _switchBtnForRepeatIsOn? @"1":@"0";
    
    if ([eventModel.event isEqualToString:@""]) {
        
        [self showReminderAlertViewWithMessage:@"请输入事件名"];
        
    } else if ([eventModel.eventDate isEqualToString:@""]) {
        
        [self showReminderAlertViewWithMessage:@"请选择目标日期"];
        
    } else {

        NSMutableArray *eventList = [self loadList];
        if (type) {
            
            [eventList removeObjectAtIndex:_eventIndex];
            
        }
        
        if (_switchBtnForSetTopIsOn) {
            
            REEventModel *model = (REEventModel *)eventList[0];
            model.isTop = @"0";
            [eventList removeObjectAtIndex:0];
            [eventList insertObject:model atIndex:0];
            [eventList insertObject:eventModel atIndex:0];
            
        } else if (type){
            
            [eventList insertObject:eventModel atIndex:_eventIndex];
            
        } else {
            
            [eventList addObject:eventModel];
            
        }
        
        [self saveWithList:eventList];
        
    }
    
}

- (NSMutableArray *)loadList {
    
    NSMutableArray *list = [[NSMutableArray alloc] initWithCapacity:10];
    if ([REPersistanceManager loadCustomObjectWithKey:DATELIST]) {
        
        list = (NSMutableArray *)[REPersistanceManager loadCustomObjectWithKey:DATELIST];
        
    }
    
    return list;
    
}

- (void)saveWithList:(NSMutableArray *)list {
    
    [REPersistanceManager saveCustomObject:list key:DATELIST];
    
}

- (void)deleteEventFromEventList {
    
    NSMutableArray *array = [self loadList];
    [array removeObjectAtIndex:_eventIndex];
    [self saveWithList:array];
    
}

#pragma mark - editTableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return 2;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *sectionHeadView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, _editTableView.frame.size.width, 30.0f)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 100, 30)];
    titleLabel.text = section ? @"扩展":@"事件";
    titleLabel.font = [UIFont systemFontOfSize:13.0f];
    titleLabel.textColor = [UIColor lightGrayColor];
    [sectionHeadView addSubview:titleLabel];
    
    return sectionHeadView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return sectionHeaderHeight;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    
    if (section == 1) {
        
        UIView *sectionFooterView = [[UIView alloc] initWithFrame:CGRectMake(5, 0, _editTableView.frame.size.width - 10, 30.0f)];
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, sectionFooterView.frame.size.width, 30)];
        titleLabel.text = @"开启重复开关后，该事件的目标日则为每年的这个日期";
        titleLabel.font = [UIFont systemFontOfSize:13.0f];
        titleLabel.textColor = [UIColor lightGrayColor];
        [sectionFooterView addSubview:titleLabel];
        
        return sectionFooterView;
        
    }
    
    return nil;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    
    return section ? 30.0f : 1.0f;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return rowHeight;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    NSString *reuseIdentifier = @"editCell";
    REEditTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        
        cell = [[REEditTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
        
    }
    if (indexPath.section == 0) {
        
        if (row == 0) {
            
            cell.keyLabel.text = @"事件名";
            cell.eventTextField.placeholder = @"事件名";
            cell.eventTextField.text = _model?_model.event:@"";
            
        }
        if (row == 1) {
            
            cell.keyLabel.text = @"日期";
            cell.eventTextField.text = _model?_model.eventDate:@"";
            cell.eventTextField.inputView = self.datePicker;
            
        }
        
    } else {
        
        if (row == 0) {
            
            cell.keyLabel.text = @"置顶";
            UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(ScreenWidth - 5 - 49, 6, 49, 32)];
            switchButton.onTintColor = ThemeColor;
            switchButton.tag = 0;
            [switchButton setOn:_switchBtnForSetTopIsOn];
            [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:switchButton];
            
        }
        if (row == 1) {
            
            cell.keyLabel.text = @"重复";
            UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(ScreenWidth - 5 - 49, 6, 49, 32)];
            switchButton.onTintColor = ThemeColor;
            switchButton.tag = 1;
            [switchButton setOn:_switchBtnForRepeatIsOn];
            [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
            [cell.contentView addSubview:switchButton];
            
        }
        
    }
    
    return cell;
    
}

#pragma mark - editTableView delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
}

@end
