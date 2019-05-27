//
//  AlbumCoordinator.swift
//  MyAlbum
//
//  Created by joris favier on 25/05/2019.
//  Copyright © 2019 jorisfavier. All rights reserved.
//

import Foundation
import UIKit

class AlbumCoordinator: BaseCoordinator {
    
    private let navControler: UINavigationController
    private let dependencyContainer: DependencyContainer
    
    init(navigationCtrl: UINavigationController, dependencyContainer: DependencyContainer){
        self.navControler = navigationCtrl
        self.dependencyContainer = dependencyContainer
    }
    
    override func start() {
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "AlbumViewController") as! AlbumViewController
        let viewmodel = AlbumViewModel(albumService: dependencyContainer.albumService)
        vc.viewModel = viewmodel
        viewmodel.showAlbumDetail
            .subscribe(onNext: { [weak self] album in
                self?.showPhotoList(album: album)
            })
            .disposed(by: disposeBag)
        navControler.pushViewController(vc, animated: true)
    }
    
    private func showPhotoList(album: Album){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "PhotoListViewController") as! PhotoListViewController
        vc.viewModel = PhotoListViewModel(albumService: dependencyContainer.albumService, album: album)
        navControler.pushViewController(vc, animated: true)
    }
}
