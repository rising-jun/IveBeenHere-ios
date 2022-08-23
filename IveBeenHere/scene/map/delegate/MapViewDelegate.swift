//
//  MapViewDelegate.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/23.
//

import Foundation
import MapKit

final class MapViewDelegate: NSObject { }
extension MapViewDelegate: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPointAnnotation else { return nil }
        
        let identifier = "Annotation"
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) else {
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.canShowCallout = true
            return annotationView
        }
        annotationView.annotation = annotation
        return annotationView
    }
}
