//
//  ViewController.swift
//  mylocationsmap
//
//  Created by Muhammed Essa on 1/19/20.
//  Copyright © 2020 Muhammed Essa. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController , MKMapViewDelegate,CLLocationManagerDelegate{

    @IBOutlet var map: MKMapView!
    var manager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        let myLongPress = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longPress(gestureRecognizer:)))
        myLongPress.minimumPressDuration = 2
        map.addGestureRecognizer(myLongPress)
        
        if isPlacesfound != -1 {
            
            manager.delegate = self
            manager.desiredAccuracy = kCLLocationAccuracyBest
            manager.requestWhenInUseAuthorization()
            manager.stopUpdatingLocation()
            
            if places.count > isPlacesfound{
                if let name = places[isPlacesfound]["name"]{
                if let lat = places[isPlacesfound]["lat"]{
                 if let long = places[isPlacesfound]["long"]{
                if let latitude =  Double(lat) {
                   if let longitude =  Double(long) {
                    let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
                    let coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
                    let region = MKCoordinateRegion(center: coordinate, span: span)
                    self.map.setRegion(region, animated: true)
                    let annotation = MKPointAnnotation()
                    annotation.coordinate = coordinate
                    annotation.title = name
                     self.map.addAnnotation(annotation)
                 }
                               }
                                }
                         }
            }
        }
    }


}
    
    
    @objc func longPress(gestureRecognizer:UIGestureRecognizer){
        if gestureRecognizer.state == UIGestureRecognizer.State.began{
            let touchPoint = gestureRecognizer.location(in: self.map)
            let newCorrdinate = self.map.convert(touchPoint, toCoordinateFrom: self.map)
//            let annotation = MKPointAnnotation()
//            annotation.coordinate = newCorrdinate
//            annotation.title = "New Mark"
//            self.map.addAnnotation(annotation)
            let location = CLLocation(latitude: newCorrdinate.latitude, longitude: newCorrdinate.longitude)
            var title = ""
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                if error != nil {
                    print(error)
                }else{
                    if let placemark = placemarks?[0]{
                        if placemark.subThoroughfare != nil {
                            title += placemark.subThoroughfare! + " "
                        }
                        if placemark.thoroughfare != nil {
                                           title += placemark.thoroughfare! + " "
                          }
                        if title == "" {
                            title = "New location\(NSDate())"
                        }
                        
                        let annotation = MKPointAnnotation()
                        annotation.coordinate = newCorrdinate
                        annotation.title = title
                        self.map.addAnnotation(annotation)
                        places.append(["name"  :title , "lat" :String(newCorrdinate.latitude) , "long": String(newCorrdinate.longitude)])
                        UserDefaults.standard.set(places, forKey: "places")
                        print(places)
                    }
                }
            }
        }
    }
    
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        let location = CLLocationCoordinate2D(latitude: locations[0].coordinate.latitude, longitude: locations[0].coordinate.longitude)
        let span = MKCoordinateSpan(latitudeDelta: 0.05, longitudeDelta: 0.05)
        let region = MKCoordinateRegion(center: location, span: span)
        self.map.setRegion(region, animated: true)
    }
    
    
}
