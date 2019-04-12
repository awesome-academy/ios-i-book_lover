//
//  GenreCell.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/8/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import Then
import Reusable

final class GenreCell: UICollectionViewCell {
    @IBOutlet private weak var genreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configCell()
    }
    
    func setContent(genreTitle: String) {
        genreLabel.text = genreTitle
    }
    
    private func configCell() {
        genreLabel.do { _ in
            layer.masksToBounds = true
            layer.cornerRadius = 10
        }
    }
}

extension GenreCell: Reusable {    
}
