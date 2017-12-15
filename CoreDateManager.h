//
//  CoreDateManager.h
//  SQLiteTest
//
//  Created by rhljiayou on 14-1-8.
//  Copyright (c) 2014年 rhljiayou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UserMdl.h"
#import "orderMdl.h"
#import "addressMdl.h"
#define TableUser @"User"
#define TableMessage @"Message"
#define TableCity @"City"
#define TableKeyword @"Keyword"
#define TableAddress @"Address"

@interface CoreDateManager : NSObject

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

//插入数据
- (void)insertCoreData:(NSMutableArray*)dataArray;
- (void)addnewAddressWith:(NSDictionary*)dic;

- (void)insertCitySearchHistory:(NSString*)city;
- (void)insertKeyWordSearchHistory:(NSString*)key;
//查询
//- (NSMutableArray*)selectData:(int)pageSize andOffset:(int)currentPage;
- (NSMutableArray*)selectWithGrabOrderMsg;
- (NSMutableArray*)selectWithPraiseOrderMsg;
- (NSMutableArray*)selectWithCommentOrderMsg;

- (NSMutableArray*)selectWithCityHistory;
- (NSMutableArray*)selectWithKeyWordHitory;
//查询地址
- (NSArray*)selectWithAddress;
//- (NSMutableArray*)queryWithAddress;
//删除
-(void)deleteDataWithTable:(NSString*)table;
//删除一条
- (void)deleteDataWithTable:(NSString *)table andId:(NSString*)index;
//更新
- (void)updateWithModifyAddress:(NSDictionary*)addressDic;

//缓存用户
- (void)updateUser:(NSMutableArray*)dataArray;
//从缓存中查询当前用户
- (UserMdl*)queryWithCurrentUser;
@end
