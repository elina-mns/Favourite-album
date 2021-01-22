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

    enum EndPoints {
        case searchAlbum(album: String)
        var url: URL {
            return URL(string: self.stringValue)!
        }
        var stringValue: String {
            switch self {
            case let .searchAlbum(album):
                return "https://ws.audioscrobbler.com/2.0/?method=album.search&api_key=\(AlbumSearchAPI.api)&album=\(album)&format=json"
            }
        }
    }

    func requestSearchAlbums(searchQuery: String, completionHandler: @escaping (SearchResponseModel?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: EndPoints.searchAlbum(album: searchQuery).url, completionHandler: { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let downloadedData = try decoder.decode(SearchResponseModel.self, from: data)
                completionHandler(downloadedData, nil)
            } catch {
                completionHandler(nil, error)
            }
        })
        task.resume()
    }
}
