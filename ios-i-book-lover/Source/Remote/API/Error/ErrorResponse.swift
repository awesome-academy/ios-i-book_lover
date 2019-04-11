//
//  ErrorResponse.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/11/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import XMLMapper

final class ErrorResponse: XMLMappable {
    var documentationUrl = "" 
    var message = ""
    var nodeName: String! = ""
    
    required init?(map: XMLMap) {
        mapping(map: map)
    }
    
    func mapping(map: XMLMap) {
        documentationUrl <- map["documentation_url"]
        message <- map["message"]
    }
}
