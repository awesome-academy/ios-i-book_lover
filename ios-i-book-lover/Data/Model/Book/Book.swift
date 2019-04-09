//
//  Book.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/5/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import Foundation
import XMLMapper

final class Book: XMLMappable {
    var nodeName: String! = ""
    var id: Text?
    var title: String?
    var imageUrl: String?
    var ratingsCount: Text?
    var averageRating: String?
    var author: Author?
    
    required init?(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        id <- map["best_book.id"]
        title <- map["best_book.title"]
        imageUrl <- map["best_book.image_url"]
        ratingsCount <- map["ratings_count"]
        averageRating <- map["average_rating"]
        author <- map["best_book.author"]
    }
}

