//
//  PopularBookRepository.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/11/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

protocol BookRepository {
    func searchBooks(isbn: String, completion: @escaping (BaseResult<SearchBookResponse>) -> Void)
    func searchBooksByGenre(genre: String, completion: @escaping (BaseResult<SearchBookResponse>) -> Void)
    func searchAllBooks(query: String, page: String, completion: @escaping (BaseResult<SearchBookResponse>) -> Void)
}

final class BookRepositoryImpl: BookRepository {
    private var api: APIService?
    
    required init(api: APIService) {
        self.api = api
    }
    
    func searchBooks(isbn: String, completion: @escaping (BaseResult<SearchBookResponse>) -> Void) {
        let input = SearchBookRequest(isbn: isbn)
        
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
    
    func searchBooksByGenre(genre: String, completion: @escaping (BaseResult<SearchBookResponse>) -> Void) {
        let input = SearchBookByGenreRequest(genre: genre)
        
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
    
    func searchAllBooks(query: String, page: String, completion: @escaping (BaseResult<SearchBookResponse>) -> Void) {
        let input = SearchAllBooksRequest(query: query, page: page)
        
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
