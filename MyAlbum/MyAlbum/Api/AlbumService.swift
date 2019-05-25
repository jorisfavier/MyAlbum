//
//  AlbumService.swift
//  MyAlbumPlayground
//
//  Created by joris favier on 25/05/2019.
//  Copyright © 2019 jorisfavier. All rights reserved.
//

import Foundation
import RxSwift


protocol AlbumService {
    
    /// Retrieve the album list
    ///
    /// - Returns: a list of album
    func getAlbums() -> Observable<[AlbumDTO]>
    
    /// Retrieve one or all the photos from a given album
    ///
    /// - Parameters:
    ///   - idAlbum: the album identifier
    ///   - idPhoto: the photo identifier (optional)
    /// - Returns: the list of photos
    func getPhotos(idAlbum: Int, idPhoto: Int?) -> Observable<[PhotoDTO]>
    
}
