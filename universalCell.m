//
//  universalCell.m
//  闲么
//
//  Created by 邹应天 on 16/1/27.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//
typedef void (^actionBlock)();
#import "universalCell.h"
#import "UIImageView+WebCache.h"

@interface universalCell()
@property UIView *displayV;
@property UIImageView *priceIcon;
@property UIView *LineBreak;

@property (nonatomic,copy) actionBlock theBlock;
@property (nonatomic,weak) actionBlock praiseBlock;
@property (nonatomic,copy) actionBlock commentBlock;
@end

@implementation universalCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.contentView.layer.shadowColor = [UIColor grayColor].CGColor;
        self.contentView.layer.shadowOffset = CGSizeMake(0, 0);
        self.contentView.layer.shadowOpacity = 0.5;
        self.contentView.layer.shadowRadius = 2;
        [self initialWithModel];
        [self createGrabOrder];
        [self createNameAndFavicon];
        [self createPrice];
        [self createImages];
        [self createTitleAndContent];
        [self createToolBar];
    }
    return self;
}
-(void)initialWithModel{
    
    self.favicon = [[UIImageView alloc]init];
    self.username = [[UILabel alloc]init];
    
    self.publishTime = [[UILabel alloc]init];
    
    self.price = [[UILabel alloc]init];
    self.priceIcon = [UIImageView new];
    self.content = [UILabel new];
    self.title = [UILabel new];
    
    
    [self.contentView addSubview:self.favicon];
    [self.contentView addSubview:self.username];
    [self.contentView addSubview:self.publishTime];
    [self.contentView addSubview:self.price];
    [self.contentView addSubview:self.priceIcon];
    [self.contentView addSubview:self.title];
    [self.contentView addSubview:self.content];
    
    self.nineGridV = [UIView new];
    [self.contentView addSubview:self.nineGridV];
    
    
    self.LineBreak = [UIView new];
    self.location = [UIButton new];
    self.praise = [UIButton new];
    self.comment = [UIButton new];
    
    [self.contentView addSubview:self.LineBreak];
    [self.contentView addSubview:self.location];
    [self.contentView addSubview: self.praise];
    [self.contentView addSubview:self.comment];
    
}

- (void)updateWithModel:(orderMdl *)model{
    self.username.text = model.creator.nickName;
    self.title.text = model.title;
    [self.favicon sd_setImageWithURL:[NSURL URLWithString:model.creator.faviconUrl]];
    self.publishTime.text = model.createtimeBynow;
    [self.location setTitle:model.position forState:UIControlStateNormal];
    [self.praise setTitle:[NSString stringWithFormat:@"%ld",(long)model.praiseNum] forState:UIControlStateNormal];
    [self.price setText:[NSString stringWithFormat:@"¥%ld",(long)model.tip]];
    self.content.text = model.des;
    [self.comment setTitle:[NSString stringWithFormat:@"%ld",(unsigned long)model.comment.count] forState:UIControlStateNormal];
    self.imageArray = [NSMutableArray array];
    
    if (model.iMgs){
        for (int i=0; i<model.iMgs.count; i++) {
            [self.imageArray addObject:[NSString stringWithFormat:@"http://123haomai.cn:90%@",model.iMgs[i]] ];
        }
        [self createImages];
    }
    else{
        [self remakeNinegridConstraint];
    }
}
#pragma  mark ----------------name and favicon
-(void)createNameAndFavicon{
    int magin = 4;
    self.username.font = [UIFont systemFontOfSize:14];
    [self.username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.favicon.mas_right).offset(padding);    // 设置titleLabel上边跟左边与父控件的偏移量
        make.bottom.equalTo(self.favicon.mas_centerY);
        make.width.mas_equalTo(100);
    }];
    
    
    self.publishTime.text = @"0分钟前";
    self.publishTime.font = [UIFont systemFontOfSize:12];
    self.publishTime.textColor = [UIColor grayColor];

    [self.publishTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.and.right.equalTo(self.username);                       // 设置contentLabel左边和右边对于titleLabel左右对齐
        make.top.mas_equalTo(self.username.mas_bottom).offset(magin);     // 设置contentLabel的上边对于titleLabel的下边的偏移量
    }];
    
    
    //self.favicon.layer.backgroundColor = [UIColor purpleColor].CGColor;
    self.favicon.layer.cornerRadius = 20;
    self.favicon.clipsToBounds = YES;
    [self.favicon mas_makeConstraints:^(MASConstraintMaker *make) {
         make.top.mas_equalTo(self.contentView.mas_top).offset(padding);
         make.left.mas_equalTo(self.contentView.mas_left).offset(padding);
            make.size.mas_equalTo(40);
    }];

}




