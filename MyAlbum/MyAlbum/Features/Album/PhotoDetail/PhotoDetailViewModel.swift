//
//  PhotoDetailViewModel.swift
//  MyAlbum
//
//  Created by joris favier on 27/05/2019.
//  Copyright © 2019 jorisfavier. All rights reserved.
//

import UIKit
import RxSwift

class PhotoDetailViewModel {
    
    let photo: Photo
    
    private let _dissmiss = PublishSubject<Void>()
    
    var callDismiss: AnyObserver<Void> {
        return _dissmiss.asObserver()
    }
    
    var dismiss: Observable<Void> {
        return _dissmiss.asObservable()
    }
    
    init(photo: Photo) {
        self.photo = photo
    }
}
