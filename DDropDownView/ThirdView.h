//
//  ThirdView.h
//  DDropDownView
//
//  Created by 吴丹 on 2020/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class ThirdView;

@protocol ThirdViewDelegate <NSObject>

- (void)thirdView:(ThirdView *)view didSelectedIndex:(NSUInteger)index;

@end

@interface ThirdView : UIView<UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, weak) id <ThirdViewDelegate> delegate;
@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, copy) NSArray<NSString *> *titleArray;
@property (nonatomic, assign) NSUInteger selectedIndex;

@end

NS_ASSUME_NONNULL_END
