//
//  PhotoDetailViewController.swift
//  MyAlbum
//
//  Created by joris favier on 27/05/2019.
//  Copyright © 2019 jorisfavier. All rights reserved.
//

import UIKit
import Kingfisher
import RxCocoa
import RxSwift

class PhotoDetailViewController: UIViewController {
    
    var viewModel: PhotoDetailViewModel!
    
    @IBOutlet weak var fullScreenImage: UIImageView!
    @IBOutlet weak var closeButton: UIButton!
    
    private var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        let url = URL(string: viewModel.photo.url)
        let processor = CroppingImageProcessor(size: fullScreenImage.frame.size,
                                               anchor: CGPoint(x: 0.5, y: 0.5))
        fullScreenImage.kf.setImage(with: url,
                               options: [.processor(processor)])
        closeButton.rx.controlEvent(.touchUpInside)
            .bind(to: viewModel.callDismiss)
        .disposed(by: disposeBag)
    }
}
