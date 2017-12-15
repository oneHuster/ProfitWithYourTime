//
//  CoreDateManager.m
//  SQLiteTest
//
//  Created by rhljiayou on 14-1-8.
//  Copyright (c) 2014年 rhljiayou. All rights reserved.
//

#import "CoreDateManager.h"

@implementation CoreDateManager

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"UserModel.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

//插入数据
- (void)insertCoreData:(NSMutableArray*)dataArray
{
    NSManagedObjectContext *context = [self managedObjectContext];
    for (orderMdl *order in dataArray) {
        NSManagedObject *cacheOrder = [NSEntityDescription insertNewObjectForEntityForName:TableMessage inManagedObjectContext:context];
        [cacheOrder setValue:[NSNumber numberWithInteger:order.orderId] forKey:@"id"];
        [cacheOrder setValue:[NSNumber numberWithInteger:order.userId] forKey:@"userId"];
        [cacheOrder setValue:order.createtime forKey:@"createTime"];
        [cacheOrder setValue:order.iMgs forKey:@"iMgs"];
        [cacheOrder setValue:order.creator.nickName forKey:@"creatorName"];
        [cacheOrder setValue:order.creator.faviconUrl forKey:@"avatar"];
        [cacheOrder setValue:[NSNumber numberWithInteger:order.statu] forKey:@"statu"];
        NSError *error;
        if(![context save:&error])
        {
            NSLog(@"不能保存：%@",[error localizedDescription]);
        }
    }
}

- (void)addnewAddressWith:(NSDictionary *)dic{
    NSManagedObjectContext *context = [self managedObjectContext];
//    for (orderMdl *order in dataArray) {
        NSManagedObject *cacheOrder = [NSEntityDescription insertNewObjectForEntityForName:TableAddress inManagedObjectContext:context];
        [cacheOrder setValue:dic[@"userName"] forKey:@"userName"];
        [cacheOrder setValue:dic[@"phone"] forKey:@"phone"];
        [cacheOrder setValue:dic[@"isDefault"] forKey:@"isDefault"];
        [cacheOrder setValue:dic[@"province"] forKey:@"province"];
        [cacheOrder setValue:dic[@"city"] forKey:@"city"];
        [cacheOrder setValue:dic[@"district"] forKey:@"district"];
        [cacheOrder setValue:dic[@"address"] forKey:@"address"];
        [cacheOrder setValue:dic[@"id"] forKey:@"id"];
        NSError *error;
        if(![context save:&error])
        {
            NSLog(@"不能保存：%@",[error localizedDescription]);
        }
//    }

}

- (void)insertCitySearchHistory:(NSString *)city{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *cacheCity = [NSEntityDescription insertNewObjectForEntityForName:TableCity inManagedObjectContext:context];
    [cacheCity setValue:city forKey:@"city"];
}

- (void)insertKeyWordSearchHistory:(NSString *)key{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSManagedObject *cacheKey = [NSEntityDescription insertNewObjectForEntityForName:TableKeyword inManagedObjectContext:context];
    [cacheKey setValue:key forKey:@"key"];

}

//查询
- (NSMutableArray*)selectWithGrabOrderMsg
{
    NSManagedObjectContext *context = [self managedObjectContext];
    // 限定查询结果的数量
    //setFetchLimit
    // 查询的偏移量
    //setFetchOffset
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:TableMessage inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (NSManagedObject *cache in fetchedObjects) {
        if ([[cache valueForKey:@"statu"]integerValue]==20020009){
            orderMdl *order = [[orderMdl alloc]init];
            order.creator = [[UserMdl alloc]init];
            order.orderId = [[cache valueForKey:@"id"]integerValue];
            order.userId = [[cache valueForKey:@"userId"]integerValue];
            order.createtime = [cache valueForKey:@"createTime"];
            order.iMgs = [cache valueForKey:@"iMgs"];
            order.creator.nickName = [cache valueForKey:@"creatorName"];
            order.creator.faviconUrl = [cache valueForKey:@"avatar"];
            order.statu = [[cache valueForKey:@"statu"]integerValue];
            [resultArray addObject:order];
        }
    }
    return resultArray;
}
//查询点赞消息
- (NSMutableArray*)selectWithPraiseOrderMsg
{
    NSManagedObjectContext *context = [self managedObjectContext];
    // 限定查询结果的数量
    //setFetchLimit
    // 查询的偏移量
    //setFetchOffset
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:TableMessage inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (NSManagedObject *cache in fetchedObjects) {
        if ([[cache valueForKey:@"statu"]integerValue]==20020006){
            orderMdl *order = [[orderMdl alloc]init];
            order.creator = [[UserMdl alloc]init];
            order.orderId = [[cache valueForKey:@"id"]integerValue];
            order.userId = [[cache valueForKey:@"userId"]integerValue];
            order.createtime = [cache valueForKey:@"createTime"];
            order.iMgs = [cache valueForKey:@"iMgs"];
            order.creator.nickName = [cache valueForKey:@"creatorName"];
            order.creator.faviconUrl = [cache valueForKey:@"avatar"];
            order.statu = [[cache valueForKey:@"statu"]integerValue];
            [resultArray addObject:order];
        }
    }
    return resultArray;
}


