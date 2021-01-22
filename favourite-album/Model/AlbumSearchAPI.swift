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
    
    func requestSearchAlbums(completionHandler: @escaping (SearchResponseModel?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: EndPoints.searchAlbum.url, completionHandler: { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            let decoder = JSONDecoder()
            let downloadedData = try! decoder.decode(SearchResponseModel.self, from: data)
            completionHandler(downloadedData, nil)
        })
        task.resume()
    }
}
