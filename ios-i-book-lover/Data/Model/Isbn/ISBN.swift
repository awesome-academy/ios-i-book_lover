//
//  Isbn.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/11/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import ObjectMapper

final class ISBN: Mappable {
    var ISBN = ""
    
    required init?(map: Map) {
        
    }
    
    func mapping(map: Map) {
        ISBN <- map["primary_isbn10"]
    }
}
