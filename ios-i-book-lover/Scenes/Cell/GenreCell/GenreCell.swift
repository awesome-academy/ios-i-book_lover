//
//  GenreCell.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/8/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import Then

final class GenreCell: UICollectionViewCell {
    @IBOutlet weak var genreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        genreLabel.do { _ in
            layer.masksToBounds = true
            layer.cornerRadius = 10
        }
    }
}
