//
//  AlbumSearchAPI.swift
//  favourite-album
//
//  Created by Elina Mansurova on 2021-01-22.
//

import Foundation

struct AlbumSearchAPI {
    
    static let api = "832d3c29d799038de8782f8e4116284a"
    static let secret = "228400156bafd06fe3bdeb43f2b70489"
//    
//    static var artist: String
//    static var album: String
//    
//    enum EndPoints {
//        case searchAlbum
//        var url: URL {
//            return URL(string: self.stringValue)!
//        }
//        var stringValue: String {
//            switch self {
//            case .searchAlbum:
//                return "http://ws.audioscrobbler.com/2.0/?method=album.getinfo&api_key=\(AlbumSearchAPI.api)&artist=\(artist)&album=\(album)&format=json"
//            }
//        }
//    }
//    
//    func requestSearchAlbums(completionHandler: @escaping (SearchResponseModel?, Error?) -> Void) {
//        let task = URLSession.shared.dataTask(with: EndPoints.searchAlbum.url, completionHandler: { (data, response, error) in
//            guard let data = data else {
//                completionHandler(nil, error)
//                return
//            }
//            let decoder = JSONDecoder()
//            let downloadedData = try! decoder.decode(SearchResponseModel.self, from: data)
//            completionHandler(downloadedData, nil)
//        })
//        task.resume()
//    }
}
