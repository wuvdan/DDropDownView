//
//  SeconedView.m
//  DDropDownView
//
//  Created by 吴丹 on 2020/11/17.
//

#import "SecondView.h"

@interface SecondViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *titleLabel;
@end

@implementation SecondViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.font = [UIFont systemFontOfSize:15];
        [self.contentView addSubview:_titleLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.titleLabel.frame = self.bounds;
}

@end

@implementation SecondView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        UICollectionViewFlowLayout *collectionViewFlowLayout = [[UICollectionViewFlowLayout alloc] init];
        collectionViewFlowLayout.sectionInset = UIEdgeInsetsMake(10, 10, 10, 10);
        collectionViewFlowLayout.itemSize = CGSizeMake((UIScreen.mainScreen.bounds.size.width - 50) / 4, (UIScreen.mainScreen.bounds.size.width - 50) / 8);

        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:collectionViewFlowLayout];
        _collectionView.dataSource = self;
        _collectionView.delegate = self;
        _collectionView.backgroundColor = [UIColor whiteColor];
        [_collectionView registerClass:NSClassFromString(@"SecondViewCell") forCellWithReuseIdentifier:@"SecondViewCell"];
        [self addSubview:_collectionView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.collectionView.frame = self.bounds;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    SecondViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"SecondViewCell" forIndexPath:indexPath];
    
    cell.titleLabel.text = self.titleArray[indexPath.item];
    cell.contentView.layer.borderWidth = 1;
    if (self.selectedIndex == indexPath.item) {
        cell.titleLabel.textColor = [UIColor whiteColor];
        cell.contentView.layer.borderColor = [UIColor clearColor].CGColor;
        cell.contentView.backgroundColor = [UIColor colorWithRed:7.0/255 green:193.0/255 blue:96.0/255 alpha:1];
    } else {
        cell.titleLabel.textColor = [UIColor lightGrayColor];
        cell.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        cell.contentView.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(secondView:didSelectedIndex:)]) {
        [self.delegate secondView:self didSelectedIndex:indexPath.row];
    }
    self.selectedIndex = indexPath.row;
    [collectionView reloadData];
}

@end
