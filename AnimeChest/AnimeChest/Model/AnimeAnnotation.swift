//
//  AnimeAnnotation.swift
//  AnimeChest
//
//  Created by Erik Kokaev on 5/24/21.
//

import MapKit

class AnimeAnnotation: NSObject, MKAnnotation {
    let title: String?
    let subtitle: String?
    let coordinate: CLLocationCoordinate2D
    let animeItem: AnimeItem
    
    var image: UIImage {
        #imageLiteral(resourceName: "mapIcon")
    }
    
    init(title: String?, subtitle: String?, coordinate: CLLocationCoordinate2D, animeItem: AnimeItem) {
        self.title = title
        self.subtitle = subtitle
        self.coordinate = coordinate
        self.animeItem = animeItem
        
        super.init()
    }
}
