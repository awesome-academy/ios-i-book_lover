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
    static let progresses = ["Interested to Read", "Currently Reading", "Read"]
    static let defaultProgress = "Want to Read"
    static let pages = ["1", "2", "3", "4", "5", "6", "7", "8", "9", "10"]
    static let bookCategories = ["Books", "Currently Reading", "Read", "Genres"]
    static let radiusCircle = 80
    static let widthExploreCollectionView: CGFloat = 20
}

enum Cells {
    static let heightGenreWelcome: CGFloat = 32
    static let heightGenreCell: CGFloat = 67
    static let heightBookCell: CGFloat = 220
    static let widthBookCell: CGFloat = 130
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

enum DefaultKeys {
    static let goal = "goal"
    static let keyWord = "keyWords"
    static let progress = "progress"
}

enum LabelFont {
    static let percentageCircle: CGFloat = 15
}

enum Alerts {
    static let setGoalTitle = "Set goal"
    static let setGoalMessage = "Set your goal and execute it!"
    static let adjustTitle = "Update your goal"
    static let adjustMessage = "New Book Completed?"
    static let doneTitle = "Challenge Completed !!"
    static let doneMessage = "You completed this challenge, set new goal?"
    
    static let adjustAction = "Reset Goal"
    static let cancelAction = "Cancel"
    static let actionAction = "Ok"
    static let addAction = "Add"
}
