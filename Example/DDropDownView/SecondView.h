//
//  SecondView.h
//  DDropDownView
//
//  Created by 吴丹 on 2020/11/17.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class SecondView;

@protocol SecondViewDelegate <NSObject>

- (void)secondView:(SecondView *)view didSelectedIndex:(NSUInteger)index;

@end

@interface SecondView : UIView<UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, weak) id <SecondViewDelegate> delegate;
@property (nonatomic, strong) UICollectionView *collectionView;
@property (nonatomic, copy) NSArray<NSString *> *titleArray;
@property (nonatomic, assign) NSUInteger selectedIndex;
@end

NS_ASSUME_NONNULL_END
