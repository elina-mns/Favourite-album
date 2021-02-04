//
//  AlbumInfoAPI.swift
//  favourite-album
//
//  Created by Elina Mansurova on 2021-02-03.
//

import Foundation

struct AlbumInfoAPI {
    
    static let api = "832d3c29d799038de8782f8e4116284a"
    
    enum EndPoints {
        case infoAlbum(artist: String, album: String)
        var url: URL {
            return URL(string: self.stringValue)!
        }
        var stringValue: String {
            switch self {
            case let .infoAlbum(artist, album):
                return "https://ws.audioscrobbler.com//2.0/?method=album.getinfo&api_key=\(AlbumInfoAPI.api)&artist=\(artist)&album=\(album)&format=json"
            }
        }
    }

    func requestInfo(artist: String, album: String, completionHandler: @escaping (InfoResponseModel?, Error?) -> Void) {
        let task = URLSession.shared.dataTask(with: EndPoints.infoAlbum(artist: artist, album: album).url, completionHandler: { (data, response, error) in
            guard let data = data else {
                completionHandler(nil, error)
                return
            }
            let decoder = JSONDecoder()
            do {
                let downloadedData = try decoder.decode(InfoResponseModel.self, from: data)
                completionHandler(downloadedData, nil)
            } catch {
                completionHandler(nil, error)
                print(error)
            }
        })
        task.resume()
    }
}

