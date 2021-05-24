//
//  MapViewController.swift
//  AnimeChest
//
//  Created by Erik Kokaev on 5/23/21.
//

import MapKit
import CoreLocation
import UIKit

class MapViewController: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    private var locationManager = CLLocationManager()
    var animeItems: [AnimeItem] = []
        
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        mapView.register(AnimeMarkerView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        
        locationManager.delegate = self
        locationManager.requestAlwaysAuthorization()
        locationManager.startUpdatingLocation()
        
        NotificationCenter.default.addObserver(self, selector: #selector(didUpdateAnnotations), name: .didUpdateAnnotations, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.post(name: .didResetAnnotations, object: nil)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let allAnotations = self.mapView.annotations
        mapView.removeAnnotations(allAnotations)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
     }
    
    @objc func didUpdateAnnotations(_ notification: Notification) {
        if let data = notification.userInfo as? [String: [AnimeItem]] {
            if let animeItems = data["allItems"] {
                for animeItem in animeItems {
                    let annotation = AnimeAnnotation (title: animeItem.title,
                                                      subtitle: String(animeItem.episodes),
                                                      coordinate: CLLocationCoordinate2D(latitude: animeItem.mapX, longitude: animeItem.mapY),
                                                      animeItem: animeItem)
                    mapView.addAnnotation(annotation)
                }
            }
        }
    }
  
}

extension MapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            let latitude = location.coordinate.latitude
            let longitude = location.coordinate.longitude
            
            let region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: latitude, longitude: longitude), latitudinalMeters: 500, longitudinalMeters: 500)
            
            mapView.setRegion(region, animated: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        let allert = UIAlertController(title: "Error getting location", message: "Please turn check your internet connection ", preferredStyle: .alert)
        allert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        self.present(allert, animated: true)
    }

}

extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        guard let animeAnnotation = view.annotation as? AnimeAnnotation else { return }
        
        if let animeDetailedController = storyboard?.instantiateViewController(identifier: AnimeDetailedViewController.identifier, creator: { coder in
            return AnimeDetailedViewController(coder: coder, animeItem: animeAnnotation.animeItem)
        }) {
            show(animeDetailedController, sender: nil)
        }
    }
}
