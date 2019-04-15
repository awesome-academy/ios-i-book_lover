//
//  DetailBookResponse.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/12/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import XMLMapper

final class BookDetailResponse: XMLMappable {
    var nodeName: String!
    var book: BookDetail?
    
    required init(map: XMLMap) {
        mapping(map: map)
    }
    
    func mapping(map: XMLMap) {
        book <- map["book"]
    }
}
