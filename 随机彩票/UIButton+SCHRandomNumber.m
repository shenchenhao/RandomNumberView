//
//  UIButton+OriginRect.m
//  随机彩票
//
//  Created by 沈 晨豪 on 14-1-28.
//  Copyright (c) 2014年 sch. All rights reserved.
//

#import "UIButton+SCHRandomNumber.h"
#import <objc/runtime.h>

static const void *OriginRectKey    = (void *)@"OriginRectKey";
static const void *OriginCenterKey  = (void *)@"OriginCenterKey";
static const void *IsSelectedKey    = (void *)@"IsSelectedKey";
static const void *NormalImageKey   = (void *)@"NormalImageKey";
static const void *SelectedImageKey = (void *)@"SelectedImageKey";

@implementation UIButton (SCHRandomNumber)

@dynamic origin_rect;
@dynamic origin_center;
@dynamic is_selected;

@dynamic normal_image;
@dynamic selected_image;


/*
 *return  (NSValue *) 返回原始坐标
 *
 */
- (NSValue *)origin_rect
{

    return objc_getAssociatedObject(self, OriginRectKey);;
}


/*
 *void 设置原始坐标
 *
 *@param origin_rect :原始坐标的值
 *
 */
- (void)setOrigin_rect: (NSValue*) origin_rect
{
    objc_setAssociatedObject(self, OriginRectKey, origin_rect, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSValue *)origin_center
{
    return objc_getAssociatedObject(self, OriginCenterKey);
}

- (void)setOrigin_center:(NSValue *)origin_center
{
    objc_setAssociatedObject(self, OriginCenterKey, origin_center, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (NSNumber *)is_selected
{
    return objc_getAssociatedObject(self,IsSelectedKey);
}

- (void)setIs_selected:(NSNumber *)is_selected
{
    objc_setAssociatedObject(self, IsSelectedKey, is_selected, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


- (UIImage *)normal_image
{
    return objc_getAssociatedObject(self, NormalImageKey);
}

- (void)setNormal_image:(UIImage *)normal_image
{
    objc_setAssociatedObject(self, NormalImageKey, normal_image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIImage *)selected_image
{
    return objc_getAssociatedObject(self, SelectedImageKey);
}

- (void)setSelected_image:(UIImage *)selected_image
{
    objc_setAssociatedObject(self, SelectedImageKey, selected_image, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}


@end


