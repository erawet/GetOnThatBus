//
//  ViewController.m
//  GetOnThatBus
//
//  Created by Don Wettasinghe on 1/23/15.
//  Copyright (c) 2015 Don Wettasinghe. All rights reserved.
//

#import "ViewController.h"
#import <MapKit/MapKit.h>
#import "BusAnnotation.h"
#import "DetailStopViewController.h"


@interface ViewController ()<MKMapViewDelegate, UITableViewDataSource, UITableViewDelegate>

@property NSMutableArray *busStops;
@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property BusAnnotation *selectStop;
@property (weak, nonatomic) IBOutlet UISegmentedControl *viewSelection;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.busStops = [NSMutableArray new];
    
    NSURL *url=[NSURL URLWithString:@"https://s3.amazonaws.com/mobile-makers-lib/bus.json"];
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        
        NSDictionary *busStopList=[NSJSONSerialization JSONObjectWithData:data
                                                                  options:NSJSONReadingAllowFragments
                                                                    error:&connectionError];
        
        self.busStops=[busStopList objectForKey:@"row"];
        [self setBusStops];

        NSLog(@"Bus: %@", self.busStops);
       [self.mapView showAnnotations:self.mapView.annotations animated:YES];
        [self.tableView reloadData];
    }];
    
    self.mapView.showsUserLocation=YES;

}

- (IBAction)onTapSegmentedControl:(UISegmentedControl *)sender {
    
    if (self.viewSelection.selectedSegmentIndex==0 ) {
        self.tableView.hidden=YES;
        self.mapView.hidden=NO;
    }else{
        self.tableView.hidden=NO;
        self.mapView.hidden=YES;
       
    }
    
}

-(void)setBusStops{
    
    for (NSDictionary *busStopData in self.busStops ) {
    
        BusAnnotation *busAnnotation=[[BusAnnotation alloc]init];
        
        busAnnotation.name = [busStopData objectForKey:@"cta_stop_name"];
        busAnnotation.longitute = [busStopData objectForKey:@"longitude"];
        busAnnotation.latitude = [busStopData objectForKey:@"latitude"];
        busAnnotation.routes = [busStopData objectForKey:@"routes"];
        busAnnotation.modalTransfer = [busStopData objectForKey:@"inter_modal"];
        busAnnotation.address = [busStopData objectForKey:@"_address"];
        
        
        double checkLong = [busAnnotation.longitute doubleValue];
        if (checkLong > 0) {
            NSString *newLong = [NSString stringWithFormat:@"-%@", busAnnotation.longitute];
            busAnnotation.longitute = newLong;
        }
        
        CGFloat longitute = (CGFloat)[busAnnotation.longitute floatValue];
        CGFloat latitude = (CGFloat)[busAnnotation.latitude floatValue];
        
        busAnnotation.title=busAnnotation.name;
        busAnnotation.subtitle=busAnnotation.routes;
        busAnnotation.coordinate=CLLocationCoordinate2DMake(latitude, longitute);
        [self.mapView addAnnotation:busAnnotation];
        
    }
   

}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"Cell"];
    BusAnnotation *bus=[self.mapView.annotations objectAtIndex:indexPath.row];
    cell.textLabel.text=bus.name;
    
    
    return cell;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.busStops.count;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
   
    BusAnnotation *bus=[self.mapView.annotations objectAtIndex:indexPath.row];
    self.selectStop=bus;
    // [self performSegueWithIdentifier:@"ShowBusStop" sender:self];
    
    
}


-(void)mapView:(MKMapView *)mapView annotationView:(MKAnnotationView *)view calloutAccessoryControlTapped:(UIControl *)control{
    
    BusAnnotation *bus = view.annotation;
    self.selectStop = bus;
    [self performSegueWithIdentifier:@"ShowBusStop" sender:self];
    
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    DetailStopViewController *detVC=[segue destinationViewController];
    detVC.busStops=self.selectStop;
    
}

-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation{
    
    if (annotation == mapView.userLocation) {
        return nil;
    }
    
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:nil];
    pin.canShowCallout = YES;
    pin.rightCalloutAccessoryView = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
    
    
    BusAnnotation *busAnnot=[[BusAnnotation alloc]init];
    
    for (BusAnnotation *bus in self.mapView.annotations) {
    
        if ([bus.title isEqualToString:annotation.title]) {
            busAnnot = bus;
        }
    }
    
    
      if (busAnnot.modalTransfer != nil) {
        if ([busAnnot.modalTransfer isEqualToString:@"Metra"] ) {
            pin.pinColor=MKPinAnnotationColorGreen;
        }else{
            pin.pinColor=MKPinAnnotationColorPurple;
        }
      }
    
    return pin;
}





@end
