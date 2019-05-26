//
//  Album.swift
//  MyAlbumPlayground
//
//  Created by joris favier on 24/05/2019.
//  Copyright © 2019 jorisfavier. All rights reserved.
//

import Foundation

class Album {
    let id: Int
    let title: String
    var thumbnailUrl: String? {
        return photos?.first?.thumbnailUrl
    }
    var photos: [Photo]?
    
    init(id: Int, title: String) {
        self.id = id
        self.title = title
    }
    
    init(album: AlbumDTO){
        self.id = album.id
        self.title = album.title
    }
    
    
}
