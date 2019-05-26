//
//  ViewController.swift
//  MyAlbum
//
//  Created by joris favier on 24/05/2019.
//  Copyright © 2019 jorisfavier. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class AlbumViewController: UIViewController {
    
    @IBOutlet weak var albumCollectionView: UICollectionView!
    
    private let refreshControl = UIRefreshControl()
    private let disposeBag = DisposeBag()
    
    var viewModel: AlbumViewModel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
        refreshControl.sendActions(for: .valueChanged)
    }
    
    private func initUI(){
        albumCollectionView.insertSubview(refreshControl, at: 0)
        albumCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func initData(){
        viewModel.albums
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] _ in self?.refreshControl.endRefreshing() })
            .bind(to: albumCollectionView.rx.items(cellIdentifier: "AlbumCollectionViewCell",
                                                   cellType: AlbumCollectionViewCell.self)) { (_, album, cell) in
                cell.setup(album: album)
            }
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.reload)
            .disposed(by: disposeBag)
    }

}

extension AlbumViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width
        //We want 3 column but with a margin of 10 between each cell
        let cellWidth = (width - 30) / 3
        return CGSize(width: cellWidth, height: cellWidth)
    }
}

