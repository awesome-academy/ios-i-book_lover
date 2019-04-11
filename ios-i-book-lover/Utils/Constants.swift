//
//  Constants.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/4/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import UIKit

enum Constants {
    static let appName = "Book Lover"
    static let genres = ["Art", "Biography", "Business", "Chick-lit",
                         "Children's", "Christian", "Classics", "Comics",
                         "Cookbooks", "Fantasy", "Fiction", "History", "Horror",
                         "Non-fiction", "Psychology", "Science", "Self-help", "Travel",
                         "Romance", "Young-adult"]
    static let indicatorTag = 999
    static let preDisplayItems = 6
}

enum Cells {
    static let heightGenreWelcome: CGFloat = 32
    static let heightGenreCell: CGFloat = 67
    static let heightBookCell: CGFloat = 220
    static let weightBookCell: CGFloat = 130
    static let fontSize: CGFloat = 20
}
