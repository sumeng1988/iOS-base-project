
//
//  SMHud.m
//  Base
//
//  Created by sumeng on 4/16/15.
//  Copyright (c) 2015 sumeng. All rights reserved.
//

#import "SMHud.h"
#import "MBProgressHUD.h"

@implementation SMHud

static MBProgressHUD *__gs_hud = nil;

+ (void)text:(NSString *)text inView:(UIView*)view {
    if (text.notEmpty == NO) {
        return;
    }
    
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeText;
    hud.detailsLabelText = text;
    hud.detailsLabelFont = hud.labelFont;
    [hud hide:YES afterDelay:2.0f];
}

+ (void)text:(NSString *)text {
    UIView* view = [AppDelegate shared].window;
    [self text:text inView:view];
}

+ (void)text:(NSString *)text title:(NSString *)title {
    UIView* view = [AppDelegate shared].window;
    MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.removeFromSuperViewOnHide = YES;
    hud.mode = MBProgressHUDModeText;
    hud.labelText = title;
    hud.detailsLabelText = text;
    [hud hide:YES afterDelay:2.0f];
}

static int __gs_hud_progress_counter = 0;

+ (void)showProgressInView:(UIView *)view {
    if (__sync_fetch_and_add(&__gs_hud_progress_counter, 1) == 0) {
        if (__gs_hud != nil) {
            LOG(@"SMHud Progress 全局句柄已经被占用");
            return;
        }
        if (view == nil) {
            view = [AppDelegate shared].window;
        }
        __gs_hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        __gs_hud.removeFromSuperViewOnHide = YES;
        __gs_hud.mode = MBProgressHUDModeIndeterminate;
    }
}

+ (void)showProgress {
    [self showProgressInView:nil];
}

+ (void)hideProgress {
    if (__gs_hud_progress_counter == 0) {
        return;
    }
    
    if (__sync_sub_and_fetch(&__gs_hud_progress_counter, 1) == 0) {
        if (__gs_hud == nil) {
            LOG(@"SMHud Progress 全局句柄为 nil");
            return;
        }
        [__gs_hud hide:YES];
        __gs_hud = nil;
    }
}

@end
