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
        vc.albumSvc = dependencyContainer.albumService
        navControler.pushViewController(vc, animated: true)
    }
}
