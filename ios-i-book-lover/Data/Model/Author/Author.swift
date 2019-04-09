//
//  Author.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/7/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import Foundation
import XMLMapper

final class Author: XMLMappable {
    var nodeName: String! = ""
    var id: Text?
    var name: String?
    
    required init?(map: XMLMap) {
    }
    
    func mapping(map: XMLMap) {
        id <- map["id"]
        name <- map["name"]
    }
}
