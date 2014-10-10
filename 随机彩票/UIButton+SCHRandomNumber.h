//
//  UIButton+OriginRect.h
//  随机彩票
//
//  Created by 沈 晨豪 on 14-1-28.
//  Copyright (c) 2014年 sch. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (SCHRandomNumber)

@property (nonatomic,retain) NSValue  *origin_rect;
@property (nonatomic,retain) NSValue  *origin_center;

@property (nonatomic,retain) NSNumber *is_selected;

@property (nonatomic,retain) UIImage *normal_image;
@property (nonatomic,retain) UIImage *selected_image;

@end
