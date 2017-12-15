//
//  homePageVC.m
//  闲么
//
//  Created by 邹应天 on 16/1/21.
//  Copyright © 2016年 yingtian zou. All rights reserved.
//
typedef NS_ENUM(NSInteger,LOADSTATUS){
    LOADSTATUSRefresh,
    LOADSTATUSLoad
};

#import "homePageVC.h"
#import <Masonry/Masonry.h>
#import "universalCell.h"
#import "KTDropdownMenuView.h"
#import "adminInfoVC.h"
#import "detailVC.h"
#import "BaiduMapC.h"
#import "NSString+getDeviceModel.h"
#import "CoreDateManager.h"
#import "UIImage+setAttribute.h"
//#import <BaiduMapAPI_Location/BMKLocationService.h>
#import "NetWorkingObj.h"
#import <MJRefresh/MJRefresh.h>
#import "NSString+timeFormat.h"
#import "popupV.h"
#import <STPopup/STPopup.h>
#import "commentPopVC.h"
#import "UIImageView+WebCache.h"
#import "UIButton+WebCache.h"

static const NSInteger loadCount = 3;
#define citySelectorWidth  25
@interface homePageVC ()<SDCycleScrollViewDelegate,UISearchBarDelegate,UISearchDisplayDelegate,NetWorkingDelegate,KTDropdownMenuDelegate>{
    NSArray *listNames;
    LOADSTATUS loadstat;
    NSInteger orderIndex;
}
@property UISearchDisplayController *searchDisplayBar;
@property (nonatomic, strong) NSArray *searchResults;
@property MySearchBar *backSearchBar;
@property UITableView *resultTableV;
@property adminInfoVC *adminInfo;
@property UILabel *userNameLb;
@property KTDropdownMenuView *citySelector;
//@property(strong, nonatomic) UISearchController *searchController;
@property detailVC *detailvc;
@property UserMdl *userModel;
@property BaiduMapC *baiduManager;
@property NetWorkingObj *networking;
@property NSMutableArray *orderList;
@end

static NSString *mainBodyIdentifier = @"mainbodyCell";
static NSString *commonIdentifier = @"common";

@implementation homePageVC

- (void)viewDidLoad {
    //NSLog(@"%@",self.navigationController.navigationBar);
    [super viewDidLoad];
    self.orderList = [[NSMutableArray alloc]init];
    self.view.backgroundColor = [UIColor colorWithWhite:0.94 alpha:1];
    self.detailvc = [[detailVC alloc]init];
    
    [self initialTableView];
    [self initialCycleScrollView];
    [self initialSearchBar];
    [self createSearchDisplayController];
    [self initialadminInfoVC];
    [self initWithCityMenu];
    //[self createLocationService];
    
    self.extendedLayoutIncludesOpaqueBars = YES;
//    CoreDateManager *cache = [[CoreDateManager alloc]init];
//    [cache queryWithCurrentUser];
//    
//    orderIndex = 1;//从0开始取
    
    [self refreshCurrentData];
    [self.tableView reloadData];

}
-(void)viewWillAppear:(BOOL)animated{
    
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsCompact];
    [self loadModelinView];
    
    _baiduManager = [BaiduMapC getTheBDMManager];
    [_baiduManager startLocationServer];
}
-(void)viewDidAppear:(BOOL)animated{
   
    [self presentTabbar];
        if (self.adminFavicon) {
            [self.navigationController.navigationBar addSubview:self.adminFavicon];
            [self.navigationController.navigationBar addSubview:self.citySelector];
            [self.navigationController.navigationBar addSubview:self.searchbar];
            [self.navigationController.navigationBar addSubview:self.searchBarButton];
            [self.navigationController.navigationBar addSubview:_userNameLb];
        }
}


-(void)loadModelinView{
    _userModel = [UserMdl getCurrentUserMdl];
    [self.adminFavicon setImageWithURL:[NSURL URLWithString:_userModel.faviconUrl] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"favicon"]];
//    [self.adminFavicon setTitle:@"123" forState:UIControlStateNormal];
    _userNameLb.text = _userModel.nickName;
}
//百度地图
#pragma mark ----------------------baidu map delegate