//查询城市搜索记录
- (NSMutableArray*)selectWithCityHistory{
    NSManagedObjectContext *context = [self managedObjectContext];
    // 限定查询结果的数量
    //setFetchLimit
    // 查询的偏移量
    //setFetchOffset
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    [fetchRequest setFetchLimit:5];
    NSEntityDescription *entity = [NSEntityDescription entityForName:TableCity inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (NSManagedObject *cache in fetchedObjects) {
        NSString *string = [cache valueForKey:@"city"];
        [resultArray addObject:string];
    }
    return resultArray;

}

- (NSMutableArray*)selectWithKeyWordHitory{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:TableKeyword inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (NSManagedObject *cache in fetchedObjects) {
        NSString *string = [cache valueForKey:@"key"];
        [resultArray addObject:string];
    }
    return resultArray;

}
//查询地址
- (NSArray*)selectWithAddress{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription entityForName:TableAddress inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    NSMutableArray *resultArray = [NSMutableArray array];
    
    for (NSManagedObject *cache in fetchedObjects) {
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                        [cache valueForKey:@"id"],@"id",
                        [cache valueForKey:@"userName"],@"userName",
                        [cache valueForKey:@"phone"],@"phone",
                        [cache valueForKey:@"province"],@"province",
                        [cache valueForKey:@"city"],@"city",
                        [cache valueForKey:@"district"],@"district",
                        [cache valueForKey:@"address"],@"address",
                        [cache valueForKey:@"isDefault"],@"isDefault",nil];
        [resultArray addObject:dic];
    }
    return resultArray;

}
//删除
-(void)deleteDataWithTable:(NSString*)table
{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:table inManagedObjectContext:context];

    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setIncludesPropertyValues:NO];
    [request setEntity:entity];
    NSError *error = nil;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    if (!error && datas && [datas count])
    {
        for (NSManagedObject *obj in datas)
        {
            [context deleteObject:obj];
        }
        if (![context save:&error])
        {
            NSLog(@"error:%@",error);  
        }  
    }
}
//删除一条
- (void)deleteDataWithTable:(NSString *)table andId:(NSString*)index{
    NSManagedObjectContext *context = [self managedObjectContext];
    NSEntityDescription *entity = [NSEntityDescription entityForName:table inManagedObjectContext:context];
    NSPredicate *predicate = [NSPredicate
                              predicateWithFormat:@"id like[cd] %@",index];
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:entity];
    [request setPredicate:predicate];
    
    NSError *error = nil;
    NSArray *datas = [context executeFetchRequest:request error:&error];
    if (!error && datas && [datas count])
    {
        for (NSManagedObject *obj in datas)
        {
            [context deleteObject:obj];
        }
        if (![context save:&error])
        {
            NSLog(@"error:%@",error);
        }
    }

}
//更新
-(void)updateWithModifyAddress:(NSDictionary *)addressDic{
        NSManagedObjectContext *context = [self managedObjectContext];
    //NSLog(@"%@",NSStringFromClass([addressDic[@"id"] class]));
        NSPredicate *predicate = [NSPredicate
                                  predicateWithFormat:@"id like[cd] %@",addressDic[@"id"]];
    
    //    //首先你需要建立一个request
        NSFetchRequest * request = [[NSFetchRequest alloc] init];
        [request setEntity:[NSEntityDescription entityForName:TableAddress inManagedObjectContext:context]];
        [request setPredicate:predicate];
    //
        NSError *error = nil;
        NSArray *result = [context executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
//        for (News *info in result) {
//            info.islook = islook;
//        }
    for (NSManagedObject *cache in result) {

        [cache setValue:addressDic[@"id"] forKey:@"id"];
        [cache setValue:addressDic[@"userName"] forKey:@"userName"];
        [cache setValue:addressDic[@"phone"] forKey:@"phone"];
        [cache setValue:addressDic[@"isDefault"] forKey:@"isDefault"];
        [cache setValue:addressDic[@"province"] forKey:@"province"];
        [cache setValue:addressDic[@"city"] forKey:@"city"];
        [cache setValue:addressDic[@"district"] forKey:@"district"];
        [cache setValue:addressDic[@"address"] forKey:@"address"];
    }

    //    //保存
        if ([context save:&error]) {
            //更新成功
            NSLog(@"更新成功");
        }

}
//- (void)updateData:(NSString*)newsId  withIsLook:(NSString*)islook
//{
//    NSManagedObjectContext *context = [self managedObjectContext];
//
//    NSPredicate *predicate = [NSPredicate
//                              predicateWithFormat:@"newsid like[cd] %@",newsId];
//    
//    //首先你需要建立一个request
//    NSFetchRequest * request = [[NSFetchRequest alloc] init];
//    [request setEntity:[NSEntityDescription entityForName:TableUser inManagedObjectContext:context]];
//    [request setPredicate:predicate];
//    
//    NSError *error = nil;
//    NSArray *result = [context executeFetchRequest:request error:&error];//这里获取到的是一个数组，你需要取出你要更新的那个obj
////    for (News *info in result) {
////        info.islook = islook;
////    }
//    
//    //保存
//    if ([context save:&error]) {
//        //更新成功
//        NSLog(@"更新成功");
//    }
//}
//缓存用户
- (void)updateUser:(NSMutableArray *)dataArray{

    NSManagedObjectContext *context = [self managedObjectContext];
    [self deleteDataWithTable:TableUser];
    for (UserMdl *user in dataArray) {
        NSManagedObject *cacheUser = [NSEntityDescription insertNewObjectForEntityForName:TableUser inManagedObjectContext:context];
        [cacheUser setValue:user.nickName forKey:@"nickName"];
        [cacheUser setValue:user.phone forKey:@"phone"];
        [cacheUser setValue:[NSNumber numberWithInteger:user.age] forKey:@"age"];
        [cacheUser setValue:[NSNumber numberWithInteger:user.userId] forKey:@"userId"];
        [cacheUser setValue:[NSNumber numberWithInteger:user.sex] forKey:@"sex"];
        [cacheUser setValue:user.faviconUrl forKey:@"faviconURL"];
        [cacheUser setValue:user.smallIconUrl forKey:@"smallIconURL"];
        [cacheUser setValue:user.HomePlace forKey:@"HomePlace"];
        [cacheUser setValue:user.myWords forKey:@"mood"];

        NSError *error;
        if(![context save:&error])
        {
            NSLog(@"不能保存：%@",[error localizedDescription]);
        }
    }
}

/*查询当前用户*/
// 限定查询结果的数量
//setFetchLimit
// 查询的偏移量
//setFetchOffset
//UserMdl *user;
- (UserMdl*)queryWithCurrentUser{
    NSManagedObjectContext *context = [self managedObjectContext];
    
    UserMdl *currentUser = [UserMdl getCurrentUserMdl];
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    
    [fetchRequest setFetchLimit:1];
//    [fetchRequest setFetchOffset:1];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:TableUser inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    NSError *error;
    currentUser.nickName = @"未登录";
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    for (NSManagedObject *user in fetchedObjects) {
        currentUser.nickName = [user valueForKey:@"nickName"];
        currentUser.phone  = [user valueForKey:@"phone"];
        currentUser.age = [[user valueForKey:@"age"]integerValue];
        currentUser.userId = [[user valueForKey:@"userId"]integerValue];
        currentUser.sex = [[user valueForKey:@"sex"]integerValue];
        currentUser.faviconUrl = [user valueForKey:@"faviconURL"];
    }
    
    return currentUser;
}
@end
