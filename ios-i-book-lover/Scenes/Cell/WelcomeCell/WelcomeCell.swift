//
//  WelcomeCell.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/7/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import Then
import Reusable

final class WelcomeCell: UICollectionViewCell, Reusable {
    @IBOutlet private weak var genreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configCell()
    }
    
    override var isSelected: Bool {
        didSet {
            if isSelected {
                genreLabel.backgroundColor = .mainColor
                genreLabel.textColor = .white
            } else {
                genreLabel.backgroundColor = .white
                genreLabel.textColor = .mainColor
            }
        }
    }
    
    func setContent(genreTitle: String) {
        genreLabel.text = genreTitle
    }
    
    private func configCell() {
        genreLabel.do { _ in
            layer.masksToBounds = true
            layer.cornerRadius = 6
            layer.borderColor = UIColor.mainColor.cgColor
            layer.borderWidth = 1
        }
    }
}