#pragma  mark ---------------------searchBar
-(void)initialSearchBar{
        self.searchBarButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-padding-40, 15, 40, 20)];
        self.searchBarButton.layer.cornerRadius = 1;
        self.searchBarButton.clipsToBounds = YES;
        self.searchBarButton.titleLabel.font = [UIFont systemFontOfSize:10];
        [self.searchBarButton setTitle:@"附近" forState:UIControlStateNormal];
        [self.searchBarButton addTarget:self action:@selector(searchNearby) forControlEvents:UIControlEventTouchUpInside];
        self.searchBarButton.backgroundColor = Tint_COLOR;
        [self.navigationController.navigationBar addSubview:self.searchBarButton];

        //请输入关键词
        self.searchbar = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2, 15, self.searchBarButton.frame.origin.x-SCREEN_WIDTH/2-padding, 20)];
    //self.searchbar.alpha = 0.6;
    self.searchbar.layer.cornerRadius = 2;
    
        self.searchbar.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.6];
    [self.searchbar setContentMode:UIViewContentModeLeft];
    [self.searchbar setImage:[[UIImage imageNamed:@"magnifyIcon"]imageByApplyingAlpha:0.5]forState:UIControlStateNormal];
        //[self.searchbar setImage:[UIImage imageNamed:@"magnifyIcon"] forState:UIControlStateHighlighted];
    [self.searchbar setTitleColor:[UIColor colorWithWhite:1 alpha:0.6] forState:UIControlStateNormal];
    [self.searchbar setTitleColor:[UIColor colorWithWhite:0.2 alpha:0.6] forState:UIControlStateHighlighted];
    //self.searchbar.titleLabel.textColor = Font_COLOR;
    self.searchbar.titleLabel.font = [UIFont systemFontOfSize:10];
    //self.searchbar.titleLabel.textColor = [UIColor colorWithWhite:0.9 alpha:0.6];
        [self.searchbar setTitle:@"请输入关键词" forState:UIControlStateNormal];
    [self.searchbar setImageEdgeInsets:UIEdgeInsetsMake(3,0,3,6)];
    //self.searchbar.contentMode = UIViewContentModeScaleAspectFit;
        [self.navigationController.navigationBar addSubview:self.searchbar];
        [self.searchbar addTarget:self action:@selector(toContentSearchDisplayView) forControlEvents:UIControlEventTouchUpInside];
    
    
        //主页头像
        self.adminFavicon = [[UIButton alloc]initWithFrame:CGRectMake(padding, padding,30,30)];
        [self.navigationController.navigationBar addSubview:self.adminFavicon];
        self.adminFavicon.imageView.layer.cornerRadius = 15;
        self.adminFavicon.imageView.clipsToBounds = YES;
        self.adminFavicon.imageView.contentMode = UIViewContentModeScaleToFill;
   
        [self.adminFavicon setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [self.adminFavicon addTarget:self action:@selector(pushViewtoAdminInfoVC) forControlEvents:UIControlEventTouchDown];

        [self.adminFavicon.titleLabel setFont:[UIFont systemFontOfSize:11]];
    
    
    
    _userNameLb = [[UILabel alloc]initWithFrame:CGRectMake(padding+30+padding, padding, SCREEN_WIDTH/2-padding-25-citySelectorWidth - 40, 30)];
    _userNameLb.text = @"未登录";
    [self.navigationController.navigationBar addSubview:_userNameLb];
    _userNameLb.textColor = [UIColor whiteColor];
    _userNameLb.font = [UIFont systemFontOfSize:11];
    

}

-(void)initialadminInfoVC{
    self.adminInfo   =   [[adminInfoVC alloc]init];
}

