//
//  PhotoDTO.swift
//  MyAlbumPlayground
//
//  Created by joris favier on 24/05/2019.
//  Copyright © 2019 jorisfavier. All rights reserved.
//

import Foundation

struct PhotoDTO {
    let albumId: Int
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
    
}

extension PhotoDTO {
    init?(from json: [String: Any]) {
        guard
            let albumId = json["albumId"] as? Int,
            let id = json["id"] as? Int,
            let title = json["title"] as? String,
            let url = json["url"] as? String,
            let thumbnailUrl = json["thumbnailUrl"] as? String
            else { return nil }
        self.init(albumId: albumId, id: id, title: title, url: url, thumbnailUrl: thumbnailUrl)
    }
}
