//
//  AnimeMarkerView.swift
//  AnimeChest
//
//  Created by Erik Kokaev on 5/24/21.
//
import MapKit

class AnimeMarkerView: MKAnnotationView {
    override var annotation: MKAnnotation? {
        willSet {
            guard let animeAnnotaionView = newValue as? AnimeAnnotation else { return }
            
            canShowCallout = true
            calloutOffset = CGPoint(x: -5, y: 5)
            rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
            image = animeAnnotaionView.image
        }
    }
}
