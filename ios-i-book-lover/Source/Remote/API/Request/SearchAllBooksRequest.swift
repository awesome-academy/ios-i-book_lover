//
//  SearchAllBookRequest.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/16/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import Alamofire

final class SearchAllBooksRequest: BaseRequest {
    required init(query: String, page: String) {
        let body: [String: Any]  = [
            "q": query,
            "page": page
        ]
        super.init(url: Configuration.searchUrl, requestType: .get, body: body)
    }
}
