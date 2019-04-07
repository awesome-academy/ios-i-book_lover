//
//  BookCell.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/8/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import Then
import Reusable

final class BookCell: UICollectionViewCell {
    @IBOutlet weak var bookImageView: UIImageView!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var ratingView: RatingView!
    var book: Book? {
        didSet {
            
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
}

extension BookCell: Reusable {
}
