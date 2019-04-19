//
//  GenreEditCell.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/19/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import Reusable

final class GenreEditCell: UICollectionViewCell, Reusable {
    @IBOutlet private weak var genreLabel: UILabel!
    
    override var isSelected: Bool {
        didSet {
            genreLabel.do {
                $0.backgroundColor = isSelected ? .mainColor :  .white
                $0.textColor = isSelected ? .white : .mainColor
            }
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configCell()
    }
    
    func setContent(genreTitle: String) {
        genreLabel.text = genreTitle
    }
    
    private func configCell() {
        genreLabel.do {
            $0.layer.masksToBounds = true
            $0.layer.cornerRadius = 6
            $0.layer.borderColor = UIColor.mainColor.cgColor
            $0.layer.borderWidth = 1
        }
    }
}
