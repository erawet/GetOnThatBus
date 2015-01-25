//
//  BusAnnotation.h
//  GetOnThatBus
//
//  Created by Don Wettasinghe on 1/25/15.
//  Copyright (c) 2015 Don Wettasinghe. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface BusAnnotation : MKPointAnnotation

@property NSString *name;
@property NSString *routes;
@property NSString *longitute;
@property NSString *latitude;
@property NSString *modalTransfer;
@property NSString *address;

@end
