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
        let vm = PhotoListViewModel(albumService: dependencyContainer.albumService, album: album)
        vc.viewModel = vm
        vm.showPhotoDetail
            .subscribe(onNext: { [weak self] photo in
                self?.showPhotoDetail(photo: photo)
            })
            .disposed(by: disposeBag)
        navControler.pushViewController(vc, animated: true)
    }
    
    private func showPhotoDetail(photo: Photo){
        let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
        let vc = storyboard.instantiateViewController(withIdentifier: "PhotoDetailViewController") as! PhotoDetailViewController
        let vm = PhotoDetailViewModel(photo: photo)
        vc.viewModel = vm
        vm.dismiss
            .subscribe(onNext: { [weak self] _ in
                self?.navControler.dismiss(animated: true, completion: nil)
            })
            .disposed(by: disposeBag)
        navControler.present(vc, animated: true, completion: nil)
    }
}
