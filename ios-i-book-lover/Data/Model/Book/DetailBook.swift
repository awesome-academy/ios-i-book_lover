//
//  DetailBook.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/7/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import XMLMapper

final class DetailBook: XMLMappable {
    var nodeName: String! = ""
    var id = ""
    var title = ""
    var isbn = ""
    var imageUrl = ""
    var publicationYear = ""
    var publicationMonth = ""
    var publicationDay = ""
    var publisher = ""
    var descriptions = ""
    var ratingsCount = ""
    var averageRating = ""
    var numOfPages = ""
    var link = ""
    var author: DetailAuthor?
    
    required init?(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        id <- map["book.id"]
        title <- map["book.title"]
        imageUrl <- map["book.image_url"]
        ratingsCount <- map["book.ratings_count"]
        averageRating <- map["book.average_rating"]
        author <- map["book.authors.author"]
        publicationYear <- map["book.publication_year"]
        publicationMonth <- map["book.publication_month"]
        publicationDay <- map["book.publication_day"]
        publisher <- map["book.publisher"]
        numOfPages <- map["book.num_pages"]
        descriptions <- map["book.description"]
        link <- map["book.url"]
        isbn <- map["book.isbn"]
    }
}
