//
//  detailVC.m
//  闲么
//
//  Created by 邹应天 on 16/2/14.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "detailVC.h"
#import "UITableView+custome.h"
#import "payVC.h"
#import "detailImageCell.h"
#import "detailContenAndNameCell.h"
#import "NSString+timeFormat.h"
#import "NetWorkingObj.h"
#import "orderCommentCell.h"
#import "UIImageView+WebCache.h"
#import <STPopup.h>
#import "commentPopVC.h"

@interface detailVC()<UITableViewDelegate,UITableViewDataSource,NetWorkingDelegate>
@property UIView *headlineView;
@property UIImageView *faviconV;
@property UILabel  *username;
@property UILabel *createTime;
@property UITableView *tableV;
@property UIView *toolBarV;
@property UIToolbar *toolbar;
@property UILabel *tip;
@property UIImageView *tipsIcon;
@property UIButton *grabButton;

@end
static NSString *detailCellId = @"detailcellID";
static NSString *detailImgaeCellId = @"detailImageId";
static NSString *detailTitleCellId = @"detailTitleId";
static NSString *detailCommentCellId = @"detailCommentCellId";
#define bottomBarHeight  50
#define headline_H 50
#define titleCellColor [UIColor grayColor]
#define titleCellHeight 25
@implementation detailVC

