//
//  SearchResponseModel.swift
//  favourite-album
//
//  Created by Elina Mansurova on 2021-01-22.
//

import Foundation

struct SearchResponseModel: Codable {
    
    let results: Results
    
    struct Results: Codable {
        let album: Album
        
        struct Album: Codable {
            let name: String
            let artist: String
            let image: Image
            
            struct Image: Codable {
                let text: String
                let size: String
                
                enum CodingKeys: String, CodingKey {
                    case text = "#text"
                    case size
                }
            }
        }
    }
}
