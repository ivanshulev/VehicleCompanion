//
//  MapView.swift
//  VehicleCompanion
//
//  Created by Ivan Shulev on 18.09.25.
//

import SwiftUI
import MapKit

struct MapView: UIViewRepresentable {
    var viewModel: PlacesViewModel
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.delegate = context.coordinator
        mapView.showsUserLocation = true
        return mapView
    }
    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        uiView.removeAnnotations(uiView.annotations)
        
        let annotations = viewModel.filteredPlaces.map { place -> MKPointAnnotation in
            let annotation = MKPointAnnotation()
            annotation.coordinate = place.coordinate
            annotation.title = place.name
            
            return annotation
        }
        
        uiView.addAnnotations(annotations)
        uiView.setRegion(viewModel.region, animated: true)
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self, onCalloutTap: { place in
            viewModel.selectedPlace = place
            viewModel.isShowingDetail = true
        })
    }
    
    class Coordinator: NSObject, MKMapViewDelegate {
        var parent: MapView
        var onCalloutTap: (Place) -> Void
        
        init(_ parent: MapView, onCalloutTap: @escaping (Place) -> Void) {
            self.parent = parent
            self.onCalloutTap = onCalloutTap
        }
        
        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            if annotation is MKUserLocation {
                return nil
            }
            
            let identifier = "Marker"
            var annotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            
            if annotationView == nil {
                annotationView = MKMarkerAnnotationView(annotation: annotation, reuseIdentifier: identifier)
                annotationView?.canShowCallout = true
                annotationView?.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            } else {
                annotationView?.annotation = annotation
            }
            
            return annotationView
        }
        
        func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
            guard let title = view.annotation?.title else {
                return
            }
            
            guard let selectedPlace = parent.viewModel.filteredPlaces.first(where: { $0.name == title }) else {
                return
            }
            
            onCalloutTap(selectedPlace)
        }
        
        func mapView(_ mapView: MKMapView, regionDidChangeAnimated animated: Bool) {
            parent.viewModel.centerCoordinate = mapView.centerCoordinate
        }
    }
}
