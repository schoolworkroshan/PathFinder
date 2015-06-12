//
//  ViewController.m
//  PathMaker
//
//  Created by Roshan Lamichhane on 4/21/15.
//  Copyright (c) 2015 Vastika. All rights reserved.
//
#import "ViewController.h"

@interface ViewController ()
{
    NSMutableArray *distanceFromInitialPointDestination;
    CLLocation *coordinate;
    NSMutableArray *valueArray;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    [self initializeLocation];
    //[self arrayofLocs];
    //Create Map Area
    self.locationManager = [[CLLocationManager alloc] init];
    
    self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
    // Code to check if the app can respond to the new selector found in iOS 8. If so, request it.
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
    //[self distanceBetweenMultipleLocations];
   //[self distanceBetweenTwoPoints];
    [self distanceBetweenPointsClockwise];
    [self distanceBetweenPointsAntiClockwise];
    [self calculateShortestDistance];
    [self calculateShortestDistanceToCoordinate];
    [self indexFinder];
    [self shortestdistanceToStation];
    //Copying the coordinate for the shortest distance from the user to the specific location in the track/path/loop
   // coordinate = [self calculateShortestDistanceToCoordinate];
    MKCoordinateRegion region;
    region.center.latitude=32.860717;
    region.center.longitude=-96.990722;
    region.span.latitudeDelta= 0.5f;
    region.span.longitudeDelta  = 0.5f;
    
    //CLLocationCoordinate2D coordinate[3] = [
    
    
    CLLocationCoordinate2D *coordinateArray
    = malloc(sizeof(CLLocationCoordinate2D) * valueArray.count);
    
    int caIndex = 0;
    for (CLLocation *loc in valueArray) {
        coordinateArray[caIndex] = loc.coordinate;
        caIndex++;
    }
    
    
//    CLLocationCoordinate2D coordinates[18] = {{32.860717, -96.990722}, {32.860754, -96.990715},
//        {32.860812, -96.990710},{32.860877, -96.990713}, {32.860914, -96.990697},
//        {32.860917, -96.990610},{32.860912, -96.990504}, {32.860909, -96.990370}, {32.860908, -96.990223},
//        {32.860896, -96.990108}, {32.860841, -96.990101}, {32.860779, -96.990102},
//        {32.860706, -96.990105}, {32.860665, -96.990110}, {32.860680, -96.990333} ,
//        {32.860685, -96.990530}, {32.860695, -96.990679}, {32.860709, -96.990717}};
//    
    //CLLocationCoordinate2D values = CLLocationCoordinate2DMake(32.860717, -96.990722);
    

    [self.mapView setRegion:region animated:YES];//
        _routeLine= [MKPolyline polylineWithCoordinates:coordinateArray count:[valueArray count]];

        free(coordinateArray);
    self.mapView.mapType = MKMapTypeStandard;
    [self.mapView addOverlay:_routeLine];//
    [self.mapView setVisibleMapRect:_routeLine.boundingMapRect];
    //NSMutableArray *locations = [[NSMutableArray alloc]initWithArray:(__bridge NSArray *)(coordinates)];
    MKPointAnnotation *annotation1 = [[MKPointAnnotation alloc]init];
    NSMutableArray *array = [[NSMutableArray alloc]init];
    MKPointAnnotation *annotation2 = [[MKPointAnnotation alloc]init];
    annotation1.coordinate=CLLocationCoordinate2DMake(32.860812, -96.990710);
    [array addObject:annotation1];
    MKPointAnnotation *annotation3 = [[MKPointAnnotation alloc]init];
    annotation3.coordinate=CLLocationCoordinate2DMake(32.860914, -96.990697);
    [array addObject:annotation3];
    annotation2.coordinate = CLLocationCoordinate2DMake(32.860841, -96.990101);
    [array addObject:annotation2];
    [self.mapView addAnnotations:array];
    _arrayofAnnotation = [[NSMutableArray alloc]init];
    [_arrayofAnnotation addObjectsFromArray:array];
    
    
    
}




- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"pin"];
    if(annotation == [_arrayofAnnotation objectAtIndex:1]) {
        pin.pinColor = MKPinAnnotationColorGreen;
        
    }
    else {
        pin.pinColor = MKPinAnnotationColorRed;
        
    }
    return pin;
    
}
 
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(MKOverlayRenderer *) mapView:(MKMapView *)mapView rendererForOverlay:(id<MKOverlay>)overlay {
    
    _routeLineView = [[MKPolylineRenderer alloc]initWithPolyline:_routeLine];
    _routeLineView.strokeColor = [UIColor purpleColor];
    _routeLineView.lineWidth= 5;
    
    return _routeLineView;
}

