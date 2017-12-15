//
//  homeMainbodyCell.m
//  闲么
//
//  Created by 邹应天 on 16/1/23.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "homeMainbodyCell.h"
//#import <Masonry/Masonry.h>
#import "nine_gridImageView.h"
@interface homeMainbodyCell()
@property UIView *displayV;
@end
@implementation homeMainbodyCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
       // self.clipsToBounds = NO;
        
        self.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1];
        self.displayV = [UIView new];
        self.displayV.backgroundColor = [UIColor whiteColor];
        [self addSubview:self.displayV];
        self.displayV.layer.shadowOffset = CGSizeMake(0, 0);
        self.displayV.layer.shadowColor = [UIColor grayColor].CGColor;
        self.displayV.layer.shadowOpacity = 1;
        self.displayV.layer.shadowRadius =2;
        [self.displayV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.mas_equalTo(self.mas_left).offset(13);
            make.top.mas_equalTo(self.mas_top).offset(13);
            make.right.mas_equalTo(self.mas_right).offset(-20);
        }];
    }
    return self;
}
-(void)initialWithModel{
        [self.displayV mas_updateConstraints:^(MASConstraintMaker *make) {
            make.bottom.mas_equalTo(self.mas_bottom).offset(-13);
        }];
        [self createNameAndFavicon];
        [self createImages];
        [self createPrice];
    [self createTitleAndContent];
    
}
+ (CGFloat)heightWithModel {
    homeMainbodyCell *cell = [[homeMainbodyCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@""];
    [cell createNameAndFavicon];
    CGFloat nineGridV_Height = [cell createImages];
    [cell layoutIfNeeded];
    /*头像到disV上边距+头像高度＋九宫格高*/
    return 31.3 + 50 + nineGridV_Height+[cell createTitleAndContent];
}
#pragma  mark ----------------name and favicon
-(void)createNameAndFavicon{
    self.favicon = [[UIButton alloc]init];
    self.favicon.layer.backgroundColor = [UIColor purpleColor].CGColor;
    [self addSubview:self.favicon];
    [self.favicon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.displayV.mas_top).offset(31.3);
        make.left.mas_equalTo(self.displayV.mas_left).offset(25.3);
        make.width.mas_equalTo(50);
        make.height.mas_equalTo(50);
    }];
    self.username = [[UILabel alloc]init];
    self.username.text = @"Vendetta";
    [self addSubview:self.username];
    [self.username mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.favicon.mas_right).offset(19.3);
        make.top.mas_equalTo(self.displayV.mas_top).offset(40.6);
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(20);
    }];
    self.publishTime = [[UILabel alloc]init];
    self.publishTime.text = @"12分钟前";
    self.publishTime.textColor=[UIColor grayColor];
    [self addSubview:self.publishTime];
    [self.publishTime mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.username.mas_bottom);
        make.left.equalTo(self.username);
        make.width.equalTo(self.username);
        make.height.mas_equalTo(18);
    }];
}
-(void)createPrice{
    self.price = [[UILabel alloc]init];
    self.price.backgroundColor = [UIColor colorWithWhite:0.9 alpha:0.8];
    self.price.text = @"¥80";
    self.price.font = [UIFont systemFontOfSize:12];
    self.price.textAlignment = NSTextAlignmentCenter;
    self.price.textColor = [UIColor orangeColor];
    [self addSubview:self.price];
    [self.price mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.displayV.mas_right).offset(-8);
        make.top.mas_equalTo(self.displayV.mas_top).offset(31);
        make.width.mas_equalTo(40);
        make.height.mas_equalTo(15);
    }];
}

#pragma mark -----------------toolBar

#pragma  mark ----------------nine_grid Images
-(CGFloat)createImages{
    
     self.imageArray=[NSMutableArray arrayWithObjects:[UIImage imageNamed:@"h1.jpg"],[UIImage imageNamed:@"h4.jpg"],nil];
    
    self.nineGridV = [UIView new];
    [self addSubview:self.nineGridV];
    [self.nineGridV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.favicon.mas_bottom);
        make.left.mas_equalTo(self.displayV.mas_left);
        make.width.equalTo(self.displayV.mas_width);
    }];
    NSMutableArray *imageVs = [[NSMutableArray alloc]init];
    for (int i=0; i<self.imageArray.count; i++) {
        UIImageView *imageV = [[UIImageView alloc]init];
       // imageV.clipsToBounds = YES;
        imageV.image = self.imageArray[i];
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
    //UIView *lastView = views.lastObject;
    [self.nineGridV mas_updateConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(lastView.mas_bottom).offset(padding);
    }];
   
    return (  13+ ((SCREEN_WIDTH/3-8)/1.3+8)*(self.imageArray.count/3+1) +8 );/*display上边距 + (每张图片高 + 图片上边距)*图片行数 +最后一张图片下边距*/
}

