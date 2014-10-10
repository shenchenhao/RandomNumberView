//
//  SCHRandomNumberView.h
//  随机彩票
//
//  Created by 沈 晨豪 on 14-1-27.
//  Copyright (c) 2014年 sch. All rights reserved.
//

#import <UIKit/UIKit.h>



/*显示方式*/
typedef enum
{
    DefalutShowType = 0,        //默认显示
    
    JumpShowType,               //跳跃的显示 （未实现）
    
    GradualChangeMoveShowType,  //渐变移动显示
    
}ShowType;

/*随机方式*/
typedef enum
{
    DefalutRandomType = 0,  //默认随机
    
    ChaosRandomType         //混乱随机
    
}RandomType;

/*计数方式*/
typedef enum
{
    CountByZero = 0,   //从0开始计数
    
    CountByOne         //从1开始计数
    
}CountType;


@class SCHRandomNumberView;

@protocol RandomNumberDataSource<NSObject>
@optional

/*
 *return 返回有多少 数据 (int)
 *
 *@param sch_random_number_view : 对象本身
 *
 */
- (int)numberOfCell:(SCHRandomNumberView *) sch_random_number_view;


/*
 *return 多少行 (int)
 *
 *@param sch_random_number_view : 对象本身
 *
 */
- (int)numberOfColumns:(SCHRandomNumberView *)sch_random_number_view;

/*
 *return 返回正常button 的图像 (UIImage *)
 *
 *@param sch_random_number_view : 对象本身
 *
 */
- (UIImage *)cellNormalImage:(SCHRandomNumberView *) sch_random_number_view cellAtIndex:(int) index;

/*
 *return 返回button 被选择的图像 (UIImage *)
 *
 *@param sch_random_number_view : 对象本身
 *
 */
- (UIImage *)cellSelectedImage:(SCHRandomNumberView *) sch_random_number_view cellAtIndex:(int) index;

/*
 *return  里面得cell的大小(CGSize)
 *
 *@param sch_random_number_view : 对象本身
 *
 */
- (CGSize)cellSize:(SCHRandomNumberView *) sch_random_number_view;

/*
 *return 距离顶部的距离 (CGFloat)
 *
 *@param sch_random_number_view : 对象本身
 *
 */
- (CGFloat)topViewSpace:(SCHRandomNumberView *) sch_random_number_view;

/*
 *return 距离底部的距离 (CGFloat)
 *
 *@param sch_random_number_view : 对象本身
 *
 */
- (CGFloat)bottomViewSpace:(SCHRandomNumberView *) sch_random_number_view;


/*
 *return 距离左边的距离 (CGFloat)
 *
 *@param sch_random_number_view : 对象本身
 *
 */
- (CGFloat)leftViewSpace:(SCHRandomNumberView *) sch_random_number_view;

/*
 *return 距离右边的距离 (CGFloat)
 *
 *@param sch_random_number_view : 对象本身
 *
 */
- (CGFloat)rightViewSpace:(SCHRandomNumberView *) sch_random_number_view;


@end

@protocol RandomNumberDelegate <NSObject>

@optional

/*
 *void 选择的button
 *
 *@param sch_random_number_view : 对象本身
 *@param button                 : 被按下的button
 *@param index                  : butto 所在的索引
 *
 */
- (void)randomNumberView:(SCHRandomNumberView *)sch_random_number_view didSelectedCell:(UIButton *)button atIndex:(int)index;

/*
 *void 随机动画的效果结束
 *
 *@param sch_random_number_view : 本身
 *
 */
- (void)randomNumberViewAnimationEnd:(SCHRandomNumberView *)sch_random_number_view;

@end



@interface SCHRandomNumberView : UIView
{
    /*数据属性*/
    NSMutableArray *_button_array;             //所有button的array
    NSMutableArray *_unselected_button_array;  //没有选择的button的array
    NSMutableArray *_selected_button_array;    //选择了的button的array

    int             _button_count;             //button 数量
    int             _columns;                  //列数
    int             _rows;                     //行数
    
    /*基本布局属性*/
    CGFloat         _top_space;                //距离上边的距离
    CGFloat         _bottom_space;             //距离底部的距离
    CGFloat         _left_space;               //距离左边的距离
    CGFloat         _right_space;              //距离右边的距离
    
    CGFloat         _cell_top_buttom_space;    //单元上下的间隔
    CGFloat         _cell_left_right_space;    //单元左右的间隔
    
    CGSize          _cell_size;                //单元大小
    
    
    /*模式*/
    ShowType        _show_type;                //显示方式
    
    RandomType      _random_type;              //随机方式
    
    
    struct
    {
        unsigned int numberOfCellDataSource   : 1;
        unsigned int numberOfRowsDataSource   : 1;
        unsigned int normalImageDataSource    : 1;
        unsigned int selectedImageDataSource  : 1;
        unsigned int cellSizeDataSource       : 1;
        unsigned int topSpaceDataSource       : 1;
        unsigned int bottomSpaceDataSource    : 1;
        unsigned int leftSpaceDataSource      : 1;
        unsigned int rightSpaceDataSource     : 1;
        
    } _data_source_flags;
    
    id<RandomNumberDataSource> _data_source;
    
    struct
    {
        unsigned int didSelectedAtIndex       : 1;
        unsigned int randomAnimationEnd       : 1;
        
    } _delegate_flags;
    
    id<RandomNumberDelegate>   _delegate;
    
    
    BOOL                       _is_roandom_animationing;
    
}
@property (nonatomic,readonly) NSMutableArray             *unselected_button_array;
@property (nonatomic,readonly) NSMutableArray             *selected_button_array;

@property (nonatomic,assign)   ShowType                   show_type;
@property (nonatomic,assign)   RandomType                 random_type;


@property (nonatomic,assign)   id<RandomNumberDataSource> data_source;
@property (nonatomic,assign)   id<RandomNumberDelegate>   delegate;


/*
 *return 动画状态 (BOOL)
 *
 */
- (BOOL)getAnimationState;


/*
 *void 加载
 *
 */
- (void)reload;

/*
 *void 重置 button
 *
 */
- (void)reset;


/*
 *void  随机产生 count数量被选择的cell
 *
 *@param count : 需要随机产生的被选择的cell的数量
 *
 */
- (void)randomSelectedCellByCount:(int) count;

/*
 *return 返回被选中的 数的 index 的array
 *
 *@param count_type : 计数的方式 有从0开始和从1开始 2种
 *
 */
- (NSMutableArray *)getSelectedNumberArray:(CountType) count_type;

@end
























