//
//  SearchBookByGenreRequest.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/15/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import Alamofire

final class SearchBookByGenreRequest: BaseRequest {
    required init(genre: String) {
        let body: [String: Any]  = [
            "q": genre
        ]
        super.init(url: Configuration.searchUrl, requestType: .get, body: body)
    }
}
