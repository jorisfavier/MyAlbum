//
//  DependencyContainer.swift
//  MyAlbum
//
//  Created by joris favier on 25/05/2019.
//  Copyright © 2019 jorisfavier. All rights reserved.
//

import Foundation

protocol DependencyContainer {
    var albumService: AlbumService { get }
}

class DependencyContainerImpl: DependencyContainer {
    var albumService: AlbumService
    
    init() {
        albumService = AlbumServiceImpl()
    }
}
