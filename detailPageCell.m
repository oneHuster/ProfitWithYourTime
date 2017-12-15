//
//  detailPageCell.m
//  闲么
//
//  Created by 邹应天 on 16/3/29.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//

#import "detailPageCell.h"
@interface detailPageCell()
@property UIView *nineGridV;
@end
@implementation detailPageCell
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        [self createImages:[NSArray array]];
    }
    return self;
}
- (void)createImages:(NSArray<UIImage *>*)images{
    
        
        images = [NSArray arrayWithObjects:[UIImage imageNamed:@"h1.jpg"],[UIImage imageNamed:@"h2.jpg"],[UIImage imageNamed:@"h3.jpg"],nil];
        [self.nineGridV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.contentView);
            make.left.equalTo(self.contentView);
            make.right.equalTo(self.contentView);
        }];
        NSMutableArray *imageVs = [[NSMutableArray alloc]init];
        for (int i=0; i<images.count; i++) {
            UIImageView *imageV = [[UIImageView alloc]init];
            // imageV.clipsToBounds = YES;
            imageV.image = images[i];
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
                make.bottom.mas_equalTo(self.contentView.mas_bottom).offset(padding);
            }
            else  make.bottom.mas_equalTo(lastView.mas_bottom).offset(padding);
        }];
        
        //    return (  13+ ((SCREEN_WIDTH/3-8)/1.3+8)*(self.imageArray.count/3+1) +8 );/*display上边距 + (每张图片高 + 图片上边距)*图片行数 +最后一张图片下边距*/
    

}
@end
