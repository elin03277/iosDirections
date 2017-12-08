//
//  ViewController.swift
//  iOSdirections
//
//  Created by Eric Lin on 2017-10-04.
//  Copyright © 2017 Eric Lin. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapkitView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set delegate to self
        mapkitView.delegate = self
        
        //add placemarks for each location
        //set starting location and destination location, so here we are starting at SFU
        let originPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 49.276765, longitude: -122.917957), addressDictionary: nil)
        
        //and where we want to go is UBC
        let destinationPlacemark = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 49.2606, longitude: -123.2460), addressDictionary: nil)
        
        //add map items for each location
        let originMapItem = MKMapItem(placemark: originPlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        //name each placemark
        let originAnnotation = MKPointAnnotation()
        originAnnotation.title = "SFU"
        
        if let location = originPlacemark.location {
            originAnnotation.coordinate = location.coordinate
        }
        
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "UBC"
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        //show annotations
        self.mapkitView.showAnnotations([originAnnotation,destinationAnnotation], animated: true )
        
        //request directions from source to destination
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = originMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .automobile
        
        //calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.mapkitView.add(route.polyline)
            
            let rect = route.polyline.boundingMapRect
            self.mapkitView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let renderer = MKPolylineRenderer(overlay: overlay)
        renderer.strokeColor = UIColor.blue
        return renderer
    }
}