- (void)viewDidLoad{
    self.navigationItem.title = @"详情";
    [self initWithTableView];
    [self initWithHeadLineView];
    [self initWithToolBar];
//    [self createToolBar];
    self.toolBarV.hidden = YES;
    self.extendedLayoutIncludesOpaqueBars = YES;
}
- (void)viewWillAppear:(BOOL)animated{
    if (_type == DETAILTYPECELL) {
        
    }
    else{
        UserMdl *user = [UserMdl getCurrentUserMdl];
        self.toolBarV.hidden = NO;
        if ([_model isMe:user.userId]){
                _grabButton.layer.backgroundColor = [UIColor grayColor].CGColor;
            [_grabButton setTitle:@"已抢单" forState:UIControlStateNormal];
            _grabButton.userInteractionEnabled = NO;
        }
        else{
            _grabButton.layer.backgroundColor = Tint_COLOR.CGColor;
            [_grabButton setTitle:@"立即抢单" forState:UIControlStateNormal];
            _grabButton.userInteractionEnabled = YES;
        }

    }
    [self.tableV reloadData];
    [self reloadToolBarAndHeadviewModel];
}
- (void)viewWillDisappear:(BOOL)animated{
    //[self.toolbar removeFromSuperview];
}
- (void)viewDidDisappear:(BOOL)animated{
    self.toolBarV.hidden = YES;
    _grabButton.layer.backgroundColor = Tint_COLOR.CGColor;
}
- (void)initWithHeadLineView
{
    self.headlineView = [UIView new];
    [self.view addSubview:self.headlineView];
    self.headlineView.layer.shadowColor = [UIColor grayColor].CGColor;
    self.headlineView.layer.shadowOffset = CGSizeMake(0, 1);
    self.headlineView.layer.shadowOpacity = 1;
    self.headlineView.backgroundColor = [UIColor whiteColor];
    [self.headlineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view);
        make.width.equalTo(self.view);
        make.top.mas_equalTo(self.view).offset(NAV_HEIGHT);
        make.height.mas_equalTo(headline_H);
    }];
    
    self.faviconV = [UIImageView new];
    [self.headlineView addSubview:self.faviconV];
    [self.faviconV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headlineView).offset(padding);
        make.centerY.mas_equalTo(self.headlineView);
        make.size.mas_equalTo(35);
    }];
    
    _username = [UILabel new];
    [self.headlineView addSubview:_username];
    [_username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.faviconV.mas_centerY);
        make.left.equalTo(self.faviconV.mas_right).offset(padding);
    }];
    
    _createTime = [UILabel new];
    _createTime.font = [UIFont systemFontOfSize:13];
    _createTime.textColor = Font_COLOR;
    [self.headlineView addSubview:_createTime];
    [_createTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.faviconV.mas_centerY);
        make.left.equalTo(self.faviconV.mas_right).offset(padding);
    }];
    
    _tip = [UILabel new];
    _tip.backgroundColor = V_COLOR;
    _tip.text= @"¥0";
    _tip.font = [UIFont systemFontOfSize:15];
    _tip.textAlignment = NSTextAlignmentCenter;
    _tip.textColor = [UIColor orangeColor];
    [self.headlineView addSubview:_tip];
    [_tip mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.headlineView.mas_right).offset(-18);
        make.centerY.equalTo(self.headlineView);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
    }];
    
    _tipsIcon = [UIImageView new];
    _tipsIcon.image = [UIImage imageNamed:@"priceIcon.png"];
    [self.headlineView addSubview:_tipsIcon];
    [_tipsIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(_tip.mas_left).offset(-4);
        make.height.mas_equalTo(_tip).offset(-4);
        make.width.mas_equalTo(_tip.mas_height).offset(-6);
        make.top.mas_equalTo(_tip).offset(2);
    }];
}
//-(UIView*)createWithHeadView{
//    UIView *headV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, VC_WIDTH, 50)];
//    return headV;
//}
- (UIView*)createWithFooterView{
    UIView *footerV = [[UIView alloc]initWithFrame:CGRectMake(0, 0, VC_WIDTH, 50)];
    return footerV;
}
- (void)initWithTableView{
    self.tableV = [[UITableView alloc]initWithFrame:CGRectMake(0,headline_H, VC_WIDTH, VC_HEIGHT-headline_H) style:UITableViewStyleGrouped];
    [self.tableV registerClass:[UITableViewCell class] forCellReuseIdentifier:detailCellId];
    [self.tableV registerClass:[detailImageCell class] forCellReuseIdentifier:detailImgaeCellId];
    [self.tableV registerClass:[detailContenAndNameCell class] forCellReuseIdentifier:detailTitleCellId];
    [self.tableV registerClass:[orderCommentCell class] forCellReuseIdentifier:detailCommentCellId];
    
    self.tableV.delegate = self;
    self.tableV.dataSource = self;
    [self.view addSubview:self.tableV];
    
    //self.tableV.tableHeaderView =  [self createWithHeadView];
    self.tableV.tableFooterView = [self createWithFooterView];
//    [self.tableV modifyTheHeaderViewLabel];
//    [self.tableV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.headlineView.mas_bottom);
//        make.left.and.width.equalTo(self.view);
//        make.bottom.equalTo(self.view).offset(-bottomBarHeight);
//    }];
    self.tableV.backgroundColor = [UIColor whiteColor];
    [self.tableV setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    self.tableV.rowHeight = 0; // in viewdidload
    
   
    
}
//-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
//{
//    return 0.01f;
//}

- (void)initWithToolBar{
    self.toolBarV = [UIView new];
    self.toolBarV.userInteractionEnabled = YES;
    self.toolBarV.backgroundColor = V_COLOR;
    [self.view addSubview:self.toolBarV];
    [self.toolBarV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.width.and.bottom.mas_equalTo(self.view);
        make.height.mas_equalTo(bottomBarHeight);
    }];
    
    _grabButton = [UIButton new];
    _grabButton.userInteractionEnabled = YES;
    _grabButton.layer.backgroundColor = Tint_COLOR.CGColor;
    _grabButton.layer.cornerRadius = 3;
    [_grabButton setTitle:@"立即抢单" forState:UIControlStateNormal];
    [_grabButton addTarget:self action:@selector(grabTheOrder:) forControlEvents:UIControlEventTouchUpInside];
    _grabButton.frame = self.view.bounds;
    [self.toolBarV addSubview:_grabButton];
    [_grabButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.toolBarV);
        make.right.equalTo(self.toolBarV).offset(-20);
        make.height.mas_equalTo(34);
        make.width.mas_equalTo(120);
    }];
    
    UIButton *praise = [UIButton new];
    [praise setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [praise setTitle:[NSString stringWithFormat:@"%ld",(long)_model.praiseNum] forState:UIControlStateNormal];
    praise.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [praise setImage:[UIImage imageNamed:@"praiseIcon.png"] forState:UIControlStateNormal];
    praise.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.toolBarV addSubview:praise];
    [praise mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.toolBarV);
        make.height.mas_equalTo(16);
        //make.width.mas_equalTo();
        make.left.equalTo(self.toolBarV).offset(padding);
    }];

    
    UIButton *comment = [UIButton new];
    [comment setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [comment setTitle:[NSString stringWithFormat:@"%ld",(unsigned long)_model.comment.count] forState:UIControlStateNormal];
    comment.titleLabel.font = [UIFont systemFontOfSize:15];
    
    [comment setImage:[UIImage imageNamed:@"messageIcon.png"] forState:UIControlStateNormal];
    [comment addTarget: self action:@selector(addNewCommentButtonPressed) forControlEvents:UIControlEventTouchUpInside];
    comment.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [comment setTitleEdgeInsets:UIEdgeInsetsMake(0,20, 0,0)];
    [self.toolBarV addSubview:comment];
    [comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.toolBarV);
        make.height.mas_equalTo(16);
        make.left.equalTo(praise.mas_right).offset(padding*2);
    }];

}
- (void)showTheHeadLineVShadows{
    self.headlineView.clipsToBounds = NO;
}
- (void)hideTheHeadLineVShadows{
    self.headlineView.clipsToBounds = YES;

}
- (void)grabTheOrder:(UIButton*)button{
    NetWorkingObj *net  = [NetWorkingObj shareInstance];
    net.delegate = self;
    [net grabTheOrder:_model];
    button.layer.backgroundColor = [UIColor grayColor].CGColor;
}
- (void)addNewCommentButtonPressed{
    commentPopVC *commentpopvc = [commentPopVC new];
    commentpopvc.orderModel = _model;
    STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:commentpopvc];
    [popupController presentInViewController:self];

}

