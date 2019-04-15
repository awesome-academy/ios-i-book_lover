//
//  BookListCell.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/15/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit
import Reusable
import Kingfisher

final class BookListCell: UITableViewCell, NibReusable {
    @IBOutlet private weak var bookImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var ratingView: RatingView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setContent(book: Book) {
        guard let author = book.author,
            let url = URL(string: book.imageUrl) else {
            return
        }
        authorLabel.text = author.name
        titleLabel.text = book.title
        ratingView.setRating(rate: Double(book.averageRating) ?? 0.0)
        let resource = ImageResource(downloadURL: url, cacheKey: book.imageUrl)
        bookImageView.kf.setImage(with: resource)
    }
}
