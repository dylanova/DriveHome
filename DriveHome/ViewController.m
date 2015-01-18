//
//  ViewController.m
//  DriveHome
//
//  Created by Dylan Porter on 1/17/15.
//  Copyright (c) 2015 Dylan Porter. All rights reserved.
//

#import "ViewController.h"
#import "DirectionService.h"

@interface ViewController () {
    GMSMapView *mapView_;
    NSMutableArray *waypoints_;
    NSMutableArray *waypointStrings_;
}

@end

@implementation ViewController

//@synthesize gs;

- (void)loadView {
    //gs = [[GeocodingService alloc] init];
    waypoints_ = [[NSMutableArray alloc]init];
    waypointStrings_ = [[NSMutableArray alloc]init];
    
    // Create a GMSCameraPosition that tells the map to display the
    // coordinate -33.86,151.20 at zoom level 6.
    GMSCameraPosition *camera = [GMSCameraPosition cameraWithLatitude:30.2861
                                                            longitude:-97.7394
                                                                 zoom:10.9];
    mapView_ = [GMSMapView mapWithFrame:CGRectZero camera:camera];
    mapView_.delegate = self;
    mapView_.myLocationEnabled = YES;
    mapView_.trafficEnabled = YES;
    self.view = mapView_;
    
    [self calculateMopacTo290To35];
    
    // Creates a marker in the center of the map.
    //GMSMarker *marker = [[GMSMarker alloc] init];
    //marker.position = CLLocationCoordinate2DMake(-33.86, 151.20);
    //marker.title = @"Sydney";
    //marker.snippet = @"Australia";
    //marker.map = mapView_;
}



- (void)calculateMopacTo290To35
{
    GMSMarker *marker = [GMSMarker markerWithPosition:jollyville];
    marker.map = mapView_;
    [waypoints_ addObject:marker];
    NSString *positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                jollyville.latitude,jollyville.longitude];
    [waypointStrings_ addObject:positionString];
    
    marker = [GMSMarker markerWithPosition:Mand360];
    marker.map = mapView_;
    [waypoints_ addObject:marker];
    positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                Mand360.latitude,Mand360.longitude];
    [waypointStrings_ addObject:positionString];
    
    marker = [GMSMarker markerWithPosition:BWand35];
    marker.map = mapView_;
    [waypoints_ addObject:marker];
    positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                BWand35.latitude,BWand35.longitude];
    [waypointStrings_ addObject:positionString];
    
    marker = [GMSMarker markerWithPosition:I35andSlr];
    marker.map = mapView_;
    [waypoints_ addObject:marker];
    positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                I35andSlr.latitude,I35andSlr.longitude];
    [waypointStrings_ addObject:positionString];
    
    marker = [GMSMarker markerWithPosition:home];
    marker.map = mapView_;
    [waypoints_ addObject:marker];
    positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                home.latitude,home.longitude];
    [waypointStrings_ addObject:positionString];
    
    NSString *sensor = @"false";
    NSArray *parameters = [NSArray arrayWithObjects:sensor, waypointStrings_, nil];
    NSArray *keys = [NSArray arrayWithObjects:@"sensor", @"waypoints", nil];
    NSDictionary *query = [NSDictionary dictionaryWithObjects:parameters
                                                      forKeys:keys];
    DirectionService *mds=[[DirectionService alloc] init];
    SEL selector = @selector(addDirections:);
    [mds setDirectionsQuery:query
               withSelector:selector
               withDelegate:self];
}

- (void)mapView:(GMSMapView *)mapView didTapAtCoordinate:
                (CLLocationCoordinate2D)coordinate {
    
    CLLocationCoordinate2D position = CLLocationCoordinate2DMake(
                                                                 coordinate.latitude,
                                                                 coordinate.longitude);
    GMSMarker *marker = [GMSMarker markerWithPosition:position];
    marker.map = mapView_;
    [waypoints_ addObject:marker];
    NSString *positionString = [[NSString alloc] initWithFormat:@"%f,%f",
                                coordinate.latitude,coordinate.longitude];
    [waypointStrings_ addObject:positionString];
    if([waypoints_ count]>1){
        NSString *sensor = @"false";
        NSArray *parameters = [NSArray arrayWithObjects:sensor, waypointStrings_,
                               nil];
        NSArray *keys = [NSArray arrayWithObjects:@"sensor", @"waypoints", nil];
        NSDictionary *query = [NSDictionary dictionaryWithObjects:parameters
                                                          forKeys:keys];
        DirectionService *mds=[[DirectionService alloc] init];
        SEL selector = @selector(addDirections:);
        [mds setDirectionsQuery:query
                   withSelector:selector
                   withDelegate:self];
    }
}

- (void)addDirections:(NSDictionary *)json {
    
    NSDictionary *routes = [json objectForKey:@"routes"][0];
    
    NSDictionary *route = [routes objectForKey:@"overview_polyline"];
    NSString *overview_route = [route objectForKey:@"points"];
    GMSPath *path = [GMSPath pathFromEncodedPath:overview_route];
    GMSPolyline *polyline = [GMSPolyline polylineWithPath:path];
    polyline.map = mapView_;
    
    for ( int i = 0; i < waypoints_.count - 1; i ++ )
    {
        NSDictionary *legs = [routes objectForKey:@"legs"][i];
        
        NSDictionary *duration = [legs objectForKey:@"duration"];
        NSString *duration_text = [duration objectForKey:@"text"];
        UILabel *label =  [[UILabel alloc] initWithFrame: CGRectMake(0, 0+50*i, 200, 50)];
        label.text = [NSString stringWithFormat:@"Duration: %@", duration_text];
        [self.view addSubview:label];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (IBAction)geocode:(id)sender {
//    [addressField resignFirstResponder];
//    SEL sel = @selector(addMarker);
//    //[self performSelector:@selector(addMarker)];
//
//    NSLog(@"%@",NSStringFromSelector(sel));
//    [gs geocodeAddress:addressField.text withCallback:@selector(addMarker) withDelegate:self];
//}

//- (void)addMarker{
//    
//    double lat = [[gs.geocode objectForKey:@"lat"] doubleValue];
//    double lng = [[gs.geocode objectForKey:@"lng"] doubleValue];
//    
//    GMSMarker *marker = [[GMSMarker alloc] init];
//    CLLocationCoordinate2D geolocation = CLLocationCoordinate2DMake(lat,lng);
//    marker.position = geolocation;
//    marker.title = [gs.geocode objectForKey:@"address"];
//    
//    marker.map = mapView_;
//    
//    GMSCameraUpdate *geoLocateCam = [GMSCameraUpdate setTarget:geolocation zoom:10.0];
//    [mapView_ animateWithCameraUpdate:geoLocateCam];
//    
//}

@end
