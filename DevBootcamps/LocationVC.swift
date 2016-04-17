//
//  SecondViewController.swift
//  DevBootcamps
//
//  Created by Mark Price on 12/30/15.
//  Copyright © 2015 Mark Price. All rights reserved.
//

import UIKit
import MapKit



class LocationVC: UIViewController, UITableViewDelegate, UITableViewDataSource, MKMapViewDelegate {
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var map: MKMapView!
    
    var flat = true
    let regionRadius: CLLocationDistance = 2000
    
    let locationManager = CLLocationManager()
    
    //Lets pretend we downloaded these from the server
    let addresses = [
        "268 ly thuong kiet, phuong 14, quan 10"
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        map.delegate = self
        tableView.delegate = self
        tableView.dataSource = self
        
        for add in addresses {
            getPlacemarkFromAddress(add)
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        locationAuthStatus()
    }

    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func locationAuthStatus() {
        if CLLocationManager.authorizationStatus() == .AuthorizedWhenInUse {
            map.showsUserLocation = true
        } else {
            locationManager.requestWhenInUseAuthorization()
        }
    }
    
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(location.coordinate, regionRadius * 2, regionRadius * 2)
        
        map.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(mapView: MKMapView, didUpdateUserLocation userLocation: MKUserLocation) {
        if flat {
            if let loc = userLocation.location {
                centerMapOnLocation(loc)
                //returnLocation = loc
            }
            flat = false
        }
        
        
    }
    
    
    
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        
        if annotation.isKindOfClass(BootcampAnnotation) {
            //var title: String?
            let annoView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Default")
            annoView.pinTintColor = UIColor.blueColor()
            annoView.canShowCallout = true
            annoView.leftCalloutAccessoryView = UIImageView(frame: CGRect(x:0, y:0, width: 50, height:50))
            
            // resize the image
            let imageView = annoView.leftCalloutAccessoryView as! UIImageView
            
            imageView.layer.borderColor = UIColor.whiteColor().CGColor
            imageView.layer.borderWidth = 3.0
            imageView.contentMode = UIViewContentMode.ScaleAspectFill
            
            imageView.image = UIImage(named: "phongtro")
            
            UIGraphicsBeginImageContext(imageView.frame.size)
            imageView.layer.renderInContext(UIGraphicsGetCurrentContext()!)
            var thumbnail = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
//xx
            
            //Add button 
            annoView.rightCalloutAccessoryView = UIButton(type: .DetailDisclosure) as UIView
            
            //centerMapOnLocation(CLLocation(coder: annotation))
            
            annoView.animatesDrop = true
            
            
            return annoView
            
        } else if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        return nil
        
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            self.performSegueWithIdentifier("fullImageSegue", sender: nil)
            print ("Button right pressed!")
        }else if control == view.leftCalloutAccessoryView {
            print ("Button left pressed!")
        }
    }
    
    func createAnnotationForLocation(location: CLLocation) {
        let bootcamp = BootcampAnnotation(coordinate: location.coordinate, title: "title")
        map.addAnnotation(bootcamp)
    }
    
    func getPlacemarkFromAddress(address: String) {
        CLGeocoder().geocodeAddressString(address) { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if let marks = placemarks where marks.count > 0 {
                if let loc = marks[0].location {
                    //We have a valid location with coordinates
                    self.createAnnotationForLocation(loc)
                }
            }
        }
    }
    
    
    
}















