//
//  Configuration.swift
//  BookLover
//
//  Created by nguyen.nam.khanh on 4/5/19.
//  Copyright © 2019 nguyen.nam.khanh. All rights reserved.
//

enum Configuration {    
    static let baseUrl = "https://www.goodreads.com/"
    static let search = "search/index.xml?"
    static let isbn = "book/isbn/"
    static let bookShow = "book/show/"
    static let searchUrl = "\(baseUrl)\(search)\(APIKey.key)"
    static let searchUrlByIsbn = "\(baseUrl)\(isbn)"
        
    static let baseNYTUrl = "https://api.nytimes.com/svc/books/v3/lists.json?"
    static let nonFictionList = "list-name=hardcover-nonfiction"
    static let searchIsbnUrl = "\(baseNYTUrl)\(nonFictionList)&api-key=\(APIKey.NYTKey)"
    
    static let bookDetailUrl = "\(baseUrl)\(bookShow)"
    static let bookDetailSubUrl = ".xml?\(APIKey.key)"
    
    static let reviewUrl = "\(baseUrl)api/reviews_widget_iframe?format=html"
    
    static let purchaseUrl = "\(baseUrl)buy_buttons/12/follow?book_id="
}
