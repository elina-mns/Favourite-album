//
//  AlbumAPI.swift
//  favourite-album
//
//  Created by Elina Mansurova on 2021-01-22.
//

import Foundation

struct AlbumAPI {
    private let api = "832d3c29d799038de8782f8e4116284a"
    private let secret = "228400156bafd06fe3bdeb43f2b70489"
    
    var artist: String
    var album: String
    
    enum EndPoints {
        case favouriteAlbum
        var url: URL {
            return URL(string: self.stringValue)!
        }
        var stringValue: String {
            switch self {
            case .favouriteAlbum:
                return "http://ws.audioscrobbler.com/2.0/?method=album.getinfo&api_key=\(api)&artist=\(artist)&album=\(album)&format=json"
            }
        }
    }
}
