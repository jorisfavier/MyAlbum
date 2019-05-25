//
//  AlbumDTO.swift
//  MyAlbumPlayground
//
//  Created by joris favier on 24/05/2019.
//  Copyright © 2019 jorisfavier. All rights reserved.
//

import Foundation

struct AlbumDTO {
    let userId: Int
    let id: Int
    let title: String
    
}

extension AlbumDTO {
    init?(from json: [String: Any]) {
        guard
            let userId = json["userId"] as? Int,
            let id = json["id"] as? Int,
            let title = json["title"] as? String
            else { return nil }
        self.init(userId: userId, id: id, title: title)
    }
}
