//
//  MapHelper.swift
//  DevBootcamps
//
//  Created by mac on 4/16/16.
//  Copyright © 2016 Mark Price. All rights reserved.
//

import MapKit

class MapHelper {
    static func getAxisLocation(address: String, onSuccess: ((Double, Double)) -> Void) {
        CLGeocoder().geocodeAddressString(address) { (placemarks: [CLPlacemark]?, error: NSError?) -> Void in
            if let marks = placemarks where marks.count > 0 {
                if let loc = marks[0].location {
                    onSuccess((loc.coordinate.latitude, loc.coordinate.longitude))
                }
            }
        }
    }
    
    static func inflateMap(view: UIView, address: String, delegate: MapHelperDelegate) {
        let map = MKMapView()
        map.frame = view.frame
        let locationDistance : CLLocationDistance = 1000
        
        getAxisLocation(address) { (data:(Double, Double)) in
            
            map.delegate = delegate
            
            
            var loc = CLLocationCoordinate2D()
            loc.latitude = data.0
            loc.longitude = data.1
            let ano = BootcampAnnotation(coordinate: loc, title: "title")
            ano.coordinate = CLLocationCoordinate2D(latitude: loc.latitude, longitude: loc.longitude)
            
            map.addAnnotation(ano)
            //var coordinateRegion = MKCoordinateRegionMakeWithDistance(loc, locationDistance, locationDistance)
            let span = MKCoordinateSpanMake(0.05, 0.05)
            let coordinateRegion = MKCoordinateRegion(center: loc, span: span)
            map.setRegion(coordinateRegion, animated: true)
            map.centerCoordinate = ano.coordinate
            //map.setRegion(region, animated: true)
            view.addSubview(map)
        }
        
    }
    
}

class MapHelperDelegate: NSObject, MKMapViewDelegate {
    func mapView(mapView: MKMapView, viewForAnnotation annotation: MKAnnotation) -> MKAnnotationView? {
        print ("bbb")
        if annotation.isKindOfClass(BootcampAnnotation) {
            //var title: String?
            let annoView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "Default")
            annoView.pinTintColor = UIColor.blueColor()
            print ("AAAa")
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
            
            annoView.animatesDrop = true
            
            
            return annoView
            
        } else if annotation.isKindOfClass(MKUserLocation) {
            return nil
        }
        
        return nil
        
    }
    
    func mapView(mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        if control == view.rightCalloutAccessoryView {
            print ("Button right pressed!")
        }else if control == view.leftCalloutAccessoryView {
            print ("Button left pressed!")
        }
    }
    
}
