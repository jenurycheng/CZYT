//
//  MBProgressHUD+Add.h
//  视频客户端
//
//  Created by mj on 13-4-18.
//  Copyright (c) 2013年 itcast. All rights reserved.
//

#import "MBProgressHUD.h"

@interface MBProgressHUD (Add)
+ (void)showError:(NSString *)error toView:(UIView *)view;
+ (void)showSuccess:(NSString *)success toView:(UIView *)view;
+ (void)showNoImg:(NSString *)str toView:(UIView *)view;

+ (MBProgressHUD *)showMessag:(NSString *)message toView:(UIView *)view;
+ (void)showMessag:(NSString *)message toView:(UIView *)view showTimeSec:(float) fSec;
+ (void)showLongMsg:(NSString *)msg toView:(UIView *)view showTimeSec:(float) fSec;


@end