//
//  AlbumViewModel.swift
//  MyAlbum
//
//  Created by joris favier on 26/05/2019.
//  Copyright © 2019 jorisfavier. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class AlbumViewModel {
    private let albumService: AlbumService
    private let disposeBag = DisposeBag()
    
    private var _albumsList: BehaviorRelay<[Album]> = BehaviorRelay.init(value: [])
    private var _reload = PublishSubject<Void>()
    private var _error = PublishSubject<String>()
    private var _selectedAlbum = PublishSubject<Album>()
    
    // MARK: Inputs
    
    /// Call to open an album
    var selectAlbum: AnyObserver<Album> {
        return _selectedAlbum.asObserver()
    }
    
    /// Call to reload the album list
    var reload: AnyObserver<Void> {
        return _reload.asObserver()
    }
    
    // MARK: Outputs
    
    /// Emits an array of fetched albums
    var albums: Observable<[Album]> {
        return _albumsList.asObservable()
    }
    
    /// Emits an error message to be displayed
    var error: Observable<String> {
        return _error.asObservable()
    }
    
    /// Emits an album to be opened
    var showAlbumDetail: Observable<Album> {
        return _selectedAlbum.asObservable()
    }
    
    
    
    init(albumService: AlbumService) {
        self.albumService = albumService
        _reload.subscribe(onNext: { [weak self] in
            self?.loadAlbums()
        }).disposed(by: disposeBag)
    }
    
    private func loadAlbums(){
        //retrieve the albums, then convert it to Album objects
        albumService.getAlbums()
            .catchError { error in
                self._error.onNext("Oups !! An error occured, please try again later")
                return Observable.empty()
            }
            .map { albumsDTO in albumsDTO.map(Album.init) }
            .flatMap { albums -> Observable<Album> in
                Observable.from(albums)
            }
            //for each album we retrieve the first photo
            .flatMap { album -> Observable<Album> in
                self.loadAlbumThumbnail(for: album)
            }
            //finally we add the album with a thumbnail to the album list
            .subscribe(onNext: { album in
                var albums = self._albumsList.value
                albums.append(album)
                self._albumsList.accept(albums)
            }).disposed(by: disposeBag)
    }
    
    /// Load one photo from a given album
    /// and add it to the album object
    /// in order to get an album thumbnail
    /// - Parameter album: the album where to get the photos from
    /// - Returns: an update album with the photos
    private func loadAlbumThumbnail(for album: Album) -> Observable<Album> {
        
        return albumService.getPhotos(idAlbum: album.id, idPhoto: 1)
            .catchError { error in
                self._error.onNext("Oups !! An error occured, please try again later")
                return Observable.empty()
            }
            .map { photos -> Album in
                album.photos = photos.map(Photo.init)
                return album
        }
    }
    
}
