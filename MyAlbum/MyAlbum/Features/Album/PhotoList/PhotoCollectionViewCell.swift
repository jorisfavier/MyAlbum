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

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImage: UIImageView!
    
    func setup(photo: Photo){
        let url = URL(string: photo.url)
        let processor = CroppingImageProcessor(size: self.frame.size,
                                                       anchor: CGPoint(x: 0.5, y: 0.5))
        photoImage.kf.setImage(with: url,
                                       options: [.processor(processor),
                                                 .transition(.fade(1))])
    }
}
