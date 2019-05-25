//
//  AlbumServiceImpl.swift
//  MyAlbum
//
//  Created by joris favier on 25/05/2019.
//  Copyright © 2019 jorisfavier. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AlbumServiceImpl: AlbumService {
    
    private let session: URLSession = URLSession.shared
    
    func getAlbums() -> Observable<[AlbumDTO]> {
        let url = URL(string: "https://jsonplaceholder.typicode.com/albums")!
        return session.rx.json(url: url)
            .flatMap { json -> Observable<[AlbumDTO]> in
            guard
                let json = json as? [[String: Any]]
                else { return Observable.error(ServiceError.unableToParse) }
                let albums = json.compactMap(AlbumDTO.init)
                return Observable.just(albums)
        }
    }
    
    func getPhotos(idAlbum: Int, idPhoto: Int?) -> Observable<[PhotoDTO]> {
        var urlQueryParameter = ""
        if let idphoto = idPhoto {
            urlQueryParameter = "?id=\(idphoto)"
        }
        let url = URL(string: "https://jsonplaceholder.typicode.com/albums/\(idAlbum)/photos\(urlQueryParameter)")!
        return session.rx.json(url: url)
            .flatMap { json -> Observable<[PhotoDTO]> in
                guard
                    let json = json as? [[String: Any]]
                    else { return Observable.error(ServiceError.unableToParse) }
                let albums = json.compactMap(PhotoDTO.init)
                return Observable.just(albums)
        }
    }
    
    
}
