//
//  BookList.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/7/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import Foundation
import XMLMapper

final class BookList: XMLMappable {
    var nodeName: String! = ""
    var books: [Book]?
    
    init?(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        books <- map["search.results.work"]
    }
}
