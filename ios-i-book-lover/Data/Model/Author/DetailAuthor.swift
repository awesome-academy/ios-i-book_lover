//
//  Author.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/5/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import XMLMapper

final class DetailAuthor: XMLMappable {
    var nodeName: String! = ""
    var id = ""
    var name = ""
    var link = ""
    var imageURL: Text?
    var averageRating = ""
    var ratingCount = ""
    
    required init?(map: XMLMap) {
    }
    
    func mapping(map: XMLMap) {
        id <- map["id"]
        name <- map["name"]
        link <- map["link"]
        imageURL <- map["image_url"]
        averageRating <- map["average_rating"]
        ratingCount <- map["ratings_count"]
    }
}
