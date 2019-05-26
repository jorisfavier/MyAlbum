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
    @IBOutlet weak var noDataLabel: UILabel!
    
    private let refreshControl = UIRefreshControl()
    private let disposeBag = DisposeBag()
    
    var viewModel: AlbumViewModel!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
        refreshControl.sendActions(for: .valueChanged)
        refreshControl.beginRefreshing()
    }
    
    private func initUI(){
        albumCollectionView.insertSubview(refreshControl, at: 0)
        albumCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func initData(){
        viewModel.albums
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] albums in
                self?.refreshControl.endRefreshing()
                self?.noDataLabel.isHidden = albums.count > 0
            })
            .bind(to: albumCollectionView.rx.items(cellIdentifier: "AlbumCollectionViewCell",
                                                   cellType: AlbumCollectionViewCell.self)) { (_, album, cell) in
                cell.setup(album: album)
            }
            .disposed(by: disposeBag)
        
        refreshControl.rx.controlEvent(.valueChanged)
            .bind(to: viewModel.reload)
            .disposed(by: disposeBag)
        
        viewModel.error
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [weak self] errorMessage in
                guard let strongSelf = self else { return }
                if strongSelf.refreshControl.isRefreshing {
                    strongSelf.refreshControl.endRefreshing()
                }
                strongSelf.presentAlert(message: errorMessage)
            })
            .disposed(by: disposeBag)
    }
    
    private func presentAlert(message: String) {
        let alertController = UIAlertController(title: "Error", message: message, preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alertController, animated: true)
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

