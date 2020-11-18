//
//  FirstView.h
//  DDropDownView
//
//  Created by 吴丹 on 2020/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class FirstView;

@protocol FirstViewDelegate <NSObject>

- (void)firstView:(FirstView *)view didSelectedIndex:(NSUInteger)index;

@end

@interface FirstView : UIView<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) id <FirstViewDelegate> delegate;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray<NSString *> *titleArray;
@property (nonatomic, assign) NSUInteger selectedIndex;
@end

NS_ASSUME_NONNULL_END
