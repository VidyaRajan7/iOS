//
//  HomeViewController.swift
//  NearestplacesGoogleMap
//
//  Created by Vidya R on 13/12/17.
//  Copyright © 2017 Vidya R. All rights reserved.
//
/*
1. Reference: https://developers.google.com/places/web-service/get-api-key
2. Add Google Maps SDK for iOS, Google Places API Web Service, Google Places API for iOS, Google +API in google console in Dshborad.Add
 
 3. add API Key for iOS apps and, API for IP addresses in credentials page
     ie, open credentials -> click create credentials -> Select API Key -> click "RESTRICT KEY" -> select iOS apps -> enter BUndle id - > save
 
 
 open credentials -> click create credentials -> Select API Key -> click "RESTRICT KEY" -> select IP addresses -> enter ip address - > save
 */
import UIKit
import GoogleMaps

class HomeViewController: UIViewController,CLLocationManagerDelegate,GMSMapViewDelegate {

    let locationManager = CLLocationManager()
    let apiServerKey = "AIzaSyA4krMWV2kTWvnRrOXErfhPc8_wNixxTus"
    var resultsArray = NSMutableArray()
    @IBOutlet weak var gmpView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setLocationSetup()
        
    }

    func setLocationSetup()
    {
        self.locationManager.delegate = self
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
    }
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
                if let location = locations.first {
                    let locValue:CLLocationCoordinate2D = manager.location!.coordinate
                    //setting user location
                    let camera = GMSCameraPosition.camera(withTarget: locValue, zoom: 15.0)
                    let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        
                    mapView.camera = GMSCameraPosition(target: location.coordinate, zoom: 15, bearing: 0, viewingAngle: 0)
        
                    locationManager.stopUpdatingLocation()
                    fetchPlacesNearCoordinate(coordinate: locValue, radius: 200, name: "restaurant")
                }
    }

    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        locationManager.stopUpdatingLocation()
        print(error)
    }
    
   
    
    func fetchPlacesNearCoordinate(coordinate: CLLocationCoordinate2D, radius: Double, name : String){
       // var urlString = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?key=\(apiServerKey)&location=\(coordinate.latitude),\(coordinate.longitude)&radius=\(radius)&rankby=prominence&sensor=true"
       // urlString += "&name=\(name)"
        
        
        
        let urlString = "https://maps.googleapis.com/maps/api/place/search/json?location=\(coordinate.latitude),\(coordinate.longitude)&radius=200&types=restaurant&sensor=false&key=\(apiServerKey)"
        //urlString = urlString.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        print(urlString)
//        if placesTask.taskIdentifier > 0 && placesTask.state == .Running {
//            placesTask.cancel()
//
//        }
         let url = URL(string: urlString)
        URLSession.shared.dataTask(with: (url as URL?)!, completionHandler: {(data, response, error) -> Void in
            
            if let jsonObj = try? JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? NSDictionary {
                
                if let results = jsonObj!["results"] as? NSArray {
                                        for rawPlace in results {
                                            print(rawPlace)
                                           
                                            self.resultsArray.add(rawPlace as! NSDictionary)
                                        }
                                    }
                OperationQueue.main.addOperation({
                    
                    self.setMapView()
                })
            }
        }).resume()
        
        
        
        
        

    }
    func setMapView()
    
    {
        
        
        if resultsArray != nil {
            
            for index in 0..<resultsArray.count {
                
                if let returnedPlace = resultsArray[index] as? NSDictionary {
                    
                    var placeName = ""
                    var latitude = 0.0
                    var longitude = 0.0
                    
                    if let name = returnedPlace["name"] as? NSString {
                        placeName = name as String
                        print(placeName)
                    }
                    
                    if let geometry = returnedPlace["geometry"] as? NSDictionary {
                        if let location = geometry["location"] as? NSDictionary {
                            if let lat = location["lat"] as? Double {
                                latitude = lat
                            }
                            
                            if let lng = location["lng"] as? Double {
                                longitude = lng
                            }
                        }
                    }
                    let camera = GMSCameraPosition.camera(withLatitude: latitude, longitude:  longitude, zoom: 8.0)
                    let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
                    view = mapView
                    let marker = GMSMarker()
                    marker.position = CLLocationCoordinate2DMake(latitude, longitude)
                    marker.title = placeName
                    
                    marker.map = mapView
                }
            }
        }
    }
}
