//
//  AlbumAPI.swift
//  favourite-album
//
//  Created by Elina Mansurova on 2021-01-22.
//

import Foundation

struct AlbumInfoAPI {
    
    static let api = "832d3c29d799038de8782f8e4116284a"
    static let secret = "228400156bafd06fe3bdeb43f2b70489"
    
    static var artist: String
    static var album: String
    
    enum EndPoints {
        case favouriteAlbum
        var url: URL {
            return URL(string: self.stringValue)!
        }
        var stringValue: String {
            switch self {
            case .favouriteAlbum:
                return "http://ws.audioscrobbler.com/2.0/?method=album.getinfo&api_key=\(AlbumInfoAPI.api)&artist=\(AlbumInfoAPI.artist)&album=\(AlbumInfoAPI.album)&format=json"
            }
        }
    }
    
    func requestAlbumInfo(completionHandler: @escaping (InfoResponseModel?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: EndPoints.favouriteAlbum.url, completionHandler: { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            let decoder = JSONDecoder()
            let downloadedData = try! decoder.decode(InfoResponseModel.self, from: data)
            completionHandler(downloadedData, nil)
        })
        task.resume()
    }
}
