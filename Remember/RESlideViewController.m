//
//  RESlideViewController.m
//  Remember
//
//  Created by Lelouch on 2016/12/6.
//  Copyright © 2016年 enice. All rights reserved.
//

#import "RESlideViewController.h"
#import "REMDefine.h"
#import "REPersistanceManager.h"
#import <MessageUI/MessageUI.h>

@interface RESlideViewController () <UITableViewDelegate, UITableViewDataSource,  MFMailComposeViewControllerDelegate>

@property (strong, nonatomic) UITableView *settingTableView;

@end

@implementation RESlideViewController

CGFloat const rowHeight_setting = 50.0f;
NSInteger const rowCount_nofication = 1;
NSInteger const rowCount_support = 3;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = ThemeColor;
    [self initHeadView];
    [self initTableView];
    // Do any additional setup after loading the view.
}

- (void)initHeadView {
    
    UILabel *headLabel = [[UILabel alloc] initWithFrame:CGRectMake(ScreenWidth - 300, 64, 300, 136)];
    headLabel.text = @"Remember";
    headLabel.font = [UIFont fontWithName:@"Arial-BoldMT" size:40.0f];
    headLabel.textColor = [UIColor whiteColor];
    headLabel.backgroundColor = [UIColor clearColor];
    headLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:headLabel];
    
}

- (void)initTableView {
    
    _settingTableView = [[UITableView alloc] initWithFrame:CGRectMake(ScreenWidth - 300, 200, 300, ScreenHeight - 200) style:UITableViewStylePlain];
    _settingTableView.delegate = self;
    _settingTableView.dataSource = self;
    _settingTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _settingTableView.bounces = NO;
    
    [self.view addSubview:_settingTableView];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)switchAction:(id)sender {
    
    UISwitch *switchButton = (UISwitch *)sender;
    [REPersistanceManager setObject:[switchButton isOn]?@"1":@"0" forKey:ISICONMARKON];
    
}

- (void)sendEmailAction {
    // 邮件服务器
    MFMailComposeViewController *mailCompose = [[MFMailComposeViewController alloc] init];
    // 设置邮件代理
    [mailCompose setMailComposeDelegate:self];
    
    // 设置邮件主题
    [mailCompose setSubject:@"Remember"];
    
    // 设置收件人
    [mailCompose setToRecipients:@[@"lelouch20@icloud.com"]];
    
    /**
     *  设置邮件的正文内容
     */
    NSString *emailContent = @"手机型号：\r\n系统版本：\r\n遇到的问题:";
    // 是否为HTML格式
    [mailCompose setMessageBody:emailContent isHTML:NO];
    // 如使用HTML格式，则为以下代码
    //    [mailCompose setMessageBody:@"<html><body><p>Hello</p><p>World！</p></body></html>" isHTML:YES];

    // 弹出邮件发送视图
    [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:mailCompose animated:YES completion:nil];
}

- (void)showReminderAlertViewWithMessage:(NSString *)message {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提醒" message:message preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *okAction = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:nil];
    
    [alertController addAction:okAction];
    
    [self presentViewController:alertController animated:YES completion:nil];
    
}

#pragma mark - tableView dataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 2;
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *sectionHeadView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _settingTableView.frame.size.width, 30.0f)];
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(5, 0, 100, 30)];
    titleLabel.text = section ? @"支持":@"功能";
    titleLabel.font = [UIFont systemFontOfSize:13.0f];
    titleLabel.textColor = [UIColor lightGrayColor];
    [sectionHeadView addSubview:titleLabel];
    
    return sectionHeadView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30.0f;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return section ? rowCount_support : rowCount_nofication;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return rowHeight_setting;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    NSString *reuseIdentifier = @"listCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:reuseIdentifier];
        
    }
    cell.textLabel.font = [UIFont systemFontOfSize:19.0f];
    if (indexPath.section == 0) {
        
        cell.textLabel.text = @"角标天数";
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        UISwitch *switchButton = [[UISwitch alloc] initWithFrame:CGRectMake(_settingTableView.frame.size.width - 5 - 49, 9, 49, 32)];
        switchButton.onTintColor = ThemeColor;
        [switchButton setOn:[[REPersistanceManager objectForKey:ISICONMARKON] isEqualToString:@"1"] ? YES: NO];
        [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        [cell.contentView addSubview:switchButton];
        
    } else {
        
        if (row == 0) {
            
            cell.textLabel.text = @"邮件反馈";
            
        } else if (row == 1) {
            
            cell.textLabel.text = @"评分鼓励";
            
        } else {
        
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.textLabel.text = @"版本信息";
            cell.detailTextLabel.text = @"v1.0.0";
            cell.detailTextLabel.textColor = [UIColor lightGrayColor];
            cell.detailTextLabel.font = [UIFont systemFontOfSize:19.0f];
            
            
        }
        
    }
    
    
    return  cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSInteger row = indexPath.row;
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (row == 0) {
        
        if ([MFMailComposeViewController canSendMail]) { // 用户已设置邮件账户
            [self sendEmailAction]; // 调用发送邮件的代码
        } else {
            
            [self showReminderAlertViewWithMessage:@"您还未设置邮件账户"];
            
        }
        
        
    }
    
}

#pragma mark - MFMailComposeViewControllerDelegate

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
    
    switch (result) {
            
        case MFMailComposeResultCancelled: // 用户取消编辑
            NSLog(@"Mail send canceled...");
            break;
        case MFMailComposeResultSaved: // 用户保存邮件
            NSLog(@"Mail saved...");
            break;
        case MFMailComposeResultSent: // 用户点击发送
            NSLog(@"Mail sent...");
            break;
        case MFMailComposeResultFailed: // 用户尝试保存或发送邮件失败
            NSLog(@"Mail send errored: %@...", [error localizedDescription]);
            break;
    }
    
    // 关闭邮件发送视图
    [[UIApplication sharedApplication].keyWindow.rootViewController dismissViewControllerAnimated:YES completion:nil];
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
