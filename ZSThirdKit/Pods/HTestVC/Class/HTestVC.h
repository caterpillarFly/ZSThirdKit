//
//  HTestVC.h
//  Baby360
//
//  Created by zhangchutian on 15/4/29.
//  Copyright (c) 2015年 zhangchutian. All rights reserved.
//
#import <UIKit/UIKit.h>
typedef void (^HTestCallback)(id sender, id data);
@interface HTestVC : UIViewController
@property (nonatomic, strong) UITableView *tableView;
/**
 *  add demo item
 *
 *  @param title
 *  @param callback
 */
- (void)addMenu:(NSString *)title callback:(HTestCallback)callback;
/**
 *  add demo item
 *
 *  @param title
 *  @param subTitle
 *  @param callback 
 */
- (void)addMenu:(NSString *)title subTitle:(NSString *)subTitle callback:(HTestCallback)callback;
@end
