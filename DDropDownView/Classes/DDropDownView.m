//
//  DDropDownView.m
//  DDropDownView
//
//  Created by 吴丹 on 2020/11/17.
//

#import "DDropDownView.h"

@implementation DDropDownConfigure

+ (DDropDownConfigure *)defalut {
    DDropDownConfigure *configure = [[DDropDownConfigure alloc] init];
    configure.arrowImageName = @"";
    configure.backgroundColor = [UIColor whiteColor];
    configure.titleNormalColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1];
    configure.arrowNormalColor = [UIColor colorWithRed:133.0/255 green:133.0/255 blue:133.0/255 alpha:1];
    configure.titleSelectedColor = [UIColor colorWithRed:7.0/255 green:193.0/255 blue:96.0/255 alpha:1];
    configure.arrowSelectedColor = [UIColor colorWithRed:7.0/255 green:193.0/255 blue:96.0/255 alpha:1];
    configure.backMaskColor = [UIColor colorWithWhite:0 alpha:0.6];
    configure.backContainerColor = [UIColor whiteColor];
    configure.bottomShadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.04];
    configure.bottomRadius = 0;
    configure.topY = 0;
    return configure;
}
@end

@interface DDropDownTitleControl : UIControl
/// 容器
@property (nonatomic, strong) UIStackView *stackView;
/// 左边文字
@property (nonatomic, strong) UILabel *titleLabel;
/// 右边箭头
@property (nonatomic, strong) UIImageView *iconImageView;
/// 样式配置
@property (nonatomic, strong) DDropDownConfigure *configure;
@end

@implementation DDropDownTitleControl

- (instancetype)initConfigure:(DDropDownConfigure *)configure {
    self = [super init];
    if (self) {
        self.configure = configure;
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.stackView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self addConstraints:@[
        [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:(NSLayoutAttributeTop) relatedBy:(NSLayoutRelationEqual) toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:self.titleLabel attribute:(NSLayoutAttributeBottom) relatedBy:(NSLayoutRelationEqual) toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0],
                
        [NSLayoutConstraint constraintWithItem:self.iconImageView attribute:(NSLayoutAttributeHeight) relatedBy:(NSLayoutRelationEqual) toItem:self.titleLabel attribute:NSLayoutAttributeHeight multiplier:0.25 constant:0],
        [NSLayoutConstraint constraintWithItem:self.iconImageView attribute:(NSLayoutAttributeWidth) relatedBy:(NSLayoutRelationEqual) toItem:self.titleLabel attribute:NSLayoutAttributeHeight multiplier:0.25 constant:0],
        
        [NSLayoutConstraint constraintWithItem:self.stackView attribute:(NSLayoutAttributeCenterX) relatedBy:(NSLayoutRelationEqual) toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0],
        [NSLayoutConstraint constraintWithItem:self.stackView attribute:(NSLayoutAttributeCenterY) relatedBy:(NSLayoutRelationEqual) toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0],
    ]];
}

