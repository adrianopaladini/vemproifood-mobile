//
//  ViewController.swift
//  vemproiFood
//
//  Created by Adriano Paladini on 21/11/18.
//  Copyright © 2018 Adriano Paladini. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController {

    @IBOutlet weak var suggestion: UILabel!
    @IBOutlet weak var mapView: MKMapView!
    let locationManager = CLLocationManager()
    let api = API()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
        }
        
    }
    
    private func setup() {
        
        locationManager.delegate = self
        
        mapView.delegate = self
        mapView.showsUserLocation = true
        
        suggestion.text = "Loading..."
        
    }
    
    private func updateSuggestion(weather: String) -> String {
        
        switch weather {
        case "Rain":
            return "🍕"
        default:
            return "🍦"
        }
        
    }
    
    @IBAction func orderAction(_ sender: Any) {
        
    }
    
    @IBAction func shareAction(_ sender: Any) {
    }
    
}

extension ViewController: MKMapViewDelegate {
    
}

extension ViewController: CLLocationManagerDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        locationManager.stopUpdatingLocation()
        
        api.weather(debug: false) { (weather) in
            
            if let weatherStatus = weather?.list.last?.weather.last?.main {
                
                self.suggestion.text = self.updateSuggestion(weather: weatherStatus)
                
            }
            
        }
        
    }
    
}
