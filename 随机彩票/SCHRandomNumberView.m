//
//  SCHRandomNumberView.m
//  随机彩票
//
//  Created by 沈 晨豪 on 14-1-27.
//  Copyright (c) 2014年 ;. All rights reserved.
//

#import "SCHRandomNumberView.h"
#import "UIButton+SCHRandomNumber.h"

#define ANIMATION_KEY @"animation_key"   //动画的key



/*动画次数的计数*/
static int button_animation_count = 0;

@interface SCHRandomNumberView()

@property (nonatomic,assign) BOOL is_roandom_animationing;

@end


@interface SCHRandomNumberView(private)

/*
 *void 检测数据源
 *
 */
- (void)checkDataSource;

/*
 *void 检测委托
 *
 */
- (void)checkDelegate;

/*
 *void 初始化layer
 *
 */
- (void)initLayer;

/*
 *void button被按下
 *
 */
- (void)buttonPressed:(id)sender;

/*
 *void 清除所有button和数据
 *
 */
- (void)clean;

/*
 *void  显示所有button
 *
 */
- (void)show;

@end

@interface SCHRandomNumberView(type)

//--显示的状态--//

/*
 *void 默认显示
 *
 */
- (void)defalutShow;

/*
 *void 跳跃显示
 *
 */
- (void)jumpShow;


//--随机的状态--/

/*
 *void 随机的状态
 *
 */
- (void)randomType;

/*
 *void 默认的随机
 *
 */
- (void)defalutRandom;

/*
 *void 混乱的随机
 *
 */
- (void)chaosRandom;

/*
 *void 设置一个路径动画
 *
 *@param time       : 时间
 *@param move_count : 移动次数
 *@param size       : 移动的场地的大小
 *@param view       : 移动的对象
 *@param name       : 动画的名字
 *
 */
- (void)pathAnimation:(float) time moveCount:(int) move_count frameSize:(CGSize)size object:(UIView *)view animationKey:(NSString *)name;

@end


@implementation SCHRandomNumberView


@synthesize unselected_button_array = _unselected_button_array;
@synthesize selected_button_array   = _selected_button_array;

@synthesize show_type               = _show_type;
@synthesize random_type             = _random_type;

@synthesize data_source             = _data_source;
@synthesize delegate                = _delegate;

@synthesize is_roandom_animationing = _is_roandom_animationing;

#pragma mark -
#pragma mark - private

/*
 *void 检测数据源
 *
 */
- (void)checkDataSource
{
    _data_source_flags.numberOfCellDataSource  = [_data_source respondsToSelector:@selector(numberOfCell:)];
    
    _data_source_flags.numberOfRowsDataSource  = [_data_source respondsToSelector:@selector(numberOfColumns:)];
    
    _data_source_flags.normalImageDataSource   = [_data_source respondsToSelector:@selector(cellNormalImage: cellAtIndex:)];
    
    _data_source_flags.selectedImageDataSource = [_data_source respondsToSelector:@selector(cellSelectedImage: cellAtIndex:)];
    
    _data_source_flags.cellSizeDataSource      = [_data_source respondsToSelector:@selector(cellSize:)];
    
    _data_source_flags.topSpaceDataSource      = [_data_source respondsToSelector:@selector(topViewSpace:)];
    
    _data_source_flags.bottomSpaceDataSource   = [_data_source respondsToSelector:@selector(bottomViewSpace:)];
    
    _data_source_flags.leftSpaceDataSource     = [_data_source respondsToSelector:@selector(leftViewSpace:)];
    
    _data_source_flags.rightSpaceDataSource    = [_data_source respondsToSelector:@selector(rightViewSpace:)];
}

/*
 *void 检测委托
 *
 */
- (void)checkDelegate
{
    _delegate_flags.didSelectedAtIndex = [_delegate respondsToSelector:@selector(randomNumberView:didSelectedCell:atIndex:)];
    
    _delegate_flags.randomAnimationEnd = [_delegate respondsToSelector:@selector(randomNumberViewAnimationEnd:)];
}

/*
 *void 清除所有button和数据
 *
 */
