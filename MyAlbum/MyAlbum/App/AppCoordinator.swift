//
//  AppCoordinator.swift
//  MyAlbumPlayground
//
//  Created by joris favier on 23/05/2019.
//  Copyright © 2019 jorisfavier. All rights reserved.
//

import Foundation
import UIKit

class AppCoordinator: BaseCoordinator {
    
    private let navControler: UINavigationController
    
    init(navigationCtrl: UINavigationController){
        self.navControler = navigationCtrl
    }
    
    override func start() {
        let albumCoordinator = AlbumCoordinator(navigationCtrl: navControler,
                                                dependencyContainer: DependencyContainerImpl())
        navigate(to: albumCoordinator)
    }

    
}
