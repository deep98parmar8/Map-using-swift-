//
//  ViewController.swift
//  Map
//
//  Created by Deep Parmar on 2020-07-27.
//  Copyright © 2020 Deep Parmar. All rights reserved.
//

import UIKit
//import map kit
import MapKit
//import core location for users location
import CoreLocation


class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate {
//connect Map kit
    @IBOutlet weak var textFieldForAddress: UITextField!
//Connect button
    @IBOutlet weak var getDirectionsButton: UIButton!
//Connect the map
    @IBOutlet weak var map: MKMapView!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        //request authorisation from user 
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
    }


    @IBAction func getDirectionTapped(_ sender: Any) {
    }
    
    func getAddress(){
        //geocoder will turn the address in to lat and long
        let geoCoder = CLGeocoder()
        //get geocode from srting and tdefine the sring from where the code will come from
        geoCoder.geocodeAddressString(textFieldForAddress.text!) { (placemarks, error) in
            //writing a guard statement to unwrap
            guard let placemarks = placemarks, let location = placemarks.first?.location
                else{
                    print("no location found")
                    return
            }//end of else
            print(location)
        }
    }
    //this tracks the user even if they move around
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        print(locations)
    }
    
    
    func mapThis(destinationCord : CLLocationCoordinate2D){
        //creating the coordinate for the users location
        let sourceCordinate = (locationManager.location?.coordinate)!
        
        let sourcePlaceMark = MKPlacemark(coordinate: sourceCordinate)
        
        let deskPlaceMark = MKPlacemark(coordinate: destinationCord)
        //creating a map kit item to store the long and lat data
        let sourceItem = MKMapItem(placemark: sourcePlaceMark)
        let deskItem =  MKMapItem(placemark: deskPlaceMark)
        //make request to apple to get destination
        let destinationRequest = MKDirections.Request()
        destinationRequest.source = sourceItem
        destinationRequest.destination = deskItem
        //we will be showing form of travel
        destinationRequest.transportType = .automobile
        //state the type of routes
        destinationRequest.requestsAlternateRoutes = true
        
        let directions = MKDirections(request: destinationRequest)
        //ask apple to calculate the route
        directions.calculate { (response, error) in
            //ststing if there is a response make itt equal to var respnse
            guard let resonse = response else {
                // if its not print the error statement
                if let error = error {
                    print("This doesnt work : (")
                }
                return
            }//else statement'
            let route = response?.routes[0]
            //adding overlay to map
        //    self.map.addOverlay(route.polyline)//the MKoverlay
        //    self.map.setVisibleMapRect(route.polyline.boundingMapRect, animated: true)//making map overlay visible
            
        }
    }
    
 
}//end of class

