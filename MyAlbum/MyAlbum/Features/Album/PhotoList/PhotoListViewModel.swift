//
//  PhotoListViewModel.swift
//  MyAlbum
//
//  Created by joris favier on 27/05/2019.
//  Copyright © 2019 jorisfavier. All rights reserved.
//

import RxSwift
import RxCocoa

class PhotoListViewModel {
    private let albumService: AlbumService
    private let disposeBag = DisposeBag()
    private let album: Album
    
    private var _reload = PublishSubject<Void>()
    private var _error = PublishSubject<String>()
    private var _photoList = BehaviorSubject<[Photo]>(value : [])
    
    var photoList: Observable<[Photo]> {
        return _photoList.asObservable()
    }
    
    var reload: AnyObserver<Void> {
        return _reload.asObserver()
    }
    var error: Observable<String> {
        return _error.asObservable()
    }
    
    var title: Observable<String> {
        return Observable.just(album.title)
    }
    
    init(albumService: AlbumService, album: Album) {
        self.albumService = albumService
        self.album = album
        _reload.subscribe(onNext: { [weak self] in
            self?.loadPhoto()
        }).disposed(by: disposeBag)
    }
    
    private func loadPhoto(){
        //retrieve the albums, then convert it to Album objects
        albumService.getPhotos(idAlbum: album.id, idPhoto: nil)
            .catchError { error in
                self._error.onNext("Oups !! An error occured, please try again later")
                return Observable.empty()
            }
            .map { photoDTO in photoDTO.map(Photo.init) }
            .subscribe(onNext: { [weak self] photos in
                self?._photoList.onNext(photos)
            })
            .disposed(by: disposeBag)
        
    }
}
