//
//  InfoResponseModel.swift
//  favourite-album
//
//  Created by Elina Mansurova on 2021-01-22.
//

import UIKit

struct InfoResponseModel: Codable {
    let album: Album
    
    struct Album: Codable {
        let name: String  //name of the album
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
    
        let listeners: String
        let playcounts: String
    
        let wiki: Wiki
        
        struct Wiki: Codable {
            let summary: String
        }
    }

}
