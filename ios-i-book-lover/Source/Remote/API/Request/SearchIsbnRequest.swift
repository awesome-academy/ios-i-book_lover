//
//  SearchIsbnRequest.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/11/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import Alamofire

final class SearchIsbnRequest: BaseRequest {
    required init(publishedDate: String) {
        let body: [String: Any]  = [
            "published_date": publishedDate
        ]
        super.init(url: Configuration.searchIsbnUrl, requestType: .get, body: body)
    }
}