-(void)createPrice{
  
    self.price.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1];
    self.price.text = @"¥0";
    self.price.font = [UIFont systemFontOfSize:15];
    self.price.textAlignment = NSTextAlignmentCenter;
    self.price.textColor = [UIColor orangeColor];
    [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView.mas_right).offset(-padding);
        //make.top.mas_equalTo(self.username);
        make.centerY.equalTo(self.favicon);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(20);
    }];
    
    self.priceIcon.image = [UIImage imageNamed:@"priceIcon.png"];
    [self.priceIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.price.mas_left).offset(-4);
        make.height.mas_equalTo(self.price).offset(-4);
        make.width.mas_equalTo(self.price.mas_height).offset(-6);
        //make.top.mas_equalTo(self.price).offset(2);
        make.centerY.equalTo(self.favicon);
    }];
}


- (void)remakeConstraint{
    
}
#pragma mark -----------------title and content
-(void)createTitleAndContent{
    //self.title.textColor = [UIColor orangeColor];
    self.title.lineBreakMode = NSLineBreakByWordWrapping;
    [self.title setNumberOfLines:0];
    self.title.font = [UIFont systemFontOfSize:15];
    self.title.textColor = [UIColor orangeColor];
    self.title.text = @" ";
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nineGridV.mas_bottom);
        make.left.mas_equalTo(self.favicon.mas_left);
        make.right.mas_equalTo(self.nineGridV.mas_right);
    }];
    
    self.content.lineBreakMode = NSLineBreakByWordWrapping;
    [self.content setNumberOfLines:0];
    self.content.font = [UIFont systemFontOfSize:12];
    self.content.textColor = [UIColor grayColor];
    self.content.text = @" ";
    //self.content.text = @"三叶草 男子 经典鞋 一号黑 M21780 43码 加急！加急！";
    [self.content mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.title.mas_bottom);
        make.left.and.right.equalTo(self.title);
    }];
    
    
}
#pragma mark --------------------------toolBar
-(void)createToolBar{
    self.LineBreak.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1];
    [self.LineBreak mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.content.mas_bottom);
        make.left.equalTo(self.favicon);
        make.right.equalTo(self.price);
        make.height.mas_equalTo(1.3);
    }];
    
    
    [self.location setTitle:@"武汉华科 距离你850米" forState:UIControlStateNormal];
    self.location.titleLabel.font = [UIFont systemFontOfSize:11];
    //[self.location.titleLabel setLineBreakMode: UILineBreakModeWordWrap];
