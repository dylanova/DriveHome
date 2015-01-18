//
//  ViewController.h
//  DriveHome
//
//  Created by Dylan Porter on 1/17/15.
//  Copyright (c) 2015 Dylan Porter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "GeocodingService.h"
#import <GoogleMaps/GoogleMaps.h>

@interface ViewController : UIViewController <GMSMapViewDelegate> 

//- (IBAction)geocode:(id)sender;

//@property (strong,nonatomic) GeocodingService *gs;

@end

static const CLLocationCoordinate2D jollyville  = {30.382438, -97.744723};
static const CLLocationCoordinate2D home        = {30.173429, -97.805559};
static const CLLocationCoordinate2D Mand360     = {30.251158, -97.806123};
static const CLLocationCoordinate2D MandDavis   = {30.211178, -97.858474};
static const CLLocationCoordinate2D MandSlr     = {30.201138, -97.866746};
static const CLLocationCoordinate2D ManandSlr   = {30.173642, -97.823546};
static const CLLocationCoordinate2D BWand35     = {30.220879, -97.760382};
static const CLLocationCoordinate2D I35andSlr   = {30.167690, -97.786351};