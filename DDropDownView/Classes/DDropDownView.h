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

@interface DDropDownConfigure : NSObject
/// 背景颜色默认为白色
@property (nonatomic, strong) UIColor *backgroundColor;
/// 标题文本普通样式颜色 默认为黑色
@property (nonatomic, strong) UIColor *titleNormalColor;
/// 标题文本选中样式颜色 默认为绿色
@property (nonatomic, strong) UIColor *titleSelectedColor;
/// 右边箭头图片名称
@property (nonatomic, copy) NSString *arrowImageName;
/// 标题文本普通样式颜色 默认为灰色
@property (nonatomic, strong) UIColor *arrowNormalColor;
/// 标题文本选中样式颜色 默认为绿色
@property (nonatomic, strong) UIColor *arrowSelectedColor;
/// 背景遮罩层颜色 默认为 黑色 透明度 0.6
@property (nonatomic, strong) UIColor *backMaskColor;
/// 添加子视图的背景视图颜色，默认为白色
@property (nonatomic, strong) UIColor *backContainerColor;
/// 底部阴影颜色 默认为黑色 透明为0.04
@property (nonatomic, strong) UIColor *bottomShadowColor;
/// 底部圆角 默认为 18
@property (nonatomic, assign) CGFloat bottomRadius;
/// frame top y
@property (nonatomic, assign) CGFloat topY;

+ (DDropDownConfigure *)defalut;
@end

@interface DDropDownView : UIView
/// 点击标题显示筛选，回调需要显示的高度
@property (nonatomic, weak) id <DDropDownViewDelegate> delegate;
/// 默认显示的标题内容
@property (nonatomic, copy) NSArray<NSString *> *defaultTitleArray;
/// 用于添加子视图，子视图高度与代理中回调一致
@property (nonatomic, strong) UIView *containerView;
/// 自定义样式创建
- (instancetype)initWithConfigure:(DDropDownConfigure *)configure;
/// 修改标题
- (void)setTiteWithText:(NSString *)text titleIndex:(NSUInteger)titleIndex;
/// 关闭筛选窗口
- (void)closeView;
/// 刷新高度
- (void)reloadViewByHeight:(CGFloat)height;
@end

NS_ASSUME_NONNULL_END
