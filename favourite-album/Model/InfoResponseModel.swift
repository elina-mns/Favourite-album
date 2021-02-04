//
//  InfoResponseModel.swift
//  favourite-album
//
//  Created by Elina Mansurova on 2021-02-03.
//

import Foundation

struct InfoResponseModel: Codable {
    let album: AlbumInfo
}

struct AlbumInfo: Codable {
    let name: String
    let artist: String
    let listeners: String
    let playcount: String
    let wiki: Wiki
}

struct Wiki: Codable {
    let summary: String
}
