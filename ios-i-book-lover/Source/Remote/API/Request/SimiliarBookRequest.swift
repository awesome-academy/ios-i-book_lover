//
//  SimiliarRequest.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/13/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import Alamofire

final class SimiliarBookRequest: BaseRequest {
    required init(authorName: String) {
        let body: [String: Any]  = [
            "q": authorName
        ]
        super.init(url: Configuration.searchUrl, requestType: .get, body: body)
    }
}
