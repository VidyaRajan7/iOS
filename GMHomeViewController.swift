//
//  GMHomeViewController.swift
//  GoogleMapApplication
//
//  Created by Mobile Technology on 28/12/16.
//  Copyright © 2016 Mobile Technology. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import GooglePlacePicker
class GMHomeViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate {

    
    @IBOutlet weak var GMView: UIView!
   
    let locationManager = CLLocationManager()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        
        // Ask for Authorisation from the User.
        
        self.locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()

        locationManager.delegate = self

        var arrayd = NSMutableArray()
        let dict1 = NSMutableDictionary()
        dict1.setValue(9.0, forKey: "latituede")
         dict1.setValue(76.7809, forKey: "longitude")
        dict1.setValue("Kerala", forKey: "snippet")
        dict1.setValue("Kollam", forKey: "title")
        arrayd.add(dict1)
        
         let dict2 = NSMutableDictionary()
        dict2.setValue(9.4, forKey: "latituede")
        dict2.setValue(76.50, forKey: "longitude")
        dict2.setValue("Kerala", forKey: "snippet")
        dict2.setValue("Alappuzha", forKey: "title")
        arrayd.add(dict2)
        
        let dict3 = NSMutableDictionary()
        dict3.setValue(9.60, forKey: "latituede")
        dict3.setValue(76.88, forKey: "longitude")
        dict3.setValue("Kerala", forKey: "snippet")
        dict3.setValue("Kottayam", forKey: "title")
        arrayd.add(dict3)
        
        print(arrayd)
        print((arrayd[1] as AnyObject).value(forKey: "latituede"))
        self.loadMapView(latLongArray: arrayd )

    }
   
    func loadMapView(latLongArray : NSMutableArray)
    {
        
        // Create a GMSCameraPosition that tells the map to display the
        // coordinate -33.86,151.20 at zoom level 6.
        let camera = GMSCameraPosition.camera(withLatitude:  (latLongArray[1] as AnyObject).value(forKey: "latituede") as! CLLocationDegrees, longitude:  (latLongArray[1] as AnyObject).value(forKey: "longitude") as! CLLocationDegrees, zoom: 8.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
         view = mapView
        

        for  i in 1...latLongArray.count-1
        {
            let marker = GMSMarker()
            marker.position = CLLocationCoordinate2D(latitude: (latLongArray[i] as AnyObject).value(forKey: "latituede") as! CLLocationDegrees, longitude: (latLongArray[i] as AnyObject).value(forKey: "longitude")as! CLLocationDegrees)
            marker.title = (latLongArray[i] as AnyObject).value(forKey: "title") as! String
            marker.snippet = (latLongArray[i] as AnyObject).value(forKey: "snippet") as! String
            marker.map = mapView
          
            
        }
        

    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    
        if let location = locations.first {
            let locValue:CLLocationCoordinate2D = manager.location!.coordinate
            //setting user location
            let camera = GMSCameraPosition.camera(withTarget: locValue, zoom: 15.0)
            let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            
            mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
            
            locationManager.stopUpdatingLocation()
        }

    }
  
}
