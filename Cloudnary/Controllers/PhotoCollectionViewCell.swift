//
//  PhotosFeedViewController.swift
//  Cloudnary
//
//  Created by Archita Bansal on 9/2/17.
//  Copyright © 2017 archita. All rights reserved.
//

import UIKit

class PhotoCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }
    
}
