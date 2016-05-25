//
//  DetailViewController.m
//  EveryDo250516V2
//
//  Created by Yasmin Ahmad on 2016-05-25.
//  Copyright © 2016 YasminA. All rights reserved.
//

#import "DetailViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.task) {
        self.detailLabel.text = self.task.details;
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
