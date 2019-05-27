//
//  AlbumCollectionViewCell.swift
//  MyAlbum
//
//  Created by joris favier on 26/05/2019.
//  Copyright © 2019 jorisfavier. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher

class AlbumCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var thumbnailImageView: UIImageView!
    @IBOutlet weak var title: UILabel!
    
    func setup(album: Album){
        title.text = album.title
        if let urlString = album.thumbnailUrl,
            let url = URL(string: urlString) {
            let processor = CroppingImageProcessor(size: self.frame.size,
                                                   anchor: CGPoint(x: 0.5, y: 0.5))
            thumbnailImageView.kf.setImage(with: url,
                                           options: [.processor(processor),
                                                     .transition(.fade(1))])
        }
    }
}

