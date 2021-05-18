//
//  AnimeItem.swift
//  AnimeChest
//
//  Created by Erik Kokaev on 5/17/21.
//

import Firebase


class AnimeItem: NSObject {
    
    let ref: DatabaseReference?
    var title: String
    var episodes: Int
    var video: String
    var imagesURLs: [String]
    var mapX: Double
    var mapY: Double
    
    init(title: String, episodes: Int, video: String, imagesURLs: [String], mapX: Double, mapY: Double) {
        
        self.ref = nil
        self.title = title
        self.episodes = episodes
        self.video = video
        self.imagesURLs = imagesURLs
        self.mapX = mapX
        self.mapY = mapY
    }
    
    init?(snapshot: DataSnapshot) {
        guard
            let value = snapshot.value as? [String: AnyObject],
            let title = value["title"] as? String,
            let episodes = value["episodes"] as? Int,
            let video = value["video"] as? String,
            let imagesURLs = value["imagesURLs"] as? [String],
            let mapX = value["mapX"] as? Double,
            let mapY = value["mapY"] as? Double else {
            return nil
        }
        
        self.ref = snapshot.ref
        self.title = title
        self.episodes = episodes
        self.video = video
        self.imagesURLs = imagesURLs
        self.mapX = mapX
        self.mapY = mapY
    }
    
    func toAnyObject() -> Any {
        return [
            "title": title,
            "episodes": episodes,
            "video": video,
            "imagesURLs": imagesURLs,
            "mapX": mapX,
            "mapY": mapY
        ]
    }

}
