//
//  CategoryCell.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/17/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import Reusable

final class CategoryCell: UICollectionViewCell, NibReusable {
    @IBOutlet private weak var numberLabel: UILabel!
    @IBOutlet private weak var categoryLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()        
    }

    func setContent(number: Int, category: String) {
        numberLabel.text = String(number)
        categoryLabel.text = category
    }
}