-(CGFloat)createTitleAndContent{
    self.title = [UILabel new];
    self.title.lineBreakMode = NSLineBreakByWordWrapping;
    [self.title setNumberOfLines:0];
    self.title.font = [UIFont systemFontOfSize:13];
    self.title.textColor = [UIColor orangeColor];
    self.title.text = @"帮我在阿迪达斯带双鞋。我说的书店嗯地方数独森方式金额发毒法俄法俄法森";
    [self addSubview: self.title];
    [self.title mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.nineGridV.mas_bottom);
        make.left.mas_equalTo(self.displayV.mas_left);
        make.right.mas_equalTo(self.displayV.mas_right);
        
    }];
//    NSLog(@"lines:%ld  height:%f",(long)self.title.numberOfLines,self.title.frame.size.height);
//    return 0;
//    CGSize  titlesize = [self.title.text sizeWithFont:self.title.font                 constrainedToSize:CGSizeMake(self.frame.size.width-33,self.title.text.length) lineBreakMode:NSLineBreakByWordWrapping];
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:13]};
   CGSize titlesize = [self.title.text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH-33, 0) options: NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading attributes:attribute context:nil].size;
   
    return titlesize.height;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}







//----------------------------------------------
//-(void)initWithImage:(CGRect)frame{
//    int totalloc=3;
//    int i=0;
//    int totalrow=1;
//    UIView *displayView = [UIView new];
//    self.imageArray=[NSMutableArray arrayWithObjects:[UIImage imageNamed:@"h1.jpg"],[UIImage imageNamed:@"h2.jpg"],[UIImage imageNamed:@"h3.jpg"],[UIImage imageNamed:@"h4.jpg"],[UIImage imageNamed:@"h5.jpg"],nil];
//    if (self.imageArray.count>0) {
//        totalrow=MIN((int)(self.imageArray.count-1)/totalloc+1, 3);
//        [displayView mas_makeConstraints:^(MASConstraintMaker *make) {
//            
//        }];
//        //        displayView=[[UIView alloc]initWithFrame:CGRectMake(frame.origin.x, frame.size.height+frame.origin.y+10, frame.size.width, media_box_height*totalrow)];
//        [displayView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.top.mas_equalTo(self.favicon.mas_bottom);
//            make.left.mas_equalTo(self.mas_left);
//            make.width.equalTo(self.mas_width);
//        }];
//        
//        for (UIImage *image in self.imageArray) {
//            if (i>8) {
//                break;
//            }
//            int row=i/totalloc;//行号
//            int col=i%totalloc;//列号
//            nine_gridImageView *contentImageView = [nine_gridImageView new];
//            
//            //            nine_gridImageView *appimageView=[[nine_gridImageView alloc]initWithFrame:CGRectMake((100+MARGIN_W)*loc,(100+MARGIN_W)*row, 100, 100)];
//            contentImageView.contentMode = UIViewContentModeScaleAspectFill;
//            contentImageView.autoresizingMask = UIViewAutoresizingFlexibleHeight;
//            contentImageView.clipsToBounds=YES;
//            [contentImageView initialize];
//            contentImageView.image=image;
//            [displayView addSubview:contentImageView];
//            //九宫格约束
//            //            [contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            //                make.left.mas_equalTo(displayView.mas_left).multipliedBy(0.33*col).offset(padding);
//            //                make.width.mas_equalTo(displayView.mas_width).multipliedBy(0.33).offset(-padding*2);
//            //                make.height.mas_equalTo(make.width).multipliedBy(0.7);
//            //
//            //                //make.top.mas_equalTo(displayView.mas_top).offset(make.height.);
//            //                
//            //            }];
//            i++;
//            
//        }//for end
//        
//    }
//}


@end