- (void)NetWorkingFinishedWithGrab:(NSDictionary *)statuDic{
    NSLog(@"%@",[[statuDic objectForKey:@"message"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]);
}

- (void)reloadToolBarAndHeadviewModel{
    [self.faviconV sd_setImageWithURL:[NSURL URLWithString:_model.creator.faviconUrl] placeholderImage:[UIImage imageNamed:@"favicon"]];
    _username.text = self.model.name;
    _createTime.text = [NSString compareCurrentTime:self.model.createtime] ;
    _tip.text = [NSString stringWithFormat:@"¥%ld",(long)self.model.tip];
}

- (void)configureCell:(detailContenAndNameCell *)cell atIndexPath:(NSIndexPath *)indexPath {
    cell.content.text = _model.des;
    cell.title.text = _model.title;
    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
    //[cell updateWithModel:self.orderList[indexPath.section]];
    //cell.entity = self.feedEntitySections[indexPath.section];
}

#pragma mark --------------------------tableview delegate
- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:detailCellId];
    cell.textLabel.textColor = [UIColor colorWithWhite:0.6 alpha:1];
    cell.textLabel.font = [UIFont systemFontOfSize:12];
    
    detailImageCell *cellImage = [tableView dequeueReusableCellWithIdentifier:detailImgaeCellId];
    
    detailContenAndNameCell *cellTitle = [tableView dequeueReusableCellWithIdentifier:detailTitleCellId];
    
    orderCommentCell *cellComment = [tableView dequeueReusableCellWithIdentifier:detailCommentCellId];
    
    if (_type == DETAILTYPECELL) {
        if (indexPath.section == 0){
            if (indexPath.row == 0) {
                if (_model.iMgs)
                     [cellImage configureCellWithModel:_model.iMgs];
                return cellImage;
            }else{
                [self configureCell:cellTitle atIndexPath:indexPath];
                return cellTitle;
            }
            
        }
        if (indexPath.section == 1) {
            cell.textLabel.textColor = Tint_COLOR;
            cell.textLabel.text = [NSString stringWithFormat:@"¥%ld",(long)self.model.money];
        }
        //收货时间
        if (indexPath.section == 2) {
            cell.textLabel.text = [NSString standardizeFormat:self.model.receiveTime];
        }
        //收货地址
        if (indexPath.section==3) {
            cell.textLabel.text = [NSString stringWithFormat:@"%@%@%@",self.model.province,self.model.city,self.model.dis];
        }
        //联系电话
        if (indexPath.section==4) {
            cell.textLabel.text = self.model.phone;
        }
    }else{
        switch (indexPath.section) {
            case 0:{
                [self configureCell:cellTitle atIndexPath:indexPath];
                return cellTitle;
            }
            case 1://收货时间
                cell.textLabel.text = [NSString standardizeFormat:self.model.receiveTime];
                break;
            case 2:{//收货地址
                cell.textLabel.text = [NSString stringWithFormat:@"%@%@%@",self.model.province,self.model.city,self.model.dis];
                if (indexPath.row>0) {
                    [cellImage configureCellWithModel:_model.iMgs];
                    return cellImage;
                }
            }
                break;
            case 3:{//实时评论
                [cellComment updateWithDictionary:_model.comment[indexPath.row]];
                return cellComment;
            }
                break;
            default:
                break;
        }
    }
    
    return cell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (_type == DETAILTYPEBUTTON) {
        if (section == 2) {
            return 2;
        }else if(section<2)
            return 1;
        else
            return _model.comment.count;
    }else {
        if(section == 0)
            return 2;
        return 1;
    }
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (_type == DETAILTYPEBUTTON) {
        return 4;
    }
    else
        return 5;
}

