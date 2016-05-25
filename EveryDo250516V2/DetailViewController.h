//
//  DetailViewController.h
//  EveryDo250516V2
//
//  Created by Yasmin Ahmad on 2016-05-25.
//  Copyright © 2016 YasminA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ToDo.h"

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) ToDo *task; 

@end
