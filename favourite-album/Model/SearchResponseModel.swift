//
//  SearchResponseModel.swift
//  favourite-album
//
//  Created by Elina Mansurova on 2021-01-22.
//

import Foundation

struct SearchResponseModel: Codable {
    let results: SearchResults
}

struct SearchResults: Codable {
    let albummatches: AlbumMatches
}

struct AlbumMatches: Codable {
    let album: [Album]
}

struct Album: Codable {
    let name: String
    let artist: String
    let image: [Image]
    
    func getImageURL(with size: Image.Size) -> URL? {
        return image.first { (image) -> Bool in
            image.size == size
        }?.url
    }
}

struct Image: Codable {
    let url: URL
    let size: Size
    
    enum Size: String, Codable {
        case small
        case medium
        case large
        case extraLarge = "extralarge"
    }
    
    enum CodingKeys: String, CodingKey {
        case url = "#text"
        case size
    }
}
