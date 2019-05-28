//
//  PhotoViewController.swift
//  MyAlbum
//
//  Created by joris favier on 27/05/2019.
//  Copyright © 2019 jorisfavier. All rights reserved.
//

import UIKit
import RxSwift

class PhotoListViewController: UIViewController {
    
    var viewModel: PhotoListViewModel!
    
    @IBOutlet weak var photoCollectionView: UICollectionView!
    @IBOutlet weak var noDataAvailableLabel: UILabel!
    
    private let refreshControl = UIRefreshControl()
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initUI()
        initData()
        refreshControl.sendActions(for: .valueChanged)
        refreshControl.beginRefreshing()
    }
    
    private func initUI(){
        photoCollectionView.insertSubview(refreshControl, at: 0)
        photoCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
    }
    
    private func initData(){
        viewModel.photoList
            .observeOn(MainScheduler.instance)
            .do(onNext: { [weak self] photos in
                self?.refreshControl.endRefreshing()
                self?.noDataAvailableLabel.isHidden = photos.count > 0
            })
            .bind(to: photoCollectionView.rx.items(cellIdentifier: "PhotoCollectionViewCell",
                                                   cellType: PhotoCollectionViewCell.self)) { (_, photo, cell) in
                                                cell.setup(photo: photo)
            }
            .disposed(by: disposeBag)
        
        viewModel.title
            .bind(to: navigationItem.rx.title)
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
        
        photoCollectionView.rx.modelSelected(Photo.self)
            .bind(to: viewModel.selectPhoto)
            .disposed(by: disposeBag)
        
    }
    
}

extension PhotoListViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = collectionView.bounds.width
        //We want 2 column but with a margin of 10 between each cell
        let cellWidth = (width - 20) / 2
        return CGSize(width: cellWidth, height: cellWidth)
    }
}
