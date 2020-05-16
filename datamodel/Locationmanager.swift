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
class LinkAnnotation: NSObject, MKAnnotation {
    internal init(coordinate: CLLocationCoordinate2D, title: String? = nil, subtitle: String? = nil, url: URL? = nil) {
        self.coordinate = coordinate
        self.title = title
        self.subtitle = subtitle
        self.url = url
    }
    
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var url: URL?
}
class LocationManager:NSObject,ObservableObject{
    static let shared=LocationManager()
    let manager=CLLocationManager()
    var location: CLLocation?
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
    
}
extension LocationManager:CLLocationManagerDelegate{
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]){
        self.location=locations.last
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = "coffee"
        request.region=MKCoordinateRegion(center:locations.last!.coordinate, latitudinalMeters:1000,longitudinalMeters:1000)
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
struct MapView: UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        Coordinator()
    }
    
    class Coordinator:NSObject, MKMapViewDelegate{
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {//顯示的樣子
            let annotationView =
                mapView.dequeueReusableAnnotationView(withIdentifier: "annotation", for:
                    annotation)
            
            annotationView.canShowCallout = true
            annotationView.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return annotationView
        }
        func mapView(_ mapView: MKMapView, annotationView view:
            MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            let annotation = view.annotation as? LinkAnnotation
            if let url = annotation?.url {
                UIApplication.shared.open(url)
            }
        }
    }
    var annotations = [MKPointAnnotation]()
    
    func makeUIView(context: UIViewRepresentableContext<MapView>)
        -> MKMapView {
            let mapView = MKMapView()
            mapView.delegate=context.coordinator
            mapView.register(MKMarkerAnnotationView.self, forAnnotationViewWithReuseIdentifier: "annotation")
            return mapView
    }
    func updateUIView(_ uiView: MKMapView, context:
        UIViewRepresentableContext<MapView>) {
        uiView.removeAnnotations(uiView.annotations)
        uiView.addAnnotations(annotations)
        uiView.showAnnotations(annotations, animated: true)
    }
}
