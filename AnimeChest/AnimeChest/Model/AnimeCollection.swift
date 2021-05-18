//
//  AnimeCollection.swift
//  AnimeChest
//
//  Created by Erik Kokaev on 5/18/21.
//

import Foundation

struct AnimeCollection: Hashable {
    let name: String
    var animeItems: [AnimeItem] = []
    var identifier = UUID().uuidString
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(identifier)
    }
    
    static func == (lhs: AnimeCollection, rhs: AnimeCollection) -> Bool {
        return lhs.identifier == rhs.identifier
    }
    
    init(name: String, animeItems: [AnimeItem]) {
        self.name = name
        self.animeItems = animeItems
    }
}