//    self.location.titleLabel.lineBreakMode =  UILineBreakModeWordWrap;
//    self.location.titleLabel.numberOfLines = 0;
    
    [self.location setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    self.location.titleLabel.textAlignment = NSTextAlignmentLeft;
    [self.location setImage:[UIImage imageNamed:@"location.png"] forState:UIControlStateNormal];
    self.location.imageView.contentMode = UIViewContentModeScaleAspectFit;
    //[self.location setImageEdgeInsets:UIEdgeInsetsMake(3, 0, 3, 140)];
    [self.location setTitleEdgeInsets:UIEdgeInsetsMake(4, 0, 4, 0)];
    [self.location mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.LineBreak);
        make.top.equalTo(self.LineBreak).offset(padding);
        make.height.mas_equalTo(20);
       // make.width.mas_equalTo(150);
        //由距离确定cell高度。
        make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(-8);
        // 防止接触。
        //make.right.equalTo(self.praise.mas_left);
    }];
    
    
    
    [self.comment setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.comment setTitle:@"评论" forState:UIControlStateNormal];
    self.comment.titleLabel.font = [UIFont systemFontOfSize:11];
    
    [self.comment setImage:[UIImage imageNamed:@"messageIcon.png"] forState:UIControlStateNormal];
    [self.comment setImageEdgeInsets:UIEdgeInsetsMake(4, 0, 4,30)];
    self.comment.imageView.contentMode = UIViewContentModeScaleAspectFit;
   [self.comment setTitleEdgeInsets:UIEdgeInsetsMake(4, 0, 4, 0)];
    [self.comment mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.LineBreak);
        make.top.equalTo(self.LineBreak).offset(padding);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(50);
    }];
    
    
    
    [self.praise setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    [self.praise setTitle:@"12" forState:UIControlStateNormal];
     self.praise.titleLabel.font = [UIFont systemFontOfSize:11];
    
    [self.praise setImage:[UIImage imageNamed:@"praiseIcon.png"] forState:UIControlStateNormal];
    [self.praise setImageEdgeInsets:UIEdgeInsetsMake(4, 0, 4,20)];
     self.praise.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.praise setTitleEdgeInsets:UIEdgeInsetsMake(4, 0, 4, 0)];
    [self.praise mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.comment.mas_left);
        make.top.equalTo(self.LineBreak).offset(padding);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(40);
    }];

}

- (void)createGrabOrder{
    self.grabOrder = [UIButton new];
    self.grabOrder.layer.backgroundColor = Tint_COLOR.CGColor;
    self.grabOrder.layer.cornerRadius = 2;
    self.grabOrder.titleLabel.textColor = [UIColor whiteColor];
    self.grabOrder.titleLabel.font  = [UIFont systemFontOfSize:11];
    [self.grabOrder setTitle:@"抢单" forState:UIControlStateNormal];
    [self.contentView addSubview:self.grabOrder];
}

-(void)addTheGrabOrder:(void (^)(void))action{
    
    

     [self.grabOrder mas_makeConstraints:^(MASConstraintMaker *make) {
         make.right.equalTo(self.LineBreak);
         //make.top.equalTo(self.LineBreak).offset(padding);
         make.centerY.equalTo(_comment);
         make.height.mas_equalTo(26);
         make.width.mas_equalTo(55);
     }];
    
    [self.comment mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.grabOrder.mas_left);
        make.top.equalTo(self.LineBreak).offset(padding);
        make.height.mas_equalTo(20);
        make.width.mas_equalTo(50);
    }];
    //添加点击事件
//    if ([self.grabOrder isTouchInside]) {
//        action();
//    }
    self.theBlock = action;
    [self.grabOrder addTarget:self action:@selector(buttonBePressed) forControlEvents:UIControlEventTouchUpInside];
    
}
- (void)addThePraised:(void (^)(void))action{
    self.praiseBlock = action;
    [self.praise addTarget:self action:@selector(praiseTheOrder) forControlEvents:UIControlEventTouchUpInside];
}
- (void)addTheComment:(void (^)(void))action{
    self.commentBlock = action;
    [self.comment addTarget:self action:@selector(commentButtonPressed) forControlEvents:UIControlEventTouchUpInside];
}
- (void)buttonBePressed{
    self.theBlock();
}
- (void)praiseTheOrder{
    [self.praise setImageEdgeInsets:UIEdgeInsetsMake(4, 0, 4,20)];
    [_praise setImage:[UIImage imageNamed:@"praisedIcon"] forState:UIControlStateNormal];
    [self.praise setTitleEdgeInsets:UIEdgeInsetsMake(4, 0, 4, 0)];

    self.praiseBlock();
}
- (void)commentButtonPressed{
    self.commentBlock();
}


//- (void)createImages{
//    [_nineGridV mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.mas_equalTo(self.favicon.mas_bottom);
//        make.left.equalTo(self.contentView);
//        make.right.equalTo(self.contentView);
//    }];
//    if (self.imageArray.count>0) {
//        
//    }
//}

#pragma  mark ----------------nine_grid Images
//no images
- (void)remakeNinegridConstraint{
    for (UIView *view in self.nineGridV.subviews) {
        [view removeFromSuperview];
    }
    [self.nineGridV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.favicon.mas_bottom);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
        make.height.mas_equalTo(0.1);
    }];
}

