//
//  DetailBook.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/7/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import XMLMapper

final class BookDetail: XMLMappable {
    var nodeName: String! = ""
    var id = ""
    var title = ""
    var isbn = ""
    var imageUrl = ""
    var publishYear = ""
    var publishMonth = ""
    var publishDay = ""
    var publisher = ""
    var descriptions = ""
    var ratingsCount = ""
    var averageRating = ""
    var numOfPages = ""
    var link = ""
    var author: DetailAuthor?
    
    init() {}
    
    required init?(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        id <- map["id"]
        title <- map["title"]
        imageUrl <- map["image_url"]
        ratingsCount <- map["ratings_count"]
        averageRating <- map["average_rating"]
        author <- map["authors.author"]
        publishYear <- map["publication_year"]
        publishMonth <- map["publication_month"]
        publishDay <- map["publication_day"]
        publisher <- map["publisher"]
        numOfPages <- map["num_pages"]
        descriptions <- map["description"]
        link <- map["url"]
        isbn <- map["isbn"]
    }
}
