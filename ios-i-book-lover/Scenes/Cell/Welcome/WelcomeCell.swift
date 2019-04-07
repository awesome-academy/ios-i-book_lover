//
//  WelcomeCell.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/7/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import Then

final class WelcomeCell: UICollectionViewCell {
    @IBOutlet weak var genreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()

        genreLabel.do {_ in 
            layer.masksToBounds = true
            layer.cornerRadius = 6
            layer.borderColor = UIColor.mainColor.cgColor
            layer.borderWidth = 1
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                genreLabel.backgroundColor = .mainColor
                genreLabel.textColor = .white
            } else {
                genreLabel.backgroundColor = .white
                genreLabel.textColor = .mainColor
            }
        }
    }
}
