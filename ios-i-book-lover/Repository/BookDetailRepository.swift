//
//  BookDetailRepository.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/12/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

protocol BookDetailRepository {
    func searchBookDetail(id: String, completion: @escaping (BaseResult<BookDetailResponse>) -> Void)
}

final class BookDetailRepositoryImpl: BookDetailRepository {
    private var api: APIService?
    
    required init(api: APIService) {
        self.api = api
    }
    
    func searchBookDetail(id: String, completion: @escaping (BaseResult<BookDetailResponse>) -> Void) {
        let input = BookDetailRequest(id: id)
        
        api?.requestXML(input: input) { (object: BookDetailResponse?, error) in
            if let object = object {
                completion(.success(object))
            } else if let error = error {
                completion(.failure(error: error))
            } else {
                completion(.failure(error: nil))
            }
        }
    }
}
