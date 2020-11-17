//
//  FirstView.m
//  DDropDownView
//
//  Created by 吴丹 on 2020/11/17.
//

#import "FirstView.h"

@implementation FirstView

- (instancetype)init {
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.tableFooterView = [[UIView alloc] init];
        _tableView.rowHeight = 55;
        [_tableView registerClass:NSClassFromString(@"UITableViewCell") forCellReuseIdentifier:@"UITableViewCell"];
        [self addSubview:self.tableView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.tableView.frame = self.bounds;
}

- (void)setSelectedIndex:(NSUInteger)selectedIndex {
    _selectedIndex = selectedIndex;
    [self.tableView reloadData];
}

- (void)setTitleArray:(NSArray<NSString *> *)titleArray {
    _titleArray = titleArray;
    [self.tableView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell" forIndexPath:indexPath];
    cell.textLabel.text = _titleArray[indexPath.row];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_selectedIndex == indexPath.row) {
        cell.textLabel.textColor = [UIColor colorWithRed:7.0/255 green:193.0/255 blue:96.0/255 alpha:1];
        cell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        cell.textLabel.textColor = [UIColor lightGrayColor];
        cell.accessoryType = UITableViewCellAccessoryNone;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.delegate && [self.delegate respondsToSelector:@selector(firstView:didSelectedIndex:)]) {
        [self.delegate firstView:self didSelectedIndex:indexPath.row];
    }
    self.selectedIndex = indexPath.row;
    [tableView reloadData];
}

@end
