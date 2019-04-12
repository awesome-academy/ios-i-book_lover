//
//  BaseResult.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/11/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

import XMLMapper

enum BaseResult<T: XMLMappable> {
    case success(T?)
    case failure(error: BaseError?)
}
