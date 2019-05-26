//
//  Photo.swift
//  MyAlbumPlayground
//
//  Created by joris favier on 24/05/2019.
//  Copyright © 2019 jorisfavier. All rights reserved.
//

import Foundation

class Photo {
    let id: Int
    let title: String
    let url: String
    let thumbnailUrl: String
    
    init(albumId: Int,
         id: Int,
         title: String,
         url: String,
         thumbnailUrl: String){
        self.id = id
        self.title = title
        self.url = url
        self.thumbnailUrl = thumbnailUrl
    }
    
    init(photoDTO: PhotoDTO) {
        self.id = photoDTO.id
        self.title = photoDTO.title
        self.thumbnailUrl = photoDTO.thumbnailUrl
        self.url = photoDTO.url
    }
}