-(void)initWithCityMenu{
    NSArray *titles = @[@"武汉", @"上海", @"北京", @"深圳", @"天津"];
    self.citySelector = [[KTDropdownMenuView alloc] initWithFrame:CGRectMake(SCREEN_WIDTH/2-padding-25-padding, 15, citySelectorWidth, 20) titles:titles];
    self.citySelector.textColor = [UIColor blackColor];
    self.citySelector.cellColor = [UIColor whiteColor];
    self.citySelector.titleTextColor = [UIColor whiteColor];
    self.citySelector.width = VC_WIDTH;
    self.citySelector.textFont = [UIFont systemFontOfSize:10];
    self.citySelector.delegate = self;
    [self.navigationController.navigationBar addSubview:self.citySelector];
    
    __weak typeof(self) weakself = self;
    self.citySelector.selectedAtIndex = ^(int index)
    {
        NetWorkingObj *net = [NetWorkingObj shareInstance];
        if ([weakself.citySelector.titles[0] isEqualToString:@"武汉"]) {
            [net loadTheOrdersWithCounts:1 andCity:weakself.citySelector.titles[index] andKey:nil andOrderBy:nil andX:0 andY:0];
        }
        if ([weakself.citySelector.titles[0] isEqualToString:@"食品"]) {
             [net loadTheOrdersWithCounts:1 andCity:nil andKey:weakself.citySelector.titles[index] andOrderBy:nil andX:0 andY:0];
        }
        net.delegate = weakself;
        [weakself.tableView.mj_header  beginRefreshing];
        [weakself.tableView reloadData];
    };

}
#pragma mark --------------------------------KTD MENU delegate
- (void)KTDMfilterButtonPressed:(NSString *)cityString{
    _networking = [NetWorkingObj shareInstance];
    orderIndex = 2;
    [_networking loadTheOrdersWithCounts:1 andCity:cityString andKey:nil andOrderBy:nil andX:0 andY:0];
    _networking.delegate = self;
    [self.tableView.mj_header beginRefreshing];
    loadstat = LOADSTATUSRefresh;
}

- (void)searchNearby{
    _networking = [NetWorkingObj shareInstance];
    orderIndex = 2;
    [_networking loadTheOrdersWithCounts:1 andCity:nil andKey:nil andOrderBy:nil andX:_baiduManager.currentCoordinate.latitude andY:_baiduManager.currentCoordinate.longitude];
    _networking.delegate = self;
    [self.tableView.mj_header beginRefreshing];
    loadstat = LOADSTATUSRefresh;
}
#pragma mark   -------------------------------pushVtoAdminVC
-(void)pushViewtoAdminInfoVC{
    //self.adminInfo.hidesBottomBarWhenPushed = YES;
    [self hideTheTabbar];
    [self.navigationController pushViewController:self.adminInfo animated:YES];
    [self clearNavigationBarItems];
}

-(void)clearNavigationBarItems{
    [self.adminFavicon removeFromSuperview];
    [self.searchBarButton removeFromSuperview];
    [self.searchbar removeFromSuperview];
    [self.citySelector removeFromSuperview];
    [_userNameLb removeFromSuperview];
}
#pragma mark  ---------------------------------------searchDisplay delegate
-(void)toContentSearchDisplayView{
    //[_citySelector hideMenu];
    [self.backSearchBar becomeFirstResponder];
}
-(void)createSearchDisplayController{
    self.backSearchBar = [MySearchBar new];
    [self.view addSubview:self.backSearchBar];
    [self.backSearchBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.and.top.left.equalTo(self.view);
        make.height.mas_equalTo(NAV_HEIGHT);
    }];
    self.backSearchBar.delegate = self;
    
    listNames = [NSArray arrayWithObjects:@"111",@"222",@"333",@"1232",@"233", nil];
//    self.searchbar.delegate=self;
    [self.backSearchBar setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [self.backSearchBar sizeToFit];
    
    
    self.searchDisplayBar = [[UISearchDisplayController alloc] initWithSearchBar:self.backSearchBar contentsController:self];
    self.searchDisplayBar.delegate = self;

    
    self.searchDisplayBar.searchResultsDataSource = self;
    self.searchDisplayBar.searchResultsDelegate = self;
    
    
#pragma mark -----------------------------------------------------------setup the result tableview
    [self.searchDisplayBar.searchResultsTableView registerClass:[UITableViewCell class] forCellReuseIdentifier:commonIdentifier];
    self.searchDisplayBar.searchResultsTableView.separatorInset = UIEdgeInsetsMake(0, 15, 0, 15);
//    self.resultTableV  = [[UITableView alloc]initWithFrame:self.view.frame];
//    self.resultTableV.alpha = 0.5;
}
- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar {
}
- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
   
}


/**
 *  通过搜索条件过滤得到搜索结果
 *
 *  @param searchText 关键词
 *  @param scope      范围
 */
- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF contains[cd] %@", searchText];
    self.searchResults = [listNames filteredArrayUsingPredicate:resultPredicate];
}




