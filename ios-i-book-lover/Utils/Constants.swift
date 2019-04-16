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

enum Genres {
    static let genreImages = ["ic_art", "ic_biography", "ic_business", "ic_chick_lit",
                              "ic_children", "ic_christian", "ic_classic", "ic_comics",
                              "ic_cookbook", "ic_fantasy", "ic_fiction", "ic_history", "ic_horror",
                              "ic_nonfiction", "ic_psychology", "ic_science", "ic_self_help", "ic_travel",
                              "ic_romantic", "ic_young"]
}

enum IndicatorChild {
    static let review = "Review"
    static let about = "About"
}
