//
//  Author.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/5/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import Foundation
import XMLMapper

final class DetailAuthor: XMLMappable {
    var nodeName: String! = ""
    var id: String?
    var name: String?
    var link: String?
    var imageURL: String?
    
    required init?(map: XMLMap) {
    }
    
    func mapping(map: XMLMap) {
        id <- map["id"]
        name <- map["name"]
        link <- map["link"]
        imageURL <- map["image_url"]
    }
}
