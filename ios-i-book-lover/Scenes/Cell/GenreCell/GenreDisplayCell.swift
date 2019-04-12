//
//  GenreDisplayCell.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/12/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import Reusable

final class GenreDisplayCell: UITableViewCell {
    @IBOutlet private weak var genreImageView: UIImageView!
    @IBOutlet private weak var genreLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        configCell()
    }
    
    func setContent(genreTitle: String, genreImage: String) {
        genreImageView.image = UIImage(named: genreImage)
        genreLabel.text = genreTitle
    }
    
    private func configCell() {
        selectionStyle = .none
    }
}

extension GenreDisplayCell: Reusable {
}
