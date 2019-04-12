//
//  SearchIsbnResponse.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/11/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import ObjectMapper

final class SearchIsbnResponse: Mappable {    
    var resultList: [ISBNList]?
    
    required init(map: Map) {
        mapping(map: map)
    }
    
    func mapping(map: Map) {
        resultList <- map["results"]
    }
}

