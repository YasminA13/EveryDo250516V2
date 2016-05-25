//
//  ToDo+CoreDataProperties.h
//  EveryDo250516V2
//
//  Created by Yasmin Ahmad on 2016-05-25.
//  Copyright © 2016 YasminA. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "ToDo.h"

NS_ASSUME_NONNULL_BEGIN

@interface ToDo (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *task;
@property (nullable, nonatomic, retain) NSString *details;
@property (nullable, nonatomic, retain) NSString *priority;

@end

NS_ASSUME_NONNULL_END