- (void)clean
{
    if(_button_array.count <= 0)
        return;
    
    for (UIButton *button in _button_array)
    {
        [button removeFromSuperview];
    }
    
    [_button_array removeAllObjects];
    [_selected_button_array removeAllObjects];
    [_unselected_button_array removeAllObjects];
    
}

/*
 *void 初始化layer
 *
 */
- (void)initLayer
{
    if(nil == _data_source)
        return;
    
    /*多少单元*/
    if (_data_source_flags.numberOfCellDataSource)
    {
        _button_count = [_data_source numberOfCell:self];
    }
    else
    {
        _button_count = 0;
//        return;
    }
    
    /*多少行*/
    if (_data_source_flags.numberOfRowsDataSource)
    {
        _columns = [_data_source numberOfColumns:self];
    }
    else
    {
        _columns = 1;
    }
    
    _rows =  (_button_count + _columns - 1) / _columns;
    
    /*距离上边的距离*/
    if(_data_source_flags.topSpaceDataSource)
    {
        _top_space = [_data_source topViewSpace:self];
    }
    else
    {
        _top_space = 10.0f;
    }
    
    /*距离底部的距离*/
    if(_data_source_flags.bottomSpaceDataSource)
    {
        _bottom_space = [_data_source bottomViewSpace:self];
    }
    else
    {
        _bottom_space = 10.0f;
    }

    /*距离左边的距离*/
    if(_data_source_flags.leftSpaceDataSource)
    {
        _left_space = [_data_source leftViewSpace:self];
    }
    else
    {
        _left_space = 5.0f;
    }
    
    /*距离右边的距离*/
    if (_data_source_flags.rightSpaceDataSource)
    {
        _right_space = [_data_source rightViewSpace:self];
    }
    else
    {
        _right_space = 5.0f;
    }
    
    /*cell 大小*/
    if(_data_source_flags.cellSizeDataSource)
    {
        _cell_size = [_data_source cellSize:self];
    }
    else
    {
        _cell_size = CGSizeMake(30.0f, 30.0f);
    }
    
    /*左右距离*/
    if(_columns - 1 > 0)
        _cell_left_right_space = (self.frame.size.width - _left_space - _right_space - _cell_size.width * _columns) / (_columns - 1);
    else
        _cell_left_right_space = 0.0f;
    
    
    /*上下距离*/
    if(_rows - 1 > 0)
        _cell_top_buttom_space = (self.frame.size.height - _top_space - _bottom_space - _cell_size.height * _rows) / (_rows - 1);
    else
        _cell_top_buttom_space = 0.0f;
    
    
    /*创建 button*/
    for (int i = 0; i < _button_count; ++i)
    {
        UIButton *button   = [UIButton buttonWithType:UIButtonTypeCustom];
        
        CGRect    rect     = CGRectMake((i % _columns) * (_cell_size.width  + _cell_left_right_space) + _right_space,
                                        (i / _columns) * (_cell_size.height + _cell_top_buttom_space) + _top_space,
                                        _cell_size.width,
                                        _cell_size.height);
        
        button.frame       = rect;
        button.origin_rect = [NSValue valueWithCGRect:rect];
        button.origin_center = [NSValue valueWithCGPoint:button.center];
        
        button.is_selected = [NSNumber numberWithBool:NO];
        
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [_button_array addObject:button];
        [_unselected_button_array addObject:button];
    }
    
    /*自定义 button*/
    
    /*正常的图标*/
    if(_data_source_flags.normalImageDataSource)
    {
        for (int i = 0; i < _button_count; ++i)
        {
            UIImage  *image     = [_data_source cellNormalImage:self cellAtIndex:i];
            UIButton *button    = [_button_array objectAtIndex:i];
            
            button.normal_image = image;
            
            if(button.normal_image)
            {
                [button setBackgroundImage:button.normal_image forState:UIControlStateNormal];
            }
            else
            {
              
                [button setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
                [button setBackgroundColor:[UIColor blackColor]];
            }
        }
    }
    else
    {
        for (int i = 0; i < _button_count; ++i)
        {
            UIButton *button    = [_button_array objectAtIndex:i];
            
            button.normal_image = nil;
            
            [button setTitle:[NSString stringWithFormat:@"%d",i] forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor blackColor]];
        }
    }
    
    
    /*被选择的图标*/
    if(_data_source_flags.selectedImageDataSource)
    {
        for (int i = 0; i < _button_count; ++i)
        {
            UIImage  *image        = [_data_source cellSelectedImage:self cellAtIndex:i];
            UIButton *button       = [_button_array objectAtIndex:i];
            
            button.selected_image  = image;
            
            if(button.selected_image)
            {
                [button setBackgroundImage:button.selected_image forState:UIControlStateNormal];
            }
            else
            {
                [button setBackgroundColor:[UIColor redColor]];
            }
        }
    }
    else
    {
        for (int i = 0; i < _button_count; ++i)
        {
            UIButton *button       = [_button_array objectAtIndex:i];
            
            button.selected_image  = nil;
            
            //[button setBackgroundColor:[UIColor redColor]];
            
        }
    }
    
}


