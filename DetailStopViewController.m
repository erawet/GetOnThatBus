//
//  DetailStopViewController.m
//  GetOnThatBus
//
//  Created by Don Wettasinghe on 1/25/15.
//  Copyright (c) 2015 Don Wettasinghe. All rights reserved.
//

#import "DetailStopViewController.h"

@interface DetailStopViewController ()
@property (weak, nonatomic) IBOutlet UILabel *route;
@property (weak, nonatomic) IBOutlet UILabel *address;
@property (weak, nonatomic) IBOutlet UILabel *pace;

@end

@implementation DetailStopViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.title=self.busStops.name;
    self.address.text=self.busStops.address;
    self.pace.text=self.busStops.modalTransfer;
    self.route.text=self.busStops.routes;
    
}

@end
