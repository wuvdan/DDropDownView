//
//  DDropDownView.m
//  DDropDownView
//
//  Created by 吴丹 on 2020/11/17.
//

#import "DDropDownView.h"

@interface DDropDownTitleControl : UIControl
@property (nonatomic, strong) UIStackView *stackView;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIImageView *iconImageView;
@end

@implementation DDropDownTitleControl

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        [self addSubview:self.stackView];

        self.stackView.translatesAutoresizingMaskIntoConstraints = NO;
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
        self.iconImageView.translatesAutoresizingMaskIntoConstraints = NO;
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
        self.titleLabel.textColor = [UIColor colorWithRed:7.0/255 green:193.0/255 blue:96.0/255 alpha:1];
        self.iconImageView.tintColor = [UIColor colorWithRed:7/255.0 green:193/255.0 blue:96/255.0 alpha:1.0];
        self.iconImageView.transform = CGAffineTransformMakeRotation(M_PI);
    } else {
        self.iconImageView.transform = CGAffineTransformIdentity;
        self.titleLabel.textColor = [UIColor colorWithRed:51.0/255 green:51.0/255 blue:51.0/255 alpha:1];
        self.iconImageView.tintColor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
    }
}

- (UILabel *)titleLabel {
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentLeft;
        _titleLabel.font = [UIFont systemFontOfSize:14];
        _titleLabel.textColor = [UIColor colorWithRed:153.0/255 green:153.0/255 blue:153.0/255 alpha:1];
    }
    return _titleLabel;
}

- (UIImageView *)iconImageView {
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] init];
        _iconImageView.image = [[UIImage imageNamed:@"down"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
        _iconImageView.tintColor = [UIColor lightGrayColor];
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

@end

@implementation DDropDownView

- (instancetype)init {
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.titleStackView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleStackView.frame = self.bounds;
    
    self.layer.shadowColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.04].CGColor;
    self.layer.shadowOffset = CGSizeMake(0,4);
    self.layer.shadowOpacity = 1;
    self.layer.shadowRadius = 16;
}

- (void)setDefaultTitleArray:(NSArray<NSString *> *)defaultTitleArray {
    _defaultTitleArray = defaultTitleArray;
 
    [defaultTitleArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        DDropDownTitleControl *view = [[DDropDownTitleControl alloc] init];
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
                
        self.backgroundButton.frame = CGRectMake(0, CGRectGetMaxY(self.frame), self.bounds.size.width, CGRectGetHeight(self.superview.frame) - CGRectGetMaxY(self.frame));
        self.containerView.frame = CGRectMake(0, CGRectGetMaxY(self.frame), self.bounds.size.width, self.lastShowViewHeight);
        self.containerView.subviews.firstObject.frame = CGRectMake(0, 0, self.bounds.size.width, self.lastShowViewHeight);
            
        if (!self.isOpening) {
            self.backgroundButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
        }
        
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
        [UIView setAnimationRepeatAutoreverses:NO];
        [UIView setAnimationTransition:UIViewAnimationTransitionNone forView:self cache:YES];
        [UIView setAnimationDuration:0.35];
        self.containerView.frame = CGRectMake(0, CGRectGetMaxY(self.frame), self.bounds.size.width, showViewHeight);
        self.containerView.subviews.firstObject.frame = CGRectMake(0, 0, self.bounds.size.width, showViewHeight);
        self.backgroundButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0.6];
        [UIView commitAnimations];
        self.lastShowViewHeight = showViewHeight;
    }
}

#pragma Public Method

- (void)setTiteWithText:(NSString *)text titleIndex:(NSUInteger)titleIndex {
    DDropDownTitleControl *view = self.titleStackView.arrangedSubviews[titleIndex];
    view.titleLabel.text = text;
}

- (void)closeView {
    [UIView animateWithDuration:0.3 delay:0 options:(UIViewAnimationOptionLayoutSubviews) animations:^{
        self.containerView.frame = CGRectMake(0, CGRectGetMaxY(self.frame), self.bounds.size.width, 0);
        self.containerView.subviews.firstObject.frame = CGRectMake(0, 0, self.bounds.size.width, 0);
        self.backgroundButton.backgroundColor = [UIColor colorWithWhite:0 alpha:0];
    } completion:^(BOOL finished) {
        self.lastShowViewHeight = 0;
        self.isOpening = NO;
        for (DDropDownTitleControl *view in self.titleStackView.arrangedSubviews) {
            view.selected = NO;
        }
        for (DDropDownTitleControl *view in self.containerView.subviews) {
            [view removeFromSuperview];
        }
    }];
}

- (void)didMoveToSuperview {
    UIView *parentView = self.superview;
    self.backgroundButton.frame = CGRectMake(0, CGRectGetMaxY(self.frame), self.bounds.size.width, 0);
    self.containerView.frame = CGRectMake(0, CGRectGetMaxY(self.frame), self.bounds.size.width, 0);
    [parentView addSubview:self.backgroundButton];
    [parentView addSubview:self.containerView];
    [parentView bringSubviewToFront:self];
}

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
        _containerView.backgroundColor = [UIColor whiteColor];
        _containerView.clipsToBounds = YES;
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
