//
//  ViewController.h
//  PathMaker
//
//  Created by Roshan Lamichhane on 4/21/15.
//  Copyright (c) 2015 Vastika. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
@interface ViewController : UIViewController <MKMapViewDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property (strong, nonatomic) CLLocationManager *locationManager;
@property (nonatomic, retain) MKPolyline *routeLine;
@property (nonatomic, retain) MKPolylineRenderer *routeLineView;
@property (nonatomic,retain) NSMutableArray *arrayOfLocation;
@end


