//
//  DetailBookRequest.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/12/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import Alamofire

final class BookDetailRequest: BaseRequest {
    required init(id: String) {
        super.init(url: "\(Configuration.bookDetailUrl)\(id)\(Configuration.bookDetailSubUrl)", requestType: .get)
    }
}
