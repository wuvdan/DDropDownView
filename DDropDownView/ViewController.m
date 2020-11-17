//
//  ViewController.m
//  DDropDownView
//
//  Created by 吴丹 on 2020/11/17.
//

#import "ViewController.h"
#import "DDropDownView.h"

#import "FirstView.h"
#import "SecondView.h"
#import "ThirdView.h"

@interface ViewController ()
<
DDropDownViewDelegate,
FirstViewDelegate,
SecondViewDelegate,
ThirdViewDelegate
>

@property (nonatomic, strong) DDropDownView *titleView;
@property (nonatomic, strong) FirstView *firstView;
@property (nonatomic, strong) SecondView *secondView;
@property (nonatomic, strong) ThirdView *thirdView;

@property (nonatomic, assign) NSUInteger firstSelectedIndex;
@property (nonatomic, assign) NSUInteger secondSelectedIndex;
@property (nonatomic, assign) NSUInteger thirdSelectedIndex;

@property (nonatomic, copy) NSArray<NSString *> *secondTitleArray;
@end

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Example";
    self.view.backgroundColor = [UIColor colorWithRed:0.9 green:0.9 blue:0.9 alpha:1];
    
    self.titleView = [[DDropDownView alloc] init];
    self.titleView.backgroundColor = [UIColor whiteColor];
    self.titleView.delegate = self;
    self.titleView.frame = CGRectMake(0, 88, UIScreen.mainScreen.bounds.size.width, 55);
    self.titleView.defaultTitleArray = @[@"男", @"Swift", @"热度"];
    [self.view addSubview:self.titleView];
    
    self.firstView = [[FirstView alloc] init];
    self.firstView.delegate = self;
    
    self.secondView = [[SecondView alloc] init];
    self.secondView.delegate = self;
    
    self.thirdView = [[ThirdView alloc] init];
    self.thirdView.delegate = self;
    
    self.secondTitleArray = @[@"Swift", @"Objective-C", @"Java", @"C#", @"C", @"C++", @"JavaScript", @"Python", @"Go", @"Rust", @"PHP", @"Ruby", @"Perl", @"VB"];
}

#pragma mark - FirstView Delegate
- (void)firstView:(FirstView *)view didSelectedIndex:(NSUInteger)index {
    self.firstSelectedIndex = index;
    [self.titleView setTiteWithText:@[@"男", @"女"][index] titleIndex:0];
    [self.titleView closeView];
}

#pragma mark - SecondView Delegate
- (void)secondView:(SecondView *)view didSelectedIndex:(NSUInteger)index {
    self.secondSelectedIndex = index;
    [self.titleView setTiteWithText:self.secondTitleArray[index] titleIndex:1];
    [self.titleView closeView];
}

#pragma mark - ThirdView Delegate
- (void)thirdView:(ThirdView *)view didSelectedIndex:(NSUInteger)index {
    self.thirdSelectedIndex = index;
    [self.titleView setTiteWithText:@[@"热度", @"论文", @"数量", @"最新"][index] titleIndex:2];
    [self.titleView closeView];
}

#pragma mark - DDropDownView Delegate
- (CGFloat)heightOfShowViewInDropDownView:(DDropDownView *)view didTappedItemIndex:(NSUInteger)currentIndex {
    if (currentIndex == 0) {
        self.firstView.titleArray = @[@"男", @"女"];
        self.firstView.selectedIndex = self.firstSelectedIndex;
        [view.containerView addSubview:self.firstView];
        return 55 * self.firstView.titleArray.count;
    }
    
    if (currentIndex == 1) {
        [view.containerView addSubview:self.secondView];
        self.secondView.titleArray = self.secondTitleArray;
        self.secondView.selectedIndex = self.secondSelectedIndex;
        return 300;
    };
    if (currentIndex == 2) {
        self.thirdView.titleArray = @[@"热度", @"论文", @"数量", @"最新"];
        self.thirdView.selectedIndex = self.thirdSelectedIndex;
        [view.containerView addSubview:self.thirdView];
        return 55 * self.thirdView.titleArray.count;
    };
    return 0;
}

@end
