//
//  IsbnRepository.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/11/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

protocol IsbnRepository {
    func searchIsbn(publishedDate: String, completion: @escaping (BaseResultJSON<SearchIsbnResponse>) -> Void)
}

final class IsbnRepositoryImpl: IsbnRepository {    
    private var api: APIService?
    
    required init(api: APIService) {
        self.api = api
    }
    
    func searchIsbn(publishedDate: String, completion: @escaping (BaseResultJSON<SearchIsbnResponse>) -> Void) {
        let input = SearchIsbnRequest(publishedDate: publishedDate)
        
        api?.requestJSON(input: input) { (object: SearchIsbnResponse?, error) in
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

