//
//  DDropDownView.h
//  DDropDownView
//
//  Created by 吴丹 on 2020/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
@class DDropDownView;
@protocol DDropDownViewDelegate <NSObject>
/// 点击标题显示筛选，回调需要显示的高度
- (CGFloat)heightOfShowViewInDropDownView:(DDropDownView *)view
                       didTappedItemIndex:(NSUInteger)currentIndex;
@end

@interface DDropDownView : UIView
/// 点击标题显示筛选，回调需要显示的高度
@property (nonatomic, weak) id <DDropDownViewDelegate> delegate;
/// 默认显示的标题内容
@property (nonatomic, copy) NSArray<NSString *> *defaultTitleArray;
/// 用于添加子视图，子视图高度与代理中回调一致
@property (nonatomic, strong) UIView *containerView;
/// 修改标题
- (void)setTiteWithText:(NSString *)text titleIndex:(NSUInteger)titleIndex;
/// 关闭筛选窗口
- (void)closeView;

@end

NS_ASSUME_NONNULL_END