#pragma mark - UISearchDisplayController 代理

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    
    [self filterContentForSearchText:searchString scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:[[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    
    return YES;
}
- (void)searchDisplayControllerWillBeginSearch:(UISearchDisplayController *)controller{
    [self hideTheTabbar];
}

- (void)searchDisplayControllerWillEndSearch:(UISearchDisplayController *)controller{
    [self presentTabbar];
}



#pragma mark -------------------cycleScrollView
-(void)initialCycleScrollView{
    
    NSArray *imagesURLStrings = @[
                                  @"https://ss2.baidu.com/-vo3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a4b3d7085dee3d6d2293d48b252b5910/0e2442a7d933c89524cd5cd4d51373f0830200ea.jpg",
                                  @"https://ss0.baidu.com/-Po3dSag_xI4khGko9WTAnF6hhy/super/whfpf%3D425%2C260%2C50/sign=a41eb338dd33c895a62bcb3bb72e47c2/5fdf8db1cb134954a2192ccb524e9258d1094a1e.jpg",
                                  @"http://c.hiphotos.baidu.com/image/w%3D400/sign=c2318ff84334970a4773112fa5c8d1c0/b7fd5266d0160924c1fae5ccd60735fae7cd340d.jpg"
                                  ];

//    self.cycleScrollView = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 180) shouldInfiniteLoop:YES imageNamesGroup:imagesURLStrings];
    self.cycleScrollView = [[SDCycleScrollView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_WIDTH*0.5625)];//宽高比
        //self.cycleScrollView.autoScroll = NO;
        self.cycleScrollView.infiniteLoop = YES;
        self.cycleScrollView.imageURLStringsGroup = imagesURLStrings;
        
        self.cycleScrollView.autoScrollTimeInterval=5.0;//轮播时间
        //self.cycleScrollView.currentPageDotImage      //轮播分页控件
        self.cycleScrollView.delegate = self;
        self.cycleScrollView.pageControlStyle = SDCycleScrollViewPageContolStyleAnimated;
    [self.tableView addSubview:self.cycleScrollView];
    
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        self.cycleScrollView.imageURLStringsGroup = imagesURLStrings;
    });
    
    [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.tableView.mas_top).offset(-padding);

        make.height.mas_equalTo(180);
        make.width.mas_equalTo(self.view.mas_width);
    }];
    
}

#pragma mark - SDCycleScrollViewDelegate
-(void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index{
    
}
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index
{
    NSLog(@"---点击了第%ld张图片", (long)index);
    
//    [self.navigationController pushViewController:[NSClassFromString(@"DemoVCWithXib") new] animated:YES];
}



#pragma mark ---------------------tableview
-(void)initialTableView{
    self.tableView = [UITableView new];
    [self.view addSubview:self.tableView];
    //下拉刷新
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self refreshCurrentData];
//        [self performSelectorOnMainThread:@selector(loadNewData)  withObject:nil waitUntilDone:YES];
        //dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            // 刷新表格
            //[self.tableView reloadData];
        //[self performSelector:@selector(tableviewrefresh) withObject:nil afterDelay:3];
            // (最好在刷新表格后调用)调用endRefreshing可以结束刷新状态
            //[self.tableView.mj_header endRefreshing];
       // });
    }];
    
    self.tableView.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        [self loadNewData];
    }];
    
    self.tableView.mj_header.ignoredScrollViewContentInsetTop = 190;
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.contentInset = UIEdgeInsetsMake(180+padding, 0, 0, 0);
    self.tableView .backgroundColor = [UIColor colorWithWhite:0.94 alpha:1];
    [self.tableView registerClass:[universalCell class] forCellReuseIdentifier:mainBodyIdentifier];
    self.tableView.clipsToBounds = NO;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
//    //预设高度
    self.tableView.estimatedRowHeight = UITableViewAutomaticDimension;
//    self.infoTableView.contentInset = UIEdgeInsetsMake(10, 10, 10, 10);
    [self.tableView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top);
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        make.bottom.equalTo(self.view.mas_bottom);
    }];

}
- (void)refreshCurrentData{
    _networking = [NetWorkingObj shareInstance];
    orderIndex = 2;
    [_networking loadTheOrdersWithCounts:1 andCity:nil andKey:nil andOrderBy:nil andX:0 andY:0];
    _networking.delegate = self;
    loadstat = LOADSTATUSRefresh;
}

