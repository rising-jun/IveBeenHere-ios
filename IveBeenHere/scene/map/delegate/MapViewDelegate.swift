//
//  MapViewDelegate.swift
//  IveBeenHere
//
//  Created by 김동준 on 2022/08/23.
//

import Foundation
import MapKit

final class MapViewDelegate: NSObject {
    var draggedPinRelay: PublishRelay<Coordinate>?
}
extension MapViewDelegate: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if let postAnnotation = annotation as? PostAnnotation {
            guard let postAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: PostAnnotationView.identifier) as? PostAnnotationView else { return nil }
            postAnnotationView.configuration(with: postAnnotation.visitDTO)
            postAnnotationView.annotation = postAnnotation
            return postAnnotationView
        }
        
        guard annotation is MKPointAnnotation else { return nil }
        let identifier = "Annotation"
        guard let annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: MKAnnotationView.id) else {
            let annotationView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            annotationView.canShowCallout = true
            annotationView.isDraggable = true
            return annotationView
        }
        annotationView.annotation = annotation
        return annotationView
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, didChange newState: MKAnnotationView.DragState, fromOldState oldState: MKAnnotationView.DragState) {
        if newState == MKAnnotationView.DragState.ending {
            if let droppedAt = view.annotation?.coordinate {
                let coordi = Coordinate(latitude: droppedAt.latitude, longitude: droppedAt.longitude)
                draggedPinRelay?.accept(value: coordi)
            }
        }
    }
}

extension MKAnnotationView{
    static let id = "Annotation"
}
