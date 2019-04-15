//
//  SimiliarBookRepository.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/13/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

protocol SimiliarBookRepository {
    func searchBooks(authorName: String, completion: @escaping (BaseResult<SearchBookResponse>) -> Void)
}

final class SimiliarBookRepositoryImpl: SimiliarBookRepository {
    private var api: APIService?
    
    required init(api: APIService) {
        self.api = api
    }
    
    func searchBooks(authorName: String, completion: @escaping (BaseResult<SearchBookResponse>) -> Void) {
        let input = SimiliarBookRequest(authorName: authorName)
        
        api?.requestXML(input: input) { (object: SearchBookResponse?, error) in
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
