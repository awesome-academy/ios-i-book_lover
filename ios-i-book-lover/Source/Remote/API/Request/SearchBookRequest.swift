//
//  SearchBookRequest.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/11/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import Alamofire

final class SearchBookRequest: BaseRequest {
    required init(isbn: String) {
        let body: [String: Any]  = [
            "q": isbn
        ]
        super.init(url: Configuration.searchUrl, requestType: .get, body: body)
    }
}