/*
 *void button被按下
 *
 */
- (void)buttonPressed:(id)sender
{
    UIButton *button = (UIButton *)sender;
    
    BOOL is_selected =  [button.is_selected boolValue];
 
    if(is_selected)
    {
        if(button.normal_image)
            [button setBackgroundImage:button.normal_image forState:UIControlStateNormal];
        else
            [button setBackgroundColor:[UIColor blackColor]];
        
    
        [_unselected_button_array addObject:button];
        [_selected_button_array removeObject:button];
    }
    else
    {
        if(button.selected_image)
            [button setBackgroundImage:button.selected_image forState:UIControlStateNormal];
        else
            [button setBackgroundColor:[UIColor redColor]];
        
        [_selected_button_array addObject:button];
        [_unselected_button_array removeObject:button];
    }
    
    is_selected        = !is_selected;
    button.is_selected = [NSNumber numberWithBool:is_selected];
    
    
    if(_delegate_flags.didSelectedAtIndex)
        [_delegate randomNumberView:self didSelectedCell:button atIndex:(int)[_button_array indexOfObject:button]];
}

#pragma mark -
#pragma mark - type


/*
 *void 默认显示
 *
 */
- (void)defalutShow
{
    for (UIButton *button in _button_array)
    {
        [self addSubview:button];
    }
}

/*
 *void 跳跃显示
 *
 */
- (void)jumpShow
{
    /*还未实现*/
}


/*
 *void 渐变移动的显示
 *
 */
- (void)gradualChangeMoveShow
{
    self.is_roandom_animationing = YES;
    
    for (int i = 0; i < _button_array.count; ++i)
    {
        UIButton *button = [_button_array objectAtIndex:i];
        
        button.alpha     = 0.1f;
        button.transform = CGAffineTransformMakeScale(0.0f, 0.0f);
        
        [self addSubview:button];
        
        [UIView animateWithDuration:0.32f
                              delay: (float)i * 0.02f
                            options:UIViewAnimationOptionCurveEaseOut
                         animations:^{
                             button.alpha = 1.0f;
                             button.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
                             
                         } completion:^(BOOL finished) {
                             if (i == _button_array.count - 1)
                             {
                                 self.is_roandom_animationing = NO;
                             }
                         }];
    }
}


/*
 *void 随机的状态
 *
 */
- (void)randomType
{
    switch (_random_type)
    {
        case DefalutRandomType:
            [self defalutRandom];
            break;
            
        case ChaosRandomType:
            [self chaosRandom];
            break;
            
        default:
            [self defalutRandom];
            break;
    }
}

/*
 *void 默认的随机
 *
 */
- (void)defalutRandom
{
    for (UIButton *button in _selected_button_array)
    {
        
        if(button.selected_image)
        {
            [button setBackgroundImage:button.selected_image forState:UIControlStateNormal];
        }
        else
        {
            [button setBackgroundColor:[UIColor redColor]];
        }
    }
    
    self.is_roandom_animationing = NO;
    

}


/*
 *void 混乱的随机
 *
 */