- (UIView*)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, VC_WIDTH, titleCellHeight)];
    footView.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1];
    UILabel *titleLb = [UILabel new];
    titleLb.font = [UIFont fontWithName:@"Helvetica-Light" size:15];
   
    [footView addSubview:titleLb];
    [titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(footView).offset(padding);
        make.centerY.equalTo(footView);
    }];
    if (_type == DETAILTYPEBUTTON) {
        switch (section) {
            case 0:
                titleLb.text = @"收货时间";
                break;
            case 1:
                titleLb.text = @"收货地址";
                break;
            case 2:
                titleLb.text = @"实时评论";
                break;
            case 3:
                footView.backgroundColor = [UIColor clearColor];
                break;
            default:
                break;
        }

    }else
        switch (section) {

            case 0:
                titleLb.text = @"本金";
                break;
            case 1:
                titleLb.text = @"收货时间";
                break;
            case 2:
                titleLb.text = @"收货地址";
                break;
            case 3:
                titleLb.text = @"联系电话";
                break;
            case 4:
                footView.backgroundColor = [UIColor clearColor];
                break;
            default:
                break;
        }
    return footView;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentOffset.y>3) {
        [self showTheHeadLineVShadows];
    }
    else
        [self hideTheHeadLineVShadows];
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{

    return titleCellHeight;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return  0.01f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(nonnull NSIndexPath *)indexPath{
    if (_type == DETAILTYPEBUTTON){
        if (indexPath.section==0) {
            return [tableView fd_heightForCellWithIdentifier:detailTitleCellId configuration:^(id cell) {
                [self configureCell:cell atIndexPath:indexPath];
            }];
        }else if (indexPath.section == 2 && indexPath.row>0)
        {
            return [tableView fd_heightForCellWithIdentifier:detailImgaeCellId configuration:^(id cell) {
                if (_model.iMgs)
                    [cell configureCellWithModel:_model.iMgs];
                else
                    [cell configureCellWithModel:[NSArray array]];
            }];
        }
        else if(indexPath.section == 3)
            return  [tableView fd_heightForCellWithIdentifier:detailCommentCellId configuration:^(id cell) {
                [cell updateWithDictionary:_model.comment[indexPath.row]];
            }];
        return 40;
    }
    else{
        //图片下面标题式样
        if (indexPath.section==0)
        {
            if (indexPath.row == 0)
                return [tableView fd_heightForCellWithIdentifier:detailImgaeCellId configuration:^(id cell) {
                    //if (_model.iMgs)
                        [cell configureCellWithModel: _model.iMgs];
                    //else
                        //[cell configureCellWithModel:[NSArray array]];
                }];
            else
                return [tableView fd_heightForCellWithIdentifier:detailTitleCellId configuration:^(id cell) {
                    [self configureCell:cell atIndexPath:indexPath];
                }];
            
        }
        
        return 40;
    }
}
@end
