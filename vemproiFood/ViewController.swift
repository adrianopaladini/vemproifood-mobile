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
    @IBOutlet weak var orderButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
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
        
        shareButton.isEnabled = false
        orderButton.isEnabled = false
        
        locationManager.delegate = self
        
        mapView.showsUserLocation = true
        mapView.camera.altitude = 500
        
        suggestion.text = "⭕️"
        
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
        if UIApplication.shared.canOpenURL(URL(string: "ifood://")!) {
           UIApplication.shared.open(URL(string: "ifood://")!)
        }
    }
    
    @IBAction func shareAction(_ sender: Any) {
        let vc = UIActivityViewController(activityItems: ["Pedindo \(suggestion.text). #iFood"], applicationActivities: [])
        self.present(vc, animated: true, completion: nil)
    }
    
}

extension ViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        locationManager.stopUpdatingLocation()
        
        if let userLocation = locations.first {
            let userCoordinates = CLLocationCoordinate2D(latitude: userLocation.coordinate.latitude, longitude: userLocation.coordinate.longitude)
            mapView.camera.centerCoordinate = userCoordinates
        }
        
        let location = "Campinas,br"
        
        api.getWeather(location) { (weather) in
            
            if let weatherStatus = weather?.list.first?.weather.first?.main {
                
                self.suggestion.text = self.updateSuggestion(weather: weatherStatus)
                
            } else {
                
                self.suggestion.text = "🍫"
                
            }
            
            self.shareButton.isEnabled = true
            self.orderButton.isEnabled = true
            
        }
        
    }
    
}