- (void)setSelected:(BOOL)selected {
    [super setSelected:selected];
    
    if (selected) {
        self.titleLabel.textColor = self.configure.titleSelectedColor;
        self.iconImageView.tintColor = self.configure.arrowSelectedColor;
        self.iconImageView.transform = CGAffineTransformMakeRotation(M_PI);
    } else {
        self.iconImageView.transform = CGAffineTransformIdentity;
        self.titleLabel.textColor = self.configure.titleNormalColor;
        self.iconImageView.tintColor = self.configure.arrowNormalColor;
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = self.configure.titleNormalColor;
        _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _titleLabel;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        if (self.configure.arrowImageName.length > 0) {
            _iconImageView.image =
            [[UIImage imageNamed:self.configure.arrowImageName] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        } else {
            NSBundle *bundle = [NSBundle bundleForClass:[self class]];
            NSUInteger scale = [UIScreen mainScreen].scale;
            NSString *imageName = [NSString stringWithFormat:@"icon_d_dropdown@%zdx.png", scale];
            NSString *path = [bundle pathForResource:imageName ofType:nil inDirectory:@"DDropDownView.bundle"];
            _iconImageView.image =
            [[UIImage imageWithContentsOfFile:path] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        }
         
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImageView.tintColor = self.configure.arrowNormalColor;
        _iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _iconImageView;
}

- (UIStackView *)stackView {
    if (!_stackView) {
        _stackView = [[UIStackView alloc] initWithArrangedSubviews:@[self.titleLabel, self.iconImageView]];
        _stackView.distribution = UIStackViewDistributionFill;
        _stackView.userInteractionEnabled = NO;
        _stackView.alignment = UIStackViewAlignmentCenter;
        _stackView.axis = UILayoutConstraintAxisHorizontal;
        _stackView.spacing = 3;
        _stackView.translatesAutoresizingMaskIntoConstraints = NO;
    }
    return _stackView;
}
@end

@interface DDropDownView ()
/// 标题视图
@property (nonatomic, strong) UIStackView *titleStackView;
/// 底部透明视图，点击可以关闭窗口
@property (nonatomic, strong) UIButton *backgroundButton;
/// 是否开启，开启背景颜色不变，只有第一次打开才会 0 ~ 0.4
@property (nonatomic, assign) BOOL isOpening;
/// 记录上一次View打开显示的高度
@property (nonatomic, assign) CGFloat lastShowViewHeight;
/// 样式配置
@property (nonatomic, strong) DDropDownConfigure *configure;
@end

@implementation DDropDownView

- (instancetype)initWithConfigure:(DDropDownConfigure *)configure {
    self = [super init];
    if (self) {
        self.configure = configure;
        self.backgroundColor = self.configure.backgroundColor;
        [self addSubview:self.titleStackView];
    }
    return self;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.configure = [DDropDownConfigure defalut];
        self.backgroundColor = self.configure.backgroundColor;
        [self addSubview:self.titleStackView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleStackView.frame = self.bounds;
    
    self.layer.shadowColor = self.configure.bottomShadowColor.CGColor;
    self.layer.shadowOffset = CGSizeMake(0,4);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 16;
}

- (void)setDefaultTitleArray:(NSArray<NSString *> *)defaultTitleArray {
    _defaultTitleArray = defaultTitleArray;
 
    [defaultTitleArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DDropDownTitleControl *view = [[DDropDownTitleControl alloc] initConfigure:self.configure];
        view.titleLabel.text = obj;
        view.tag = idx;
        [view addTarget:self action:@selector(didTappedTitleControl:) forControlEvents:UIControlEventTouchUpInside];
        [self.titleStackView addArrangedSubview:view];
    }];
}

- (void)didTappedTitleControl:(DDropDownTitleControl *)sender {

    if (sender.selected) {
        [self closeView];
        sender.selected = NO;
        return;
    } else {
        self.isOpening = YES;
        sender.selected = !sender.selected;
        [self.containerView.subviews.firstObject removeFromSuperview];
    }
    
    for (DDropDownTitleControl *view in self.titleStackView.arrangedSubviews) {
        if (view.tag != sender.tag) {
            view.selected = NO;
        }
    }
    
    if (self.delegate &&
        [self.delegate respondsToSelector:@selector(heightOfShowViewInDropDownView:didTappedItemIndex:)]) {
        CGFloat showViewHeight = [self.delegate heightOfShowViewInDropDownView:self didTappedItemIndex:sender.tag];
        
        self.backgroundButton.frame = CGRectMake(0, self.configure.topY, self.bounds.size.width, CGRectGetHeight(self.window.frame) - self.configure.topY);
        self.containerView.frame = CGRectMake(0, self.configure.topY, self.bounds.size.width, self.lastShowViewHeight);
        self.containerView.subviews.firstObject.frame = CGRectMake(0, 0, self.bounds.size.width, self.lastShowViewHeight);
            
        if (!self.isOpening) {
            self.backgroundButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        }
        
        [UIApplication.sharedApplication.keyWindow bringSubviewToFront:self.backgroundButton];
        [UIApplication.sharedApplication.keyWindow bringSubviewToFront:self.containerView];
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationRepeatAutoreverses:NO];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
        [UIView setAnimationDuration:0.35];
        self.containerView.frame = CGRectMake(0, self.configure.topY, self.bounds.size.width, showViewHeight);
        self.containerView.subviews.firstObject.frame = CGRectMake(0, 0, self.bounds.size.width, showViewHeight);
        self.backgroundButton.backgroundColor = self.configure.backMaskColor;
        [UIView commitAnimations];
        self.lastShowViewHeight = showViewHeight;
    }
}

#pragma Public Method

/// 刷新高度
- (void)reloadViewByHeight:(CGFloat)height {
    CGFloat MaxY = self.configure.topY;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationRepeatAutoreverses:NO];
    [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
    [UIView setAnimationDuration:0.35];
    self.containerView.frame = CGRectMake(0, MaxY, self.bounds.size.width, height);
    self.containerView.subviews.firstObject.frame = CGRectMake(0, 0, self.bounds.size.width, height);
    self.backgroundButton.backgroundColor = self.configure.backMaskColor;
    [UIView commitAnimations];
    self.lastShowViewHeight = height;
}

- (void)setTiteWithText:(NSString *)text titleIndex:(NSUInteger)titleIndex {
    DDropDownTitleControl *view = self.titleStackView.arrangedSubviews[titleIndex];
    view.titleLabel.text = text;
}

- (void)closeView {
    CGFloat MaxY = self.configure.topY;

    [UIView animateWithDuration:0.3 delay:0 options:(UIViewAnimationOptionLayoutSubviews) animations:^{
        self.containerView.frame = CGRectMake(0, MaxY, self.bounds.size.width, 0);
        self.containerView.subviews.firstObject.frame = CGRectMake(0, 0, self.bounds.size.width, 0);
        self.backgroundButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    } completion:^(BOOL finished) {
        self.lastShowViewHeight = 0;
        self.isOpening = NO;
        self.backgroundButton.frame = CGRectMake(0, MaxY, self.bounds.size.width, 0);
        for (DDropDownTitleControl *view in self.titleStackView.arrangedSubviews) {
            view.selected = NO;
        }
        for (DDropDownTitleControl *view in self.containerView.subviews) {
            [view removeFromSuperview];
        }
    }];
}

- (void)didMoveToSuperview {
    
    CGFloat MaxY = self.configure.topY;
    
    self.backgroundButton.frame = CGRectMake(0, MaxY, self.bounds.size.width, 0);
    self.containerView.frame = CGRectMake(0, MaxY, self.bounds.size.width, 0);
    [UIApplication.sharedApplication.keyWindow addSubview:self.backgroundButton];
    [UIApplication.sharedApplication.keyWindow addSubview:self.containerView];
    [UIApplication.sharedApplication.keyWindow bringSubviewToFront:self];
}

- (UIViewController*)getViewController {
  for (UIView* next = [self superview]; next; next = next.superview) {
    UIResponder* nextResponder = [next nextResponder];
    if ([nextResponder isKindOfClass:[UIViewController class]]) {
      return (UIViewController*)nextResponder;
    }
  }
  return nil;
}

#pragma mark - Getter

- (UIButton *)backgroundButton {
    if (!_backgroundButton) {
        _backgroundButton = [[UIButton alloc] init];
        [_backgroundButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backgroundButton;
}

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = self.configure.backContainerColor;
        _containerView.clipsToBounds = YES;
        if (@available(iOS 11.0, *)) {
            _containerView.layer.cornerRadius = self.configure.bottomRadius;
            _containerView.layer.maskedCorners = kCALayerMinXMaxYCorner | kCALayerMaxXMaxYCorner;
        }
    }
    return _containerView;
}

- (UIStackView *)titleStackView {
    if (!_titleStackView) {
        _titleStackView = [[UIStackView alloc] init];
        _titleStackView.distribution = UIStackViewDistributionFillProportionally;
        _titleStackView.alignment = UIStackViewAlignmentCenter;
        _titleStackView.axis = UILayoutConstraintAxisHorizontal;
    }
    return _titleStackView;
}
@end