-(void)createImages{
    
    for (UIView *view in self.nineGridV.subviews) {
        [view removeFromSuperview];
    }
 
    [self.nineGridV mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.favicon.mas_bottom);
        make.left.equalTo(self.contentView);
        make.right.equalTo(self.contentView);
    }];
    NSMutableArray *imageVs = [[NSMutableArray alloc]init];
    for (int i=0; i<self.imageArray.count; i++) {
        UIImageView *imageV = [[UIImageView alloc]init];
        // imageV.clipsToBounds = YES;
        //imageV.image  = self.imageArray[i];
        [imageV sd_setImageWithURL:self.imageArray[i]];
        [imageVs addObject:imageV];
        [self.nineGridV addSubview:imageV];
    }
    NSArray *items = imageVs;
    
    
    NSInteger rowCapacity = 3;//每行item容量(个数)
    
    CGFloat itemSpacing = 8; //item间距
    CGFloat rowSpacing = 8; //行间距
    CGFloat topMargin = 8; //上边距
    CGFloat leftMargin = 8; //左边距
    CGFloat rightMargin = 8; //右边距
    
    
    __block UIImageView *lastView;
    [items enumerateObjectsUsingBlock:^(UIImageView   *view, NSUInteger idx, BOOL *  stop) {
        NSInteger rowIndex = idx / rowCapacity; //行index
        NSInteger columnIndex = idx % rowCapacity;//列index
        
        if (lastView) {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                //设置 各个item 大小相等
                make.size.equalTo(lastView);
            }];
        }
        if (columnIndex == 0) {//每行第一列
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                //设置左边界
                make.left.offset(leftMargin);
                if (rowIndex == 0) {//第一行 第一个
                    make.width.equalTo(view.mas_height).multipliedBy(1.3);
                    //make.width.equalTo(view.mas_height);//长宽相等
                    if (items.count < rowCapacity) {//不满一行时 需要 计算item宽
                        //比如 每行容量是6,则公式为:(superviewWidth/6) - (leftMargin + rightMargin + SumOfItemSpacing)/6
                        make.width.equalTo(view.superview).multipliedBy(1.0/rowCapacity).offset(-(leftMargin + rightMargin + (rowCapacity -1) * itemSpacing)/rowCapacity);
                        
                    }
                    [view mas_makeConstraints:^(MASConstraintMaker *make) {//设置上边界
                        make.top.offset(topMargin);
                    }];
                }else {//其它行 第一个
                    [view mas_makeConstraints:^(MASConstraintMaker *make) {
                        //和上一行的距离
                        make.top.equalTo(lastView.mas_bottom).offset(rowSpacing);
                    }];
                }
            }];
        }else {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                //设置item水平间距
                make.left.equalTo(lastView.mas_right).offset(itemSpacing);
                //设置item水平对齐
                make.centerY.equalTo(lastView);
                
                //设置右边界距离
                if (columnIndex == rowCapacity - 1 && rowIndex == 0) {//只有第一行最后一个有必要设置与父视图右边的距离，因为结合这条约束和之前的约束可以得出item的宽，前提是必须满一行，不满一行 需要计算item的宽
                    make.right.offset(- rightMargin);
                }
            }];
        }
        lastView = view;
    }];// 枚举结束
    
    
    
    //----------------------------------------关键性两个约束
    [self.nineGridV mas_updateConstraints:^(MASConstraintMaker *make) {
        if (lastView==nil) {
            make.bottom.mas_equalTo(self.publishTime.mas_bottom).offset(padding);
        }
        else  make.bottom.mas_equalTo(lastView.mas_bottom).offset(padding);
    }];
    
//    return (  13+ ((SCREEN_WIDTH/3-8)/1.3+8)*(self.imageArray.count/3+1) +8 );/*display上边距 + (每张图片高 + 图片上边距)*图片行数 +最后一张图片下边距*/
}

- (void)configureCellWithModel:(orderMdl *)model{
    self.fd_enforceFrameLayout = NO;
    [self updateWithModel:model];
}

@end
