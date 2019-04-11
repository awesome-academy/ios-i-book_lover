//
//  SearchBookResponse.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/11/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import XMLMapper

final class SearchBookResponse: XMLMappable {
    var nodeName: String!
    var books: [Book]?
    
    required init(map: XMLMap) {
        mapping(map: map)
    }
    
    func mapping(map: XMLMap) {
        books <- map["search.results.work"]
    }
}
