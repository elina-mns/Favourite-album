//
//  AlbumSearchAPI.swift
//  favourite-album
//
//  Created by Elina Mansurova on 2021-01-22.
//

import Foundation

struct AlbumSearchAPI {
    
    enum EndPoints {
        case searchAlbum
        var url: URL {
            return URL(string: self.stringValue)!
        }
        var stringValue: String {
            switch self {
            case .searchAlbum:
                return "http://ws.audioscrobbler.com/2.0/?method=album.getinfo&api_key=\(AlbumInfoAPI.api)&artist=\(AlbumInfoAPI.artist)&album=\(AlbumInfoAPI.album)&format=json"
            }
        }
    }
}
