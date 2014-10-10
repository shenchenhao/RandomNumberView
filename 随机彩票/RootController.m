//
//  RootController.m
//  随机彩票
//
//  Created by 沈 晨豪 on 14-2-11.
//  Copyright (c) 2014年 sch. All rights reserved.
//

#import "RootController.h"
#import "prefix.h"
#import "SCHRandomNumberView.h"

@interface RootController ()<RandomNumberDataSource,RandomNumberDelegate>
{
    SCHRandomNumberView *_random_number_view;
}

@end

@implementation RootController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
        _random_number_view = [[SCHRandomNumberView alloc] initWithFrame:CGRectMake(0.0f, 100.0f, 320.0f, 200.0f)];
    }
    return self;
}

- (void)loadView
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, FULL_SCREEN_SIZE.width,FULL_SCREEN_SIZE.height)];
    
    self.view    = view;
    
    [view release], view = nil;
    
}

- (void)test
{
    [_random_number_view randomSelectedCellByCount:10];
    
//    NSArray *array_1 = [_random_number_view getSelectedNumberArray:CountByOne];
//    NSArray *array_2 = [_random_number_view getSelectedNumberArray:CountByZero];
//    
//    NSLog(@"%@ \n %@",array_1,array_2);
    
}

- (void)test2
{
    if ([_random_number_view getAnimationState]) {
        return;
    }
    
    [_random_number_view reload];
}

 

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self.view addSubview:_random_number_view];
    
    _random_number_view.data_source = self;
    _random_number_view.delegate    = self;
    _random_number_view.show_type   = GradualChangeMoveShowType;
    _random_number_view.random_type = ChaosRandomType;
    [_random_number_view reload];

    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame     = CGRectMake(100.0f, 400.0f, 80.0f, 30.0f);
    
    [button setTitle:@"random" forState:UIControlStateNormal];
    
    [button setBackgroundColor:[UIColor redColor]];
    
    [button addTarget:self action:@selector(test) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button];
    
    
    UIButton *button2 = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    button2.frame     = CGRectMake(200.0f, 400.0f, 80.0f, 30.0f);
    
    [button2 setTitle:@"refresh" forState:UIControlStateNormal];
    
    [button2 setBackgroundColor:[UIColor redColor]];
    
    [button2 addTarget:self action:@selector(test2) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:button2];
    
//    UIAccelerometer *accel = [UIAccelerometer sharedAccelerometer];
//	accel.delegate         = self;
//	accel.updateInterval    = 1.0f/10.0f;
//#pragma pack(8)
//    typedef struct _size
//    {
//        
//        char c;
//        short e;
//        short d;
//     
//        short b;
//        char f;
//        double a;
//    }SIZE;
//#pragma pack()
//  
//    struct test2 {
//        
//   
//        char  a1 : 1;
////        int   a5 : 1;
//        char  a2 : 1 ;
//        char  a3 : 1 ;
//        char  a4 : 1 ;
//        char  a5 : 1 ;
//        char  a6 : 1 ;
//        char  a7 : 1 ;
//        char  a8 : 1 ;
//        char  a9 : 1 ;
//
//        
//        
//    };
//    
//    NSLog(@"哈哈 ---%lu",sizeof( SIZE));
//
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - 
#pragma mark - datasource

- (int)numberOfCell:(SCHRandomNumberView *)sch_random_number_view
{
    return 35;
    
}

- (int)numberOfColumns:(SCHRandomNumberView *)sch_random_number_view
{
    return 9;
}

- (CGSize)cellSize:(SCHRandomNumberView *)sch_random_number_view
{
    return CGSizeMake(30.0f, 30.0f);
}

#pragma mark -
#pragma mark - delegate 

- (void)randomNumberView:(SCHRandomNumberView *)sch_random_number_view didSelectedCell:(UIButton *)button atIndex:(int)index
{
    NSLog(@"---- %d",index);
}

#pragma mark -
#pragma mark - dealloc

- (void)dealloc
{
    [_random_number_view release], _random_number_view = nil;
    
    [super dealloc];
}

@end





