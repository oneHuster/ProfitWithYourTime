//
//  KTDheaderCell.m
//  闲么
//
//  Created by 邹应天 on 16/4/20.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "KTDheaderCell.h"
#import "UIButton+ButtonBlock.h"
@interface KTDheaderCell()
@property UIView *backView;
@end
@implementation KTDheaderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor blackColor];
    [self createNavView];
    return self;
}
- (void)createNavView{
    _backView = [[UIView alloc]init];
    [self.contentView addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.and.top.and.bottom.equalTo(_backView.superview);
    }];
    _backView.backgroundColor = [UIColor blackColor];
    
    _disButton = [UIButton new];
    [_disButton setTitle:@"区域 ∧" forState:UIControlStateNormal];
    _disButton.titleLabel.font = [UIFont systemFontOfSize:11];
    _disButton.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.9];
    [_backView addSubview:_disButton];
    [_disButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_backView.mas_bottom);
        make.left.mas_equalTo(_backView.mas_left);
        make.height.mas_equalTo(30);
        make.width.mas_equalTo(_backView.mas_width).multipliedBy(0.33);
    }];
    
    _sortButton = [UIButton new];
    _sortButton.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.9];
    [_sortButton setTitle:@"排序 ∨" forState:UIControlStateNormal];
    _sortButton.titleLabel.font = [UIFont systemFontOfSize:11];
    [_backView addSubview:_sortButton];
    [_sortButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_backView.mas_bottom);
        make.height.mas_equalTo(30);
        make.right.equalTo(_backView.mas_right);
        make.width.mas_equalTo(_backView.mas_width).multipliedBy(0.33);
    }];

    
    _classify = [UIButton new];
    _classify.backgroundColor = [UIColor colorWithWhite:0.3 alpha:0.9];
    [_classify setTitle:@"分类 ∨" forState:UIControlStateNormal];
    _classify.titleLabel.font = [UIFont systemFontOfSize:11];
    [_backView addSubview:_classify];
    [_classify mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(_backView.mas_bottom);
        make.height.mas_equalTo(30);
        make.left.equalTo(_disButton.mas_right).offset(1);
        make.right.equalTo(_sortButton.mas_left).offset(-1);

    }];
    
    _backButton = [UIButton new];
    [_backButton setImage:[UIImage imageNamed:@"backItem"] forState:UIControlStateNormal];
    [_backView addSubview:_backButton];
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_backView.mas_left).offset(7);
        make.bottom.mas_equalTo(_disButton.mas_top).offset(-padding);
        make.width.mas_equalTo(12);
        make.height.mas_equalTo(25);
    }];
    
    _searchButton = [UIButton createUniversalButtonTypeWithTitle:@"筛选"];
    _searchButton.titleLabel.font = [UIFont systemFontOfSize:11];
    [_backView addSubview:_searchButton];
    [_searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_backView).offset(-padding);
        make.width.mas_equalTo(40);
        make.bottom.and.top.equalTo(_backButton);
    }];
    
    _searchBox = [[KTDsearchBox alloc]init];
    _searchBox.backgroundColor = _classify.backgroundColor;
    [_backView addSubview:_searchBox];
    [_searchBox mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_backButton.mas_right).offset(20);
        make.bottom.and.top.equalTo(_backButton);
        make.right.equalTo(_searchButton.mas_left).offset(-5);
    }];
}
@end