- (void)chaosRandom
{
    
    /*没被选择的*/
    float unselected_time          = 2.0f;
    float unselected_move_time     = 1.2f;
    float unselected_increment     = (unselected_time - unselected_move_time) / ((float)_unselected_button_array.count);
    
    for (int i = 0; i < _unselected_button_array.count; ++i)
    {
        UIButton *button      = [_unselected_button_array objectAtIndex:i];
        
        unselected_move_time += unselected_increment;
        
        [self pathAnimation:unselected_move_time moveCount:20 frameSize:self.frame.size object:button animationKey:[NSString stringWithFormat:@"unselected_%d",i]];
    }
    
    /*被选择的*/
    float selected_time = 1.2f;
    float move_time     = 0.7f;
    float increment     = (selected_time - move_time) / ((float)_selected_button_array.count);
    
    
    NSMutableArray *temp_selected_button_array = [[NSMutableArray alloc] initWithArray:_selected_button_array];
    
    for (int i = 0; i < _selected_button_array.count; ++i)
    {
        
        UIButton *button = [temp_selected_button_array objectAtIndex:arc4random()%temp_selected_button_array.count];
        
        [temp_selected_button_array removeObject:button];
        
        move_time       += increment;
        
        int index        = (int)[_selected_button_array indexOfObject:button];
        
        [self pathAnimation:move_time moveCount:20 frameSize:self.frame.size object:button animationKey:[NSString stringWithFormat:@"selected_%d",index]];
    }
    
    [temp_selected_button_array release],temp_selected_button_array = nil;
    
}


/*
 *void 设置一个路径动画
 *
 *@param time       : 时间
 *@param move_count : 移动次数
 *@param size       : 移动的场地的大小
 *
 */
- (void)pathAnimation:(float) time moveCount:(int) move_count frameSize:(CGSize) size object:(UIView *) view animationKey:(NSString *)name
{
    [view.layer removeAllAnimations];
    
    UIButton *button = (UIButton *)view;
    CGPoint   center = [button.origin_center CGPointValue];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:[NSString stringWithFormat:@"position"]];
    
    CGMutablePathRef     path      = CGPathCreateMutable();
    
    CGPathMoveToPoint(path, NULL,center.x, center.y);
    
    
    CGFloat x = center.x;
    CGFloat y = center.y;
    
    for (int i = 0; i < move_count; ++i)
    {
        x = arc4random() % (int)size.width;
        y = arc4random() % (int)size.height;
        
        CGPathAddLineToPoint(path, NULL, x, y);
    }
    
    
    [animation setPath:path];
    [animation setDuration:time];
    
    CGPathRelease(path);
    
    animation.fillMode            = kCAFillModeForwards;
	animation.repeatCount         = 1;
    animation.removedOnCompletion = YES;
 	animation.calculationMode     = @"paced";
    animation.delegate            = self;
    
    [animation setValue:name forKey:ANIMATION_KEY];
    
    [button.layer addAnimation:animation forKey:name];
}


#pragma mark -
#pragma mark - public

- (void)setData_source:(id<RandomNumberDataSource>)data_source
{
    _data_source = data_source;
    
    [self checkDataSource];
}

- (BOOL)getAnimationState
{
    return _is_roandom_animationing;
}


- (void)setDelegate:(id<RandomNumberDelegate>)delegate
{
    _delegate = delegate;
    
    [self checkDelegate];
}


/*
 *void 重新加载
 *
 */
- (void)reload
{
    [self clean];
    
    [self initLayer];
    
    [self show];
}

/*
 *void 重置 button
 *
 */
- (void)reset
{
    
    for (UIButton *button in _selected_button_array)
    {
        [button setBackgroundImage:button.normal_image forState:UIControlStateNormal];
        button.is_selected = [NSNumber numberWithBool:NO];
        
        if(nil == button.normal_image)
            [button setBackgroundColor:[UIColor blackColor]];
    }
    
    [_selected_button_array   removeAllObjects];
    
    [_unselected_button_array removeAllObjects];
    
    [_unselected_button_array addObjectsFromArray:_button_array];
}


/*
 *void  显示所有button
 *
 */
