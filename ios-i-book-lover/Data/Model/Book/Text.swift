//
//  Text.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/7/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import Foundation
import XMLMapper

final class Text: XMLMappable {
    var nodeName: String! = ""
    var type: String?
    var text: String?
    
    required init?(map: XMLMap) {}
    
    func mapping(map: XMLMap) {
        type <- map.attributes["type"]
        text <- map.innerText
    }
}
