//
//  REMDefine.h
//  Remember
//
//  Created by Lelouch on 2016/11/22.
//  Copyright © 2016年 enice. All rights reserved.
//

#ifndef REMDefine_h
#define REMDefine_h

#define ScreenWidth [[UIScreen mainScreen] bounds].size.width        //获取屏幕宽度
#define ScreenHeight [[UIScreen mainScreen] bounds].size.height      //获取屏幕高度
#define SystemVersionDoubleValue [[[UIDevice currentDevice] systemVersion] doubleValue]

//#define ThemeColor [UIColor colorWithRed:0.0f green:147.0/255.0f blue:154.0/255.0f alpha:1.0f]
//#define ThemeColor [UIColor colorWithRed:243.0/255.0f green:156.0/255.0f blue:17.0/255.0f alpha:1.0f]
//#define ThemeColor [UIColor colorWithRed:1.0f green:0.07f blue:0.2f alpha:1.0f]
#define ThemeColor [UIColor colorWithRed:233.0/255.0f green:59.0/255.0f blue:80.0/255.0f alpha:1.0f]

//add navigationBar left button
#define ADD_NAVI_LEFT_BACK_BTN(leftButton) do { \
UIBarButtonItem *BackItem = [[UIBarButtonItem alloc] initWithCustomView:leftButton];\
UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];\
negativeSpacer.width = -5;\
if (SystemVersionDoubleValue >= 7.0) {\
self.navigationItem.leftBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, BackItem, nil];\
}\
else {\
self.navigationItem.leftBarButtonItem = BackItem;\
}\
} while (0)

//add navigationBar right button
#define ADD_NAVI_RIGHT_BTN(rightButton) do { \
UIBarButtonItem *BackItem = [[UIBarButtonItem alloc] initWithCustomView:rightButton];\
UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];\
negativeSpacer.width = -5;\
if (SystemVersionDoubleValue >= 7.0) {\
self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:negativeSpacer, BackItem, nil];\
}\
else {\
self.navigationItem.rightBarButtonItem = BackItem;\
}\
} while (0)



#define DATELIST @"dateList"
#define DAYS @"days"
#define ISICONMARKON @"isIconMarkON"

#endif /* REMDefine_h */