//-(float) distanceBetweenTwoPoints {
//    CLLocationDistance distance =0.0;
//    NSMutableArray *arrayofLocation = [self arrayofLocs];
//    int i;
//    for (i=1; i<10; i++) {
//        //NSLog(@"%@",arrayofLocation[i]);
//        distance += [arrayofLocation[i] distanceFromLocation:arrayofLocation[i+1]];
//     //   NSLog(@"%f",distance);
//    }
//    
//   // NSLog(@"%f",distance);
//    float finalDistance;
//    finalDistance= distance;
//    return finalDistance;
//}

//
//-(float) distanceBetweenPoints {
//    CLLocationDistance distance =0.0;
//    NSMutableArray *arrayofLocation = [self arrayofLocs];
//    int i;
//    for (i=10; i<18; i++) {
//        //NSLog(@"%@",arrayofLocation[i]);
//        //NSLog(@"%f",distance);
//        //NSLog(@"%d",i);
//        if(i==17) {
//            distance += [arrayofLocation[i] distanceFromLocation:arrayofLocation[0]];
//            i=-1;
//        }else{
//            distance += [arrayofLocation[i] distanceFromLocation:arrayofLocation[i+1]];
//        }
//        if(i==1){
//            break;
//    }
//    }
//  //  NSLog(@"%f",distance);
//    //NSLog(@"%f",distance);
//    float finalDistance;
//    finalDistance= distance;
//    return finalDistance;
//}
//

//Find shortest distance in anticlockwise direction
-(float) distanceBetweenPointsAntiClockwise {
    CLLocationDistance distance =0.0;
    NSMutableArray *arrayofLocation = [self arrayofLocs];
    int i;
    int position;
    position = [self indexFinder];
    for (i=position; i>=0; i--) {
        //NSLog(@"%@",arrayofLocation[i]);
        //NSLog(@"%f",distance);
        //NSLog(@"%d",i);
        if(i==0) {
            distance += [arrayofLocation[i] distanceFromLocation:arrayofLocation[17]];
            // NSLog(@"%d  location",i);
            i=18;
        }
        else if(i==(position+1))
        {
            distance += [arrayofLocation[i] distanceFromLocation:arrayofLocation[i+1]];
          //  NSLog(@"%d 5 location",i);
            break;
        }
        
        else if (i==1)  {
            break;
        }
        else if(i==10) {
            break;
        }
         else
        {
            distance += [arrayofLocation[i] distanceFromLocation:arrayofLocation[i-1]];
          //  NSLog(@"%d",i);
            
        }
    }
    
   // NSLog(@"%f",distance);
    //NSLog(@"%f",distance);
    float finalDistance;
    finalDistance= distance;
    return finalDistance;
}

//Find the shortest station to clockwise direction
-(float) distanceBetweenPointsClockwise {
    CLLocationDistance distance =0.0;
    NSMutableArray *arrayofLocation = [self arrayofLocs];
    int i;
    int position;
    position = [self indexFinder];
    for (i=position; i<18; i++) {
        //NSLog(@"%@",arrayofLocation[i]);
        //NSLog(@"%f",distance);
        //NSLog(@"%d",i);
        if(i==17) {
            distance += [arrayofLocation[i] distanceFromLocation:arrayofLocation[0]];
      //      NSLog(@"%d",i);
            i=-1;
        }
        else if(i==(position-1))
        {
             distance += [arrayofLocation[i] distanceFromLocation:arrayofLocation[i+1]];
         //   NSLog(@"%d 3rd location",i);
            break;
        }
//        else if(i==1) {
//            break;
//        }
//        else if(i==10) {
//            break;
//        }
        else
        {
        distance += [arrayofLocation[i] distanceFromLocation:arrayofLocation[i+1]];
           // NSLog(@"%d",i);
         
        }
    }
  
  //    NSLog(@"%f",distance);
    //NSLog(@"%f",distance);
    float finalDistance;
    finalDistance= distance;
    return finalDistance;
}