- (void)show
{
    switch (_show_type)
    {
        case DefalutShowType:
            [self defalutShow];
            break;
            
        case JumpShowType:
            [self jumpShow];
            break;
            
        case GradualChangeMoveShowType:
            [self gradualChangeMoveShow];
            break;
            
        default:
            [self defalutShow];
            break;
    }
}

/*
 *return 返回被选中的 数的 index 的array
 *
 *@param count_type : 计数的方式 有从0开始和从1开始 2种
 *
 */
- (NSMutableArray *)getSelectedNumberArray:(CountType) count_type
{
    NSMutableArray *array = [[NSMutableArray alloc] init];
    
    int increment;
    
    switch (count_type)
    {
        case CountByZero:
            increment = 0;
            break;
            
        case CountByOne:
            increment = 1;
            break;
            
        default:
            increment = 0;
            break;
    }
    
    
    for (UIButton *button in _selected_button_array)
    {
        int index = (int)[_button_array indexOfObject:button] + increment;
        
        [array addObject:[NSNumber numberWithInt:index]];
    }
    
    return [array autorelease];
}


/*
 *void  随机产生 count数量被选择的cell
 *
 *@param count : 需要随机产生的被选择的cell
 *
 */
- (void)randomSelectedCellByCount:(int)count
{
    if(_is_roandom_animationing)
        return;
    

    self.is_roandom_animationing = YES;
    
    /*所有button重置*/
    [self reset];
    

    int i = count;
    
    if(i > _button_count)
        i = _button_count;
    
    while (i)
    {
        --i;
        
        UIButton *button   = [_unselected_button_array objectAtIndex:arc4random()%_unselected_button_array.count];
        //[button setBackgroundImage:button.selected_image forState:UIControlStateNormal];
        
        button.is_selected = [NSNumber numberWithBool:YES];
        
        [_selected_button_array   addObject:button];
        [_unselected_button_array removeObject:button];
    }
    
    /*随机显示*/
    [self randomType];
}


#pragma mark -
#pragma mark - init

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {

        _show_type               = DefalutShowType;
    
        _random_type             = DefalutRandomType;
        
        _is_roandom_animationing = NO;
        
        _button_array            = [[NSMutableArray alloc] init];
        
        _selected_button_array   = [[NSMutableArray alloc] init];
        
        _unselected_button_array = [[NSMutableArray alloc] init];
        
        [self addObserver:self forKeyPath:@"is_roandom_animationing" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:NULL];
        
        // Initialization code
    }
    return self;
}


#pragma mark -
#pragma mark - animation delegate
- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    
    NSString *str   = [anim valueForKey:ANIMATION_KEY];
    
    if(str)
    {
        NSArray  *array = [str componentsSeparatedByString:@"_"];
        
        NSString *str_1 = [array objectAtIndex:0];
        int       index = [[array objectAtIndex:1] intValue];
        
        if([str_1 isEqualToString:@"selected"])
        {
            UIButton *button = [_selected_button_array objectAtIndex:index];
            
            if(button.selected_image)
            {
                [button setBackgroundImage:button.selected_image forState:UIControlStateNormal];
            }
            else
            {
                [button setBackgroundColor:[UIColor redColor]];
            }
        }
    }

    /*全部动画结束*/
    ++button_animation_count;
    
    if(button_animation_count == _button_array.count)
    {
        button_animation_count       = 0;
        self.is_roandom_animationing = NO;
    
        if (_delegate_flags.randomAnimationEnd)
        {
            [_delegate randomNumberViewAnimationEnd:self];
        }
    }
 
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

#pragma mark -
#pragma mark - kvo

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if([keyPath isEqualToString:@"is_roandom_animationing"])
    {
        for (UIButton *button in _button_array)
        {
            button.userInteractionEnabled = !_is_roandom_animationing;
        }
    }
}

#pragma mark -
#pragma mark - dealloc

- (void)dealloc
{
    [_button_array            release], _button_array            = nil;
    
    [_unselected_button_array release], _unselected_button_array = nil;
    
    [_selected_button_array   release], _selected_button_array   = nil;
    
    [super dealloc];
}

@end
