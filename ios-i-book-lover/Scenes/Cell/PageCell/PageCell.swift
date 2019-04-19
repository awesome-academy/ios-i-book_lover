//
//  PageCell.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/16/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import Reusable

final class PageCell: UICollectionViewCell {
    @IBOutlet private weak var pageLabel: UILabel!
    
    override var isSelected: Bool {
        didSet { pageLabel.textColor = isSelected ? .mainColor : .lightColor }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setContent(page: String) {
        pageLabel.text = page
    }
    
}

extension PageCell: Reusable {
}