- (void) initializeLocation{
    valueArray = [[NSMutableArray alloc]init];
    [valueArray addObject:[[CLLocation alloc] initWithLatitude:32.860717 longitude:-96.990722]];
    [valueArray addObject:[[CLLocation alloc] initWithLatitude:32.860754 longitude:-96.990715]];
    [valueArray addObject:[[CLLocation alloc] initWithLatitude:32.860812 longitude: -96.990710]];
    [valueArray addObject:[[CLLocation alloc] initWithLatitude:32.860877 longitude: -96.990713]];
    [valueArray addObject:[[CLLocation alloc] initWithLatitude:32.860914 longitude: -96.990697]];
    [valueArray addObject:[[CLLocation alloc] initWithLatitude:32.860917 longitude:-96.990610]];
    [valueArray addObject:[[CLLocation alloc] initWithLatitude:32.860912 longitude: -96.990504]];
    [valueArray addObject:[[CLLocation alloc] initWithLatitude:32.860909 longitude: -96.990370]];
    [valueArray addObject:[[CLLocation alloc] initWithLatitude:32.860908 longitude: -96.990223]];
    [valueArray addObject:[[CLLocation alloc] initWithLatitude:32.860896 longitude: -96.990108]];
    [valueArray addObject:[[CLLocation alloc] initWithLatitude:32.860841 longitude: -96.990101]];
    [valueArray addObject:[[CLLocation alloc] initWithLatitude:32.860779 longitude:-96.990102]];
    [valueArray addObject:[[CLLocation alloc] initWithLatitude:32.860706 longitude:-96.990105]];
    [valueArray addObject:[[CLLocation alloc] initWithLatitude:32.860665 longitude:-96.990110]];
    [valueArray addObject:[[CLLocation alloc] initWithLatitude:32.860680 longitude:-96.990333]];
    [valueArray addObject:[[CLLocation alloc] initWithLatitude:32.860685 longitude:-96.990530]];
    [valueArray addObject:[[CLLocation alloc] initWithLatitude:32.860695 longitude:-96.990679]];
    [valueArray addObject:[[CLLocation alloc] initWithLatitude:32.860709 longitude:-96.990717]];

}

-(NSMutableArray *) arrayofLocs {
    
    return valueArray;
}


//Compare the values in arrayofLocs to the position of the user
-(CLLocation *) calculateShortestDistanceToCoordinate {
   NSMutableArray *arrayOfLocation = [self arrayofLocs];
    CLLocation *updatedLocation;
    float shortestDistance=1000;
    CLLocation *locu;
    CLLocation *givenCoordinate = [[CLLocation alloc] initWithLatitude:32.860620 longitude:-96.990295];
    float distance;
    int i;
    for (i=0; i<arrayOfLocation.count; i++) {
        distance = [arrayOfLocation[i] distanceFromLocation:givenCoordinate];
        if(shortestDistance > distance)
        {
            shortestDistance=distance;
            updatedLocation=arrayOfLocation[i];
            
        }
      // NSLog(@"%f",shortestDistance);
       
    }
   //  NSLog(@"%f %f",updatedLocation.coordinate.latitude, updatedLocation.coordinate.longitude);
    
    locu  = updatedLocation;
    return locu;
}

//Compare the values in arrayofLocs to the position of the user
-(float) calculateShortestDistanceToUser {
    NSMutableArray *arrayOfLocation = [self arrayofLocs];
    CLLocation *updatedLocation;
    float shortestDistance=1000;
    float locudistance;
    CLLocation *givenCoordinate = [[CLLocation alloc] initWithLatitude:32.860620 longitude:-96.990295];
    float distance;
    int i;
    for (i=0; i<arrayOfLocation.count; i++) {
        distance = [arrayOfLocation[i] distanceFromLocation:givenCoordinate];
        if(shortestDistance > distance)
        {
            shortestDistance=distance;
            updatedLocation=arrayOfLocation[i];
            
        }
        // NSLog(@"%f",shortestDistance);
        
    }
    //  NSLog(@"%f %f",updatedLocation.coordinate.latitude, updatedLocation.coordinate.longitude);
    
    locudistance  = shortestDistance;
    return locudistance;
}

-(float) indexFinder {
    float  finder;
    NSMutableArray *arrayCoordinates = [self arrayofLocs];
    float distance;
    //CLLocation *lat = arrayCoordinates.
   // NSLog(@"%@",arrayCoordinates);
  //  CLLocation *updatedLocation;
    
    CLLocation *coord ;
    coord = [self calculateShortestDistanceToCoordinate];
     int i;
   // int indexOftheDesignatedCoordinate;
    for (i=0; i<arrayCoordinates.count; i++) {
        distance = [arrayCoordinates[i] distanceFromLocation:coord];
        if(distance==0){
            //NSLog(@"%d is the index of the coordinate we want to locate ",i);
            break;
        }
        
            //break;
        
    }
    
        finder= i;
    
   // NSLog(@"%d here",indexOftheDesignatedCoordinate);
    
    return finder;
}
//Find the shortest distanced station
-(float) calculateShortestDistance {
    float value;
   if( [self distanceBetweenPointsClockwise ] < [self distanceBetweenPointsAntiClockwise] ){
       NSLog(@"shortest distance is %f", [self distanceBetweenPointsClockwise]);
       value = [self distanceBetweenPointsClockwise];
    }
    else{
        NSLog(@"shortest distance is %f", [self distanceBetweenPointsAntiClockwise]);
        value= [self distanceBetweenPointsAntiClockwise];
    }
    
    return value;
}


//Shortest distance to a station including the current user's position to

-(float) shortestdistanceToStation   {
    float dist;
    
    dist = [self calculateShortestDistance] + [self calculateShortestDistanceToUser];
    NSLog(@"shortest distance from the user's position %f",dist);
    return dist;
    
}
@end