- (void)loadNewData{
    _networking = [NetWorkingObj shareInstance];
    [_networking loadTheOrdersWithCounts:orderIndex++ andCity:nil andKey:nil andOrderBy:nil andX:0 andY:0];
    _networking.delegate = self;
    loadstat = LOADSTATUSLoad;
    [self.tableView.mj_footer beginRefreshing];
}
#pragma mark =========================networking delegate
-(void)NetWorkingFinishedWithLoadList:(NSArray *)list{
    if (loadstat == LOADSTATUSRefresh)
        self.orderList = [NSMutableArray array];
    
    for (NSMutableDictionary *dic in list) {
        //NSLog(@"%@",dic);
        orderMdl *order = [orderMdl initFromDictionary:dic];
        [self.orderList addObject:order];
    }
    
    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
    if (list.count< 1) {
        [self.tableView.mj_footer endRefreshingWithNoMoreData];
    }
    [self.tableView reloadData];
}
- (void)NetWorkingFailedToRequest:(NSError *)error{
    popupV *popupv = [popupV initWithErrorInfo:[error.userInfo objectForKey:@"NSLocalizedDescription"]];
    [self.view addSubview:popupv];
    //popupv.center =CGPointMake(VC_WIDTH/2,);
    [popupv animationPresentAfterTimeInterval:0 AndDelay:4];

    [self.tableView.mj_header endRefreshing];
    [self.tableView.mj_footer endRefreshing];
}

//-(void)tableviewrefresh{
//    [self.tableView reloadData];
//    [self.tableView.mj_header endRefreshing];
//}

#pragma mark ------------------------------------tablevieDelegate
//这里始终是1
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == self.tableView) {
        return 1;
    }else{
        return self.searchResults.count;
    }
}
//section数量
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == self.tableView){
        return self.orderList.count;//自定义这个数
    }else{
        return 1;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 10;
}
//设置footerview高度
- (void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section {view.tintColor = [UIColor clearColor];}

//cell高度
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (tableView == self.tableView) {
//        return [self.tableView fd_heightForCellWithIdentifier:mainBodyIdentifier cacheByIndexPath:indexPath configuration:^(universalCell *cell) {
//            //[self configureCell:cell atIndexPath:indexPath];
//            [cell configureCellWithModel:self.orderList[indexPath.section]];
//        }];
        return [tableView fd_heightForCellWithIdentifier:mainBodyIdentifier configuration:^(id cell) {
            [cell configureCellWithModel:self.orderList[indexPath.section]];
        }];
    }else{
        return tableView.rowHeight;
    }
}

//- (void)configureCell:(universalCell *)cell atIndexPath:(NSIndexPath *)indexPath {
//    cell.fd_enforceFrameLayout = NO; // Enable to use "-sizeThatFits:"
//    [cell updateWithModel:self.orderList[indexPath.section]];
//    //cell.entity = self.feedEntitySections[indexPath.section];
//}

//datasourse
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    universalCell *mainbodyCell = [tableView dequeueReusableCellWithIdentifier:mainBodyIdentifier];
 
    UITableViewCell *resultCell = [tableView dequeueReusableCellWithIdentifier:commonIdentifier];

    if (tableView != self.tableView ) {
        resultCell.textLabel.text = self.searchResults[indexPath.row];
    }
    //mainbodyCell.fd_enforceFrameLayout = NO;
    orderMdl *ordermodel = self.orderList[indexPath.section];
    ordermodel.createtimeBynow = [NSString compareCurrentTime:ordermodel.createtime];
    //NSLog(@"time is:%@",ordermodel.createtimeBynow);
    [mainbodyCell updateWithModel:ordermodel];
    [mainbodyCell addTheGrabOrder:^{
        self.detailvc.type = DETAILTYPEBUTTON;
        [self clearNavigationBarItems];
        [self hideTheTabbar];
        self.detailvc.model = self.orderList[indexPath.section];
        [self.navigationController pushViewController:self.detailvc animated:YES];
    }];
    [mainbodyCell addThePraised:^{
        
    }];
    [mainbodyCell addTheComment:^{
        commentPopVC *commentpopvc = [commentPopVC new];
        commentpopvc.orderModel = ordermodel;
        STPopupController *popupController = [[STPopupController alloc] initWithRootViewController:commentpopvc];
        [popupController presentInViewController:self];

    }];
    return  (tableView == self.tableView) ?  mainbodyCell : resultCell ;
    

}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    self.detailvc.type = DETAILTYPECELL;
    self.detailvc.model = self.orderList[indexPath.section];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [self clearNavigationBarItems];
    [self hideTheTabbar];
    [self.navigationController pushViewController:self.detailvc animated:YES];
}





@end
