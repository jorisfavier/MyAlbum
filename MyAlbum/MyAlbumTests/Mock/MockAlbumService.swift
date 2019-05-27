//
//  MockAlbumService.swift
//  MyAlbumTests
//
//  Created by joris favier on 27/05/2019.
//  Copyright © 2019 jorisfavier. All rights reserved.
//

import Foundation
import RxSwift
@testable import MyAlbum

class MockAlbumService: AlbumService {
    private var fakeAlbums: [AlbumDTO]?
    private var fakePhotos: [PhotoDTO]?
    
    init(fakeAlbums: [AlbumDTO]?, fakePhotos: [PhotoDTO]?){
        self.fakeAlbums = fakeAlbums
        self.fakePhotos = fakePhotos
    }
    
    func getAlbums() -> Observable<[AlbumDTO]> {
        guard let fakeDatas = fakeAlbums else {
            return Observable.error(ServiceError.serverError)
        }
        return Observable.just(fakeDatas)
    }
    
    func getPhotos(idAlbum: Int, idPhoto: Int?) -> Observable<[PhotoDTO]> {
        guard let fakeDatas = fakePhotos else {
            return Observable.error(ServiceError.serverError)
        }
        return Observable.just(fakeDatas)
    }
    
    
}
