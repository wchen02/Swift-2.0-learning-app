//
//  Track.swift
//  test
//
//  Created by nluo on 5/22/15.
//  Copyright (c) 2015 nluo. All rights reserved.
//

import Foundation

struct Track {
    let title: String
    let price: String
    let previewUrl: String
    
    init(title: String, price: String, previewUrl: String) {
        self.title = title
        self.price = price
        self.previewUrl = previewUrl
    }
    
    static func tracksWithJSON(results: NSArray) -> [Track] {
        var tracks = [Track]()
        for trackInfo in results {
            // Create the track
            if let kind = trackInfo["kind"] as? String {
                if kind=="song" {
                    let trackPrice = trackInfo["trackPrice"] as? String ?? "?"
                    let trackTitle = trackInfo["trackName"] as? String ?? "Unknown"
                    let trackPreviewUrl = trackInfo["previewUrl"] as? String ?? ""
                    
                    let track = Track(title: trackTitle, price: trackPrice, previewUrl: trackPreviewUrl)
                    tracks.append(track)
                }
            }
        }
        return tracks
    }
}
