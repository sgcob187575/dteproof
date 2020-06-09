//
//  Locationmanager.swift
//  dteproof
//
//  Created by 陳昱豪 on 2020/5/13.
//  Copyright © 2020 Chen_Yu_Hao. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit
import SwiftUI
class LocationManager:NSObject,ObservableObject{
    static let shared=LocationManager()
    let manager=CLLocationManager()
    var location: CLLocation?
    var query="餐廳"
    @Published var mapItems=[MKMapItem]()
    override init()
    {
        super.init()
        manager.delegate=self
    }
    func getLocation(){
        manager.requestWhenInUseAuthorization()
        manager.requestLocation()
    }
    func setquery(query:String){
        self.query=query
        manager.requestLocation()
    }
    
}
extension LocationManager:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        self.location=locations.last
        //DataManager.shared.setlocation(location: self.location!)
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = self.query
        request.region=MKCoordinateRegion(center:locations.last!.coordinate, latitudinalMeters:0.01,longitudinalMeters:0.01)
        let search = MKLocalSearch(request: request)
        search.start{ (response, error) in
            if let mapItems=response?.mapItems{
                self.mapItems=mapItems
            }
        }
        
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    }
    
}
